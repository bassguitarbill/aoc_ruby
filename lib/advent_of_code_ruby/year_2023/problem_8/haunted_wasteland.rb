require_relative "../../problem"
require "set"
require "prime"

module AdventOfCodeRuby
  module Year2023
    module Problem8
      class HauntedWasteland < Problem
        def part_1(input)
          #network = Network.for input
          # network.navigate_to!("ZZZ")
          #network.steps
        end

        def part_2(input)
          network = Network.for input
          network.navigate_ghosts_to!
          network.steps
        end
      end

      class Ghost
        attr_reader :node, :states, :state_list, :cycle_start, :cycle_length
        def initialize(node)
          @node = node
          @states = Set[]
          @state_list = []
          @in_cycle = false
          @steps = 0
        end

        def in_cycle?
          @in_cycle
        end

        def step_to(node, di)
          return if in_cycle?
          @node = node
          state = "#{di}#{node}"
          if states === state
            @in_cycle = true
            @cycle_start = state_list.index state
            @cycle_length = @steps - cycle_start
          else
            states.add state
            state_list.push state
            @steps += 1
          end
        end

        def right
          node.right
        end

        def left
          node.left
        end

        def ending_node?
          node.ending_node?
        end
      end

      class Network
        attr_reader :directions, :nodes
        attr_accessor :current_node, :current_ghosts, :steps, :directions_index
        def initialize(directions, nodes)
          @directions = directions
          @nodes = nodes
          @current_node = starting_node
          @current_ghosts = starting_nodes.map{ |node| Ghost.new node }
          @steps = 0
          @directions_index = 0
        end

        def starting_node
          nodes["AAA"]
        end

        def starting_nodes
          nodes.values.filter(&:starting_node?)
        end

        def step_ghosts!
          case directions[directions_index]
          when "R"
            current_ghosts.each{ |ghost| ghost.step_to(nodes[ghost.right], directions_index) }
          when "L"
            current_ghosts.each{ |ghost| ghost.step_to(nodes[ghost.left], directions_index) }
          end
          self.steps += 1
          self.directions_index = (directions_index + 1) % directions.count
          if current_ghosts.all?(&:in_cycle?)
            p current_ghosts.map{ |ghost| ghost.cycle_length.prime_division.to_h.keys }.reduce(&:intersection)[0]
            raise
          end
        end

        def step!
          case directions[directions_index]
          when "R"
            self.current_node = nodes[current_node.right]
          when "L"
            self.current_node = nodes[current_node.left]
          end
          self.steps += 1
          self.directions_index = (directions_index + 1) % directions.count
        end

        def navigate_ghosts_to!
          step_ghosts! until current_ghosts.all?(&:ending_node?)
        end

        def navigate_to!(destination)
          step! until current_node.name == destination
        end

        def self.for(string)
          directions, nodes = string.chomp.split("\n\n")
          nodes = nodes.split("\n").map{ |line| Node.for line }
          nodes = nodes.each_with_object({}){ |node, hash| hash.merge! Hash[node.name, node] }
          new directions.split(""), nodes
        end
      end

      class Node
        attr_reader :name, :left, :right
        def initialize(name, left, right)
          @name = name
          @left = left
          @right = right
        end

        def self.for(string)
          name, lr = string.split(" = ")
          left, right = lr.split(", ")
          new name, left[1..], right [0..-2]
        end

        def starting_node?
          name[-1] == "A"
        end

        def ending_node?
          name[-1] == "Z"
        end
      end
    end
  end
end
