module Mastermind

  # Represents the mastermind board, consisting of all of the patterns guessed
  class Board
    attr_accessor :guesses, :feedback, :colorized

    def initialize
      @guesses = []
      @feedback = []

      # For formatting of colored output 
      @colorized = { R: [220,20,60], O: [255,163,0], Y: [255,215,0], 
                     G: [34,139,34], B: [30,144,255], P: [148,0,211] }
    end

    # Takes in a pattern object and a feedback object and adds it to the
    # guesses and feedback arrays
    def add_block(pattern, feedback)
      @guesses << pattern
      @feedback << feedback
    end

    # Returns a formatted board as a string that contains 
    # all of the items from @gusses and @feedback
    def formatted_board
      background = [40,40,40] # Background color for table
      board_as_text = "\nCurrent Guesses and Feedback History:\n"
      board_as_text << " " * 46 << "\# Correct   \# Correct\n"
      board_as_text << "Guess \#   Slot 1   Slot 2   Slot 3   Slot 4      "\
                       "Slot        Color\n"
      board_as_text << "-" * 67 << "\n"

      @guesses.each_with_index do |guess, i|
        if i < 9
          board_as_text << Paint["   #{i + 1}   ", "white", background]
        else
          board_as_text << Paint["   #{i + 1}  ", "white", background]
        end
        guess.colors.each do |color|
          board_as_text << Paint["      #{color.to_s}  ", \
                                 @colorized[color], background]
        end
        @feedback[i].each do |clue, num| 
          board_as_text << Paint["        #{num}   ", "white", background]
        end
        board_as_text << "\n"
      end

      board_as_text << " \n"
    end

  end

end
