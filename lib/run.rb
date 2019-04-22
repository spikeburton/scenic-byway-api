require_relative '../config/environment'
require_relative './parser'

def all_state_data_to_hash(state)
  data = parse_state_data(get_state_data(state))

  {
    byways: data.collect { |x| byway_data_to_hash(x) }
  }
end

# GA_DATA = get_state_data("GA")
# ALL_DATA = parse_state_data(GA_DATA)
# ALL_DATA_HASH = ALL_DATA.collect { |x| byway_data_to_hash(x) }
GA_DATA = all_state_data_to_hash("GA")
File.write("db.json", JSON.pretty_generate(GA_DATA))

Pry.start
