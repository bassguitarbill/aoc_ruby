require_relative "../../problem"

module AdventOfCodeRuby
  module Year2023
    module Problem1
      class Trebuchet < Problem
        def part_1(input)
          input.chomp.split("\n").map do |line|
            chars = line
                      .gsub(/[a-z]/, "")
                      .split("")
            (chars[0] + chars[-1]).to_i
          end.sum
        end

        def part_2(input)
          input.chomp.split("\n").map do |line|
            (first_digit(line) + last_digit(line)).to_i
          end.sum
        end

        def is_digit?(c)
          digits.values.include? c
        end

        def digits
          {
            "one" => "1",
            "two" => "2",
            "three" => "3",
            "four" => "4",
            "five" => "5",
            "six" => "6",
            "seven" => "7",
            "eight" => "8",
            "nine" => "9"
          }
        end

        def starts_with_digit?(str)
          return str[0] if is_digit?(str[0])
          digits.keys.each { |key| return digits[key] if str.start_with?(key) }
          nil
        end

        def first_digit(str)
          starts_with_digit?(str) || first_digit(str[1..])
        end

        def ends_with_digit?(str)
          return str[-1] if is_digit?(str[-1])
          digits.keys.each { |key| return digits[key] if str.end_with?(key) }
          nil
        end

        def last_digit(str)
          ends_with_digit?(str) || last_digit(str[0..-2])
        end
      end
    end
  end
end
