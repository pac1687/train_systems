class Trains
  attr_reader :id, :lines

  def initialize(attributes)
    @id = attributes['id'].to_i
    @lines = attributes['lines']
  end

  def ==(another_train)
    self.id == another_train.id && self.lines == another_train.lines
  end

  def save
    results = DB.exec("INSERT INTO trains (lines) VALUES ('#{@lines}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM trains;")
    trains = []
    results.each do |result|
      new_train = Trains.new(result)
      trains << new_train
    end
    trains
  end

  def self.search(lines)
    results = DB.exec("SELECT * FROM trains WHERE lines = '#{lines}';")
    @id = results.first['id'].to_i
  end

  def self.update_train(train_id, new_line)
    results = DB.exec("UPDATE trains SET lines = '#{new_line}' WHERE id = #{train_id} RETURNING lines;")
    @lines = results.first['lines']
  end

  def self.delete_train(train_id)
    DB.exec("DELETE FROM trains WHERE id = #{train_id};")
  end
end
