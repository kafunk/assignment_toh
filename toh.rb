#helper methods
def column_names(tower_num, col_width)
  spaces = (col_width - 8)/2
  spaces.times do
    print " "
  end
  print "Tower #{tower_num}"
  spaces.times do
    print " "
  end
end

def tower_visual(disc_size, col_width)
  if disc_size.nil?
    disc_size = 0
  end
  spaces = (col_width - disc_size * 2)/2
  spaces.times do
    print " "
  end
  disc_size.times do
    print "<>"
  end
  spaces.times do
    print " "
  end
end

def valid_move?(from, to, current_board)
  if from.between?(1,3) && to.between?(1,3)
    if (from != to) && !current_board["#{from}"].empty?
      if current_board["#{to}"].empty?
        true
      elsif current_board["#{to}"][-1] > current_board["#{from}"][-1]
        true
      else
        false
      end
    end
  end
end

def quit?(input)
  input.strip == "q" || input.strip == "quit"
end

def won?(tower_2, tower_3, total_discs)
  tower_2 == [*1..total_discs].sort.reverse || tower_3 == [*1..total_discs].sort.reverse
end

def exit
  puts "Alright, we'll take a break for now. Come play again soon!"
end

#main methods
def move(from_to, current_board, total_discs)
  from = from_to[0].to_i
    to = from_to[1].to_i
  if valid_move?(from, to, current_board)
    current_board["#{to}"] << current_board["#{from}"].pop
    play(current_board, total_discs)
  else
    puts "Invalid move, please try again." 
    get_move(current_board, total_discs)
  end
end

def render(current_board, total_discs)
  i = 0
  index = total_discs - 1
  col_width = total_discs * 2 + 2
  print "\n"
  until (index-i) < 0
    if (current_board["1"][index-i] == nil) && (current_board["2"][index-i] == nil) && (current_board["3"][index-i] == nil)
      print "\n"
    else 
      current_board.each do |tower_num, tower_array|
        tower_visual((tower_array[index-i]), col_width)
      end
      print "\n"
    end
    i += 1
  end
  column_names("01", col_width)
  column_names("02", col_width)
  column_names("03", col_width)
  2.times { print "\n" }
end

def total_discs_get
  print "> "
  input = gets.chomp
  if input.empty?
    puts "(..type something!)"
    total_discs_get
  elsif quit?(input)
    exit
  else
    total_discs = input.strip.to_i
    if total_discs < 3
      puts "Try playing with at least 3 discs."
      total_discs_get
    elsif total_discs > 50
      puts "Your screen is only so wide. Go lower!"
      total_discs_get
    else
      puts "Initializing play with #{total_discs} discs..."
      init(total_discs)
    end
  end
end 

def init(total_discs)
  tower_1 = [*1..total_discs].reverse
  tower_1.map { |disc| disc.to_s }
  tower_2 = []
  tower_3 = []
  current_board = {"1"=>tower_1, "2"=>tower_2, "3"=>tower_3}
  puts "Here is the current state of the board:"
  render(current_board, total_discs)
  puts "Enter where you'd like to move in the format 'from, to', e.g. '1, 3'. Enter 'q' to quit."
  get_move(current_board, total_discs)
end

def get_move(current_board, total_discs)
  print "> "
  input = gets.chomp
  if input.empty?
    puts "(..type something!)"
    get_move(current_board, total_discs)
  elsif quit?(input)
    exit
  else
    from_to = input.split("")
    from_to.reject! {|item| item =~ /\D/ }
    if from_to.length == 1
      from_to = from_to + from_to
    end
    move(from_to, current_board, total_discs)
  end
end

def play(current_board, total_discs)
  if won?(current_board["2"], current_board["3"], total_discs)
    puts "YOU WON! Nice job."
    render(current_board, total_discs)
  else
    puts "Here is the current state of the board:\n"
    render(current_board, total_discs)
    puts "Enter your next move in format 'from, to'."
    get_move(current_board, total_discs)
  end
end

#main
puts "Welcome to Tower of Hanoi!"
puts "How many discs do you want to play with?"
total_discs_get