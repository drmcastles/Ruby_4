class PassengerCarriage < Carriage
  attr_reader :type

  def initialize(number)
    @type = :passenger
    super(number)
  end
end
