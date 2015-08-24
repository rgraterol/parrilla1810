class Cipher

  extend ActiveSupport::Concern

  def initialize(shuffled)
    normal = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + [' ']
    @map = normal.zip(shuffled).inject(:encrypt => {} , :decrypt => {}) do |hash,(a,b)|
      hash[:encrypt][a] = b
      hash[:decrypt][b] = a
      hash
    end
  end

  def encrypt(str)
    str.split(//).map { |char| @map[:encrypt][char] }.join
  end

  def decrypt(str)
    str.split(//).map { |char| @map[:decrypt][char] }.join
  end

end