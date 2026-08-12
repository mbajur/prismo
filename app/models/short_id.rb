# typed: false

# Taken from
# https://github.com/lobsters/lobsters/blob/main/app/models/short_id.rb
class ShortId
  attr_accessor :klass, :generation_attempts

  def initialize(klass)
    self.klass = klass
    self.generation_attempts = 0
  end

  def generate
    until (generated_id = candidate_id) && generated_id.valid?
      self.generation_attempts += 1
      raise "too many hash collisions" if generation_attempts == 10
    end
    generated_id.to_s
  end

  def candidate_id
    CandidateId.new(klass)
  end

  class CandidateId
    attr_accessor :klass, :id

    def initialize(klass)
      self.klass = klass
      self.id = generate_id
    end

    def to_s
      id
    end

    def generate_id
      random_str(6).downcase
    end

    def valid?
      !klass.exists?(short_id: id)
    end

    def random_str(len)
      str = ""
      while str.length < len
        chr = OpenSSL::Random.random_bytes(1)
        ord = chr.unpack1("C")

        #          0            9              A            Z              a            z
        if ord.between?(48, 57) || ord.between?(65, 90) || ord.between?(97, 122)
          str += chr
        end
      end

      str
    end
  end
end
