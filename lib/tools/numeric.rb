# Override Numeric class
class Numeric
  def positive?
    self >= 0
  end

  def rad
    (self * Math::PI / 180.0) % (2 * Math::PI)
  end

  def rad_modulo
    self % (2 * Math::PI)
  end

  def deg
    (self / Math::PI * 180.0) % 360.0
  end

  def rotate_rad(amount = Math::PI / 2.0)
    (self + amount) % (2 * Math::PI)
  end

  def to_file_size
    {
      B: 1024,
      KB: 1024 * 1024,
      MB: 1024 * 1024 * 1024,
      GB: 1024 * 1024 * 1024 * 1024,
      TB: 1024 * 1024 * 1024 * 1024 * 1024
    }.each_pair do |label, value|
      return "#{(to_f / (value / 1024)).round(2)}#{label}" if self < value
    end
  end
end
