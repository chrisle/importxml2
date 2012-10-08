require 'spec_helper'
require './lib/server_response'

describe 'server_response' do
  # use_vcr_cassette

  it 'should detect a 404' do
    r = ServerResponse.new('http://localhost:9393/404').detect
    r.should == ['404']
  end

  it 'should detect a 301' do
    r = ServerResponse.new('http://localhost:9393/301').detect
    r.should == ["301", "http://localhost:9393/after-redirect"]
  end

  it 'should detect a 302' do
    r = ServerResponse.new('http://localhost:9393/302').detect
    r.should == ["302", "http://localhost:9393/after-redirect"]
  end

  it 'should detect a 200' do
    r = ServerResponse.new('http://localhost:9393').detect
    r.should == ['200']
  end

  it 'should detect a 302 to 404 chain' do
    r = ServerResponse.new('http://localhost:9393/redirect-chain-test').detect_chain
    r.should == ["302", "http://localhost:9393/redirect-chain-test-end",
                 "404"]
  end

  it 'should follow a chain of redirects' do
    r = ServerResponse.new('http://localhost:9393/redirect-3-times').detect_chain
    r.should == ["302", "http://localhost:9393/redirect-3-times/1",
                 "302", "http://localhost:9393/redirect-3-times/2",
                 "302", "http://localhost:9393/redirect-3-times/3",
                 "404"]
  end

  it 'should stop following redirects' do
    r = ServerResponse.new('http://localhost:9393/redirect-3-times')
    r.max_redirects 2
    r.detect_chain.should == ["302", "http://localhost:9393/redirect-3-times/1",
                              "302", "http://localhost:9393/redirect-3-times/2",
                              "Max redirects allowed."]
  end

  it 'should detect a possible fake 404 page (with 404)' do
    r = ServerResponse.new('http://localhost:9393/fake404-1').detect
    r.should == ["200 Possible fake 404"]
  end
  it 'should detect a possible fake 404 page (with not found)' do
    r = ServerResponse.new('http://localhost:9393/fake404-2').detect
    r.should == ["200 Possible fake 404"]
  end
  it 'should detect a possible fake 404 page (with cannot be found)' do
    r = ServerResponse.new('http://localhost:9393/fake404-3').detect
    r.should == ["200 Possible fake 404"]
  end


end
