# frozen_string_literal: true

# MasterMind class currently contains game logic and state
class Mastermind
  attr_reader :code_to_solve, :includes_and_location_counter, :includes_counter

  def initialize
    @code_to_solve = []
    @includes_counter = 0
    @includes_and_location_counter = 0
  end

  def welcome
    puts '|++++++++++++++++++++++++++++++|'
    puts '|+++++++++ MASTERMIND +++++++++|'
    puts '|++++++++++++++++++++++++++++++|'
    puts ''
    puts 'Welcome to MASTERMIND. The game of Mind Masters.'
    puts ''
    puts "MASTERMIND is a game where you have to guess your opponent's secret code within a limited number of guesses."
    puts 'For our game, you the code will be 4 numeric digits (1-6) and you have 12 guesses to crack the code'
  end

  def play_round
  end

  def select_random_code
    4.times { @code_to_solve.push(rand(1..6)) }
  end

  # first split the input code into an array and see if the solution contains the character
  def check_if_input_included(input)
    @includes_counter = 0
    input_array = input.split('').map(&:to_i)
    input_array.each do |guess_number|
      @includes_counter += 1 if @code_to_solve.include?(guess_number)
    end
  end

  # split the input code into an hash and see if the sol contains char in loc (using k as location, v as guess number)
  def check_if_input_included_in_right_spot(input)
    input_hash = {}
    code_to_solve_hash = {}
    input.split('').map(&:to_i).each_with_index { |number, index| input_hash[index + 1] = number }
    @code_to_solve.each_with_index { |number, index| code_to_solve_hash[index + 1] = number }
    4.times do |i|
      @includes_and_location_counter += 1 if input_hash[i + 1] == code_to_solve_hash[i + 1]
    end
  end
end

# Player class represents the player and the computer playing the game
class Player
  # need to add while loop to ensure valid input
  def validate_input(code)
    code.is_a?(Integer) && code >= 1111 && code <= 6666
  end
end

game = Mastermind.new
game.select_random_code
p game.code_to_solve
p game.check_if_input_included('1234')
p game.check_if_input_included_in_right_spot('1234')
p game.includes_counter
p game.includes_and_location_counter
