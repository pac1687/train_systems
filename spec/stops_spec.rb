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
end
