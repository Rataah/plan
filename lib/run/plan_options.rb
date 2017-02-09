module Plan
  class PlanOptions
    def self.parse(args)
      Plan.configure_logger
      options = OpenStruct.new(wall_merger: true, wall_filler: true, display_area: true)
      option_parser = PlanOptions.create_options(options)
      option_parser.parse!(args)

      if options.configuration_file.nil? || options.output_file.nil?
        puts 'Missing Argument(s)'
        puts option_parser
        exit
      end

      options
    end

    def self.create_options(options)
      OptionParser.new do |opts|
        opts.on('-f', '--file FILE', 'Blueprint definition file') do |conf_file|
          options.configuration_file = conf_file
        end

        opts.on('-o', '--output FILE', 'Output file') do |output_file|
          options.output_file = output_file
        end

        opts.on('--disable-wall-merger', 'Disable the wall merger step') do
          options.wall_merger = false
        end

        opts.on('--disable-wall-filler', 'Disable the wall filler step') do
          options.wall_filler = false
        end

        opts.on('--disable-display-area', 'Disable the display of the total area') do
          options.display_area = false
        end

        opts.on('-v', '--verbose') do
          Plan.configure_logger(true)
        end

        opts.on('-h', '--help', 'Display this screen') do
          puts "Plan version:#{Plan::VERSION}"
          puts opts
          exit
        end
      end
    end
  end
end
