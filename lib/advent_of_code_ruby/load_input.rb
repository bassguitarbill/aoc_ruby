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

    def self.root_folder
      File.join(File.dirname(__FILE__), '../..')
    end

    def root_folder
      self.class.root_folder
    end

    COOKIE_NOT_FOUND_MESSAGE = <<-MSG
`#{File.absolute_path(File.join(root_folder, "cookie"))}` not found
First, log in at `https://adventofcode.com/2022/auth/login`
Open your browser\'s network inspection panel, copy the value of the `cookie` parameter inside a request
Create the file `#{File.absolute_path(File.join(root_folder, "cookie"))}` and fill it with the value of the `cookie` parameter
    MSG

    def advent_of_code_cookie
      unless File.exist? File.join(root_folder, "cookie")
        puts COOKIE_NOT_FOUND_MESSAGE
        exit 3
      end
      File.read(File.join(root_folder, "cookie"))
    end
  end
end
