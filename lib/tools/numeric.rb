# Override Numeric class
class Numeric
  def rad
    (self * Math::PI / 180.0) % (2 * Math::PI)
  end

  def deg
    (self / Math::PI * 180.0) % 360.0
  end
end
