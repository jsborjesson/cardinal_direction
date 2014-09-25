class CardinalDirection

  CARDINALS = %w[ N E S W ]
  ORDINALS  = %w[ N NE E SE S SW W NW ]
  WIND_16   = %w[ N NNE NE ENE E ESE SE SSE S SSW SW WSW W WNW NW NNW ]
  NAMES     = { ?N => 'north', ?E => 'east', ?S => 'south', ?W => 'west' }

  attr_reader  :degrees
  alias_method :azimuth, :degrees
  alias_method :to_f,    :degrees

  def initialize(degrees)
    @degrees = degrees.to_f % 360
  end

  def self.parse(direction)
    index = WIND_16.find_index(direction.upcase)
    fail ArgumentError if index.nil?
    new(index * 22.5)
  end

  def cardinal
    CARDINALS[find_index_with_precision(4)]
  end

  def ordinal
    ORDINALS[find_index_with_precision(8)]
  end
  alias_method :intercardinal, :ordinal
  alias_method :intermediate,  :ordinal

  def bearing
    textify(secondary_intercardinal)
  end

  def secondary_intercardinal
    WIND_16[find_index_with_precision(16)]
  end

  def inspect
    "#<CardinalDirection #{secondary_intercardinal} (#{degrees}°)>"
  end

  private

  def textify(direction)
    case direction.length
    when 1
      NAMES[direction]
    when 2
      NAMES[direction[0]] + NAMES[direction[1]]
    when 3
      NAMES[direction[0]] + '-' + NAMES[direction[1]] + NAMES[direction[2]]
    end.capitalize
  end

  def find_index_with_precision(precision)
    multiple = 360.0 / precision
    (closest_multiple_of_degree(multiple) / multiple) % precision
  end

  def closest_multiple_of_degree(multiple)
    times = (degrees / multiple).round
    multiple * times
  end

end
