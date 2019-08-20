
require_relative 'train.rb'
require_relative 'carriage.rb'
require_relative 'passenger_train.rb'
require_relative 'cargo_train.rb'
require_relative 'cargo_carriage.rb'
require_relative 'passenger_carriage.rb'
require_relative 'station.rb'
require_relative 'route.rb'

class Main

  def main_menu
    loop do
    show_menu(MAIN_MENU, "Main menu:")
      case gets.to_i
      when 1 then station_menu
      when 2 then train_menu
      when 3 then route_menu
      when 0 then exit
      else puts "Input error."
      end
    end
  end

  private

  MAIN_MENU = [
    'Station menu',
    'Train menu',
    'Route menu'
  ]

  STATION_MENU = [
    'Create station',
    'View stations',
    'View trains on station'
  ]

  TRAIN_MENU = [
    'Create train',
    'Assign Train to the route',
    'Add carriage to the train',
    'Remove carriage from the train',
    'Move the train'
  ]

  ROUTE_MENU = [
    'Create route',
    'Add intermediate station to route',
    'Delete intermediate station from route',
    'View routes'
  ]

  TRAIN_TYPE_MENU = [
    'Create cargo train',
    'Create passenger train'
  ]

  DIRECTION_MENU = [
    'Go next station',
    'Go previous station'
  ]

  CREATE_ROUTE_STATION_MENU = [
    'Add existing station to route',
    'Create a new one and add to route'
  ]

  attr_reader :trains, :routes, :stations

  def initialize
    @trains = []
    @routes = []
    @stations = []
  end

# Functional menu
  def station_menu
    loop do
      show_menu(STATION_MENU, "Station menu:")
      case gets.to_i
      when 1 then create_station
      when 2 then show_array(stations)
      when 3 then trains_on_station
      when 0 then return
      else puts "Input error."
      end
    end
  end

  def train_menu
    loop do
      show_menu(TRAIN_MENU, "Train menu:")
      case gets.to_i
      when 1 then create_train
      when 2 then assign_train
      when 3 then add_carriage
      when 4 then delete_carriage
      when 5 then train_go
      when 0 then return
      else puts "Input error."
      end
    end
  end

  def route_menu
    loop do
      show_menu(ROUTE_MENU, "Route menu:")
      case gets.to_i
      when 1 then create_route
      when 2 then add_route_station
      when 3 then delete_route_station
      when 4 then show_array(routes)
      when 0 then return
      else puts "Input error."
      end
    end
  end

# Station menu methods
  def create_station
    puts "Enter station name:"
    name = gets.chomp
    if stations.any? { |station| station.name == name }
      puts "This station already exist."
      return
    end
    new_station = Station.new(name)
    stations << new_station
    puts "You created a station: #{new_station.name}."
    new_station
  end

  def trains_on_station
    station = select_from_array(stations)
    return if station.nil?
    if station.trains.empty?
      puts "There are no trains at this station."
      return
    end
    station_info(station)
    station.trains.each { |train| train_info(train)}
  end

# Train menu methods
  def create_train
    puts "Enter train number:"
    number = gets.chomp
    if trains.any? { |train| train.number == number }
      puts "Train with this number already exist."
      return
    end
    show_menu(TRAIN_TYPE_MENU, "Select train type:")
    case gets.to_i
    when 1 then trains << CargoTrain.new(number)
    when 2 then trains << PassengerTrain.new(number)
    else
      puts "Input error."
      return
    end
    train_info(trains.last)
  end

  def assign_train
    train = select_from_array(trains)
    return if train.nil?
    route = select_from_array(routes)
    return if route.nil?
    train.add_route(route)
    train_info(train)
    route_info(route)
  end

  def add_carriage
    train = select_from_array(trains)
    return if train.nil?
    unless train.speed.zero?
      puts "Speed is too high."
      puts "You must stop to add carriage."
      return
    end
    case train
    when CargoTrain then train.add_carriage(CargoCarriage.new)
    when PassengerTrain then train.add_carriage(PassengerCarriage.new)
    end
    train_info(train)
  end

  def delete_carriage
    train = select_from_array(trains)
    return if train.nil?
    unless train.speed.zero?
      puts "Speed is too high."
      puts "You must stop to delete carriage."
      return
    end
    if train.carriages.size.zero?
      puts "This train has no cars."
      return
    end
    train.delete_carriage
    train_info(train)
  end

  def train_go
    train = select_from_array(trains)
    return if train.nil?
    if train.route.nil?
      puts "This train has no route."
      return
    end
    show_menu(DIRECTION_MENU, "Choose a direction:")
    case gets.to_i
    when 1 then move_train_to_next_station(train)
    when 2 then move_train_to_previous_station(train)
    else
      puts "Input error."
      return
    end
    train_info(train)
  end

  def move_train_to_next_station(train)
    if train.next_station.nil?
      puts "This is the end station."
      return
    end
    train.go_next_station
  end

  def move_train_to_previous_station(train)
    if train.previous_station.nil?
      puts "This is the end station."
      return
    end
    train.go_previous_station
  end

# Route menu methods
  def create_route
    start_station = select_or_create_station('Start station:')
    finish_station = select_or_create_station('Finish station:')
    return if start_station.nil? || finish_station.nil?
    return if start_station == finish_station
    route = Route.new(start_station, finish_station)
    routes << route
    route_info(route)
  end

  def add_route_station
    route = select_from_array(routes)
    return if route.nil?
    station = select_or_create_station('Station:')
    return if station.nil?
    if route.stations.include?(station)
      puts "This station already in the route."
      return
    end
    route.add_station(station)
    route_info(route)
  end

  def select_or_create_station(title)
    show_menu(CREATE_ROUTE_STATION_MENU, title)
    case gets.to_i
    when 1
      station = select_from_array(stations)
      return if station.nil?
      station
    when 2
      station = create_station
      if station.nil?
        puts "A station with that name already exists."
        return
      end
      station
    else
      puts "Input error."
      return
    end
  end

  def delete_route_station
    route = select_from_array(routes)
    return if route.nil?
    station = select_from_array(route.stations)
    return if station.nil?
    if [route.first_station, route.finish_station].include?(station)
      puts "Cannot delete starting or ending station."
      return
    end
    route.delete_station(station)
    route_info(route)
  end

# Utilities
  # Show menu
  def show_menu(menu, title = nil)
    puts title if title
    menu.each.with_index(1) do |item, index|
      puts "#{index}. #{item}"
    end
    puts "0. Exit"
  end

  # Формирует список чего-нибудь с индексами
  def show_array(array)
    return puts "No train, station or route created." if array.empty?
    puts "All items:"
    array.each.with_index(1) do |item, index|
      print "#{index}. "
      info(item)
    end
  end

  # Выбор элемента из списка | возвращает этот элемент
  def select_from_array(array)
    return if show_array(array).nil?
    puts "Enter Index -> (1 - #{array.size})"
    index = gets.to_i
    if index.between?(1, array.size)
      array[index - 1]
    else
      puts "Input error."
      return
    end
  end

#Info methods
  def info(item)
    case item
    when Station then station_info(item)
    when Train then train_info(item)
    when Route then route_info(item)
    end
  end

  def train_info(train)
    puts "Train -> Number: #{train.number}; Type: #{train.type} train; Number of carriages: #{train.carriages.size};"
    unless train.route.nil?
      if train.previous_station.nil?
        previous_station = "N/D"
      else
        previous_station = train.previous_station.name
      end
      current_station = train.current_station.name
      if train.next_station.nil?
        next_station = "N/D"
      else
        next_station = train.next_station.name
      end
      puts "Previous station: #{previous_station}; Current station: #{current_station}; Next station: #{next_station};"
    end
  end

  def route_info(route)
    print "Route "
    route.stations.each { |station| print "->#{station.name}" }
    puts
  end

  def station_info(station)
    puts "Station: #{station.name}"
  end

  # def seed
  #   a = Station.new("a")
  #   b = Station.new("b")
  #   c = Station.new("c")
  #   d = Station.new("d")
  #   e = Station.new("e")
  #   f = Station.new("f")
  #   g = Station.new("g")
  #   h = Station.new("h")
  #   stations << a << b << c << d << e << f << g << h

  #   train1 = CargoTrain.new("train1")
  #   train2 = PassengerTrain.new("train2")
  #   train3 = CargoTrain.new("train3")
  #   train4 = PassengerTrain.new("train4")
  #   trains << train1 << train2 << train3 << train4

  #   route1 = Route.new(a, d)
  #   route2 = Route.new(e, h)
  #   routes << route1 << route2

  #   #delete_route_station
  #   #train menu test
  #   #create_station
  #   #show_array(stations)
  #   #trains_on_station

  #   # station menu test
  #   # create_train
  #   # assign_train
  #   # add_carriage
  #   # delete_carriage
  #   # train_go

  #   # station menu test
  #   # create_route
  #   # add_route_station
  #   # delete_route_station
  #   # show_array(routes)
  # end
end

main = Main.new
main.main_menu
#main.seed
