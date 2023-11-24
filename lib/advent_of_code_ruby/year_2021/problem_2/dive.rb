require_relative "../../problem"

module AdventOfCodeRuby
  module Year2021
    module Problem2
      class Dive < Problem
        def part(input, submarine_class: Submarine)
          submarine = submarine_class.for input
          submarine.execute_commands
          submarine.solution
        end

        def part_1(input)
          part input, submarine_class: Submarine
        end

        def part_2(input)
          part input, submarine_class: AimSubmarine
        end
      end

      class Submarine
        attr_accessor :horizontal_position, :depth
        attr_reader :commands

        def initialize(commands)
          @commands = commands
          @horizontal_position = 0
          @depth = 0
        end

        def solution
          horizontal_position * depth
        end

        def execute_command
          command = commands.shift
          send("execute_#{command.verb}_command".to_sym, command.num)
        end

        def execute_commands
          execute_command until commands.empty?
        end

        def execute_up_command(num)
          self.depth -= num
        end

        def execute_down_command(num)
          self.depth += num
        end

        def execute_forward_command(num)
          self.horizontal_position += num
        end

        def self.for(string)
          new string.chomp.split("\n").map{ |line| Command.for line }
        end
      end

      class AimSubmarine < Submarine
        attr_accessor :aim
        def initialize(commands)
          super
          @aim = 0
        end
        
        def execute_up_command(num)
          self.aim -= num
        end

        def execute_down_command(num)
          self.aim += num
        end

        def execute_forward_command(num)
          self.horizontal_position += num
          self.depth += aim * num
        end
      end

      class Command
        attr_reader :verb, :num
        def initialize(verb, num)
          @verb = verb
          @num = num
        end

        def self.for(string)
          verb, num = string.split
          new verb, num.to_i
        end
      end
    end
  end
end
