class CargoCarriage < Carriage
   attr_reader :type

  def initialize(number)
    @type = :cargo
    super(number)
  end
end
