require_relative "../../problem"

module AdventOfCodeRuby
  module Year2023
    module Problem16
      class TheFloorWillBeLava < Problem
        def part_1(input)
          cave = Cave.from input
          cave.propagate
          cave.energized_points.count
        end

        def part_2(input)
          cave = Cave.from input
          width = cave.rows[0].length
          height = cave.rows.length
          top = (0..(width - 1)).map do |x|
            cave = Cave.from input
            cave.beams[0] = Beam.new(cave, Point.new(x, -1), :down)
            cave.propagate
            cave.energized_points.count
          end.max
          bottom = (0..(width - 1)).map do |x|
            cave = Cave.from input
            cave.beams[0] = Beam.new(cave, Point.new(x, height), :up)
            cave.propagate
            cave.energized_points.count
          end.max
          left = (0..(height - 1)).map do |y|
            cave = Cave.from input
            cave.beams[0] = Beam.new(cave, Point.new(-1, y), :right)
            cave.propagate
            cave.energized_points.count
          end.max
          right = (0..(height - 1)).map do |y|
            cave = Cave.from input
            cave.beams[0] = Beam.new(cave, Point.new(width, y), :left)
            cave.propagate
            cave.energized_points.count
          end.max

          [top, bottom, left, right].max
        end
      end

      class Cave
        attr_reader :rows, :beams
        def initialize(rows)
          @rows = rows
          @beams = [Beam.new(self, Point.new(-1, 0), :right)]
        end

        def self.from(string)
          new string.chomp.split("\n").map{ |line| line.split "" }
        end

        def tile_at(x, y)
          return nil if x < 0 || x > (rows[0].length - 1) || y < 0 || y > (rows.length - 1)
          rows[y][x]
        end

        def add_beam(beam)
          duplicate_beam = beams.find do |b|
            b.points[0].x == beam.points[0].x && b.points[0].y == beam.points[0].y && beam.direction == b.direction
          end
          beams << beam unless duplicate_beam
        end

        def propagate
          until done_propagating?
            # puts beams.reject(&:done).count
            beams.each(&:propagate) 
          end
        end

        def done_propagating?
          beams.all?(&:done)
        end

        def energized_points
          beams.map(&:points).flatten.filter do |point|
            point.x >= 0 && point.y >= 0 && point.x < rows[0].length && point.y < rows.length
          end.uniq{|point| point.x + (point.y * rows[0].length) }.sort
        end
      end

      class Point
        attr_reader :x, :y
        def initialize(x, y)
          @x = x
          @y = y
        end

        def eql?(other)
          puts "egh"
          x.eql?(other.x) && y.eql?(other.y)
        end

        def <=>(other)
          return x <=> other.x unless x == other.x
          y <=> other.y
        end
      end

      class Beam
        attr_reader :cave, :points, :direction, :done
        def initialize(cave, start_point, direction)
          @cave = cave
          @points = [start_point]
          @direction = direction
          @done = false
        end

        def propagate
          return if done

          new_point = Point.new(*case direction
                      when :up
                        [points.last.x, points.last.y - 1]
                      when :down
                        [points.last.x, points.last.y + 1]
                      when :left
                        [points.last.x - 1, points.last.y]
                      when :right
                        [points.last.x + 1, points.last.y]
                      end)
          points << new_point
          tile = cave.tile_at(new_point.x, new_point.y)
          unless tile == "."
            @done = true
            case direction
            when :up
              case tile
              when "-"
                cave.add_beam Beam.new(cave, new_point, :left)
                cave.add_beam Beam.new(cave, new_point, :right)
              when "|"
                cave.add_beam Beam.new(cave, new_point, :up)
              when "\\"
                cave.add_beam Beam.new(cave, new_point, :left)
              when "/"
                cave.add_beam Beam.new(cave, new_point, :right)
              end
            when :down
              case tile
              when "-"
                cave.add_beam Beam.new(cave, new_point, :left)
                cave.add_beam Beam.new(cave, new_point, :right)
              when "|"
                cave.add_beam Beam.new(cave, new_point, :down)
              when "\\"
                cave.add_beam Beam.new(cave, new_point, :right)
              when "/"
                cave.add_beam Beam.new(cave, new_point, :left)
              end
            when :left
              case tile
              when "-"
                cave.add_beam Beam.new(cave, new_point, :left)
              when "|"
                cave.add_beam Beam.new(cave, new_point, :up)
                cave.add_beam Beam.new(cave, new_point, :down)
              when "\\"
                cave.add_beam Beam.new(cave, new_point, :up)
              when "/"
                cave.add_beam Beam.new(cave, new_point, :down)
              end
            when :right
              case tile
              when "-"
                cave.add_beam Beam.new(cave, new_point, :right)
              when "|"
                cave.add_beam Beam.new(cave, new_point, :up)
                cave.add_beam Beam.new(cave, new_point, :down)
              when "\\"
                cave.add_beam Beam.new(cave, new_point, :down)
              when "/"
                cave.add_beam Beam.new(cave, new_point, :up)
              end
            end
          end
        end
      end
    end
  end
end
