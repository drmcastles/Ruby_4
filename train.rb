class Train
  attr_reader :number, :speed, :route, :carriages

  def initialize(number)
    @number = number
    @speed = 0
    @current_station = nil
    @route = nil
    @carriages = []
  end

  def accelerate(value)
    @speed += value
    @speed = 0 if @speed < 0
  end

  def stop
    @speed = 0
  end

  def add_carriage(carriage)
    return unless speed.zero?
    return unless attachable_carriage?(carriage)
    carriages << carriage
  end

  def delete_carriage
    return unless speed.zero? && carriages.size > 0
    carriages.delete(carriages.last)
  end

  def current_station
    route.stations[@current_station_index]
  end

  def add_route(route)
    @route = route
    @current_station_index = 0
    current_station.train_in(self)
  end

  def next_station
    route.stations[@current_station_index + 1]
  end

  def previous_station
    return unless @current_station_index.positive?
    route.stations[@current_station_index - 1]
  end

  def go_next_station
    return unless @route
    return unless next_station
    current_station.delete_train(self)
    @current_station_index += 1
    current_station.train_in(self)
  end

  def go_previous_station
    return unless @route
    return unless previous_station
    current_station.delete_train(self)
    @current_station_index -= 1
    current_station.train_in(self)
  end
end

