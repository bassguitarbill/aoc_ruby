require_relative "../../problem"

module AdventOfCodeRuby
  module Year2023
    module Problem1
      class Trebuchet < Problem
        def part(input, calibration_line_class)
          input.chomp.split("\n").map { |line| calibration_line_class.new(line).value }.sum
        end

        def part_1(input)
          part(input, CalibrationLine)
        end

        def part_2(input)
          part(input, AlphaCalibrationLine)
        end

        class CalibrationLine
          attr_reader :text
          def initialize(text)
            @text = text
          end

          def digits
            text.gsub(/[a-z]/, "").split("")
          end

          def first_digit
            digits.first
          end

          def last_digit
            digits.last
          end

          def value
            (first_digit + last_digit).to_i
          end
        end

        class AlphaCalibrationLine < CalibrationLine
          def first_digit(str = text)
            self.class.starts_with_digit?(str) || first_digit(str[1..])
          end

          def last_digit(str = text)
            self.class.ends_with_digit?(str) || last_digit(str[0..-2])
          end

          def self.is_digit?(c)
            digits.values.include? c
          end

          def self.digits
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

          def self.starts_with_digit?(str)
            return str[0] if is_digit?(str[0])
            digits.keys.each { |key| return digits[key] if str.start_with?(key) }
            false
          end

          def self.ends_with_digit?(str)
            return str[-1] if is_digit?(str[-1])
            digits.keys.each { |key| return digits[key] if str.end_with?(key) }
            false
          end
        end

      end
    end
  end
end
