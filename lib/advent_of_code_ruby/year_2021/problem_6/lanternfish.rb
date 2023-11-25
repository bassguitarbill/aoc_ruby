require_relative "../../problem"

module AdventOfCodeRuby
  module Year2021
    module Problem6
      class Lanternfish < Problem
        def part(input, times)
          school = School.for input
          times.times { school.pass_day }
          school.fish_count
        end

        def part_1(input)
          part(input, 80)
        end

        def part_2(input)
          part(input, 256)
        end
      end

      class School
        attr_reader :fish
        def initialize(fish)
          @fish = fish.tally
        end

        def self.for(string)
          new string.chomp.split(",").map(&:to_i)
        end

        def fish_count
          fish.values.sum
        end

        def pass_day
          age
          spawn
        end

        def age
          fish.transform_keys!{ |key| key - 1 }
        end

        def spawn
          spawn_count = fish[-1] || 0
          fish.merge!({ 6 => (fish[6] || 0) + spawn_count })
          fish.merge!({ 8 => spawn_count })
          fish.merge!({ -1 => 0 })
        end
      end
    end
  end
end
