require "train_spec_helper"

describe Stations do

  it "initializes with a station name" do
    test_station = Stations.new({'stations' => "St. Louis"})
    expect(test_station).to be_an_instance_of Stations
  end

  it "allows stations to be saved to the database" do
    test_station = Stations.new({'stations' => "Kansas City"})
    test_station.save
    expect(Stations.all).to eq [test_station]
  end

  it 'lists out all the stations' do
    test_station = Stations.new({'stations' => "St. Louis"})
    test_station.save
    test_station1 = Stations.new({'stations' => "Kansas City"})
    test_station1.save
    list_stations = Stations.all
    expect(Stations.all).to eq [test_station, test_station1]
  end

  it 'searches for a station name and returns the id' do
    test_station = Stations.new({'stations' => "Charleston"})
    test_station.save
    test_search = "Charleston"
    result = Stations.search(test_search)
    expect(result).to eq test_station.id
  end
end
