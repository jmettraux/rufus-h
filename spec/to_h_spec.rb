# encoding: utf-8

#
# Specifying rufus-h
#
# Fri Jan 30 13:48:23 JST 2009
#

require File.dirname(__FILE__) + '/spec_base'

class Car
  def initialize
    @brand = 'bentley'
    @location = '松島'
    @owner = nil
  end
end

puts

describe 'to_h()' do

  #before do
  #end

  it 'should not touch Fixnum instances' do

    Rufus::H.to_h(-1).should.equal(-1)
    Rufus::H.to_h(0).should.equal(0)
    Rufus::H.to_h(1).should.equal(1)
    Rufus::H.to_h(0.0).should.equal(0.0)
    Rufus::H.to_h(1e10).should.equal(1e10)
  end

  it 'should not touch Boolean instances' do

    Rufus::H.to_h(true).should.equal(true)
    Rufus::H.to_h(false).should.equal(false)
  end

  it 'should turn Symbol instances into a hash' do

    Rufus::H.to_h(:s).should.equal({"_RH_:"=>"s"})
  end

  it 'should not touch short strings' do

    Rufus::H.to_h('car').should.equal('car')

    Rufus::H.to_h(
      '_123456789_123456789_12'
    ).should.equal(
      '_123456789_123456789_12'
    )
  end

  it 'should turn long strings into hashes' do

    Rufus::H.to_h(
      '_123456789_123456789_123'
    ).should.equal(
      {"_RH_S"=>"_123456789_123456789_123"}
    )
  end

  it 'should not duplicate long strings' do

    Rufus::H.to_h(
      ['_123456789_123456789_123','_123456789_123456789_123']
    ).should.equal(
      [{"_RH_S"=>"_123456789_123456789_123","_RH_I"=>0},"_RH_0"]
    )
  end

  it 'should not touch arrays' do

    Rufus::H.to_h([]).should.equal([])
    Rufus::H.to_h([ 1, 2 ]).should.equal([ 1, 2 ])
  end

  it 'should not touch hashes' do

    Rufus::H.to_h({}).should.equal({})
    Rufus::H.to_h({ 'a' => 'b' }).should.equal({ 'a' => 'b' })
  end

  it 'should be ok with non-string hash keys' do

    Rufus::H.to_h(
      { 0 => 1 }
    ).should.equal(
      {"_RH_K"=>{"0"=>0}, "_RH_K0"=>1}
    )

    Rufus::H.to_h(
      { 'a' => 'b', 0 => 1 }
    ).should.equal(
      {"_RH_K"=>{"0"=>0}, "a"=>"b", "_RH_K0"=>1}
    )
  end

  it 'should not duplicate objects' do

    a = [ 1, 2, 3 ]
    h = { 'a' => 0, 'b' => 1 }

    Rufus::H.to_h(
      [ a, a ]
    ).should.equal(
      [[{"_RH_I"=>0}, 1, 2, 3], "_RH_0"]
    )

    Rufus::H.to_h(
      [ h, h ]
    ).should.equal(
      [{"a"=>0, "b"=>1, "_RH_I"=>0}, "_RH_0"]
    )
  end

  it 'should encode instances' do

    Rufus::H.to_h(
      Car.new
    ).should.equal(
      {"brand"=>"bentley", "_RH_K"=>"Car", "owner"=>nil, "location"=>"\346\235\276\345\263\266"}
    )
  end

  it 'should not encode classes' do

    lambda {
      Rufus::H.to_h(Car)
    }.should.raise(ArgumentError)
  end

  it "should not encode :except'ed instance vars" do

    Rufus::H.to_h(
      Car.new,
      :except => 'location'
    ).should.equal(
      {"brand"=>"bentley", "_RH_K"=>"Car", "owner"=>nil}
    )

    Rufus::H.to_h(
      Car.new,
      :except => [ 'location', :owner ]
    ).should.equal(
      {"brand"=>"bentley", "_RH_K"=>"Car"}
    )
  end

  it 'should :only encode some instance vars' do

    Rufus::H.to_h(
      Car.new,
      :only => :brand
    ).should.equal(
      {"brand"=>"bentley", "_RH_K"=>"Car"}
    )
  end

end

