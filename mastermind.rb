# frozen_string_literal: true

# MasterMind class currently contains game logic and state
class Mastermind
  attr_reader :code_to_solve

  def initialize
    @code_to_solve = []
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

  def select_random_code
    4.times { @code_to_solve.push(rand(1..6)) }
  end

  # first split the input code into an array
  # second see if the solution contains the character, if so map to new array with position maintained? hash?
  # for the characters
  def check_input_to_code(input)
    input_array = input.split('').map(&:to_i)
    includes_counter = 0
    input_array.each do | guess_number |
      if @code_to_solve.include?(guess_number) then includes_counter += 1 end
    end
    includes_counter
  end
end

# Player class represents the player and the computer playing the game
class Player
  def validate_input(code)
    code.is_a?(Integer) && code >= 1111 && code <= 6666
  end
end

game = Mastermind.new
game.select_random_code
p game.code_to_solve
p game.check_input_to_code('1234')
