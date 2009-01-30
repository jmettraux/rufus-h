
#
# Specifying rufus-h
#
# Fri Jan 30 13:48:23 JST 2009
#

require File.dirname(__FILE__) + '/spec_base'

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
      [ '_123456789_123456789_123', '_123456789_123456789_123' ]
    ).should.equal(
      [{"_RH_S"=>"_123456789_123456789_", "_RH_I"=>0}, "_RH_0"]
    )
  end

end

