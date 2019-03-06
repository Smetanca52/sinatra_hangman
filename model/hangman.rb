class Hangman
attr_reader :misses
attr_reader :word

def initialize
  @word = get_random_word
  @misses = []
  @correct_letters = []
end

def get_random_word
  rand_word = File.readlines('5desk.txt').select  do |w|
    w.chomp.length > 4 && w.chomp.length < 13
  end
  rand_word.sample.chomp.downcase
end

def guess(letter)
  return false if letter.nil?
  letter = letter.downcase
  if letter.length == 1  && ((@misses+@correct_letters).nil? || !(@misses+@correct_letters).include?(letter))
      @word.chars.include?(letter) ? @correct_letters << letter : @misses << letter
      return true
  end
  false
end

def show_correct
  @word.chars.map { |letter| @correct_letters.include?(letter) ? letter : "_ "   }.join
end


def show_misses
  misses_string = ""
  @misses.each { |miss| misses_string += "<strike>#{miss}</strike> " }
  misses_string
end

end
