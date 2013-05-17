class Hangman

  attr_reader :hint_array

  def initalize(turn_limit, human_is_guesser)
    if human_is_guesser
      @word_master, @word_guesser = ComputerMaster.new, HumanGuesser.new
    else
      @word_master, @word_guesser = HumanMaster.new, ComputerGuesser.new
    end
    @turn_counter = 0
    @turn_limit = turn_limit
    @hint_array = []
    @word_master.secret_word.length.times { @hint_array << "_" }
    puts "This is your word"
    display_hint
    next_turn
  end

  def display_hint
    puts @hint_array.join(' ')
  end

  def evaluate
    guessed_letter = @word_guesser.guess_letter
    if @word_master.secret_word.include? guessed_letter
      @hint_array.each_index do |slot|
        @hint_array[slot] = guessed_letter if secret_word[slot] == guessed_letter
      end
    end
    next_turn
  end

  def next_turn
    wins if @hint_array.join == @word_master.secret_word #if secret word is string
    @turn_counter += 1
    loses if @turn_counter > @turn_limit
    display_hint
    evaluate
  end

  def wins
    puts "You are a genius! It only took you #{turn_counter} turns. How'd you know?"
    terminator
  end

  def loses
    puts "You suck man! #{turn_counter} turns and you still couldn't find #{@word_master.secret_word}?"
    terminator
  end

  def terminator
    abort("Game over.")
  end
end


class Human

  attr_reader :word_guesser

  def initialize
    # @secret_word = gets.chomp
    @is_word_guesser = true

  end

  def guess_letter
    @guess_letter = gets.chomp
  end

end

class Computer

  def initialize
    @is_word_guesser = true
  end

  def read_hint
    hangman.hint
  end

end




