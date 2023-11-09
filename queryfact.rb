require 'rspec/autorun'

# given
# ft = .3 m
# ft = 12 in
# pd = .45 kg
# etc
# answer questions like
# 2 m = ? ft -> 6.5
# 2 m = ? in -> 78
# 13 in = ? hr -> not convertible

class Facts
  def initialize(facts)
    @conversion = {}
    @neighbors = Hash.new { _1[_2] = [] }
    parse_and_store(facts)
  end

  def parse_and_store(facts)
    facts.each do |fact|
      case fact.split
      in [from, '=', factor, to]
        @conversion[key(from, to)] = factor.to_f
        @conversion[key(to, from)] = 1 / factor.to_f
        @neighbors[from] << to
        @neighbors[to] << from
      else
        raise "cannot parse #{fact}"
      end
    end
  end

  def key(from, to)
    [from, to].join
  end

  def answer(query)
    case query.split
    in [amount, from, '=', '?', to]
      path = connection(from, to)
      if path
        convert(amount.to_f, from, to, path)
      else
        'cannot answer'
      end
    else
      raise "cannot parse #{query}"
    end
  end

  def connection(from, to)
    visited = Set.new()
    to_visit = Queue.new()

    to_visit << [[], from]
    while !to_visit.empty?
      path, node = to_visit.pop
      @neighbors[node].each do |neighbor|
        if neighbor == to
          return path
        end

        unless visited.include?(neighbor)
          to_visit << [path + [neighbor], neighbor]
        end
      end
      visited << node
    end

    return nil
  end

  def convert(amount, from, to, path)
    path = [from] + path + [to]
    path.each_cons(2) do |source, target|
      amount *= @conversion[key(source, target)]
    end
    amount
  end
end

def answer_query(query, facts)
  graph = Facts.new(facts)
  graph.answer(query)
end

RSpec.describe 'answer_query' do
  it 'answers basic query from facts' do
    answer = answer_query("2 m = ? ft", ["ft = .3 m"])
    expect(answer).to be_between(6, 7)
  end

  it 'answers complex query from facts' do
    answer = answer_query("2 m = ? in", ["m = 3.3 ft", "ft = 12 in"])
    expect(answer).to be_between(79, 80)
  end

  it 'handles uncovertible queries' do
    answer = answer_query("2 m = ? hr", ["ft = .3 m", "hr =  60 min"])
    expect(answer).to eq('cannot answer')
  end
end
