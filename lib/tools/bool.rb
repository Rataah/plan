# Override TrueClass class
class TrueClass
  def to_i
    1
  end
end

# Override FalseClass class
class FalseClass
  def to_i
    -1
  end
end
