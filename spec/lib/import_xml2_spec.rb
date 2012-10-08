require 'spec_helper'
require './lib/import_xml2'

describe 'ImportXml2' do
  # use_vcr_cassette

  it 'should default to returning links' do
    response = ImportXml2.new('http%3A%2F%2Fwww.seerinteractive.com', '%2F%2Fa%5B%40href%5D').get
    response.should be_an(Array)
  end

  it 'should return anchor text of links' do
    response = ImportXml2.new('http://www.seerinteractive.com', '//a[@href]').get
    response.should be_an(Array)
  end

  it 'should return anchor text of links with an empty xpath' do
    response = ImportXml2.new('http://www.seerinteractive.com', '').get
    response.should be_an(Array)
  end

  it 'should return an exception error in content' do
    response = ImportXml2.new('www.seerinteractive.com', '//a[@href]').get
    response.first.should == "Error: (www.seerinteractive.com) did not contain http or https."
  end

  it 'should work with arrays as a row' do
    response = ImportXml2.new('["http://www.seerinteractive.com", "http://www.seerinteractive.com/blog"]', '//a/@href').get
    response.first.should be_a(Array)
  end

  it 'should work with arrays as a column' do
    response = ImportXml2.new(
      '[["http://www.seerinteractive.com"], ["http://www.seerinteractive.com/blog"]]',
      '//a/@href').get
    # puts response.inspect
    response.first.should be_an(Array)
  end

  it 'should deduplicate results' do
    response = ImportXml2.new('http://www.seerinteractive.com', '//a[@href]', {
      :deduplicate => true
    }).get
    response.should be_an(Array)
  end

end
