require_relative "../../problem"
require 'set'

module AdventOfCodeRuby
  module Year2021
    module Problem5
      class HydrothermalVenture < Problem
        def part_1(input)
          OceanFloor.for(input).double_vents.count
        end

        def part_2(input)
          OceanFloor.for(input).double_vents_with_diagonal.count
        end
      end

      class OceanFloor
        attr_reader :vent_lines
        def initialize(vent_lines)
          @vent_lines = vent_lines
        end

        def double_vents
          single_vents = Set[]
          double_vents = Set[]
          vent_lines.reject(&:diagonal?).map(&:points).flatten(1).each do |point|
            double_vents.add(point) if single_vents === point
            single_vents.add point
          end
          double_vents
        end

        def double_vents_with_diagonal
          single_vents = Set[]
          double_vents = Set[]
          vent_lines.map(&:points).flatten(1).each do |point|
            double_vents.add(point) if single_vents === point
            single_vents.add point
          end
          double_vents
        end

        def self.for(string)
          new string.chomp.split("\n").map{ |line| VentLine.for line }
        end
      end

      class VentLine
        attr_reader :start_pos, :end_pos
        def initialize(start_pos, end_pos)
          @start_pos = start_pos
          @end_pos = end_pos
        end

        def self.for(string)
          start_pos, end_pos = string.split(" -> ").map{ |pos| pos.split(",").map(&:to_i) }
          new start_pos, end_pos
        end

        def diagonal?
          start_pos[0] != end_pos[0] && start_pos[1] != end_pos[1]
        end

        def num_points
          [start_pos[0] - end_pos[0], start_pos[1] - end_pos[1]].map(&:abs).max
        end

        def points
          (0..num_points).map do |index|
            [
              start_pos[0] + ((end_pos[0] - start_pos[0]).sign * index),
              start_pos[1] + ((end_pos[1] - start_pos[1]).sign * index),
            ]
          end
        end
      end
    end
  end
end

class Integer
  def sign
    [0,1,-1][self<=>0];
  end
end
    
