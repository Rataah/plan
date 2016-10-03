# Override String class
class String
  def to_id
    downcase.tr(': ', '_').tap do |id|
      id[0] = '' if id.start_with? '-'
    end
  end

  def demodulize
    gsub(/^.*::/, '')
  end
end
