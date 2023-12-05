require_relative "../../problem"

module AdventOfCodeRuby
  module Year2023
    module Problem5
      class Fertilizer < Problem
        def part_1(input)
          Almanac.for(input).lowest_location
        end

        def part_2(input)
          Almanac.for(input).lowest_location_all_seeds
        end
      end

      class Almanac
        attr_reader :seeds, :maps
        def initialize(seeds, maps)
          @seeds = seeds
          @maps = maps
        end

        def self.for(string)
          blocks = string.chomp.split("\n\n")
          seeds = blocks[0].split(" ")[1..].map(&:to_i)
          maps = blocks[1..].map{ |block| AlmanacMap.for block }
          new seeds, maps
        end

        def map_seed(seed)
          maps.reduce(seed) { |number, map| map.map_source_number(number) }
        end

        def lowest_location
          seeds.map{ |seed| map_seed seed }.min
        end

        def seed_ranges
          seeds.each_slice(2).map{ |start, length| (start..(start+length)) }
        end
        
        def lowest_location_ranges
          seed_ranges.map{ |range| range.to_a.map{ |seed| map_seed seed }.min }.min
        end

        def lowest_location_all_seeds
          natural_numbers = Enumerator.new do |yielder|
            index = 0
            loop do
              yielder.yield(index += 1)
            end
          end

          natural_numbers.find do |location|
            puts location if location % 10000 == 0
            seed_ranges.any? { |seed_range| seed_range.cover?(reverse_map(location)) }
          end
        end

        def reverse_map(location)
          maps.reverse.reduce(location) { |number, map| map.map_destination_number(number) }
        end
      end

      class AlmanacMap
        attr_reader :from, :to, :ranges
        def initialize(from, to, ranges)
          @from = from
          @to = to
          @ranges = ranges
        end

        def self.for(string)
          lines = string.split("\n")
          from, _, to = lines[0].split(" ")[0].split("-")
          new from, to, lines[1..].map{ |line| MapRange.for line }
        end

        def map_source_number(source_number)
          range = ranges.find{ |range| range.contains_source_number? source_number}
          return source_number unless range

          range.map_source_number(source_number)
        end

        def map_destination_number(destination_number)
          range = ranges.find{ |range| range.contains_destination_number? destination_number}
          return destination_number unless range

          range.map_destination_number(destination_number)
        end
      end

      class MapRange
        attr_reader :destination, :source, :length
        def initialize(destination, source, length)
          @destination = destination
          @source = source
          @length = length
        end

        def self.for(string)
          new *string.split(" ").map(&:to_i)
        end

        def contains_source_number?(source_number)
          source_number >= source && source_number < source + length
        end

        def map_source_number(source_number)
          return source_number unless contains_source_number?(source_number)
          source_number - source + destination
        end

        def contains_destination_number?(destination_number)
          destination_number >= destination && destination_number < destination + length
        end

        def map_destination_number(destination_number)
          return destination_number unless contains_destination_number?(destination_number)
          destination_number - destination + source
        end
      end
    end
  end
end
