#!/usr/bin/ruby

class Board

  attr_reader :secret_code

  def initialize
    @game_state = {}
    peg_options = %w{ R G B Y O P}
    slots = [0, 1, 2, 3]
    @secret_code = slots.map {|slot| slot = peg_options.sample}
    puts "The computer has chosen its secret code."
  end

  def display_history(players_guess, hint, turn_count)
    @game_state[turn_count] = "Turn no: #{turn_count} Guess: #{players_guess.inspect}     Hint: #{hint}"
    puts "Here is your progress so far:\n\n"

    @game_state.each_value do |counter_game_hint|
      puts counter_game_hint
    end
    puts
    puts
  end

end

class Gameplay

  attr_reader :players_guess

  def initialize
    @current_turn = 0
    @board = Board.new
    prompt_player
  end

  def prompt_player
    puts "Make your guess. Pick four colors by their initials: Red, Green, Blue, Yellow, Orange, or Purple"

    guess = gets.chomp.upcase.split("")
    until guess - %w{R G B Y O P} == [] && guess.length == 4
     puts "Invalid input!"
     guess = gets.chomp.upcase.split("")
    end
    @players_guess = guess

    evaluator(@players_guess)
  end

  def evaluator(players_guess)
    generated_hint = hint_generator(players_guess, @board.secret_code)
    count = turn_counter
    if @board.secret_code == generated_hint
      wins
    else
      puts "Nice try. Here's your hint:\n\n#{generated_hint.inspect}\n\n"
    end
    @board.display_history(@players_guess, generated_hint, count)
    prompt_player
  end

  def hint_generator(guess, code)
    hint = ["_", "_" ,"_", "_"]
    guess.each_index do |slot_index|
      hint[slot_index] = "()" if code.include?(guess[slot_index])
      hint[slot_index] = guess[slot_index] if guess[slot_index] == code[slot_index]
    end
    hint
  end

  def turn_counter
    @current_turn += 1 unless @board.secret_code == @players_guess
    #make sure to check if win on turn 10
    loses if @current_turn == 10
    @current_turn
  end

  def wins
    puts "You Win! It took you #{@current_turn} turns."
    terminator
  end

  def loses
    puts "You lost"
    puts "The code was #{@board.secret_code.inspect}"
    terminator
  end

  def terminator
    abort "Game over"
  end

end

Gameplay.new






