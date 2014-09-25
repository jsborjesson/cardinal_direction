require './cardinal_direction'

describe CardinalDirection do

  it "has degrees / azimuth with decimals" do
    direction = CardinalDirection.new(45)

    expect(direction.degrees).to eq 45.0
    expect(direction.azimuth).to eq 45.0
    expect(direction.degrees).to be_kind_of Float
  end

  it "returns degrees as to_f" do
    expect(CardinalDirection.new(22.5).to_f).to eq 22.5
  end

  it "handles cardinals" do
    expect(CardinalDirection.new(0).cardinal).to eq 'N'
    expect(CardinalDirection.new(90).cardinal).to eq 'E'
    expect(CardinalDirection.new(180).cardinal).to eq 'S'
    expect(CardinalDirection.new(270).cardinal).to eq 'W'
  end

  it "handles ordinals" do
    expect(CardinalDirection.new(45).ordinal).to eq 'NE'
    expect(CardinalDirection.new(135).ordinal).to eq 'SE'

    # aliases
    expect(CardinalDirection.new(225).intercardinal).to eq 'SW'
    expect(CardinalDirection.new(315).intermediate).to eq 'NW'
  end

  it "handles secondary intercardinals" do
    expect(CardinalDirection.new(22.5).secondary_intercardinal).to eq 'NNE'
    expect(CardinalDirection.new(337.5).secondary_intercardinal).to eq 'NNW'
  end

  it "has nice inspect output" do
    expect(CardinalDirection.new(22.5).inspect).to eq '#<CardinalDirection NNE (22.5°)>'
  end

  context "approximation" do

    let(:west_of_ssw) { CardinalDirection.new(202.6) }
    let(:east_of_sse) { CardinalDirection.new(157.4) }

    it "rounds cardinals" do
      expect(east_of_sse.cardinal).to eq 'S'
      expect(west_of_ssw.cardinal).to eq 'S'
    end

    it "rounds ordinals" do
      expect(east_of_sse.ordinal).to eq 'SE'
      expect(west_of_ssw.ordinal).to eq 'SW'
    end

    it "rounds secondary intercardinals" do
      expect(east_of_sse.secondary_intercardinal).to eq 'SSE'
      expect(west_of_ssw.secondary_intercardinal).to eq 'SSW'
    end

    it "doesn't blow up when rounding up" do
      dir = CardinalDirection.new(359)

      expect(dir.cardinal).to eq 'N'
      expect(dir.ordinal).to eq 'N'
      expect(dir.secondary_intercardinal).to eq 'N'
    end

    # http://en.wikipedia.org/wiki/Points_of_the_compass#16_cardinal_points
    it "is fucking precise" do
      expect(CardinalDirection.new(348.75).secondary_intercardinal).to eq 'N'
      expect(CardinalDirection.new(11.249).secondary_intercardinal).to eq 'N'

      expect(CardinalDirection.new(146.25).secondary_intercardinal).to eq 'SSE'
      expect(CardinalDirection.new(168.749).secondary_intercardinal).to eq 'SSE'

      expect(CardinalDirection.new(213.75).secondary_intercardinal).to eq 'SW'
      expect(CardinalDirection.new(236.249).secondary_intercardinal).to eq 'SW'
    end

  end

  it "spins on degrees over 360" do
    expect(CardinalDirection.new(725).degrees).to eq 5
  end

  context ".parse" do
    it "reads cardinals" do
      expect(CardinalDirection.parse('NNW').degrees).to eq 337.5
      expect(CardinalDirection.parse('S').degrees).to eq 180
    end

    it "throws ArgumentError on invalid input" do
      expect { CardinalDirection.parse('WNN') }.to raise_error ArgumentError
    end

    it "is case insensitive" do
      expect(CardinalDirection.parse('nnW').degrees).to eq 337.5
    end

  end

  it "has long version in bearing" do
    expect(CardinalDirection.parse('N').bearing).to eq 'North'
    expect(CardinalDirection.parse('NE').bearing).to eq 'Northeast'
    expect(CardinalDirection.parse('WNW').bearing).to eq 'West-northwest'
  end

  it "can take a specificity"
  it ".point_to_point(x1, y1, x2, y2)"
  it ".point(Point.new(x, y), Point.new(x, y))"
end
