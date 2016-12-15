module Mastermind

  # Represents the computer player
  class Computer

    def initialize(role)
      @role = role
    end


    #### COMPUTER AS CODEMAKER #### 

    # Given a guess and the secret code, computer will create a
    # clue object and incremement the counts of the clues appropriately
    def give_feedback(guess, code)
      code_colors = code.colors.dup
      guess_colors = guess.colors.dup
      clues = new_clues
      clues = increment_correct_slot(guess_colors, code_colors, clues)
      clues = increment_correct_color(guess_colors, code_colors, clues)
      clues
    end

    # Finds any completely correct slots and increments :correct_slot
    # in the clues object
    def increment_correct_slot(guess, code, clues)
      guess.each_with_index do |color, index|
        if color == code[index]
          clues[:correct_slot] += 1
          code[index] = nil # Won't be included for next testing
          guess[index] = nil # Same
        end
      end 

      clues
    end

    # Finds any correct colors and increments :correct_color
    # in the clues object
    def increment_correct_color(guess, code, clues)
      correct_colors = [] # To prevent duplicate colors from giving clues
      guess.each_with_index do |color, index|
        if !color.nil? && code.include?(color) && 
           !correct_colors.include?(color)
          clues[:correct_color] += 1
          correct_colors << color
        end
      end

      clues
    end

    private

    # Returns a new set of clues
    def new_clues
      {correct_slot: 0, correct_color: 0}
    end


    #### COMPUTER AS CODEBREAKER #### 

    public

    # Given a secret code and all possible colors, returns a new guess
    def give_pattern(code, possible_colors, guesses)
      new_pattern = Pattern.new
      last_guess = guesses.empty? ? [] : guesses.last.colors.dup
      temp_code = code.colors.dup
      temp_guess = [nil, nil, nil, nil]
      guess_and_code = add_correct_slots(temp_guess, code, temp_code, guesses, \
                                         last_guess)
      temp_guess = add_correct_colors(guess_and_code[0], guess_and_code[1], \
                                      guess_and_code[2])
      
      temp_guess.each do |color|
        if color == nil
          new_pattern.add_color(possible_colors.sample)
        else
          new_pattern.add_color(color)
        end
      end
      new_pattern
    end

    # Any any colors in correct slots to the temp_guess
    def add_correct_slots(temp_guess, code, temp_code, guesses, last_guess)
      0.upto(3) do |slot|
        if correct_slot?(code, slot, guesses)
          temp_guess[slot] = code.colors[slot]
          temp_code[slot] = nil
          last_guess[slot] = nil
        end
      end
      [temp_guess, temp_code, last_guess]
    end

    # Given a code, determines if a certain slot was correct in 
    # any of the previous guesses
    def correct_slot?(code, slot, guesses)
      guesses.each do |guess|
        return true if guess.colors[slot] == code.colors[slot]
      end
      false
    end

    # Add any correct colors to the temp_guess
    def add_correct_colors(temp_guess, temp_code, last_guess)
      must_place = {}
      last_guess.each_with_index do |color, slot|
        if color != nil && temp_code.include?(color)
          must_place[color] = slot
        end
      end
      must_place.each do |correct_color, prev_slot|
        temp_guess.each_with_index do |color, slot|
          if color == nil && prev_slot != slot
            temp_guess[slot] = correct_color
            break
          end
        end
      end
      temp_guess
    end

  end

end