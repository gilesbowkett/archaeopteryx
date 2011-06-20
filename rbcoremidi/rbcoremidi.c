/*
 *  Copyright 2008 Markus Prinz
 *  Released unter an MIT licence
 *
 */

#include <ruby.h>
#include <CoreMIDI/MIDIServices.h>
#include <pthread.h>
#include <stdlib.h>

pthread_mutex_t mutex;

CFMutableArrayRef midi_data = NULL;

VALUE mCoreMIDI = Qnil;
VALUE mCoreMIDIAPI = Qnil;

VALUE cInputPort = Qnil;
VALUE cMIDIClient = Qnil;

// We need our own data structure since MIDIPacket defines data to be a 256 byte array,
// even though it can be larger than that
typedef struct RbMIDIPacket_t {
    MIDITimeStamp timeStamp;
    UInt16 length;
    Byte* data;
} RbMIDIPacket;

// A struct that contains the input port
typedef struct RbInputPort_t {
    MIDIPortRef input_port;
} RbInputPort;

// A struct that contains the midi client
typedef struct RbMIDIClient_t {
    MIDIClientRef client;
} RbMIDIClient;

// Forward declare free_objects
static void free_objects();

// The callback function that we'll eventually supply to MIDIInputPortCreate
static void RbMIDIReadProc(const MIDIPacketList* packetList, void* readProcRefCon, void* srcConnRefCon)
{
    if( pthread_mutex_lock(&mutex) != 0 )
    {
        // uh oh
        // Not much we can do
        return;
    }
    
    MIDIPacket* current_packet = (MIDIPacket*) packetList->packet;

    unsigned int j;
    for( j = 0; j < packetList->numPackets; ++j )
    {
        RbMIDIPacket* rb_packet = (RbMIDIPacket*) malloc( sizeof(RbMIDIPacket) );
        
        if( rb_packet == NULL )
        {
            fprintf(stderr, "Failed to allocate memory for RbMIDIPacket!\n");
            abort();
        }
        
        rb_packet->timeStamp = current_packet->timeStamp;
        rb_packet->length = current_packet->length;
        
        size_t size = sizeof(Byte) * rb_packet->length;
        rb_packet->data = (Byte*) malloc( size );
        
        if( rb_packet->data == NULL )
        {
            fprintf(stderr, "Failed to allocate memory for RbMIDIPacket data!\n");
            abort();
        }
        
        memcpy(rb_packet->data, current_packet->data, size);
        
        CFArrayAppendValue(midi_data, rb_packet);
        
        current_packet = MIDIPacketNext(current_packet);
    }
    
    pthread_mutex_unlock(&mutex);
}

// Checks for new data and copies it over if there is some.
static VALUE t_check_for_new_data(VALUE self)
{
    if( pthread_mutex_trylock(&mutex) != 0 )
    {
        // no data for us yet
        return Qfalse;
    }
    
    // Switch out the arrays. Possibly evil
    CFArrayRef data = midi_data;
    midi_data = CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
    
    pthread_mutex_unlock(&mutex);
    
    // We'll use a Ruby Struct to store the data
    VALUE cMidiPacket = rb_const_get(mCoreMIDIAPI, rb_intern("MidiPacket"));
    
    VALUE rb_midi_data = rb_ary_new();
    
    CFIndex idx = 0;
    CFIndex array_size = CFArrayGetCount(data);
    const RbMIDIPacket* current_packet = NULL;
    
    for( ; idx < array_size; ++idx ) 
    {
        current_packet = (const RbMIDIPacket*) CFArrayGetValueAtIndex(data, idx);
        
        VALUE byte_array = rb_ary_new2(current_packet->length);
        
        int i;
        for (i = 0; i < current_packet->length; ++i) 
        {
            rb_ary_push(byte_array, INT2FIX(current_packet->data[i]));
        }
        
        // relies on sizeof(MIDITimeStamp) == sizeof(unsigned long long)
        assert(sizeof(MIDITimeStamp) == sizeof(unsigned long long));
        
        VALUE midi_packet_args[2];
        midi_packet_args[0] = ULL2NUM(current_packet->timeStamp);
        midi_packet_args[1] = byte_array;
        
        rb_ary_push(rb_midi_data, rb_class_new_instance((sizeof(midi_packet_args)/sizeof(midi_packet_args[0])), midi_packet_args, cMidiPacket));
        
        // While we're at it..
        // Free the memory! Save the whales!
        free(current_packet->data);
    }
    
    // Free the memory! Save the whales! Part 2!
    CFRelease(data);
    
    return rb_midi_data;
}

static VALUE t_create_client(VALUE self, VALUE client_name)
{    
    VALUE midiclient_instance = rb_class_new_instance(0, 0, cMIDIClient);
    if( midiclient_instance == Qnil )
    {
        free_objects();
        rb_fatal("Couldn't create an instance of MIDIClient!");
    }
    
    MIDIClientRef midi_client;
    
    CFStringRef client_str = CFStringCreateWithCString(kCFAllocatorDefault, RSTRING(client_name)->ptr, kCFStringEncodingASCII);
    MIDIClientCreate(client_str, NULL, NULL, &midi_client);
    CFRelease(client_str);
    
    RbMIDIClient* client_struct;
    Data_Get_Struct(midiclient_instance, RbMIDIClient, client_struct);
    
    client_struct->client = midi_client;
    
    return midiclient_instance;
}

// Create a new Input Port and saves the Ruby Callback proc.
static VALUE t_create_input_port(VALUE self, VALUE client_instance, VALUE port_name)
{
    MIDIPortRef in_port;
    
    RbMIDIClient* client;
    Data_Get_Struct(client_instance, RbMIDIClient, client);
    
    CFStringRef port_str = CFStringCreateWithCString(kCFAllocatorDefault, RSTRING(port_name)->ptr, kCFStringEncodingASCII);
    MIDIInputPortCreate(client->client, port_str, RbMIDIReadProc, NULL, &in_port);
    CFRelease(port_str);
    
    VALUE inputport_instance = rb_class_new_instance(0, 0, cInputPort);
    if( inputport_instance == Qnil )
    {
        free_objects();
        rb_fatal("Couldn't create an instance of InputPort!");
    }
    
    RbInputPort* port_struct;
    Data_Get_Struct(inputport_instance, RbInputPort, port_struct);
    
    port_struct->input_port = in_port;
    
    return inputport_instance;
}

// Return an array of all available sources, filled with the names of the sources
static VALUE t_get_sources(VALUE self)
{    
    int number_of_sources = MIDIGetNumberOfSources();
    
    VALUE source_ary = rb_ary_new2(number_of_sources);
    
    int idx;
    for(idx = 0; idx < number_of_sources; ++idx)
    {
        MIDIEndpointRef src = MIDIGetSource(idx);
        CFStringRef pname;
        char name[64];
        
        MIDIObjectGetStringProperty(src, kMIDIPropertyName, &pname);
        CFStringGetCString(pname, name, sizeof(name), 0);
        CFRelease(pname);
        
        rb_ary_push(source_ary, rb_str_new2(name));
    }
    
    return source_ary;
}

static VALUE t_get_num_sources(VALUE self)
{
    return INT2FIX(MIDIGetNumberOfSources());
}

// source is identified by the index in the array returned by get_sources
// input_port is an InputPort class
static VALUE t_connect_source_to_port(VALUE self, VALUE source_idx, VALUE input_port)
{
    RbInputPort* port;
    Data_Get_Struct(input_port, RbInputPort, port);
    
    MIDIEndpointRef source = MIDIGetSource(FIX2INT(source_idx));
    
    MIDIPortConnectSource(port->input_port, source, NULL);
    
    return Qtrue;
}

// source is identified by the index in the array returned by get_sources
// input_port is an InputPort class
static VALUE t_disconnect_source_from_port(VALUE self, VALUE source_idx, VALUE input_port)
{
    RbInputPort* port;
    Data_Get_Struct(input_port, RbInputPort, port);
    
    MIDIEndpointRef source = MIDIGetSource(FIX2INT(source_idx));
    
    MIDIPortDisconnectSource(port->input_port, source);
    
    return Qtrue;
}

/*
 *
 * RbInputPort related methods
 *
 */

static void inputport_free(void* ptr)
{
    if( ptr != NULL)
        free(ptr);
}

static VALUE inputport_alloc(VALUE klass)
{
    RbInputPort* port = (RbInputPort*) malloc(sizeof(RbInputPort));
    port->input_port = NULL;
    
    VALUE obj;
    obj = Data_Wrap_Struct(klass, 0, inputport_free, port);
    
    return obj;
}

static VALUE inputport_initialize(VALUE self)
{
    return self;
}

/*
 *
 * RbMIDIClient related methods
 *
 */

static void midiclient_free(void* ptr)
{
    if( ptr != NULL)
        free(ptr);
}

static VALUE midiclient_alloc(VALUE klass)
{
    RbMIDIClient* client = (RbMIDIClient*) malloc(sizeof(RbMIDIClient));
    client->client = NULL;
    
    VALUE obj;
    obj = Data_Wrap_Struct(klass, 0, midiclient_free, client);
    
    return obj;
}

static VALUE midiclient_initialize(VALUE self)
{
    return self;
}

/*
 *
 * util methods
 *
 */

static void free_objects()
{
    pthread_mutex_destroy(&mutex);
    
    if( midi_data != NULL )
    {
        if( CFArrayGetCount(midi_data) > 0 )
        {
            int i;
            for( i = 0; i < CFArrayGetCount(midi_data); ++i )
            {
                free(((const RbMIDIPacket*) CFArrayGetValueAtIndex(midi_data, i))->data);
            }
        }
        
        CFRelease(midi_data);
    }
}

static void init_mutex()
{
    int mutex_init_result = pthread_mutex_init(&mutex, NULL);
    
    if( mutex_init_result != 0 )
    {
        rb_sys_fail("Failed to allocate mutex");
    }
}

static void init_midi_data()
{
    midi_data = CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
    
    if( midi_data == NULL )
    {
        free_objects();
        rb_sys_fail("Failed to allocate CFMutableArray");
    }
}

static void install_at_exit_handler()
{
    // Poor Ruby programmers destructor
    if( atexit(free_objects) != 0 )
    {
        free_objects();
        rb_sys_fail("Failed to register atexit function");
    }
}

void Init_rbcoremidi()
{
    init_mutex();
    
    init_midi_data();
    
    install_at_exit_handler();
    
    mCoreMIDI = rb_define_module("CoreMIDI");
    mCoreMIDIAPI = rb_define_module_under(mCoreMIDI, "API");
    
    rb_define_singleton_method(mCoreMIDIAPI, "create_input_port", t_create_input_port, 2);
    rb_define_singleton_method(mCoreMIDIAPI, "create_client", t_create_client, 1);
    rb_define_singleton_method(mCoreMIDIAPI, "get_sources", t_get_sources, 0);
    rb_define_singleton_method(mCoreMIDIAPI, "get_num_sources", t_get_num_sources, 0);
    rb_define_singleton_method(mCoreMIDIAPI, "connect_source_to_port", t_connect_source_to_port, 2);
    rb_define_singleton_method(mCoreMIDIAPI, "disconnect_source_from_port", t_disconnect_source_from_port, 2);
    rb_define_singleton_method(mCoreMIDIAPI, "check_for_new_data", t_check_for_new_data, 0);

    // Define CoreMIDI::API::InputPort class
    cInputPort = rb_define_class_under(mCoreMIDIAPI, "InputPort", rb_cObject);
    rb_define_alloc_func(cInputPort, inputport_alloc);
    rb_define_method(cInputPort, "initialize", inputport_initialize, 0);
    
    // Define CoreMIDI::API::MIDIClient class
    cMIDIClient = rb_define_class_under(mCoreMIDIAPI, "MIDIClient", rb_cObject);
    rb_define_alloc_func(cMIDIClient, midiclient_alloc);
    rb_define_method(cMIDIClient, "initialize", midiclient_initialize, 0);
}
