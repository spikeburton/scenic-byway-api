require_relative '../config/environment'
require_relative './parser'

def all_state_data_to_hash(states)
  result = {}

  data = states.each do |s|
    d = parse_state_data(get_state_data(s))

    # set the name of the US state as the key in result
    # value is an array of all data for a particular US state
    result[s] = d.each_with_index.collect { |x,i| byway_data_to_hash(x,i+1) }
  end

  # return a hash with all the results
  {
    byways: result
  }
end

def generate_json(data)
  File.write("db.json", JSON.pretty_generate(data))
end

STATES = ["AL", "GA"]
DATA = all_state_data_to_hash(STATES)

Pry.start
