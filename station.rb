class Station
  attr_reader :name, :trains


  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    trains << train
  end

  def train_list
    trains
  end

  def cargo_trains
    trains_list_for(CargoTrain)
  end

  def passenger_trains
    trains_list_for(PassengerTrain)
  end

  def send_train(train)
    trains.delete(train)
  end

  private

  def trains_list_for(target)
    trains.select { |train| train.class == target }
  end
end
