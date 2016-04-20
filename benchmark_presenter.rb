require 'benchmark'
require 'sourcify'
require 'colorize'


class BenchmarkPresenter

  COLUMN_WIDTH = 35

  def initialize(title:, setup:, tasks:)
    @title = title
    @setup = setup
    @tasks = tasks
  end

  def run
    @setup.call unless @setup.nil?

    puts title_header
    puts setup_header unless @setup.nil?

    puts column_headers
    @tasks.each do |task|
      benchmark(task)
    end

    puts ""
    puts ""
  end

  def title_header
    "#{@title}:".green
  end

  def setup_header
    source(@setup).green
  end

  def column_headers
    ("Code".ljust(COLUMN_WIDTH) + " | " +
     "Result".ljust(COLUMN_WIDTH) + " | " +
     "Runtime (microseconds)").light_blue
  end

  def benchmark(block)
    begin
      result = nil
      runtime = Benchmark.realtime do
        result = block.call
      end

      puts source(block).ljust(COLUMN_WIDTH) +
        " | " + "#{result}".ljust(COLUMN_WIDTH) +
        " | " + ("%.2f" % (runtime * 10E5)).rjust(9)
    rescue => e
      puts source(block).ljust(COLUMN_WIDTH).red +
        " | " + e.to_s.red
    end
  end

  private

  def source(block)
    source_str = block.to_source
    source_str[7..source_str.length-3]
  end

end
