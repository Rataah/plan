# Override Array class
class Array
  def first_and_last
    [first, last]
  end

  def deep_dup
    map(&:dup)
  end
end
