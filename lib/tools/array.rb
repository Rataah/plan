# Override Array class
class Array
  def first_and_last
    [first, last]
  end

  def deep_dup
    map do |element|
      element.respond_to?(:dup) && !element.kind_of?(Numeric) ? element.dup : element
    end
  end
end
