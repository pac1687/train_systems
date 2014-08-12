require "./lib/trains"
require "./lib/stations"
require "./lib/stops"
require "pg"
require "pry"

DB = PG.connect(:dbname => 'train_system')

def main_menu
  puts "

            .---- -  -
           (   ,----- - -
            \_/      ___
          c--U---^--'o  [_
          |------------'_|
         /_(o)(o)--(o)(o)
   =================================="
  puts "
___ ____ ____ _ __ _   ____ _ _ ____ _ _ ___ ____ _  _ ____
  |  |--< |--| | | \|   ====  Y  ====  Y   |  |=== |\/| ====

  "
  puts "Are you an operator or rider:"
  puts "Press 'o' for operator."
  puts "Press 'r' for rider."
  puts "Press 'x' to exit the program."

  user_decision = gets.chomp
  if user_decision == 'o'
    operator_menu
  elsif user_decision == 'r'
    rider_menu
  elsif user_decision == 'x'
    puts "Thank you, please come again."
    exit
  else
    puts "Invalid entry. Please try again!"
    main_menu
  end
end

def operator_menu
  puts "Welcome, train system Conductor please choose an option:"
  puts "Press 't' to view train menu."
  puts "Press 'v' to view stops menu."
  puts "Press 's' to view station menu."
  puts "Press 'm' to view the main menu."
  puts "Press 'x' to exit the program."

  user_decision = gets.chomp
  if user_decision == 't'
    train_menu
  elsif user_decision == 'v'
    stops_menu
  elsif user_decision == 's'
    station_menu
  elsif user_decision == 'm'
    main_menu
  elsif user_decision == 'x'
    puts "Thank you, please come again."
    exit
  else
    puts "Invalid entry. Please try again!"
    main_menu
  end
end

def train_menu
  puts "*** Train Menu ***"
  puts "Press 'a' to add a train line."
  puts "Press 'l' to list all train lines."
  puts "Press 'u' to update a train line."
  puts "Press 'd' to delete a train line."
  puts "press 'x' to exit the program"

  user_decision = gets.chomp
  if user_decision == 'a'
    add_train
  elsif user_decision == 'l'
    list_trains
    puts "Press 'x' to return to train_menu"
    user_decision = gets.chomp
    if user_decision == 'x'
      train_menu
    end
  elsif user_decision == 'u'
    update_train
  elsif user_decision == 'd'
    main_menu
  elsif user_decision == 'x'
    puts "Thank you, please come again."
    exit
  else
    puts "Invalid entry. Please try again!"
    main_menu
  end
end

def stops_menu
end

def station_menu
end

def add_train
  puts "*** Add Train Menu ***"
  puts "Press 'a' to add a train line."
  puts "Press 'x' to return to the Train Menu."

  user_decision = gets.chomp
  if user_decision == 'a'
    puts "Please enter in the new train line name:"
    user_line = gets.chomp
    new_train = Trains.new({'lines' => user_line})
    new_train.save
    puts "'#{new_train.lines}' has been added."
    train_menu
  end
end

def list_trains
  puts "Operating trains are:"
  Trains.all.each do |line|
    puts "#{line.id}. #{line.lines}"
  end
end

def update_train
  puts "*** Update Train Menu ***"
  list_trains
  puts "Please enter the name of the train you would like to change:"
  user_decision = gets.chomp
  Trains.all.each do |name|
    if user_decision == name.lines
      search_decision = Trains.search(user_decision)
      puts "What would you like to re-name the train:"
      new_name = gets.chomp
      update = Trains.update_train(search_decision, new_name)
      puts "The train is now called #{new_name}!"
    else
      puts "Your entry is invalid. Please try again!"
    update_train
    end
  end
end

main_menu
