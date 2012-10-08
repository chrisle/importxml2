require 'spec_helper'
require 'mechanize'
require 'json'

describe 'gdocs_helper' do
  use_vcr_cassette

  before do
    @agent = Mechanize.new
  end

  it 'should say hello' do
    page = @agent.get 'http://localhost:9393/'
    data = JSON.parse(page.body)
    data['response'].should be_an(Array)
    data['response'].first.should be_an(String)
  end

  describe 'importxml2' do
    before do
      page = @agent.post('http://localhost:9393/v1/importxml2', {
        'url'   => 'http://www.seerinteractive.com',
        'xpath' => '//a/@href'
      })
      @data = JSON.parse(page.body)
    end

    it 'response should return a hash' do
      @data['response'].should be_a(Hash)
    end

    it 'response should have a url count' do
      @data['response']['count'].should > 0
    end

    it 'response should have an array' do
      @data['response']['content'].should be_an(Array)
    end
  end

  describe 'redirect-chain' do
    before do
      page = @agent.post('http://localhost:9393/v1/redirect-chain', {
        'url'   => 'http://www.seerinteractive.com'
      })
      @data = JSON.parse(page.body)
    end

    it 'response should return a hash' do
      @data['response'].should be_a(Hash)
    end

    it 'response should have a url count' do
      @data['response']['count'].should > 0
    end

    it 'response should have an array' do
      @data['response']['content'].should be_an(Array)
    end
  end    

end
