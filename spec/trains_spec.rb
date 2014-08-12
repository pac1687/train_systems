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

end
