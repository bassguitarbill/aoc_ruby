require_relative "../../problem"

module AdventOfCodeRuby
  module Year2023
    module Problem7
      class CamelCards < Problem
        def part_1(input)
          Hands.for(input).total_winnings
        end

        def part_2(input)
          Hands.for(input).replace_jokers.total_winnings
        end
      end

      class Hands
        attr_reader :hands, :ranks
        def initialize(hands, ranks = :ranks)
          @hands = hands
          @ranks = ranks
        end

        def self.for(string)
          new string.chomp.split("\n").map{ |line| Hand.for line }
        end

        def total_winnings
          hands.sort.each_with_index.map{ |hand, i| hand.bid * (i + 1) }.sum
        end

        def replace_jokers
          self.class.new hands.map(&:replace_jokers), :joker_ranks 
        end
      end

      class Hand
        include Comparable
        attr_reader :cards, :bid, :original_cards, :ranks
        def initialize(cards, bid, original_cards = nil, ranks = :ranks)
          @cards = cards
          @bid = bid
          @original_cards = original_cards || cards
          @ranks = ranks
        end

        def self.for(string)
          cards, bid = string.split
          new cards.split(""), bid.to_i
        end

        def self.types
          @@types ||= {
            "five_of_a_kind" => 7,
            "four_of_a_kind" => 6,
            "full_house" => 5,
            "three_of_a_kind" => 4,
            "two_pair" => 3,
            "pair" => 2,
            "high_card" => 1
          }
        end

        def replace_jokers
          tally = cards.tally
          if tally['J'] == 5
            return self.class.new(['K', 'K', 'K', 'K', 'K'], bid, cards, :joker_ranks)
          elsif tally['J'] == 4
            kicker = tally.keys.reject{ |key| key == 'J' }
            return self.class.new([kicker] * 5, bid, cards, :joker_ranks)
          elsif tally['J'] == nil
            return self.class.new(cards, bid, cards, :joker_ranks)
          end

          hands = cards.reduce([[]]) do |h, card|
            if card == 'J'
              h.map{ |hand| Card.joker_ranks.keys[0..-2].map{ |new_card| hand + [new_card] } }.flatten(1)
            else
              h.map{ |hand| hand + [card] }
            end
          end.map{ |hand| Hand.new(hand, bid, cards, :joker_ranks) }
          hands.sort[-1]
        end

        def types
          self.class.types
        end

        def five_of_a_kind
          return [true, []] if cards.all? { |card| card == cards[0] }
          [false, []]
        end

        def four_of_a_kind
          tally = cards.tally
          return [true, [tally.invert[1]]] if tally.values.include? 4
          [false, []]
        end

        def full_house
          return [true, []] if cards.tally.values.sort == [2, 3]
          [false, []]
        end

        def three_of_a_kind
          tally = cards.tally
          return [true, tally.reject{ |_, v| v == 3}.keys] if tally.values.include? 3
          [false, []]
        end

        def two_pair
          tally = cards.tally
          return [true, tally.reject{ |_, v| v == 2}.keys] if tally.values.sort == [1, 2, 2]
          [false, []]
        end

        def pair
          tally = cards.tally
          return [true, tally.reject{ |_, v| v == 2}.keys] if tally.values.sort == [1, 1, 1, 2]
          [false, []]
        end

        def high_card
          [true, cards]
        end

        def type_with_kicker
          @type_with_kicker ||= types.keys.each do |type|
            twk = send("#{type}")
            return [type, twk[1]] if twk[0]
          end
        end

        def type
          type_with_kicker[0]
        end

        def kicker
          type_with_kicker[1]
        end

        def <=>(other)
          return types[type] <=> types[other.type] unless (types[type] <=> types[other.type]) == 0
          (0..4).each do |i|
            cmp = Card.new(original_cards[i], ranks) <=> Card.new(other.original_cards[i], ranks) 
            return cmp unless cmp == 0
          end
          0
        end

        def to_s
          "[#{cards.join}]: #{type}(#{original_cards.join})"
        end
      end

      class Card
        include Comparable
        attr_reader :value, :ranks
        def initialize(value, ranks = :ranks)
          @value = value
          @ranks = self.class.send(ranks)
        end

        def self.ranks
          @@ranks ||= {
            "A" => 1,
            "K" => 2,
            "Q" => 3,
            "J" => 4,
            "T" => 5,
            "9" => 6,
            "8" => 7,
            "7" => 8,
            "6" => 9,
            "5" => 10,
            "4" => 11,
            "3" => 12,
            "2" => 13
          }
        end

        def self.joker_ranks
          @@ranks ||= {
            "A" => 1,
            "K" => 2,
            "Q" => 3,
            "T" => 4,
            "9" => 5,
            "8" => 6,
            "7" => 7,
            "6" => 8,
            "5" => 9,
            "4" => 10,
            "3" => 11,
            "2" => 12,
            "J" => 13
          }
        end

        def <=>(other)
          ranks[other.value] <=> ranks[value]
        end
      end
    end
  end
end
