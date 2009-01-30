
#
# Specifying rufus-h
#
# Fri Jan 30 15:09:39 JST 2009
#

require File.dirname(__FILE__) + '/spec_base'

puts

describe 'from_h()' do

  #before do
  #end

  it 'should not touch Fixnum instances' do

    Rufus::H.from_h(-1).should.equal(-1)
    Rufus::H.from_h(0).should.equal(0)
    Rufus::H.from_h(1).should.equal(1)
    Rufus::H.from_h(0.0).should.equal(0.0)
    Rufus::H.from_h(1e10).should.equal(1e10)
  end

  it 'should not touch Boolean instances' do

    Rufus::H.from_h(true).should.equal(true)
    Rufus::H.from_h(false).should.equal(false)
  end

  it 'should rebuild Symbols' do

    Rufus::H.from_h({"_RH_:"=>"s"}).should.equal(:s)
  end

  it 'should not touch short strings' do

    Rufus::H.from_h('car').should.equal('car')

    Rufus::H.from_h(
      '_123456789_123456789_12'
    ).should.equal(
      '_123456789_123456789_12'
    )
  end

  it 'should rebuild long strings' do

    Rufus::H.from_h(
      {"_RH_S"=>"_123456789_123456789_123"}
    ).should.equal(
      '_123456789_123456789_123'
    )
  end

  it 'should be ok with long strings duplicated' do

    Rufus::H.from_h(
      [{"_RH_S"=>"_123456789_123456789_123","_RH_I"=>0},"_RH_0"]
    ).should.equal(
      ['_123456789_123456789_123','_123456789_123456789_123']
    )
  end

  it 'should not touch arrays' do

    Rufus::H.from_h([]).should.equal([])
    Rufus::H.from_h([ 1, 2 ]).should.equal([ 1, 2 ])
  end

  it 'should not touch hashes' do

    Rufus::H.from_h({}).should.equal({})
    Rufus::H.from_h({ 'a' => 'b' }).should.equal({ 'a' => 'b' })
  end

  it 'should be ok with non-string hash keys' do

    Rufus::H.from_h(
      {"_RH_K"=>{"0"=>0}, "_RH_K0"=>1}
    ).should.equal(
      { 0 => 1 }
    )

    Rufus::H.from_h(
      {"_RH_K"=>{"0"=>0}, "a"=>"b", "_RH_K0"=>1}
    ).should.equal(
      { 'a' => 'b', 0 => 1 }
    )
  end

  it 'should handle object references' do

    r = Rufus::H.from_h(
      [[{"_RH_I"=>0}, 1, 2, 3], "_RH_0"]
    )
    r.first.should.be.same_as(r.last)

    r = Rufus::H.from_h(
      [{"a"=>0, "b"=>1, "_RH_I"=>0}, "_RH_0"]
    )
    r.first.should.be.same_as(r.last)
  end

  class Car
    attr_reader :brand, :location, :owner
    def initialize
      @brand = 'bentley'
      @location = '松島'
      @owner = nil
    end
  end

  it 'should decode instances' do

    car = Rufus::H.from_h(
      {"brand"=>"bentley", "_RH_K"=>"Car", "owner"=>nil, "location"=>"\346\235\276\345\263\266"}
    )
    car.brand.should.equal('bentley')
    car.location.should.equal('松島')
    car.brand.should.be(nil)
  end

end

