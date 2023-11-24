require_relative "../../problem"

module AdventOfCodeRuby
  module Year2021
    module Problem1
      class SonarSweep < Problem
        def part(input, window_size: 1)
          input = input.chomp.split.map(&:to_i)
          i1 = input[..(-1 - window_size)]
          i2 = input[window_size..]
          i1.zip(i2).select{ |a, b| a < b}.count
        end

        def part_1(input)
          part input, window_size: 1
        end

        def part_2(input)
          part input, window_size: 3
        end
      end
    end
  end
end
