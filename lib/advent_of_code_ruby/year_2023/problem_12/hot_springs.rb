require_relative "../../problem"

module AdventOfCodeRuby
  module Year2023
    module Problem12
      class HotSprings < Problem
        def part_1(input)
          records = input.chomp.split("\n").map{ |line| ConditionRecord.for line }
          records.each_with_index.map{ |record, i| record.valid_permutations(i) }.sum
        end

        def part_2(input)
        end
      end

      class ConditionRecord
        attr_reader :springs, :groups
        def initialize(springs, groups)
          @springs = "." + springs + "."
          @groups = groups
        end

        def self.for(string)
          springs, groups = string.split " "
          new springs, groups.split(",")
        end

        def regex
          @regex ||= Regexp.new("^\\.+" + groups.map{ |group| "\#\{#{group}\}" }.join("\\.+") + "\\.+$")
        end

        def permutations
          @permutations ||= springs.split("").reduce([[]]) do |combos, spring|
            if spring == "?"
              combos.map{ |combo| [".", "#"].map{ |s| combo + [s] } }.flatten 1
            else
              combos.map{ |combo| combo + [spring] }
            end
          end.map(&:join)
        end

        def valid_permutations(i = nil)
          # puts
          puts i
          # puts springs
          # puts groups
          # puts regex
          permutations.map{ |perm| regex.match perm }.compact.count
        end
      end
    end
  end
end
