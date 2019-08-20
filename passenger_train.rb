class PassengerTrain < Train
  attr_reader :type

  def add_carriage(carriage)
    super if carriage.type == :passenger
  end
end
