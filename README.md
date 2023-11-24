# Advent of Code: Ruby

## What is this?
This project is a template for developing and running your Advent of Code solutions in Ruby. You can use this to make a single repository containing your solutions for a single year, but it's capable of hosting solutions for multiple years.

## What is Advent of Code?
[Advent of Code](https://adventofcode.com) is a yearly collection of small puzzles, released one per day during the month of December, similar to an [advent calendar](https://en.wikipedia.org/wiki/Advent_calendar). The puzzles increase in difficulty as the month goes on, starting off with text-processing and integer calculation, and progressing to multidimensional arrays, complicated data structures, and graph analysis. If you're one of the first 100 people to solve a puzzle, you end up on a leaderboard. This is very challenging! I personally find these puzzles more fun to solve at a relaxed pace.

## How can I use this?
* Clone or fork this repository
* In [.gitignore](./.gitignore), remove the lines that start with `/lib/`
* If you're trying to solve the problem for the current day, run `$ bin/generate_today <problem_name>` to generate a problem stub
* If you're trying a problem from another day, run `$ bin/generate <year> <day> <problem_name>` to generate the stub
* To run your solution to today's problem, run `$ bin/run_today`
* To run your solution to an arbitrary problem, run `$ bin/run <year> <day>`

## What shouldn't I do with this repository?
The only thing you shouldn't do, that I can think of, is hammer the Advent of Code servers with repeated requests. Whenever you `generate` a problem, if its `input.txt` doesn't exist, the generator will fetch it. If you do this repeatedly, possibly by clearing input.txt and rerunning `generate`, I'm going to be the one who gets in trouble. If you change the infrastructure (any code not in `lib/advent_of_code_ruby/year*`), I'd ask that you put your own contact information in [the User-Agent header](https://github.com/bassguitarbill/advent_of_code_ruby/blob/5fd2fc3e8808542c732f39aa5ba94ce98b353f9f/lib/advent_of_code_ruby/load_input.rb#L24).

## It's not working!
Yeah, probably! I'm writing this in November, so I can't test the `generate_today` and `run_today` functionality. Please open up an [issue](https://github.com/bassguitarbill/advent_of_code_ruby/issues) if you think something isn't working properly!
