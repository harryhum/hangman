#load dictionary
def load_dictionary
    words = File.readlines "5desk.txt"

    words.each do |word|
        word = word.strip
        if word.length >= 5 && word.length <= 12
            @dictionary << word.downcase
        end
    end
end

#select 5-12 letter word
def select_word
    @secret_word = @dictionary[rand(@dictionary.length - 1)]
end

#update word board
def update_word_board
    index = 0
    @secret_word.each_char do |letter|
        #word_board[index] - [0] = letter of secret word, [1] = visible to player (y/n), [2] = character shown to player
        @word_board[:index] = [letter, "n", "_"]
        index += 1
        if @guess != "" && @guess = @word_board[:index][0]
            @word_board[:index][1] = "y"
            @good_guess = true
        elsif @guess != "" && @guess != @word_board[:index][0] 
            @good_guess = false
            @mistakes += 1
        end
    end
end

#return word visible to player
def show_word_board
    print "Secret word: "
    index = 0
    @secret_word.each_char do |letter|
        if @word_board[:index][1] == "y"
            @word_board[:index][2] = @word_board[:index][0]
        end
        print @word_board[:index][2]
        print " "
        index += 1
    end
    puts
end

#draw hangman board (hanger, man, number of incorrect guesses, word board, used letters)
def draw_board
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
    puts "Incorrect letters: "
    puts "Wrong guesses left: #{5 - @mistakes}"
end

#take guess
def get_guess
    print "Suggest a letter: "
    @guess = gets.chomp.downcase
    while @guess.length == 0 || @guess.length > 1 do
        print "That is not a valid letter"
        @guess = gets.chomp.downcase
    end
end

#check win/lose
def game_over
    index = 0 
    @secret_word.each_char do |letter|
        if @word_board[:index][1] == "y"
            @win == true
        end
        index += 1
    end

    if @mistakes == 5
        true
    elsif @win == true
        true
    else 
        false
    end
end 

#execute turn actions (guess letter, update board, check win/lose)
def execute_turn
    draw_board
    get_guess
    update_word_board
    game_over
end

def new_game
    #initialize class variables
    @dictionary = []
    @word_board = {}
    @secret_word = ""
    @guess = ""
    @good_guess = false
    @mistakes = 0
    load_dictionary
    select_word
    update_word_board
    game_over
end
