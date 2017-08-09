module Plan
  class WallPlugin
    def register
      raise NotImplementedError
    end

    def svg_include
      raise NotImplementedError
    end
  end
end
