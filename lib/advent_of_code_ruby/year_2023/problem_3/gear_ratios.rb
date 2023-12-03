require_relative "../../problem"

module AdventOfCodeRuby
  module Year2023
    module Problem3
      class GearRatios < Problem
        def part(input, solution_function)
          Schematic.from(input).solution(solution_function)
        end

        def part_1(input)
          part(input, :part_numbers)
        end

        def part_2(input)
          part(input, :gear_ratios)
        end
      end

      class Schematic
        attr_reader :rows
        def initialize(rows)
          @rows = rows
        end

        def self.from(string)
          new string.chomp.split("\n")
        end

        def symbols
          return @symbols if @symbols
          @symbols = []
          rows.each_with_index do |row, row_num|
            row.split("").each_with_index do |char, col_num|
              next if %w[. 1 2 3 4 5 6 7 8 9 0].include? char
              @symbols.push Symbol.new(row_num, col_num, char, self)
            end
          end
          @symbols
        end

        def symbol_coordinates
          @symbol_coordinates ||= symbols.map(&:coords)
        end

        def numbers
          return @numbers if @numbers
          @numbers = []
          current_number = ""
          rows.each_with_index do |row, row_num|
            row.split("").each_with_index do |char, col_num|
              if %w[1 2 3 4 5 6 7 8 9 0].include? char
                current_number << char
              elsif !current_number.empty? 
                #########################################################
                # Correction for numbers starting at the end of one row #
                # being counted as ending at the beginning of the next  #
                #########################################################
                rn = col_num == 0 ? row_num - 1 : row_num
                cn = (col_num == 0 ? row.length : col_num) - current_number.length
                
                @numbers.push Number.new(rn, cn, current_number, self)
                current_number = ""
              end
            end
          end
          @numbers
        end

        ##################################################################
        # I had to regenerate the output file from my representation and #
        # `diff` it with my input to figure out what was wrong with it   #
        ##################################################################
        def output
          lines = (0..(rows.length - 1)).map{ "." * rows[0].length }
          symbols.each do |s|
            lines[s.row][s.col] = s.value
          end

          numbers.each do |n|
            x = 0
            for c in n.value.to_s.split("")
              lines[n.row][n.col + x] = c
              x += 1
            end
          end
          lines
        end

        def gear_ratios
          symbols.map(&:gear_ratio)
        end

        def part_numbers
          numbers.select(&:part_number?).map(&:value)
        end

        def solution(solution_function)
          send(solution_function).map(&:to_i).sum
        end
      end

      class Number
        attr_reader :row, :col, :value, :schematic
        def initialize(row, col, value, schematic)
          @row = row
          @col = col
          @value = value
          @schematic = schematic
        end

        def width
          @width ||= value.length
        end

        def surrounding_block_coordinates
          ((row - 1)..(row + 1)).map{ |r| ((col - 1)..(col + width)).map{ |c| [r, c] } }.flatten 1
        end

        def self_coordinates
          (col..(col + width - 1)).map{ |c| [row, c] }
        end

        def neighbor_coordinates
          @neighbor_coordinates ||= surrounding_block_coordinates - self_coordinates
        end

        def part_number?
          schematic.symbol_coordinates.any? { |sym_coord| neighbor_coordinates.include? sym_coord }
        end
      end

      class Symbol
        attr_reader :row, :col, :value, :schematic
        def initialize(row, col, value, schematic)
          @row = row
          @col = col
          @value = value
          @schematic = schematic
        end

        def coords
          [row, col]
        end

        def is_gear?
          value == "*"
        end

        def adjecent_numbers
          schematic.numbers.select do |number|
            number.neighbor_coordinates.include? coords
          end.map(&:value).map(&:to_i)
        end

        def gear_ratio
          return 0 unless is_gear?
          return 0 unless adjecent_numbers.length == 2

          adjecent_numbers.reduce(&:*)
        end
      end
    end
  end
end
