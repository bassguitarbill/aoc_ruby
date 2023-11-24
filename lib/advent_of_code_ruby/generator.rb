require_relative 'load_input'

module AdventOfCodeRuby
  class Generator
    attr_reader :year, :day, :problem_name
    def initialize year, day, problem_name
      @year = year
      @day = day
      @problem_name = problem_name
    end

    def generate
      raise "Invalid year #{year}" unless valid_year?
      raise "Invalid day #{day}" unless valid_day?
      generate_year
      generate_problem
      generate_solution
      generate_input_text
    end

  private

    def valid_year?
      year >= 2015
    end

    def valid_day?
      day >= 1 && day <= 25
    end

    def generate_year
      Dir.mkdir year_folder unless File.directory? year_folder
      File.write(year_file, "") unless File.exist? year_file
      File.write(top_level_file, "") unless File.exist? top_level_file
      File.write(top_level_file, top_level_file_content, mode: "a") unless top_level_file_contains_year?
    end

    def generate_problem
      Dir.mkdir problem_folder unless File.directory? problem_folder
      File.write(problem_file, problem_file_content) unless File.exist? problem_file
      File.write(year_file, year_file_content) unless year_file_contains_problem?
    end

    def generate_solution
      File.write(solution_file, solution_file_content) unless File.exist? solution_file
    end

    def root_folder
      File.join(File.dirname(__FILE__), '../..')
    end

    def top_level_file
      File.join(root_folder, "lib/advent_of_code_ruby.rb")
    end

    def year_folder
      File.join(root_folder, "lib/advent_of_code_ruby/year_#{year}")
    end

    def year_file
      File.join(root_folder, "lib/advent_of_code_ruby/year_#{year}.rb")
    end

    def top_level_file_contains_year?
      File.read(top_level_file).include? top_level_file_content
    end

    def year_file_contains_problem?
      File.read(year_file).include? year_file_content
    end

    def problem_folder
      File.join(year_folder, "problem_#{day}")
    end

    def problem_file
      File.join(year_folder, "problem_#{day}.rb")
    end

    def input_file
      File.join(problem_folder, "input.txt")
    end

    def top_level_file_content
      "require_relative \"advent_of_code_ruby/year_#{year}.rb\"\n"
    end

    def year_file_content
      "require_relative \"year_#{year}/problem_#{day}.rb\"\n"
    end

    def problem_file_content
      "require_relative \"problem_#{day}/#{problem_name}.rb\"\n"
    end

    def solution_file
      File.join(problem_folder, "#{problem_name}.rb")
    end

    def solution_file_content
      <<~SOLUTION
require_relative "../../problem"

module AdventOfCodeRuby
  module Year#{year}
    module Problem#{day}
      class #{solution_class_name} < Problem
        def part_1(input)
        end

        def part_2(input)
        end
      end
    end
  end
end
SOLUTION
    end

    def solution_class_name
      problem_name.split('_').collect(&:capitalize).join
    end

    def generate_input_text
      return if problem_folder_contains_input?

      input_text = LoadInput.new(year, day).download_input
      File.write(input_file, input_text)
    end

    def problem_folder_contains_input?
      File.file? input_file
    end
  end
end
