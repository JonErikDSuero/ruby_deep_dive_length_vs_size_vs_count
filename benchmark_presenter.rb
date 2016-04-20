require 'benchmark'
require 'sourcify'
require 'colorize'


class BenchmarkPresenter

  COLUMN_WIDTH = 35
  ONE_MILLION = 10E5
  MAX_NUMBER_OF_DIGITS = 9

  def initialize(title:, setup:, tasks:)
    @title = title
    @setup = setup
    @tasks = tasks
  end

  def run
    puts title_header
    puts run_setup unless @setup.nil?

    puts column_headers
    @tasks.each { |task| puts row_benchmark(task) }

    puts ""
    puts ""
  end

  def title_header
    "#{@title}:".green
  end

  def run_setup
    @setup.call

    source(@setup).green
  end

  def column_headers
    ("Code".ljust(COLUMN_WIDTH) + " | " +
     "Result".ljust(COLUMN_WIDTH) + " | " +
     "Runtime (microseconds)").light_blue
  end

  def row_benchmark(block)
    begin
      result, runtime = benchmark(block)

      row_result(block, result, runtime)
   rescue => exception
     row_exception(block, exception)
   end
  end

  private

  def benchmark(block)
    result = nil
    runtime = Benchmark.realtime do
      result = block.call
    end

    [result, runtime]
  end

  def row_result(block, result, runtime)
      source(block).ljust(COLUMN_WIDTH) +
        " | " + "#{result}".ljust(COLUMN_WIDTH) +
        " | " + runtime_string(runtime)
  end

  def row_exception(block, exception)
    source(block).ljust(COLUMN_WIDTH).red +
      " | " + exception.to_s.red
  end

  def source(block)
    source_str = block.to_source
    source_str[7..source_str.length-3]
  end

  def runtime_string(runtime)
    ("%.2f" % (runtime * ONE_MILLION)).rjust(MAX_NUMBER_OF_DIGITS)
  end

end
