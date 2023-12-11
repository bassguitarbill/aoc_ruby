require_relative "../../problem"

module AdventOfCodeRuby
  module Year2023
    module Problem11
      class CosmicExpansion < Problem
        def part(input, expansion_factor)
          Universe.for(input, expansion_factor).galaxies.map(&:shortest_paths_sum).sum / 2
        end

        def part_1(input)
          part(input, 2)
        end

        def part_2(input)
          part(input, 1000000)
        end
      end

      class Universe
        attr_reader :rows, :expansion_factor
        def initialize(rows, expansion_factor = 1)
          @rows = rows
          @expansion_factor = expansion_factor
          @empty_rows = {}
          @empty_columns = {}
        end

        def self.for(string, expansion_factor = 1)
          new string.chomp.split("\n").map{ |line| line.split("") }, expansion_factor
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

        def ecs
          [@empty_columns, @empty_rows]
        end

        def columns
          @columns ||= rows.transpose
        end

        def empty_column?(x)
          return @empty_columns[x] if @empty_columns.key? x
          ec = Hash[x, columns[x].all?{ |char| char == "." }]
          @empty_columns.merge! ec
          @empty_columns[x]
        end

        def empty_row?(y)
          return @empty_rows[y] if @empty_rows.key? y
          @empty_rows.merge! Hash[y, rows[y].all?{ |char| char == "." }]
          @empty_rows[y]
        end
      end

      class Galaxy
        attr_reader :universe, :x, :y
        def initialize(universe, x, y)
          @universe = universe
          @x = x
          @y = y
        end

        def empty_columns_to(other)
          return 0 if other == self
          (x..(other.x)).map{ |col| universe.empty_column?(col) ? 1 : 0 }.sum +
            ((other.x)..x).map{ |col| universe.empty_column?(col) ? 1 : 0 }.sum
        end

        def empty_rows_to(other)
          return 0 if other == self
          (y..(other.y)).map{ |row| universe.empty_row?(row) ? 1 : 0 }.sum +
            ((other.y)..y).map{ |row| universe.empty_row?(row) ? 1 : 0 }.sum
        end

        def distance_to(other)
          return 0 if other == self
          # puts "  getting distance to (#{other.x}, #{other.y})"
          x_dist = (x - other.x).abs
          x_dist = x_dist + (empty_columns_to(other) * (universe.expansion_factor - 1))
          # puts "    empty_columns: #{empty_columns_to(other)}"
          y_dist = (y - other.y).abs
          y_dist = y_dist + (empty_rows_to(other) * (universe.expansion_factor - 1))
          # puts "    empty_rows: #{empty_rows_to(other)}"
          # puts "  #{x_dist + y_dist}"
          x_dist + y_dist
        end

        def shortest_paths_sum
          # puts "getting distance for (#{x}, #{y})"
          universe.galaxies.map{ |galaxy| distance_to galaxy }.sum
        end
      end
    end
  end
end
