require_relative "../../problem"

module AdventOfCodeRuby
  module Year2023
    module Problem14
      class ParabolicReflectorDish < Problem
        def part_1(input)
          platform = RockPlatform.for input
          platform.lever_north!
          platform.load
        end

        def part_2(input)
          platform = RockPlatform.for input
          40.times { |i|
            platform.spin!
            puts "#{i}: #{platform.load}"
            #puts platform.to_s
            #puts
          }
          platform.load
        end
      end

      class RockPlatform
        attr_reader :rows, :rocks
        def initialize(rows, rocks)
          @rows = rows
          @rocks = rocks
          @rocks.each{ |rock| rock.platform = self }
        end

        def self.for(string)
          rows = string.chomp.gsub("O", ".").split("\n").map{ |line| line.split "" }
          width = rows[0].count
          rocks = []
          string.chomp.split("\n").join.split("").each_with_index do |char, i|
            rocks << RoundRock.new(i % width, i / width) if char == "O"
          end
          new rows, rocks
        end

        def length
          rows.length
        end

        def width
          rows.first.length
        end

        def load
          rocks.map(&:load).sum
        end

        def ew_load
          rocks.map(&:ew_load).sum
        end

        def square_rock_at?(x, y)
          rows[y][x] == "#"
        end

        def round_rock_at?(x, y)
          rocks.any?{ |rock| rock.x == x && rock.y == y }
        end

        def rock_at?(x, y)
          square_rock_at?(x, y) || round_rock_at?(x, y)
        end

        def roll_north!
          rocks.each(&:roll_north!)
        end

        def roll_west!
          rocks.each(&:roll_west!)
        end

        def roll_south!
          rocks.each(&:roll_south!)
        end

        def roll_east!
          rocks.each(&:roll_east!)
        end

        def lever_north!
          unstick_all!
          roll_north! until all_stuck?
        end

        def lever_west!
          unstick_all!
          roll_west! until all_stuck?
        end

        def lever_south!
          unstick_all!
          roll_south! until all_stuck?
        end

        def lever_east!
          unstick_all!
          roll_east! until all_stuck?
        end

        def spin!
          lever_north!
          lever_west!
          lever_south!
          lever_east!
        end

        def unstick_all!
          rocks.each(&:unstick!)
        end

        def all_stuck?
          rocks.all?(&:stuck)
        end

        def to_s
          lines = rows.map(&:join)
          rocks.each { |rock| lines[rock.y][rock.x] = "O" }
          lines.join "\n"
        end
      end

      class RoundRock
        attr_reader :x, :y, :stuck
        attr_accessor :platform
        def initialize(x, y)
          @x = x
          @y = y
        end

        def load
          platform.length - y
        end

        def ew_load
          platform.width - x
        end

        def unstick!
          @stuck = false
        end

        def roll_north!
          return if stuck
          if y == 0 || platform.rock_at?(x, y - 1)
            @stuck = true
          else
            @y -= 1 
          end
        end

        def roll_west!
          return if stuck
          if x == 0 || platform.rock_at?(x - 1, y)
            @stuck = true
          else
            @x -= 1 
          end
        end

        def roll_south!
          return if stuck
          if y == platform.length - 1 || platform.rock_at?(x, y + 1)
            @stuck = true
          else
            @y += 1
          end
        end

        def roll_east!
          return if stuck
          if x == platform.width - 1 || platform.rock_at?(x + 1, y)
            @stuck = true
          else
            @x += 1 
          end
        end
      end
    end
  end
end
