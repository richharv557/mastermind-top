# frozen_string_literal: true

# Game class currently contains gamestate
class Game
  def initialize
    @keep_playing = true
  end

  def play_game
    while @keep_playing
      new_round = Mastermind.new
      if new_round.select_mode == 1
        breaker = Player.new
        new_round.select_random_code
      else
        breaker = CPU.new
        new_round.code_to_solve = breaker.capture_starting_guess
      end
      new_round.play_round(breaker) until new_round.game_over
      new_round.print_game_over_message
      ask_to_play_again
    end
  end

  private

  def ask_to_play_again
    puts "Do you want to play again? Enter 'y' to play again or anything else to exit."
    @keep_playing = false unless gets.chomp == 'y'
  end
end

# This represents an instance of the board/round, contains round state information
class Mastermind
  attr_reader :remaining_codes, :game_over
  attr_accessor :code_to_solve

  def initialize
    welcome
    @code_to_solve = []
    @round = 1
    @game_over = false
    @mode = 0
    @remaining_codes = [1, 2, 3, 4, 5, 6].repeated_permutation(4).to_a
  end

  def select_mode
    @mode = gets.chomp.to_i
    until @mode == 1 || @mode == 2
      puts 'Invalid input. Enter 1 if you would like to be BREAKER or 2 if you would like to be MAKER.'
      @mode = gets.chomp.to_i
    end
    @mode
  end

  def play_round(breaker)
    breaker.capture_input(self)
    check_if_exact_match(breaker.input_code, code_to_solve)
    check_if_partial_match(breaker.input_code, code_to_solve)
    create_hint
    print_hint_and_round_info(breaker.input_code)
    check_for_win
    check_for_loss
    remove_possibilities(breaker.input_code) if @mode == 2
  end

  def print_game_over_message
    puts 'Game over!'
    if @hint == '++++' && @mode == 1
      puts 'You Win!'
    elsif @round > 12 && @mode == 2
      puts 'You Win!'
    else
      puts 'You Lose!'
    end
  end

  def select_random_code
    4.times { @code_to_solve.push(rand(1..6)) }
  end

  private

  def welcome
    puts '|++++++++++++++++++++++++++++++|'
    puts '|+++++++++ MASTERMIND +++++++++|'
    puts '|++++++++++++++++++++++++++++++|'
    puts ''
    puts 'Welcome to MASTERMIND. The game of Mind Masters, like me!'
    puts ''
    puts "MASTERMIND is a game where you have to guess your opponent's secret code within a limited number of guesses."
    puts 'For our game, the code will be 4 numeric digits (1-6) and the breaker has 12 guesses to crack the code'
    puts 'Enter 1 to be code-BREAKER or 2 for code-MAKER. The CPU will be your oponent if you are MAKER.'
  end

  def check_if_partial_match(input_array, code_to_solve)
    @partial_matches = 0
    input_hash = {}
    filtered_array = input_array.select { |number| code_to_solve.include?(number) }
    filtered_array.each { |number| input_hash[number] = [code_to_solve.count(number), input_array.count(number)].min }
    @partial_matches = input_hash.values.sum - @exact_matches
  end

  # split the input code into an hash and see if the sol contains char in loc (using k as location, v as guess number)
  def check_if_exact_match(input_array, code_to_solve)
    @exact_matches = 0
    input_hash = {}
    code_to_solve_hash = {}
    input_array.each_with_index { |number, index| input_hash[index + 1] = number }
    code_to_solve.each_with_index { |number, index| code_to_solve_hash[index + 1] = number }
    4.times do |i|
      @exact_matches += 1 if input_hash[i + 1] == code_to_solve_hash[i + 1]
    end
  end

  def create_hint
    @hint = ''
    @exact_matches.times { @hint += '+' }
    @partial_matches.times { @hint += '-' }
  end

  # Knuth's algorithm with random guesses generated in the CPU subclass
  def remove_possibilities(code)
    @remaining_codes.delete(code)
    original_partials = @partial_matches
    original_exacts = @exact_matches
    temp_array = @remaining_codes.select do |set|
      check_if_exact_match(code, set)
      check_if_partial_match(code, set)
      original_partials == @partial_matches && original_exacts == @exact_matches
    end
    @remaining_codes = temp_array
  end

  def print_hint_and_round_info(code)
    puts "Round: #{@round} Guess: #{code} Result: #{@hint}"
    @round += 1
  end

  def check_for_win
    @game_over = true if @hint == '++++'
  end

  def check_for_loss
    @game_over = true if @round > 12
  end
end

# Player class represents the player and the computer playing the game
class Player
  attr_reader :input_code

  def initialize
    @input_code = []
  end

  def capture_input(_object)
    puts 'Please enter a 4 digit code using 1-6 for each digit.'
    input = gets.chomp.to_i
    until validate_input(input)
      puts 'Invalid input. Please enter a 4 digit code using 1-6 for each digit.'
      input = gets.chomp.to_i
    end
    @input_code = input.to_s.split('').map(&:to_i)
  end

  private

  def validate_input(code)
    code.is_a?(Integer) && code >= 1111 && code <= 6666
  end
end

# CPU class replaces the user input with Random guesses guided by algorithm in remove_possibilities method
class CPU < Player
  def capture_input(object)
    @input_code = []
    @input_code = object.remaining_codes.sample
  end

  def capture_starting_guess
    puts 'Please enter a 4 digit code using 1-6 for each digit as a code for the CPU to solve.'
    input = gets.chomp.to_i
    until validate_input(input)
      puts 'Invalid input. Please enter a 4 digit code using 1-6 for each digit.'
      input = gets.chomp.to_i
    end
    input.to_s.split('').map(&:to_i)
  end
end

game = Game.new
game.play_game
