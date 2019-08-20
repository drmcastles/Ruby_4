class CargoTrain < Train
  def add_carriage(carriage)
    super if carriage.type == :cargo
  end
end
