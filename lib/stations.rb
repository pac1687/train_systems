class Stations
  attr_reader :id, :stations

  def initialize(attributes)
    @id = attributes['id'].to_i
    @stations = attributes['stations']
  end

  def ==(another_station)
    self.id == another_station.id && self.stations == another_station.stations
  end

  def save
    results = DB.exec("INSERT INTO stations (stations) VALUES ('#{@stations}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM stations;")
    stations = []
    results.each do |result|
      new_station = Stations.new(result)
      stations << new_station
    end
  stations
  end

  def self.search(stations)
    results = DB.exec("SELECT * FROM stations WHERE stations = '#{stations}';")
    @id = results.first['id'].to_i
  end

end
