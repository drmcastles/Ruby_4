class Route
  attr_reader :stations

  def initialize(first_station, finish_station)
    @stations = [first_station, finish_station]
  end

  def first_station
    stations.first
  end

  def finish_station
    stations.last
  end

  def add_station(station)
    return if stations.include?(station)
    stations.insert(-2, station)
  end

  def delete_station(station)
    return if [first_station, last_station].include?(station)
    stations.delete(station)
  end
end

