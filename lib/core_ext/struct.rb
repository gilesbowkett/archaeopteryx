# this allows you to create Structs and Struct subclasses with pseudo-keyword options hashes
# rather than with long sequences of unnamed args. written by Michael Fellinger.
class Struct
  def self.create(hash)
    new(*hash.values_at(*members.map{|member| member.to_sym}))
  end
end
