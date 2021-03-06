require './benchmark_presenter'

puts "Ruby Version: #{RUBY_VERSION}"
puts ""

types = ARGV


if types.include?("sleep")
  BenchmarkPresenter.new({
    title: "SLEEP",
    setup: nil,
    tasks: [
      -> { sleep(0.5) },
    ]
  }).run
end


if types.empty? || types.include?("array")
  array = nil
  BenchmarkPresenter.new({
    title: "ARRAY",
    setup: ->{ array = (1..10E5).to_a },
    tasks: [
      -> { array.length },
      -> { array.size },
      -> { array.count },
      -> { array.count{|e| true} },
      -> { array.count(&:even?) },
      -> { array.select(&:even?).count }
    ]
  }).run
end

if types.empty? || types.include?("range")
  range = nil
  BenchmarkPresenter.new({
    title: "RANGE",
    setup: ->{ range = (1..10E5) },
    tasks: [
      -> { range.length },
      -> { range.size },
      -> { range.count },
      -> { range.count{|e| true} },
      -> { range.count(&:even?) },
      -> { range.select(&:even?).count },
    ]
  }).run
end


if types.empty? || types.include?("hash")
  hash = nil
  BenchmarkPresenter.new({
    title: "HASH",
    setup: ->{ hash = { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6 } },
    tasks: [
      -> { hash.length },
      -> { hash.size },
      -> { hash.count },
      -> { hash.count{ |k,v| true } },
      -> { hash.count{ |k,v| k == :b } },
      -> { hash.count{ |k,v| v != 5 } },
    ]
  }).run
end


if types.empty? || types.include?("string")
  string = nil
  BenchmarkPresenter.new({
    title: "STRING",
    setup: ->{ string = 'x' * 10E5 },
    tasks: [
      -> { string.length },
      -> { string.size },
      -> { string.count },
      -> { string.count('x') },
      -> { string.count('ax') },
    ]
  }).run
end


if types.empty? || types.include?("string2")
  string2 = nil
  BenchmarkPresenter.new({
    title: "STRING: PART 2",
    setup: ->{ string2 = 'hello world' },
    tasks: [
      -> { string2.length },
      -> { string2.size },
      -> { string2.count },
      -> { string2.count('x') },
      -> { string2.count('l') },
      -> { string2.count('lo') },
      -> { string2.count('lo', 'l') },
      -> { string2.count('lo', '^l') },
      -> { string2.count('k-m') },
    ]
  }).run
end

