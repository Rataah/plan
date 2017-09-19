# Override String class
class String
  def to_id
    downcase.tr(': ', '_').tap do |id|
      id[0] = '' if id.start_with? '-'
      id.insert(0, '_') if id =~ /\A[0-9]/
    end
  end

  def demodulize
    gsub(/^.*::/, '')
  end

  def numeric?
    !Float(self).nil?
  rescue _
    false
  end
end
