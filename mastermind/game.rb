module Mastermind

  # Represents one game of mastermind and adds functionality for gameplay
  class Game

    def initialize(name)
      @player = Player.new(name)
      @board = Board.new
      @turn = 1
      @colors = ["red", "orange", "yellow", "green", "blue", "purple"]
      @computer = nil
      @secret_code = Pattern.new
      @win = false
    end

    # Starts and goes through one game of mastermind
    def play_game
      instructions
      play_one_round
      puts "\nGoodbye!"
    end

    # Plays one round of the game
    def play_one_round
      @player.choose_role
      @computer = Computer.new(@player.role)
      create_secret_code
      
      until @turn > 12 || win?
        take_turn
        @turn += 1
      end
      win?

      ending_screen
    end

    # Displays the instructions
    def instructions
      puts """\nHello! Welcome to Mastermind!
      \nThis is a 2-player game in which there is a codemaker and a codebreaker.
      \nThe codemaker will make a secret 4-color code consisting of:"""
      @colors.each do |color|
        first_letter = color.upcase[0]
        puts "      " + Paint["#{color} (#{first_letter})", \
                                @board.colorized[first_letter.to_sym], "black"]
      end
      puts "The codebreaker has 12 turns to guess that 4-color code, given "\
      "feedback from the codemaker."
      puts """\nIf you are the codemaker:
      You will first start off by making a 4-color code.
      Each turn, the computer will make a guess.
      You must then give the following feedback about the computer's guess:
          -The number of correct slots
          -The number of correct colors
      You win if the computer can't break your secret code after 12 turns!
      \nIf you are the codebreaker:
      Each turn, you will enter your 4-color guess in each of 4 slots.
      The computer will then give you the following feedback about your guess:
          -The number of correct slots
          -The number of correct colors
      You win if you can break the computer's secret code after 12 turns!
      \nGood Luck!"""
    end

    # Creates a new pattern (either from the computer or user) 
    # and sets it equal to @secret_code
    def create_secret_code
      if @player.role == "codebreaker"
        @secret_code.generate_random_pattern(@colors)
      else
        puts "\nPlease enter your secret code in the following slots:"
        @secret_code = new_user_pattern
      end
    end

    # Allows one turn to proceed with a new block being added to the board
    def take_turn
      if @player.role == "codebreaker"
        puts " \n" + "=" * 67
        puts "TURN #{@turn}"
        puts @board.formatted_board
        user_add_block
      else
        puts " \n" + "=" * 67
        puts "TURN #{@turn} \n \n"
        puts "Your secret code is:       "\
             "#{@secret_code.print_abbreviated_colors}\n "
        computer_add_block
        puts @board.formatted_board
      end
    end

    # Returns a new pattern (guess) created by user inputs
    def new_user_pattern
      new_pattern = Pattern.new
      1.upto(4) do |slot|
        puts "What color would you like to place in Slot #{slot}? "\
             "(R, O, Y, G, B, P)"
        print ">> "
        input = gets.chomp
        until valid_input?(input)
          puts "Invalid color! Choose from R, O, Y, G, B, P."
          print ">> "
          input = gets.chomp
        end
        new_pattern.add_color(input)
      end
      new_pattern
    end

    # Returns true if input is valid
    def valid_input?(input)
      if input.length == 1 # When user gives abbreviated color
        @colors.any? { |color| color[0] == input.downcase }
      else # When user gives full color
        @colors.include? input.downcase
      end
    end

    # Returns true if codebreaker has won game and sets win variable to true
    def win?
      if @board.guesses.empty? # When board is empty
        false
      elsif @board.guesses.last.colors == @secret_code.colors
        @win = true
        true
      else
        false
      end
    end

    private

    # Ending screen output
    def ending_screen
      puts " \n" + "=" * 67
      puts" \nThe game is over!\n \n"
      puts @board.formatted_board
      puts "The secret code was #{@secret_code.pretty_print}."

      if @player.role == "codebreaker"
        player_as_codebreaker_ending
      else
        player_as_codemaker_ending
      end

      puts " \nPlay again? (Y/N)"
      print ">> "
      output = gets.chomp
      restart_game if output.downcase == "y"
    end

    # Restarts the game
    def restart_game
      @board = Board.new
      @turn = 1
      @colors = ["red", "orange", "yellow", "green", "blue", "purple"]
      @computer = nil
      @secret_code = Pattern.new
      @win = false
      play_one_round
    end

    #### PLAYER AS CODEBREAKER ###

    # Allows user to add a pattern and computer to add feedback
    def user_add_block
      guess = new_user_pattern
      feedback = @computer.give_feedback(guess, @secret_code)
      @board.add_block(guess, feedback)
    end

    private

    # Ending screen when player is the codebreaker
    def player_as_codebreaker_ending
      if @win
        puts " \nYOU WON!!\n"
        puts "Congrats, you figured out the secret code!"
      else
        puts " \nYOU LOST.\n"
        puts "Sorry, you couldn't figure out the secret code."
      end
    end


    #### PLAYER AS CODEMAKER ###

    public

    # Allows computer to add a pattern and player to add feedback 
    def computer_add_block
      guess = @computer.give_pattern(@secret_code, @colors, @board.guesses)
      feedback = get_feedback(guess)
      @board.add_block(guess, feedback)
    end

    # Prompt user for feedback and returns that feedback
    def get_feedback(guess)
      feedback = {correct_slot: 0, correct_color: 0}

      puts "The computer's guess is:   #{guess.print_abbreviated_colors}\n "
      puts "Please give feedback on the computer's guess."
      puts "How many are in the correct slot?"
      print ">> "
      feedback[:correct_slot] = gets.chomp
      puts "Not counting the correct slots, how many are the correct color?"
      print ">> "
      feedback[:correct_color] = gets.chomp

      feedback
    end

    private

    # Ending screen when player is the codemaker
    def player_as_codemaker_ending
      if @win
        puts " \nYOU LOST.\n"
        puts "Sorry, the computer figured out your secret code."
      else
        puts " \nYOU WON!!\n"
        puts "Congrats, the computer couldn't figure out your secret code!"
      end
    end

  end

end
