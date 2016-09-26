module Plan
  class YamlWallFactory
    def self.parse_wall(wall_name, last_point, wall_def)
      setup_default(wall_def)

      WallFactory.create(wall_name, last_point, wall_def[:length], wall_def[:direction], wall_def[:width]) do
        wall_def[:windows].each do |window_def|
          window = window(window_def[:origin], window_def[:length])
          window_def[:leaves].each do |leave_def|
            window.leave(leave_def[:length], leave_def.slice(:reverse, :origin, :angle, :outside))
          end if window_def.key? :leaves
        end if wall_def.key? :windows

        wall_def[:doors].each do |door_def|
          door = door(door_def[:origin], door_def[:length])
          door_def[:leaves].each do |leave_def|
            door.leave(leave_def[:length], leave_def.slice(:reverse, :origin, :angle, :outside))
          end if door_def.key? :leaves
        end if wall_def.key? :doors
      end
    end

    def self.setup_default(wall_def)
      wall_def[:width] = wall_def[:width] || DEFAULT_WALL_WIDTH
      wall_def[:direction] = wall_def[:direction].to_sym if wall_def[:direction].is_a? String
    end
  end
end
