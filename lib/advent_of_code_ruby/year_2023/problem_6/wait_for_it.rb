require_relative "../../problem"

module AdventOfCodeRuby
  module Year2023
    module Problem6
      class WaitForIt < Problem
        def part_1(input)
          Races.for(input, race_class: MathsRace).margin_of_error
        end

        def part_2(input)
          MathsRace.for(input).ways_to_win
        end
      end

      class Races
        attr_reader :races
        def initialize(races)
          @races = races
        end

        def self.for(string, race_class: BigRace)
          times, distances = string.chomp.split("\n").map(&:split)
          new times[1..].zip(distances[1..]).map{ |time, distance| race_class.new time.to_i, distance.to_i }
        end

        def margin_of_error
          races.map(&:ways_to_win).reduce(&:*)
        end
      end

      module Quadratic
        def square_root_part
          @square_root_part ||= Math.sqrt((b * b) - (4 * a * c))
        end

        def roots
          %i[+ -].map{ |op| (-b.send(op, square_root_part)) / (2 * a) }.sort
        end
      end

      class MathsRace
        include Quadratic
        attr_reader :time, :distance
        def initialize(time, distance)
          @time = time
          @distance = distance
        end

        def self.for(string)
          time, distance = string.chomp.split("\n").map(&:split)
          new time[1..].join.to_i, distance[1..].join.to_i
        end

        def rounded_roots
          [roots[0].next_float.ceil, roots[1].prev_float.floor + 1]
        end

        def ways_to_win
          rounded_roots.sort.reverse.reduce(&:-)
        end

        def a
          -1
        end

        def b
          time
        end

        def c
          -distance
        end
      end

      class Race
        attr_reader :time, :distance
        def initialize(time, distance)
          @time = time
          @distance = distance
        end

        def ways_to_win
          (0..time).map{ |time_held| RaceRun.new self, time_held }.filter(&:beats_the_record?).count
        end 

        def first_winning_time
          (0..time).find{ |time_held| RaceRun.new(self, time_held).beats_the_record? }
        end

        def rounded_roots
          [first_winning_time, time - first_winning_time]
        end
      end

      class RaceRun
        attr_reader :race, :time_held
        def initialize(race, time_held)
          @race = race
          @time_held = time_held
        end

        def distance
          time_held * (race.time - time_held)
        end

        def beats_the_record?
          distance > race.distance
        end
      end

      class BigRace
        attr_reader :time, :distance
        def initialize(time, distance)
          @time = time
          @distance = distance
        end

        def self.for(string)
          time, distance = string.chomp.split("\n").map(&:split)
          new time[1..].join.to_i, distance[1..].join.to_i
        end

        def first_winning_time
          return @first_winning_time if @first_winning_time
          range = time / 2
          guess = time / 4
          step = time / 8
          while range >= 1
            # puts "range: #{range}, guess: #{guess}, step: {step}"
            run = RaceRun.new(self, guess)
            if run.beats_the_record?
              guess -= step
            else
              guess += step
            end

            range /= 2
            step /= 2
          end

          # My binary search is inaccurate; this cleans it up
          @first_winning_time = ((guess - 2)..(guess + 2)).find do |guess|
            RaceRun.new(self, guess).beats_the_record?
          end
        end

        def last_winning_time
          time - first_winning_time
        end

        def ways_to_win
          last_winning_time - first_winning_time + 1
        end

        def rounded_roots
          [first_winning_time, last_winning_time]
        end
      end
    end
  end
end
