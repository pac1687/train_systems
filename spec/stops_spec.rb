require "train_spec_helper"

describe Stops do

  it 'initializes a stop with a trains id and stations id' do
    test_stop = Stops.new({'trains_id' => 1, 'stations_id' => 1})
    expect(test_stop).to be_an_instance_of Stops
  end

  it "allows stops to be saved to the database" do
    test_stop = Stops.new({'trains_id' => 1, 'stations_id' => 1})
    test_stop.save
    expect(Stops.all).to eq [test_stop]
  end

  it 'lists out all the stops' do
    test_stop = Stops.new({'trains_id' => 1, 'stations_id' => 1})
    test_stop.save
    test_stop1 = Stops.new({'trains_id' => 1, 'stations_id' => 2})
    test_stop1.save
    list_stops = Stops.all
    expect(Stops.all).to eq [test_stop, test_stop1]
  end

  it 'lists all the station stops on a line' do
    test_train = Trains.new({'lines' => "Grasshopper"})
    test_train.save
    test_train1 = Trains.new({'lines' => "The Norris"})
    test_train1.save
    test_station = Stations.new({'stations' => "St. Louis"})
    test_station.save
    test_station1 = Stations.new({'stations' => "Kansas City"})
    test_station1.save
    test_stop = Stops.new({'trains_id' => test_train.id, 'stations_id' => test_station.id})
    test_stop1 = Stops.new({'trains_id' => test_train.id, 'stations_id' => test_station1.id})
    test_stop2 = Stops.new({'trains_id' => test_train1.id, 'stations_id' => test_station1.id})
    test_stop.save
    test_stop1.save
    test_stop2.save
    test_search = "Grasshopper"
    search_id = Trains.search(test_search)
    results = Stops.station_stops_list(search_id)
    expect(results).to eq [test_station, test_station1]
  end

  it "lists all the trains associated with a station" do
    test_train = Trains.new({'lines' => "Pacific NW"})
    test_train.save
    test_train1 = Trains.new({'lines' => "Mongrel"})
    test_train1.save
    test_station = Stations.new({'stations' => "Little Rock"})
    test_station.save
    test_station1 = Stations.new({'stations' => "Omaha"})
    test_station1.save
    test_stop = Stops.new({'trains_id' => test_train.id, 'stations_id' => test_station.id})
    test_stop1 = Stops.new({'trains_id' => test_train.id, 'stations_id' => test_station1.id})
    test_stop2 = Stops.new({'trains_id' => test_train1.id, 'stations_id' => test_station1.id})
    test_stop.save
    test_stop1.save
    test_stop2.save
    test_search = "Omaha"
    search_id = Stations.search(test_search)
    results = Stops.trains_list(search_id)
    expect(results).to eq [test_train, test_train1]
  end
end


