require 'net/http'

module AdventOfCodeRuby
  class LoadInput
    attr_reader :year, :day
    def initialize(year, day)
      @year = year
      @day = day
    end

    def download_input
      return if input_already_downloaded?
      Net::HTTP.get_response(uri, header_hash).body
    end

  private

    def input_already_downloaded?
      false
    end

    def header_hash
      {
        "User-Agent" => "github.com/bassguitarbill/advent_of_code_ruby by bassguitarbill@gmail.com",
        "Cookie" => advent_of_code_cookie
      }
    end

    def uri
      URI("https://adventofcode.com/#{year}/day/#{day}/input")
    end

    def advent_of_code_cookie
      File.read(File.join(root_folder, "cookie"))
    end

    def root_folder
      File.join(File.dirname(__FILE__), '../..')
    end
  end
end
