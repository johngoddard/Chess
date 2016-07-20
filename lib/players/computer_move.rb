class ComputerMove
  attr_reader :start_pos, :end_pos, :value
  
  def initialize(start_pos, end_pos, value)
    @start_pos = start_pos
    @end_pos = end_pos
    @value = value
  end
end
