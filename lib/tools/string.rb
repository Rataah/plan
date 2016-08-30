# Override String class
class String
  def to_id
    downcase.tr(' ', '_')
  end
end
