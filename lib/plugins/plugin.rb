module Plan
  class Plugin
    class << self
      attr_reader :registration, :svg_file, :css_file

      def register(registration)
        @registration = registration
      end

      def svg(svg_file)
        @svg_file = File.join(File.dirname(caller(1..1).first.partition(':').first),  svg_file)
      end

      def css(css_file)
        @css_file = File.join(File.dirname(caller(1..1).first.partition(':').first),  css_file)
      end
    end
  end
end
