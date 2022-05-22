# frozen_string_literal: true

# MasterMind class currently contains game logic and state
class Mastermind
  attr_reader :code_to_solve, :includes_and_location_counter, :includes_counter

  def initialize
    @code_to_solve = []
    @includes_counter = 0
    @includes_and_location_counter = 0
    @guessed_code = 0
    @hint = ''
    @turn = 0
  end

  def welcome
    puts '|++++++++++++++++++++++++++++++|'
    puts '|+++++++++ MASTERMIND +++++++++|'
    puts '|++++++++++++++++++++++++++++++|'
    puts ''
    puts 'Welcome to MASTERMIND. The game of Mind Masters.'
    puts ''
    puts "MASTERMIND is a game where you have to guess your opponent's secret code within a limited number of guesses."
    puts 'For our game, the code will be 4 numeric digits (1-6) and you have 12 guesses to crack the code'
  end

  def play_round
    welcome
    # choose mode to be added
    breaker = Player.new
    breaker.capture_input
    select_random_code
    check_if_input_included(breaker.guessed_code)
    check_if_input_included_in_right_spot(breaker.guessed_code)
    p create_hint
  end

  def select_random_code
    # 4.times { @code_to_solve.push(rand(1..6)) }
    # 4.times { @code_to_solve.push(1) }
    @code_to_solve = [4, 3, 2, 1]
  end

  # first split the input code into an array and see if the solution contains the character
  # This is flawed, i don't think it handles the logic for guessing 1 number where it appears multiple times, will test
  def check_if_input_included(input)
    @includes_counter = 0
    input_array = input.to_s.split('').map(&:to_i)
    input_array.each do |guess_number|
      @includes_counter += 1 if @code_to_solve.include?(guess_number)
    end
  end

  # split the input code into an hash and see if the sol contains char in loc (using k as location, v as guess number)
  def check_if_input_included_in_right_spot(input)
    @includes_and_location_counter = 0
    input_hash = {}
    code_to_solve_hash = {}
    input.to_s.split('').map(&:to_i).each_with_index { |number, index| input_hash[index + 1] = number }
    @code_to_solve.each_with_index { |number, index| code_to_solve_hash[index + 1] = number }
    4.times do |i|
      @includes_and_location_counter += 1 if input_hash[i + 1] == code_to_solve_hash[i + 1]
    end
  end

  def create_hint
    @hint = ''
    @includes_and_location_counter.times { @hint += '+' }
    (@includes_counter - @includes_and_location_counter).times { @hint += '-' }
    @hint
  end

  def check_for_win
  end

  def check_for_loss
  end
end

# Player class represents the player and the computer playing the game
class Player
  attr_reader :guessed_code

  def initialize
    @guessed_code = 0
  end

  def validate_input(code)
    code.is_a?(Integer) && code >= 1111 && code <= 6666
  end

  def capture_input
    puts 'Please enter a 4 digit code using 1-6 for each digit.'
    @guessed_code = gets.chomp.to_i
    until validate_input(@guessed_code)
      puts 'Invalid input. Please enter a 4 digit code using 1-6 for each digit.'
      @guessed_code = gets.chomp.to_i
    end
  end
end

game = Mastermind.new
game.play_round
