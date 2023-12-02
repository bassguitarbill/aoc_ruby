require_relative "../../problem"

module AdventOfCodeRuby
  module Year2023
    module Problem2
      class CubeConundrum < Problem
        def part_1(input)
          input.chomp.split("\n").map{ |line| Game.for line }.select(&:possible?).map(&:id).sum
        end

        def part_2(input)
          input.chomp.split("\n").map{ |line| Game.for line }.map(&:power).sum
        end
      end

      class Game
        attr_reader :id, :rounds
        def initialize(id, rounds)
          @id = id
          @rounds = rounds
        end

        def possible?
          rounds.all?(&:possible?)
        end

        def blues
          rounds.map &:blue
        end

        def fewest_blue
          blues.max
        end

        def reds
          rounds.map &:red
        end

        def fewest_red
          reds.max
        end

        def greens
          rounds.map &:green
        end

        def fewest_green
          greens.max
        end

        def power
          fewest_blue * fewest_red * fewest_green
        end

        def self.for(string)
          id, rounds = string.split(": ")
          id = id.split(" ")[1].to_i
          rounds = rounds.split("; ").map{ |round| Round.for round }
          new id, rounds
        end
      end

      class Round
        attr_reader :blue, :red, :green
        def initialize(blue, red, green)
          @blue = blue
          @red = red
          @green = green
        end

        # The Elf would first like to know which games would have been possible if the bag contained only 12 red cubes, 13 green cubes, and 14 blue cubes?
        def possible?
          red <= 12 && green <= 13 && blue <= 14
        end

        def self.for(string)
          colors = string.split(", ").map{ |color| Hash[*color.split.reverse] }.reduce(&:merge)
          new colors["blue"].to_i, colors["red"].to_i, colors["green"].to_i
        end
      end
    end
  end
end
