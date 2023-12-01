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
            starts_with_digit? || self.class.new(str[1..]).first_digit
          end

          def last_digit(str = text)
            ends_with_digit? || self.class.new(str[0..-2]).last_digit
          end

          def starts_with_digit?
            return text[0] if is_digit?(text[0])
            digits.keys.each { |key| return digits[key] if text.start_with?(key) }
            false
          end

          def ends_with_digit?
            return text[-1] if is_digit?(text[-1])
            digits.keys.each { |key| return digits[key] if text.end_with?(key) }
            false
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

          def is_digit?(c)
            digits.values.include? c
          end
        end
      end
    end
  end
end
