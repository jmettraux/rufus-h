
require 'benchmark'

require 'yaml'

require 'rubygems'

require 'json' ; puts 'json'
#require 'json/pure' ; puts 'json_pure'
#require 'active_support'; puts 'ar json'

o = [
  { :a => 1, :b => [ 2, 3 ], 1 => :c, 4 => { 'a' => 'a', 'b' => :b } },
  1,
  '日本語',
  3
]

y = YAML.dump(o)
m = Marshal.dump(o)
j = o.to_json

#p y, m
#p YAML.load(y)
#p Marshal.load(m)
#puts
p y.size
p m.size
p j.size


Benchmark.benchmark(' ' * 20 + Benchmark::Tms::CAPTION, 20) do |b|

  b.report('YAML dump') do
    5000.times { YAML.dump(o) }
  end
  b.report('YAML load') do
    5000.times { YAML.load(y) }
  end

  puts

  b.report('Marshal dump') do
    5000.times { Marshal.dump(o) }
  end
  b.report('Marshal load') do
    5000.times { Marshal.load(m) }
  end

  puts

  b.report('JSON dump') do
    5000.times { o.to_json }
  end
  b.report('JSON load') do
    5000.times { JSON.parse(j) }
    #5000.times { ActiveSupport::JSON::decode(j) }
  end

  puts
end

#  $ ruby tmp/t.rb
#                    user     system      total        real
#     YAML dump  2.590000   0.020000   2.610000 (  2.626664)
#     YAML load  0.470000   0.000000   0.470000 (  0.481389)
#  Marshal dump  0.060000   0.000000   0.060000 (  0.061336)
#  Marshal load  0.060000   0.000000   0.060000 (  0.058285)
#
#  $ ruby -v
#  ruby 1.8.6 (2008-03-03 patchlevel 114) [universal-darwin9.0]

