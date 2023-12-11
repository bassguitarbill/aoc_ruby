require_relative "../../problem"

module AdventOfCodeRuby
  module Year2023
    module Problem11
      class CosmicExpansion < Problem
        def part_1(input)
          Universe.for(input).expanded.shortest_paths_sum
        end

        def part_2(input)
          universe = Universe.for(input)
          diff = universe.expanded.shortest_paths_sum - universe.shortest_paths_sum
          universe.shortest_paths_sum + (diff * 999999)
        end
      end

      class Universe
        attr_reader :rows
        def initialize(rows)
          @rows = rows
          @empty_rows = {}
          @empty_columns = {}
        end

        def self.for(string)
          new string.chomp.split("\n").map{ |line| line.split("") }
        end

        def galaxies
          return @galaxies if @galaxies
          @galaxies = []
          rows.each_with_index do |row, y|
            row.each_with_index do |char, x|
              galaxies << Galaxy.new(self, x, y) if char == "#"
            end
          end
          @galaxies
        end

        def expanded
          new_rows = []
          rows.each do |row| 
            new_rows << row
            new_rows << row unless row.include? "#"
          end

          new_columns = []
          new_rows.transpose.each do |column|
            new_columns << column
            new_columns << column unless column.include? "#"
          end

          self.class.new new_columns.transpose
        end

        def shortest_paths_sum
          @shortest_paths_sum ||= galaxies.map(&:shortest_paths_sum).sum / 2
        end
      end

      class Galaxy
        attr_reader :universe, :x, :y
        def initialize(universe, x, y)
          @universe = universe
          @x = x
          @y = y
        end

        def distance_to(other)
          # return 0 if other == self
          (x - other.x).abs + (y - other.y).abs
        end

        def shortest_paths_sum
          universe.galaxies.map{ |galaxy| distance_to galaxy }.sum
        end
      end
    end
  end
end
