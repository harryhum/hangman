require 'yaml'

def load_dictionary
    words = File.readlines "5desk.txt"

    words.each do |word|
        word = word.strip
        if word.length >= 5 && word.length <= 12
            @dictionary << word.downcase
        end
    end
end

def select_word
    @secret_word = @dictionary[rand(@dictionary.length - 1)]
end

def initialize_word_board
    index = 0
    @secret_word.each_char do |letter|
        #word_board[index] - [0] = letter of secret word, [1] = visible to player (y/n), [2] = character shown to player
        @word_board[index] = [letter, "n", "_"]
        index += 1
    end
end

def check_guess
    @good_guess = false
    index = 0
    @secret_word.each_char do |letter|
        if @guess.eql?@word_board[index][0]
            @word_board[index][1] = "y"
            @good_guess = true
        end
        index += 1
    end
    if @good_guess == false
        @mistakes += 1
        @incorrect_letters << @guess
    end
end

def show_word_board
    print "Secret word: "
    index = 0
    @secret_word.each_char do |letter|
        if @word_board[index][1] == "y"
            @word_board[index][2] = @word_board[index][0]
        end
        print @word_board[index][2]
        print " "
        index += 1
    end
end

def draw_board
    puts
    puts        "  [-----|"
    if @mistakes == 0
        puts    "        |"
    elsif @mistakes >= 1 
        puts    "  0     |"
    end
    
    if @mistakes <= 1 
        puts    "        |"
    elsif @mistakes == 2 
        puts    "  |     |"
    elsif @mistakes >= 3 
        puts    "  T     |"
    end

    if @mistakes <= 3 
        puts    "        |"
    elsif @mistakes == 4 
        puts    "  /     |"
    elsif @mistakes == 5 
        puts    "  /\\    |"
    end

    puts        "  ______|_"
    puts
    show_word_board
    puts
    print "Incorrect letters: " + @incorrect_letters.to_s
    puts
    puts "Wrong guesses left: #{5 - @mistakes}"
end

def get_guess
    print "Suggest a letter or type \"save\" to save the game: "
    @guess = gets.chomp.downcase
    if @guess == "save"
        save_game
    end
    while @guess.length == 0 || @guess.length > 1 do
        puts "That is not a valid letter."
        print "Suggest a letter: "
        @guess = gets.chomp.downcase
    end
end

def win?
    win = true
    index = 0
    @secret_word.each_char do |letter|
        if @word_board[index][1] == "n"
            win = false
        end
        index += 1
    end
    return win
end

def lose?
    @mistakes == 5 ? true : false
end

def game_over
    if win? == true
        draw_board
        puts "You won!"
        true
    elsif lose? == true
        draw_board
        puts "You lost! The secret word was " + @secret_word + "."
        true
    else
        false
    end
end

def new_game
    @dictionary = []
    @word_board = {}
    @secret_word = ""
    @guess = ""
    @incorrect_letters = []
    @mistakes = 0
    print_instructions
    prompt_game_load
end

def save_game
    game_data = [@word_board, @secret_word, @incorrect_letters, @mistakes]
    yaml = YAML::dump(game_data)
    save_file = File.new("save_file.yaml", "w+")
    save_file.write(yaml)
    puts "The current game has been saved."
    exit
end

def load_game
    game_data = YAML::load_file("save_file.yaml")
    if game_data == false
        puts "No saved games found."
        puts "Starting new game."
        load_dictionary
        select_word
        initialize_word_board
    else
        @word_board = game_data[0]
        @secret_word = game_data[1]
        @incorrect_letters = game_data[2]
        @mistakes = game_data[3]
        puts "The previous game has been successfully loaded."
    end
    File.new("save_file.yaml", "w+")
end

def prompt_game_load
    print "Would you like to load the last saved game? (y/n): "
    answer = gets.chomp.downcase

    if answer == "y"
        load_game
    elsif answer == "n"
        load_dictionary
        select_word
        initialize_word_board
    else
        print "Please enter (y/n): "
        answer = gets.chomp.downcase
    end
end

def print_instructions
    puts "The fate of the man on the noose is in your hands..."
    puts "Guess all the letters of the secret word before making 5 mistakes."

    puts "You can save the game at any time."
end

new_game
while (!game_over) do
    draw_board
    get_guess
    check_guess
    win?
    lose?
end