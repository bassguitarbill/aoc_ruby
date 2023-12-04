require_relative "../../problem"

module AdventOfCodeRuby
  module Year2023
    module Problem4
      class Scratchcards < Problem
        def part_1(input)
          ScratchcardCollection.for(input).total_point_value
        end

        def part_2(input)
          ScratchcardCollection.for(input).cascading_copy_cards_count
        end
      end

      class ScratchcardCollection
        attr_reader :cards
        def initialize(cards)
          @cards = cards
          @cards_hash = cards.each_with_object({}){ |card, hash| hash.merge!(Hash[card.id, card]) }
        end

        def self.for(string)
          new string.chomp.split("\n").map{ |line| Scratchcard.for(line) }
        end

        def total_point_value
          cards.map(&:point_value).sum
        end

        def copy_ids
          cards.map(&:copy_ids).flatten
        end

        def copy_cards
          self.class.new copy_ids.map{ |copy_id| @cards_hash[copy_id] }
        end

        def cards_count
          cards.length
        end

        def cascading_copy_cards_count
          return 0 if cards_count == 0

          cards_count + copy_cards.cascading_copy_cards_count
        end
      end

      class Scratchcard
        attr_reader :id, :numbers, :winning_numbers
        def initialize(id, numbers, winning_numbers)
          @id = id
          @numbers = numbers
          @winning_numbers = winning_numbers
        end

        def self.for(string)
          id, numbers = string.split(":")
          id = id.split[1].to_i
          numbers, winning_numbers = numbers.split("|").map(&:split)
          new id, numbers.map(&:to_i), winning_numbers.map(&:to_i)
        end

        def winners
          numbers.intersection(winning_numbers)
        end

        def number_of_winners
          winners.length
        end

        def point_value
          return 0 if number_of_winners == 0
          2 ** (number_of_winners - 1)
        end

        def copy_ids
          return [] if point_value == 0
          (1..number_of_winners).map{ |x| id + x }
        end
      end
    end
  end
end
