class Hash
  def slice(*keys)
    select { |key| keys.include? key }
  end
end
