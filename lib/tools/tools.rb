# Tools for Plan module
module Plan
  @object_ids={}

  def self.descendants(parent_class)
    descendants = []
    ObjectSpace.each_object(parent_class.singleton_class) do |k|
      descendants.unshift k unless k == parent_class
    end
    descendants
  end

  # http://www.virtuouscode.com/2009/07/14/recursively-symbolize-keys/
  def self.symbolize_keys(hash)
    hash.each_with_object({}) do |(key, value), result|
      new_key = key.is_a?(String) ? key.to_sym : key
      new_value = case value
                  when Hash
                    symbolize_keys(value)
                  when Array
                    value.map { |arr_value| arr_value.is_a?(Hash) ? symbolize_keys(arr_value) : arr_value }
                  else
                    value
                  end
      result[new_key] = new_value
      result
    end
  end

  def self.stringify(hash)
    hash.each_with_object({}) do |(key, value), result|
      new_key = key.is_a?(Symbol) ? key.to_s : key
      new_value = case value
                  when Symbol
                    value.to_s
                  when Hash
                    stringify(value)
                  when Array
                    value.map { |arr_value| arr_value.is_a?(Hash) ? stringify(arr_value) : arr_value }
                  else
                    value
                  end
      result[new_key] = new_value
      result
    end
  end

  def self.id(klass)
    @object_ids[klass] = 0 unless @object_ids.key? klass
    "#{klass.name.split('::').last}_#{@object_ids[klass] += 1}".downcase
  end
end
