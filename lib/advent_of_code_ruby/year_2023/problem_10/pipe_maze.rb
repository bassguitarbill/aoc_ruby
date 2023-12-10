require_relative "../../problem"

module AdventOfCodeRuby
  module Year2023
    module Problem10
      class PipeMaze < Problem
        def part_1(input)
          maze = Maze.for input
          path = MazePath.new maze
          path.first_step!
          path.run!
          path.directions.length / 2
        end

        def part_2(input)
          maze = Maze.for input
          path = MazePath.new maze
          path.first_step!
          path.run!
          AreaCounter.new(maze).inside_tiles
          # puts maze.to_s
          maze.tiles.select(&:inside).count
        end
      end

      class AreaCounter
        attr_reader :maze
        def initialize(maze)
          @maze = maze
        end

        def inside_tiles
          maze.rows.map{ |row| inside_tiles_row row }.sum
        end

        def inside_tiles_row(row)
          inside = false
          inside_count = 0
          horiz = nil
          row.each do |tile|
            if tile.loop
              if tile.char == "|"
                inside = !inside
              elsif tile.char == "F"
                horiz = :bottom
              elsif tile.char == "L"
                horiz = :top
              elsif tile.char == "J"
                inside = !inside if horiz == :bottom
                horiz = nil
              elsif tile.char == "7"
                inside = !inside if horiz == :top
                horiz = nil
              end
            else
              tile.inside = inside
              inside_count += 1 if inside
            end
          end
          inside_count
        end
      end

      class MazePath
        attr_reader :maze, :directions
        attr_accessor :x, :y
        def initialize(maze)
          @maze = maze
          @directions = []
          @x = maze.start_tile.x
          @y = maze.start_tile.y
        end

        def tile(x, y)
          maze.tile(x, y)
        end

        def current_tile
          tile(x, y)
        end

        def first_step!
          return up! if tile(x, y - 1).down?
          return right! if tile(x + 1, y).left?
          return down! if tile(x, y + 1).up?
          return left! if tile(x - 1, y).right?
          raise "Where do I go??"
        end

        def opposite_direction(d)
          {
            up: :down,
            down: :up,
            left: :right,
            right: :left
          }[d]
        end

        def step!
          current_tile.loop = true
          from_direction = opposite_direction(directions[-1])
          next_direction = (%i[up down left right] - [from_direction]).find do |d|
            current_tile.send("#{d.to_s}?".to_sym)
          end
          send("#{next_direction.to_s}!")
          current_tile.loop = true
        end

        def run!
          step! until current_tile.start?
        end

        def up!
          directions << :up
          @y -= 1
        end

        def right!
          directions << :right
          @x += 1
        end

        def down!
          directions << :down
          @y += 1
        end

        def left!
          directions << :left
          @x -= 1
        end
      end

      class Maze
        attr_reader :rows
        attr_accessor :x, :y
        def initialize(rows)
          @rows = rows
          rows.each{ |row| row.each{ |tile| tile.maze = self } }
          @x = start_tile.x
          @y = start_tile.y
        end

        def tiles
          rows.to_a.flatten
        end

        def start_tile
          tiles.find(&:start?)
        end

        def tile(x, y)
          rows[y][x]
        end

        def self.for(string)
          new(string.chomp.split("\n").each_with_index.map do |line, j|
            line.split("").each_with_index.map{ |tile, i| Tile.new tile, i, j }
          end)
        end

        def to_s
          rows.map do |row|
            row.map do |tile|
                       next "#" if tile.loop
                       next "@" if tile.inside
                       "."
            end.join("")
          end.join("\n")
        end
      end

      class Tile
        attr_reader :char, :x, :y
        attr_accessor :maze, :loop, :inside
        def initialize(char, x, y)
          @char = char
          @x = x
          @y = y
          @loop = false
          @inside = false
        end

        def start?
          char == "S"
        end

        def up?
          @up ||= ["L", "|", "J"].include? char
        end

        def down?
          @down ||= ["7", "|", "F"].include? char
        end

        def left?
          @left ||= ["J", "-", "7"].include? char
        end

        def right?
          @right ||= ["F", "-", "L"].include? char
        end
      end
    end
  end
end
