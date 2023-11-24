require_relative "../../problem"

module AdventOfCodeRuby
  module Year2021
    module Problem4
      class GiantSquid < Problem
        def part_1(input)
          bingo = Bingo.for input
          bingo.mark_calls_until_winner
          bingo.winning_boards.first.score
        end

        def part_2(input)
          bingo = Bingo.for input
          bingo.mark_calls
          bingo.last_winning_board.score
        end
      end

      class Bingo
        attr_reader :calls, :boards, :last_call
        def initialize(calls, boards)
          @calls = calls
          @boards = boards
        end

        def self.for(string)
          calls, *boards = string.split("\n\n")
          new calls.split(",").map(&:to_i), boards.map{ |board| Board.for board }
        end

        def mark_call
          call = calls.shift
          @last_call = call
          boards.each { |board| board.mark_cell_for_number call }
        end

        def mark_calls_until_winner
          mark_call until boards.any?(&:wins?)
        end

        def mark_calls
          mark_call until boards.all?(&:wins?)
        end

        def winning_boards
          boards.select(&:wins?)
        end

        def last_winning_board
          boards.find{ |board| board.last_call == last_call }
        end
      end

      class Board
        attr_reader :rows, :marked, :last_call
        def initialize(rows)
          @rows = rows
        end

        def wins?
          wins_horizontal? || wins_vertical?
        end

        def wins_horizontal?
          rows.any? { |row| row.all? { |cell| cell[:marked] } }
        end

        def wins_vertical?
          rows.transpose.any? { |column| column.all? { |cell| cell[:marked] } }
        end

        def cell_for_number(number)
          row = rows.find { |row| row.any? { |cell| cell[:number] == number } }
          row&.find{ |cell| cell[:number] == number }
        end

        def mark_cell_for_number(number)
          return if wins?

          @last_call = number
          cell_for_number(number)&.merge!({ marked: true })
        end

        def score
          unmarked_numbers.sum * last_call
        end

        def unmarked_numbers
          rows.map{ |row| row.reject{ |cell| cell[:marked] }.map{ |cell| cell[:number] } }.flatten
        end

        def self.for(string)
          new string.split("\n").map{ |row| row.split.map{ |cell| { number: cell.to_i, marked: false } } }
        end 
      end
    end
  end
end
