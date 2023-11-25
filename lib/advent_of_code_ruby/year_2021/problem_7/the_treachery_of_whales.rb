require_relative "../../problem"

module AdventOfCodeRuby
  module Year2021
    module Problem7
      class TheTreacheryOfWhales < Problem
        def part_1(input)
          crabs = input.chomp.split(",").map(&:to_i)
          (crabs.min..crabs.max).map do |target|
            crabs.map{ |crab| (crab - target).abs }.sum
          end.min
        end

        def part_2(input)
          crabs = input.chomp.split(",").map(&:to_i)
          (crabs.min..crabs.max).map do |target|
            crabs.map{ |crab| (crab - target).abs.triangle }.sum
          end.min
        end
      end
    end
  end
end

class Integer
  def triangle
    (1..self).sum
  end
end
