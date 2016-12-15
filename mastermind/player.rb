module Mastermind

  # Represents a single human player in the game that will guess the code
  class Player
    attr_reader :name, :role

    def initialize(name)
      @name = name
      @role = nil
    end

    # Prompts player for role choice and sets it equal to @role
    def choose_role
      puts " \n" + "=" * 67
      puts "Would you like to be the codemaker or codebreaker?"
      print ">> "
      @role = gets.chomp.downcase
      until role == "codemaker" || role == "codebreaker"
        puts "Not a valid input! Please type either codemaker or codebreaker."
        print ">> "
        @role = gets.chomp.downcase
      end
    end
  end

end