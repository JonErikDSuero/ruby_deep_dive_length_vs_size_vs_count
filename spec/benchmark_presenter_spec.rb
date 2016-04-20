require 'spec_helper'

describe BenchmarkPresenter do

  describe '#run' do
    it 'should present results' do
      a = nil
      benchmark_presenter = BenchmarkPresenter.new({
        title: "MY TITLE",
        setup: -> { a = 0.5 },
        tasks: [
          -> { a + 10 }
        ]
      })

      expect { benchmark_presenter.run }.to output(/MY TITLE/).to_stdout
      expect { benchmark_presenter.run }.to output(/a \= 0.5/).to_stdout
      expect { benchmark_presenter.run }.to output(/a \+ 10/).to_stdout
      expect { benchmark_presenter.run }.to output(/10\.5/).to_stdout
    end

    it 'should present exception messages' do
      a = double
      benchmark_presenter = BenchmarkPresenter.new({
        title: "MY TITLE",
        setup: nil,
        tasks: [
          -> { a.fail }
        ]
      })

      expect(a).to receive(:fail).at_least(:once).and_raise("My Exception Message")
      expect { benchmark_presenter.run }.to output(/MY TITLE/).to_stdout
      expect { benchmark_presenter.run }.to output(/a.fail/).to_stdout
      expect { benchmark_presenter.run }.to output(/My Exception Message/).to_stdout
    end
  end
end
