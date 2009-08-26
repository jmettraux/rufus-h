
require 'benchmark'

require 'yaml'
require 'base64'

require 'rubygems'

require 'json' ; puts 'json'
#require 'json/pure' ; puts 'json_pure'
#require 'active_support'; puts 'ar json'
#require 'yajl'; require 'yajl/json_gem'; puts 'yajl-ruby'

$:.unshift File.dirname(__FILE__) + '/../lib'
require 'rufus/h'

o = [
  { :a => 1, 'b' => [ 2, 3 ], 1 => :c, 4 => { 'a' => 'a', 'b' => :b } },
  1,
  'nada',
  3
]
#o = { 'name' => '平家', 'age' => 18, 'occupation' => 'guard' }

y = YAML.dump(o)
m = Marshal.dump(o)
j = o.to_json
h = Rufus::H.to_h(o)
hj = h.to_json
mb = Base64.encode64(m)

p [ :yaml, y.size ]
p [ :marshal, m.size ]
p [ :m_b64, mb.size ]
p [ :json, j.size ]
p [ :rh_j, hj.size ]
puts j
puts h.inspect
puts hj

puts

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

  b.report('Marshal dump b64') do
    5000.times { Base64.encode64(Marshal.dump(o)) }
  end
  b.report('Marshal load b64') do
    5000.times { Marshal.load(Base64.decode64(mb)) }
  end

  puts

  b.report('JSON dump') do
    5000.times { o.to_json }
  end
  b.report('JSON load') do
    if defined?(JSON)
      5000.times { JSON.parse(j) }
    elsif defined?(Yajl)
      5000.times { Yajl::Parser.parse(j) }
    else
      5000.times { ActiveSupport::JSON.decode(j) }
    end
  end

  puts

  b.report('r_h dump') do
    5000.times { Rufus::H.to_h(o) }
  end
  b.report('r_h load') do
    5000.times { Rufus::H.from_h(h) }
  end

  puts

  b.report('r_h inspect') do
    5000.times { Rufus::H.to_h(o).inspect }
  end

  puts

  b.report('r_h + json dump') do
    5000.times { Rufus::H.to_h(o).to_json }
  end
  b.report('r_h + json load') do
    if defined?(JSON)
      5000.times { Rufus::H.from_h(JSON.parse(j)) }
    elsif defined?(Yajl)
      5000.times { Rufus::H.from_h(Yajl::Parser.parse(j)) }
    else
      5000.times { Rufus::H.from_h(ActiveSupport::JSON.decode(hj)) }
    end
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

