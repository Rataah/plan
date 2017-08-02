module Plan
  # SVG Path element
  class SVGPath < SVGElement
    def initialize(origin)
      super('path')
      @args['d'] = SVGArg.new('', true)
      move_to(origin)
    end

    def self.curve(start_point, end_point)
      control_point = Plan.center(start_point, end_point)
                          .translate(
                            start_point.angle_with(end_point).rotate_rad,
                            start_point.dist(end_point) / 2.0
                          )
      SVGPath.new(start_point).quadratic_bezier(end_point, control_point)
    end

    def move_to(point)
      @args['d'].value << "M #{point.to_svg} "
      self
    end

    def move_by(point)
      @args['d'].value << "m #{point.to_svg} "
      self
    end

    def line_to(point)
      @args['d'].value << "L #{point.to_svg} "
      self
    end

    def line_by(point)
      @args['d'].value << "l #{point.to_svg} "
      self
    end

    def close_path
      @args['d'].value << 'Z'
      self
    end

    def arc(radius, point, large_arc_flag = 0, sweep_flag = 0)
      @args['d'].value << "A #{radius.to_svg} 0 #{large_arc_flag},#{sweep_flag} #{point.to_svg} "
      self
    end

    def quadratic_bezier(point, control_point)
      @args['d'].value << "Q #{control_point.to_svg} #{point.to_svg}"
      self
    end
  end
end
