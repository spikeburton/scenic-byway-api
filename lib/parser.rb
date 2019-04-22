require_relative '../config/environment'

def get_state_data(state)
  response = RestClient.get("#{STATE_ENDPOINT}/#{state}.json")
  JSON.parse(response)['byways'].collect(&:to_i)
end

def parse_state_data(x)
  formatter = RDoc::Markup::ToHtml.new(RDoc::Options.new, nil)
  x.collect do |data|
    res = RestClient.get("#{BYWAY_ENDPOINT}/#{data}.md")
    html_data = RDoc::Markdown.parse(res.body).accept(formatter)
    Nokogiri::HTML(html_data)
  end
end

def get_text_nodes(data)
  data.search('//text()').map(&:text)
end

## Return the bounds from the parsed data
def bounds_data(data)
  bounds = get_text_nodes(data).reject { |x| x !~ /\bbounds\b/ }
  # binding.pry
  # puts bounds
  if bounds.empty?
    "NO GEODATA AVAILABLE"
  else
    bounds.first.split('bounds:').last.split(' ').compact.reject { |x| x == '-' }
  end
end

def description_data(data)
  str = get_text_nodes(data).first
  desc = str.split('description:').last.split('contact:').first.split('path:').first.tr('“', '').tr('”', '').strip
end

## Return the name of the byway from the parsed data
def name_data(data)
  str = get_text_nodes(data).first
  name = str.split('name:').last.split('distance:').first.tr('“', '').tr('”', '').strip
end

def long_description_data(data)
  data.css('p').last.text.gsub("\n", " ")
end

def distance_data(data)
  str = get_text_nodes(data).first
  str.split('distance:').last.split('duration:').first.split('description').first.tr('“', '').tr('”', '').strip
end

def byway_data_to_hash(data)
  {
    name: name_data(data),
    distance: distance_data(data),
    description: description_data(data),
    bounds: bounds_data(data),
    long_description: long_description_data(data)
  }
end

# ALL_DATA_HASH = ALL_DATA.collect { |x| byway_data_to_hash(x) }

# HTML_DATA = RDoc::Markdown.parse(FIRST.body).accept(formatter)
# find the text node containing the bounds data and coordinates
# BOUNDS = Nokogiri::HTML(HTML_DATA).search('//text()').map(&:text).delete_if { |x| x !~ /\bbounds\b/ }
# Pry.start
