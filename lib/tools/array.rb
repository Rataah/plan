# Override Array class
class Array
  def first_and_last
    [first, last]
  end

  def deep_dup
    map do |element|
      element.respond_to?(:dup) && !element.is_a?(Numeric) ? element.dup : element
    end
  end
end
