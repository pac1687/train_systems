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
  puts "Press 's' to view station menu."
  puts "Press 'v' to view stops menu."
  puts "Press 'm' to view the main menu."
  puts "Press 'x' to exit the program."

  user_decision = gets.chomp
  if user_decision == 't'
    train_menu
  elsif user_decision == 's'
    station_menu
  elsif user_decision == 'v'
    stops_menu
  elsif user_decision == 'm'
    main_menu
  elsif user_decision == 'x'
    puts "Thank you, please come again."
    exit
  else
    puts "Invalid entry. Please try again!"
    operator_menu
  end
end

def rider_menu
  puts "*** Rider Menu ***"
  puts "Press 't' to view the train menu."
  puts "Press 's' to view the station menu."
  puts "Press 'm' to view the main menu."
  puts "Press 'x' to exit the program."

  user_decision = gets.chomp
  if user_decision == 't'
    rider_train_menu
  elsif user_decision == 's'
    rider_station_menu
  elsif user_decision == 'm'
    main_menu
  elsif user_decision == 'x'
    puts "Thank you, please come again."
    exit
  else
    puts "Invalid entry. Please try again!"
    rider_menu
  end
end

def train_menu
  puts "*** Train Menu ***"
  puts "Press 'a' to add a train line."
  puts "Press 'l' to list all train lines."
  puts "Press 'u' to update a train line."
  puts "Press 'd' to delete a train line."
  puts "Press 'o' to return to the operator menu."
  puts "press 'x' to exit the program."

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
    list_trains
    puts "Enter the number of the train you would like to delete:"
    user_decision = gets.chomp.to_i
    Trains.delete_train(user_decision)
    puts "Train deleted!"
    train_menu
  elsif user_decision == 'o'
    operator_menu
  elsif user_decision == 'x'
    puts "Thank you, please come again."
    exit
  else
    puts "Invalid entry. Please try again!"
    train_menu
  end
end

def stops_menu
  puts "*** Stops Menu ***"
  puts "Press 'a' to add a stop."
  puts "Press 'l' to list all stops."
  puts "Press 'u' to update a stop."
  puts "Press 'd' to delete a stop."
  puts "press 'x' to exit the program."

  user_decision = gets.chomp
  if user_decision == 'a'
    add_stop
  elsif user_decision == 'l'
    list_stops
    puts "Press 'x' to return to stop_menu"
    user_decision = gets.chomp
    if user_decision == 'x'
      stops_menu
    end
  elsif user_decision == 'd'
    list_stops
    puts "Enter the number of the stop you would like to delete:"
    user_decision = gets.chomp.to_i
    Stops.delete_stop(user_decision)
    puts "Stop deleted!"
    stops_menu
  elsif user_decision == 'x'
    puts "Thank you, please come again."
    exit
  else
    puts "Invalid entry. Please try again!"
    stops_menu
  end
end

def add_stop
  puts "*** Add a Stop Menu ***"
  puts "Press 'a' to add a stop."
  puts "Press 'x' to return to the Stop Menu."

  user_decision = gets.chomp
  if user_decision == 'a'
    puts "Here are the current trains:"
    list_trains
    puts "Here are the current stations:"
    list_stations
    puts "Type in the name of the train:"
    new_train = gets.chomp
    train_search = Trains.search(new_train)
    puts "Where do you want '#{new_train}' to go? Enter the name of the station:"
    new_station = gets.chomp
    station_search = Stations.search(new_station)
    new_stop = Stops.new({'trains_id' => train_search, 'stations_id' => station_search})
    new_stop.save
    puts "'#{new_train}' now goes to '#{new_station}'."
    stops_menu
  end
end

def list_stops
  puts "*** List Stops Menu ***"
  puts "Here are all the currently operating trains:"
  list_trains
  puts "These are all of the stations in working order:"
  list_stations
  puts "The stops are:"

  Stops.all.each do |stop|
    puts "Stop ID: #{stop.id} Train ID: #{stop.trains_id} Station ID: #{stop.stations_id}"
  end

  puts "Press 'x' to return to the Stop Menu.\n"
  user_decision = gets.chomp
  if user_decision == 'x'
    stops_menu
  end
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
  search_decision = Trains.search(user_decision)
  if search_decision != nil
    puts "What would you like to re-name the station:"
    new_name = gets.chomp
    Trains.update_train(search_decision, new_name)
    puts "The train is now called #{new_name}!"
    train_menu
  else
    puts "Your entry is invalid. Please try again!"
    update_train
  end
  train_menu
end

def station_menu
  puts "*** Station Menu ***"
  puts "Press 'a' to add a station."
  puts "Press 'l' to list all station."
  puts "Press 'u' to update a station."
  puts "Press 'd' to delete a station."
  puts "Press 'o' to return to the operator menu."
  puts "press 'x' to exit the program."

  user_decision = gets.chomp
  if user_decision == 'a'
    add_station
  elsif user_decision == 'l'
    list_stations
    puts "Press 'x' to return to station_menu"
    user_decision = gets.chomp
    if user_decision == 'x'
      station_menu
    end
  elsif user_decision == 'u'
    update_station
  elsif user_decision == 'd'
    list_stations
    puts "Enter the number of the station you would like to delete:"
    user_decision = gets.chomp.to_i
    Stations.delete_station(user_decision)
    puts "Station deleted!"
    station_menu
  elsif user_decision == 'o'
    operator_menu
  elsif user_decision == 'x'
    puts "Thank you, please come again."
    exit
  else
    puts "Invalid entry. Please try again!"
    station_menu
  end
end

def add_station
  puts "*** Add a Station Menu ***"
  puts "Press 'a' to add a station."
  puts "Press 'x' to return to the Station Menu."

  user_decision = gets.chomp
  if user_decision == 'a'
    puts "Please enter in the new station name:"
    user_station = gets.chomp
    new_station = Stations.new({'stations' => user_station})
    new_station.save
    puts "'#{new_station.stations}' has been added."
    station_menu
  end
end

def list_stations
  puts "Operating stations are:"
  Stations.all.each do |station|
    puts "#{station.id}. #{station.stations}"
  end
end

def update_station
  puts "*** Update Stations Menu ***"
  list_stations
  puts "Please enter the name of the station you would like to change:"
  user_decision = gets.chomp
  search_decision = Stations.search(user_decision)
  if search_decision != nil
    puts "What would you like to re-name the station:"
    new_name = gets.chomp
    Stations.update_station(search_decision, new_name)
    puts "The station is now called #{new_name}!"
    station_menu
  else
    puts "Your entry is invalid. Please try again!"
    update_station
  end
  station_menu
end

def rider_train_menu
  puts "*** Rider Train Menu ***"
  list_trains
  puts "Enter the train name to see the stations where it stops:"
  user_decision = gets.chomp
  train_search = Trains.search(user_decision)
  results = Stops.station_stops_list(train_search)
  list_stations
  puts "Please check the corresponding IDs.  Here are the stations:"
  # binding.pry
  results.each do |result|
    puts "Stop ID: #{result.id} Station: #{result.stations}"
  end
  rider_menu
end

def rider_station_menu
  puts "*** Rider Station Menu ***"
  list_stations
  puts "Enter the station name to see the trains that stop there:"
  user_decision = gets.chomp
  station_search = Stations.search(user_decision)
  results = Stops.trains_list(station_search)
  list_trains
  puts "Please check the corresponding IDs.  Here are the trains:"
  # binding.pry
  results.each do |result|
    puts "Stop ID: #{result.id} Line: #{result.lines}"
  end
  rider_menu
end

main_menu
