# Override Array class
class Array
  def indexes(values)
    values.map { |value| index(value) }
  end

  def first_and_last
    [first, last]
  end

  def rotate_if(condition)
    condition ? rotate : self
  end

  def reverse_if(condition)
    condition ? reverse : self
  end

  def loop_array
    self << first
  end

  def one?
    size == 1
  end

  def deep_dup
    map do |element|
      element.respond_to?(:dup) && !element.is_a?(Numeric) ? element.dup : element
    end
  end
end
