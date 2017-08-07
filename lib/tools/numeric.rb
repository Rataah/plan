# Override Numeric class
class Numeric
  PIx2 = (Math::PI * 2.0).freeze
  PI_2 = (Math::PI / 2.0).freeze
  PI_4 = (PI_2 / 2.0).freeze

  def positive?
    self >= 0
  end

  def negative?
    self <= 0
  end

  def one?
    self == 1
  end

  def rad
    (self * Math::PI / 180.0) % PIx2
  end

  def modulo_rad
    self % PIx2
  end

  def deg
    (self / Math::PI * 180.0) % 360.0
  end

  def rotate_rad(amount = PI_2)
    (self + amount) % PIx2
  end

  def to_file_size
    {
      B: 1024.0,
      KB: 1_048_576.0,
      MB: 1_073_741_824.0
    }.each_pair do |label, value|
      return "#{(to_f / (value / 1024.0)).round(2)}#{label}" if self < value
    end
  end
end
