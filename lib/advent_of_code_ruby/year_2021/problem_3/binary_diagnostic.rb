require_relative "../../problem"

module AdventOfCodeRuby
  module Year2021
    module Problem3
      class BinaryDiagnostic < Problem
        def part_1(input)
          gamma = input.chomp.split("\n").map{ |line| line.split ""}.transpose.map{ |column| column.tally.sort_by{ |_k, v| v }.last[0] }.join.to_i(2)
          epsilon = input.chomp.split("\n").map{ |line| line.split ""}.transpose.map{ |column| column.tally.sort_by{ |_k, v| v }.first[0] }.join.to_i(2)
          gamma * epsilon
        end

        def part_2(input)
        end
      end
    end
  end
end
