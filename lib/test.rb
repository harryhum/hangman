

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
    print "Suggest a letter: "
    @guess = gets.chomp.downcase
    while @guess.length == 0 || @guess.length > 1 do
        print "That is not a valid letter"
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

def execute_turn
    draw_board
    get_guess
    check_guess
    win?
    lose?
end

def new_game
    @dictionary = []
    @word_board = {}
    @secret_word = ""
    @guess = ""
    @incorrect_letters = []
    @mistakes = 0
    load_dictionary
    select_word
    initialize_word_board
end

new_game
while (!game_over) do
    execute_turn
end