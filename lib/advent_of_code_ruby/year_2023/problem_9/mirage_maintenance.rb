require_relative "../../problem"

module AdventOfCodeRuby
  module Year2023
    module Problem9
      class MirageMaintenance < Problem
        def part_1(input)
          input.chomp.split("\n").map{ |line| OasisReport.for line }.map{ |report| report.last_value }.sum
        end

        def part_2(input)
          input.chomp.split("\n").map{ |line| OasisReport.for line }.map{ |report| report.first_value }.sum
        end
      end

      class OasisReport
        attr_reader :values
        def initialize(values)
          @values = values
        end

        def self.for(string)
          new string.split.map(&:to_i)
        end

        def last_value
          return 0 if all_zeroes?
          values.last + derivative.last_value
        end

        def first_value
          return 0 if all_zeroes?
          values.first - derivative.first_value
        end

        def derivative
          @derivative ||= self.class.new(values[1..].zip(values[0..-2]).map{ |a, b| a - b })
        end

        def all_zeroes?
          values.all?{ |value| value == 0 }
        end
      end
    end
  end
end
