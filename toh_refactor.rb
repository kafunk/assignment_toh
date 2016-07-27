#rendering methods
def visual_padding
  print "\n"
end

def blank_line?(current_board, index)
  current_board.all? do |tower_num, tower_array|
    tower_array[index] == nil
  end
end

def num_spaces(col_width, type, num)
  num = num.to_i
  if type == "disc"
    spaces = (col_width - num * 2)/2
  else
    spaces = (col_width - 8)/2
  end
end

def print_spaces(spaces)
  spaces.times {print " "}
end

def print_main(type, num)
  num = num.to_i
  if type == "disc"
    num.times {print "<>"}
  else
    print "Tower #{num}"
  end
end

def print_column_names(col_width)
  column_names = ["01", "02", "03"]
  column_names.each {|column_name| visualize(col_width, "tower_label", "#{column_name}")}
  2.times {visual_padding}
end

def visualize(col_width, type, num)
  print_spaces(num_spaces(col_width, type, num))
  print_main(type, num)
  print_spaces(num_spaces(col_width, type, num))
end

#input processing
def get_input(current_board, total_discs)
  print "> "
  input = gets.chomp
  sift_input(input, current_board, total_discs)
end

def sift_input(input, current_board, total_discs)
  if input.empty?
    puts "(..type something!)"
    get_input
  elsif quit?(input)
    quit
  else
    process_input(input, current_board, total_discs)
  end
end

def process_input(input, current_board, total_discs)
  from_to = input.split("")
  from_to.reject! {|item| item =~ /\D/}
  from_to.map {|digit| digit.to_i}
  if from_to.length == 1
    from_to = from_to + from_to
  end
  move(from_to, current_board, total_discs)
end

  #valid_move tests
  def proper_input?(from_to)
    from_to.length == 2 &&
    from_to.each {|num| num.to_i.between?(1,3)} &&
    from_to[0] != from_to[1]
  end

  def disc_available?(from_to, current_board)
    !current_board["#{from_to[0]}"].empty?
  end

  def within_rules?(from_to, current_board)
    current_board["#{from_to[1]}"].empty? || current_board["#{from_to[1]}"][-1] > current_board["#{from_to[0]}"][-1]
  end

def valid_move?(from_to, current_board)
  proper_input?(from_to) &&
  disc_available?(from_to, current_board) &&
  within_rules?(from_to, current_board)
end

#exit... or don't
def quit?(input)
  input.strip == "q" || input.strip == "quit"
end

def quit
  puts "Alright, we'll take a break for now. Come play again soon!"
end

def won?(tower_2, tower_3, total_discs)
  tower_2 == [*1..total_discs].sort.reverse || tower_3 == [*1..total_discs].sort.reverse
end

def won!(current_board, total_discs)
  puts "YOU WON! Nice job."
  render(current_board, total_discs)
  play_again?
end

#initialize
def total_discs_get
  print "> "
  total_discs = gets.strip.to_i
  process_total_discs(total_discs)
end

def process_total_discs(total_discs)
  if total_discs < 3
    puts "Try playing with at least 3 discs."
    total_discs_get
  elsif total_discs > 50
    puts "Your screen is only so wide. Go lower!"
    total_discs_get
  else
    puts "Initializing play with #{total_discs} discs..."
    initialize_hanoi(total_discs)
  end
end 

def initialize_hanoi(total_discs)
  tower_1 = [*1..total_discs].reverse
  tower_1.map {|disc| disc.to_s}
  tower_2 = []
  tower_3 = []
  current_board = {"1" => tower_1, "2" => tower_2, "3" => tower_3} 
  prompt_move(current_board, total_discs, "first")
end

#play loop
def prompt_move(current_board, total_discs, move = "not first")
  puts "Here is the current state of the board:\n"
  render(current_board, total_discs)
  print "Enter where you'd like to move in the format 'from, to'."
  if move == "first"
    print "For example, enter the digits '1' and '3' to move a disc from Tower 1 to Tower 3. Enter 'q' if you want to quit the game at any time. For further instructions on how to play TOH, google that sh*t."
  end
  visual_padding
  get_input(current_board, total_discs)
end

def move(from_to, current_board, total_discs)
  if valid_move?(from_to, current_board)
    current_board["#{from_to[1]}"] << current_board["#{from_to[0]}"].pop
    play(current_board, total_discs)
  else
    puts "Invalid move, please try again." 
    get_input(current_board, total_discs)
  end
end

def render(current_board, total_discs)
  index = total_discs - 1
  col_width = total_discs * 2 + 2
  until index < 0
    unless blank_line?(current_board, index)
      current_board.each do |tower_num, tower_array|
        visualize(col_width, "disc", tower_array[index])
      end
    end
    visual_padding
    index -= 1
  end
  print_column_names(col_width)
end

def play(current_board, total_discs)
  if won?(current_board["2"], current_board["3"], total_discs)
    won!(current_board, total_discs)
  else
    prompt_move(current_board, total_discs)
  end
end

#start the game
puts "Welcome to Tower of Hanoi!"
puts "How many discs do you want to play with?"
total_discs_get