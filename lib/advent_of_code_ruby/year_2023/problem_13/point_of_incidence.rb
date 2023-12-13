require_relative "../../problem"

module AdventOfCodeRuby
  module Year2023
    module Problem13
      class PointOfIncidence < Problem
        def part_1(input)
          input.chomp.split("\n\n").map{ |pattern| AshPattern.from(pattern).summary }.sum
        end

        def part_2(input)
         input.chomp.split("\n\n").map{ |pattern| AshPattern.from(pattern).desmudge.summary }.sum
        end
      end

      class AshPattern
        attr_reader :rows
        attr_accessor :reflection_columns, :reflection_rows
        def initialize(rows)
          @rows = rows
        end

        def self.from(string)
          new string.split("\n").map{ |line| line.split("") }
        end

        def columns
          rows.transpose
        end

        def reflection_columns
          @reflection_columns ||= rows.map{ |row| self.class.reflection_points row }.reduce(&:intersection) 
        end

        def reflection_rows
          @reflection_rows ||= columns.map{ |row| self.class.reflection_points row }.reduce(&:intersection) 
        end

        def summary
          # puts "rc: #{reflection_columns}, rr: #{reflection_rows}"
          reflection_columns.sum + (100 * reflection_rows.sum)
        end

        def desmudged?(other)
          if reflection_rows.empty? && !other.reflection_rows.empty?
            other.reflection_columns = []
            return true
          end
          if !reflection_rows.empty? && !other.reflection_rows.empty? && reflection_rows != other.reflection_rows
            other.reflection_rows = other.reflection_rows - reflection_rows
            return true
          end
          if reflection_columns.empty? && !other.reflection_columns.empty?
            other.reflection_rows = []
            return true
          end
          if !reflection_columns.empty? && !other.reflection_columns.empty? && reflection_columns != other.reflection_columns
            other.reflection_columns = other.reflection_columns - reflection_columns
            return true
          end
          false
        end

        def desmudge
          rows.dup.each_with_index do |row, y|
            row.dup.each_with_index do |char, x|
              pattern = self.class.new rows.map(&:dup)
              pattern.rows[y][x] = char == "." ? "#" : "."
              return pattern if desmudged?(pattern)
            end
          end
          puts "dang"
          nil
        end

        # a possibility refers to the space *before* the index
        # so reflection point 5 means that 0..4 == 5..9.reverse
        def self.reflection_points(line, possibilities = (1...(line.length)))
          possibilities.filter do |point|
            width = [point, line.length - point].min
            # puts "testing #{line[(point-width)...point]} against  #{line[point...(point + width)].reverse} (width = #{width}) (point = #{point})"
            line[(point-width)...point] == line[point...(point + width)].reverse
          end
        end
      end
    end
  end
end
