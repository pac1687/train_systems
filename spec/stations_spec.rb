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
end
