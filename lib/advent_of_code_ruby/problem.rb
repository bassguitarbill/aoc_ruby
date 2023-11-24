require_relative './input'

module AdventOfCodeRuby
  class Problem
    include Input
    def run_problem
      input = load_file
      problem_parts.each_with_object({}) do |part, answers|
        answers[part] = send(part, input)
      end
    end

    def problem_parts
      %i[part_1 part_2]
    end

    def part_1(_)
      0
    end

    def part_2(_)
      0
    end
  end
end
