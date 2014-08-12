class Stops
  attr_reader :id, :trains_id, :stations_id

  def initialize(attributes)
    @id = attributes['id'].to_i
    @trains_id = attributes['trains_id'].to_i
    @stations_id = attributes['stations_id'].to_i
  end

  def ==(another_stop)
  self.id == another_stop.id && self.trains_id == another_stop.trains_id && self.stations_id == another_stop.id
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
end
