require_relative "../../problem"

module AdventOfCodeRuby
  module Year2023
    module Problem6
      class WaitForIt < Problem
        def part_1(input)
          Races.for(input).margin_of_error
        end

        def part_2(input)
          BigRace.for(input).ways_to_win
        end
      end

      class Races
        attr_reader :races
        def initialize(races)
          @races = races
        end

        def self.for(string)
          times, distances = string.chomp.split("\n").map(&:split)
          new times[1..].zip(distances[1..]).map{ |time, distance| BigRace.new time.to_i, distance.to_i }
        end

        def margin_of_error
          races.map(&:ways_to_win).reduce(&:*)
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
      end
    end
  end
end
