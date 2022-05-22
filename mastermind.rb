# frozen_string_literal: true

# MasterMind class currently contains game logic and state
class Mastermind
  attr_reader :code_to_solve, :includes_and_location_counter, :includes_counter

  def initialize
    @code_to_solve = []
    @guessed_code = []
    @hint = ''
    @round = 1
    @game_over = false
  end

  def welcome
    puts '|++++++++++++++++++++++++++++++|'
    puts '|+++++++++ MASTERMIND +++++++++|'
    puts '|++++++++++++++++++++++++++++++|'
    puts ''
    puts 'Welcome to MASTERMIND. The game of Mind Masters.'
    puts ''
    puts "MASTERMIND is a game where you have to guess your opponent's secret code within a limited number of guesses."
    puts 'For our game, the code will be 4 numeric digits (1-6) and the breaker has 12 guesses to crack the code'
    puts 'Press 1 if you would like to be BREAKER or 2 if you would like to be MAKER. The CPU will be your oponent if you are MAKER.'
  end

  def select_mode
    input = gets.chomp.to_i
    until input == 1 || input == 2
      puts 'Invalid input. Press 1 if you would like to be BREAKER or 2 if you would like to be MAKER.'
      input = gets.chomp.to_i
    end
    input
  end

  def play_game
    welcome
    if select_mode == 1
      breaker = Player.new
      select_random_code
    else
      breaker = CPU.new
    end
    play_round(breaker) until @game_over
    print_game_over_message
  end

  def play_round(breaker)
    breaker.capture_input
    check_if_partial_match(breaker.input_code)
    check_if_exact_match(breaker.input_code)
    create_hint
    print_hint_and_round_info
    check_for_win
    check_for_loss
  end

  def select_random_code
    4.times { @code_to_solve.push(rand(1..6)) }
  end

  def select_code
    4.times { @code_to_solve.push(rand(1..6)) }
  end

  def check_if_partial_match(input_array)
    @partial_matches = 0
    input_hash = {}
    filtered_array = input_array.select { |number| @code_to_solve.include?(number) }
    filtered_array.each { |number| input_hash[number] = [@code_to_solve.count(number), input_array.count(number)].min }
    @partial_matches = input_hash.values.sum
  end

  # split the input code into an hash and see if the sol contains char in loc (using k as location, v as guess number)
  def check_if_exact_match(input_array)
    @exact_matches = 0
    input_hash = {}
    code_to_solve_hash = {}
    input_array.each_with_index { |number, index| input_hash[index + 1] = number }
    @code_to_solve.each_with_index { |number, index| code_to_solve_hash[index + 1] = number }
    4.times do |i|
      @exact_matches += 1 if input_hash[i + 1] == code_to_solve_hash[i + 1]
    end
  end

  def create_hint
    @hint = ''
    @exact_matches.times { @hint += '+' }
    (@partial_matches - @exact_matches).times { @hint += '-' }
    @hint
  end

  def print_hint_and_round_info
    puts "Round: #{@round} Result: #{@hint}"
    @round += 1
  end

  def check_for_win
    @game_over = true if @hint == '++++'
  end

  def check_for_loss
    @game_over = true if @round > 12
  end

  def print_game_over_message
    puts 'Game over!'
    if @hint == '++++'
      puts 'You Win!'
    else
      puts 'You Lose!'
    end
  end
end

# Player class represents the player and the computer playing the game
class Player
  attr_reader :input_code

  def initialize
    @input_code = []
  end

  def validate_input(code)
    code.is_a?(Integer) && code >= 1111 && code <= 6666
  end

  def capture_input
    puts 'Please enter a 4 digit code using 1-6 for each digit.'
    input = gets.chomp.to_i
    until validate_input(input)
      puts 'Invalid input. Please enter a 4 digit code using 1-6 for each digit.'
      input = gets.chomp.to_i
    end
    @input_code = input.to_s.split('').map(&:to_i)
  end
end

# CPU class replaces the user input with Random guesses and then ultimately algorithmically guided guesses
class CPU < Player
  def capture_input
    @input_code = []
    4.times { @input_code.push(rand(1..6)) }
  end
end

game = Mastermind.new
game.play_game
