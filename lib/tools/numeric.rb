# Override Numeric class
class Numeric
  def rad
    self * Math::PI / 180.0
  end

  def deg
    self / Math::PI * 180.0
  end
end
