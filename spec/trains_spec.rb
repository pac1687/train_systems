require "train_spec_helper.rb"

describe Trains do

  it "initializes train with a name called line" do
    test_train = Trains.new({'lines' =>"Grasshopper"})
    expect(test_train).to be_an_instance_of Trains
  end

  it "allows trains to be saved to the database" do
    test_train = Trains.new({'lines' => "The Norris"})
    test_train.save
    expect(Trains.all).to eq [test_train]
  end

  it 'lists out all the trains' do
    test_train = Trains.new({'lines' => "Grasshopper"})
    test_train.save
    test_train1 = Trains.new({'lines' => "The Norris"})
    test_train1.save
    list_trains = Trains.all
    expect(Trains.all).to eq [test_train, test_train1]
  end

  it 'searches for a train by line name and returns the id' do
    test_train = Trains.new({'lines' => "Grasshopper"})
    test_train.save
    test_search = "Grasshopper"
    result = Trains.search(test_search)
    expect(result).to eq test_train.id
  end
end
