require 'net/http'
require 'uri'
require 'json'

output = Hash["items" => []]
data = JSON.parse(File.read('data.json'))
base = data['base']
units = data['units']

uri = URI("https://exchangeratesapi.io/api/latest?base=#{base}&symbols=#{units.join(',')}")
result = JSON.parse(Net::HTTP.get(uri))
result['rates'].each do |key, value|
    temp = Hash[
        "title" => "#{key}",
        "subtitle" => "#{base} : #{key} = 1 : #{value.round(4)} (Last Update: #{result["date"]})",
        "icon" => Hash[
            "path" => "flags/#{key}.png"
        ],
        "arg" => "#{key}"
    ]
    output["items"].push(temp)
end

print output.to_json