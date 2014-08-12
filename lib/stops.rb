class Stops
  attr_reader :id, :trains_id, :stations_id

  def initialize(attributes)
    @id = attributes['id'].to_i
    @trains_id = attributes['trains_id'].to_i
    @stations_id = attributes['stations_id'].to_i
  end

  def ==(another_stop)
  self.id == another_stop.id && self.trains_id == another_stop.trains_id && self.stations_id == another_stop.stations_id
  end

  def save
    results = DB.exec("INSERT INTO stops (trains_id, stations_id) VALUES (#{@trains_id}, #{@stations_id}) RETURNING id;")
    @id = results.first['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM stops;")
    stops = []
    results.each do |result|
      new_stop = Stops.new(result)
      stops << new_stop
    end
    stops
  end

  def self.station_stops_list(train_id)
    results = DB.exec("SELECT stations.* FROM trains JOIN stops ON(trains.id = stops.trains_id)
      JOIN stations ON (stops.stations_id = stations.id)
      WHERE trains.id = #{train_id};")
    stations = []
    results.each do |result|
      new_station = Stations.new(result)
      stations << new_station
    end
    stations
  end

  def self.trains_list(stations_id)
    results = DB.exec("SELECT trains.* FROM
      stations JOIN stops ON (stations.id = stops.stations_id)
      JOIN trains ON (stops.trains_id = trains.id)
      WHERE stations.id = #{stations_id};")
    trains = []
    results.each do |result|
      new_train = Trains.new(result)
      trains << new_train
    end
    trains
  end

  def self.search_stop(stop_id)
    results = DB.exec("SELECT * from stops WHERE id = #{stop_id};")
    @id = results.first['id'].to_i
  end

  def self.delete_stop(stop_id)
    DB.exec("DELETE FROM stops WHERE id = #{stop_id};")
  end
end
