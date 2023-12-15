require_relative "../../problem"

module AdventOfCodeRuby
  module Year2023
    module Problem15
      class LensLibrary < Problem
        def part_1(input)
          input.chomp.split(",").map{ |step| Step.for(step).part_1 }.sum
        end

        def part_2(input)
          steps = input.chomp.split(",").map{ |step| Step.for(step) }
          lens_boxes = LensBoxes.new
          steps.each{ |step| step.apply lens_boxes }
          # lens_boxes.lens_boxes.reject(&:empty?).each{ |lb| p lb; puts }
          lens_boxes.focusing_power
        end
      end

      class Lens
        attr_reader :label, :focal_length
        def initialize(label, focal_length)
          @label = label
          @focal_length = focal_length
        end
      end

      class LensBoxes
        attr_reader :lens_boxes
        def initialize
          @lens_boxes = Array.new(256) { LensBox.new }
        end

        def [](index)
          lens_boxes[index]
        end

        def focusing_power
          lens_boxes.each_with_index.map{ |lens_box, i| lens_box.focusing_power(i + 1) }.sum
        end
      end

      class LensBox
        attr_reader :lenses
        def initialize
          @lenses = []
        end

        def remove(label)
          index = lenses.index { |lens| lens.label == label }
          lenses.delete_at(index) if index
        end

        def add(lens)
          index = lenses.index { |l| l.label == lens.label }
          if index
            lenses[index] = lens
          else
            lenses.push lens
          end
        end

        def empty?
          lenses.empty?
        end

        def focusing_power(box_number)
          return 0 if lenses.empty?

          box_number * lenses.each_with_index.map do |lens, i|
            (i + 1) * lens.focal_length.to_i
          end.sum
        end
      end

      class Step
        attr_reader :label
        def initialize(label)
          @label = label
        end

        def self.for(string)
          if string.include? "-"
            RemoveStep.new string.split("-")[0]
          else
            AddStep.new *string.split("=")
          end
        end

        def box
          cv = 0
          label.split("").each do |char|
            cv += char.ord
            cv *= 17
            cv = cv % 256
          end
          cv
        end
      end

      class RemoveStep < Step
        def part_1
          cv = 0
          label.split("").each do |char|
            cv += char.ord
            cv *= 17
            cv = cv % 256
          end
          cv += "-".ord
          cv *= 17
          cv % 256
        end

        def apply(lens_boxes)
          lens_boxes[box].remove label
        end
      end

      class AddStep < Step
        attr_reader :focal_length
        def initialize(label, focal_length)
          super(label)
          @focal_length = focal_length
        end

        def part_1
          cv = 0
          label.split("").each do |char|
            cv += char.ord
            cv *= 17
            cv = cv % 256
          end
          cv += "=".ord
          cv *= 17
          cv = cv% 256
          focal_length.split("").each do |char|
            cv += char.ord
            cv *= 17
            cv = cv % 256
          end
          cv
        end

        def apply(lens_boxes)
          lens_boxes[box].add Lens.new(label, focal_length)
        end
      end
    end
  end
end
