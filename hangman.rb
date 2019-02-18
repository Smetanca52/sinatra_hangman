require "yaml"
require "set"

class Hangman

  def initialize
    @guillotine = "__\n |\n"
    @parts   = [ " O", "\n-", "|", "-", "\n/",  " \\" ].reverse
    @lost = false
    @won = false
    @secret_word = get_random_word
    @correct_guesses = []
    @wrong_guesses = []
    welcome_page
  end

  def welcome_page
    puts "Welcome to Hangman Game!"
    print 'Load game? (y/n): '
    if gets.chomp.downcase == 'y'
      load_game
    else
      play
    end
  end

  def save_game
    File.open("save.txt", 'w') { |file| file.write(YAML::dump(self))}
    puts "Game Saved!"
    exit
  end

  def load_game
    if File.exist?("save.txt")
      game = YAML::load(File.read("save.txt"))
      puts "Game Loaded!\n"
      game.play
    else
      puts "\nYou have no saved games."
    end
    exit
  end

  def get_random_word
    rand_word = File.readlines('5desk.txt').select  do |w|
      w.chomp.length > 4 && w.chomp.length < 13
    end
    rand_word.sample.chomp.downcase
  end

  def wrong_guesses
    @wrong_guesses.join(', ')
  end

  def secret_display
    @secret_word.chars.map do |l|
      @correct_guesses.include?(l) ? l : '_ '
    end.join(' ')
  end

  def game_over?
    @lost || @won
  end

  def draw
    @guillotine += @parts.pop
    @lost = @parts.empty?
  end

  def play
    until game_over?
      puts @guillotine
      puts "Secret word: #{secret_display}"
      puts "Misses: #{wrong_guesses}"
      print 'Enter your guess (or type "save" to save this game): '
      guess = gets.chomp.downcase
      puts 'Z' * 80

      if
        guess == 'save'
        save_game
      elsif
        @secret_word.include?(guess)
        @correct_guesses << guess
        if
          @correct_guesses.size == Set.new(@secret_word.chars).size
          @won = true
        end
      else
        @wrong_guesses << guess unless @wrong_guesses.include?(guess)
        draw
      end
    end

    puts 'W' * 80
    puts @guillotine
    puts @won ? "You won!" : "You lost!"
    puts "Secret word is: #{@secret_word}"
  end
end

Hangman.new.play
