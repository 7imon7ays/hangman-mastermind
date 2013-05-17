class Hangman
  def initialize
    # puts "Do you want to play as master or guesser? Pick one."
#
#     role_assignment = gets.chomp
#
#     until role_assignment == "master" || role_assignment == "guesser"
#       puts "Invalid input. Choose 'master' or 'guesser'."
#       role_assignment = gets.chomp
#     end

    @current_turn = 0
    puts "How many turns do you want to play?"
    @turn_limit = gets.chomp.to_i

    # if role_assignment == "master"
#       @master, @guesser = Human.new, Computer.new
#     else
#       @guesser, @master = Human.new, Computer.new
#     end

    @master, @guesser = Computer.new, Computer.new

    @guessed_letters = []
    @hint_array = []
    @master.pick_a_word.length.times { @hint_array << "_" }
    puts "The secret word is:"
    display_hint
    play
  end

  def display_hint
    puts "Guesses so far: #{@guessed_letters.join(' ')}"
    puts @hint_array.join(' ')
  end

  def play
    until (!@hint_array.include? "_") || (@current_turn >= @turn_limit)
      #guesser guess gives a letter
      letter = @guesser.guess(@hint_array, @guessed_letters)
      @guessed_letters << letter unless @guessed_letters.include? letter

      #master check gives a hint array
      @master.check(@hint_array, letter)
      p "There are #{@turn_limit - @current_turn} turns left."
      display_hint
      @current_turn += 1
    end
    @hint_array.include?("_") ? loses : wins
  end

  # ## make sure to CALL
#   def next_turn
#     wins if @hint_array.none? {|slot| slot == "_"}
#     @turn_counter += 1
#     loses if @turn_counter > @turn_limit
#     display_hint
#     evaluate
#   end

  def wins
    puts "Genius! It only took #{@current_turn} turns."
    terminator
  end

  def loses
    puts "Loser! #{@current_turn} turns and still no solution!"
    terminator
  end

  def terminator
    abort("Game over.")
  end

end


class Computer
  attr_accessor :dictionary

  def initialize
    @dictionary = File.readlines("2of12.txt").map {|word| word.chomp("\n")}
    @alphabet = ('a'..'z').to_a
  end

  def pick_a_word
    @secret_word = @dictionary.sample
  end

  def guess(hint_array, guessed_letters)
    candidate_words = @dictionary.select do |word|
      word.chomp.length == hint_array.length
    end

    hint_string = hint_array.join.gsub('_','.')

    candidate_words = candidate_words.select do |word|
      word.match /#{hint_string}/
    end

    candidate_letters = @alphabet.select do |letter|
      candidate_words.join.include?(letter) && !guessed_letters.include?(letter)
    end

    letter_frequencies = Hash.new(0)

    candidate_words.each do |word|
      candidate_letters.each do |letter|
        letter_frequencies[letter] += 1 if word.include? letter
      end
    end

    most_common_letter = nil
    highest_frequency = 0

    letter_frequencies.each do |key, value|
      most_common_letter, highest_frequency = key, value if value > highest_frequency
    end

    most_common_letter
  end


  def check(hint_array, letter)
    if @secret_word.include? letter
      hint_array.each_index do |slot|
        hint_array[slot] = letter if @secret_word[slot] == letter
      end
    end
    hint_array
  end

end


class Human

  def initialize
    # maybe we won't need
  end

  def pick_a_word
    puts "How many letters are there in your secret word?"
    secret_word = ""
    secret_word_length = gets.chomp.to_i
    secret_word_length.times {secret_word += "_"}
    secret_word
  end

  def guess(hint_array, guessed_letters)
    puts "Guess a letter."
    letter = gets.chomp
    # RAISE ERRORS if letters are not working
    letter
  end

  def check(hint_array, letter)
    puts "How many times does #{letter.upcase} appear in your word?"

    occurrences = (gets.chomp.to_i)
    locations = []

    until occurrences == 0
      puts "Where does #{letter.upcase} appear in your word?"
      locations << gets.chomp.to_i
      occurrences -= 1
      locations.each do |location_index|
        hint_array[location_index - 1 ] = letter
      end
    end

    hint_array
  end

end









