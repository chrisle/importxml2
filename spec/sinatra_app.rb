# Sinatra Server used to test the GDoc Helper
#
# Usage:
#
#   # First, start the Sinatra server
#   $ bundle exec ruby spec/sinatra_app.rb
#   == Sinatra/1.3.3 has taken the stage on 4567 for development with backup from Thin
#   >> Thin web server (v1.4.1 codename Chromeo)
#   >> Maximum connections set to 1024
#   >> Listening on 0.0.0.0:4567, CTRL+C to stop
#
#   # Next, run your tests. For example, to run the gdoc_helper tests:
#   $ bundle exec rspec spec/gdocs_helper_spec.rb

require 'sinatra'

# GET /404
# - Returns a 404 page
get '/404' do
  status 404
  '404 page!'
end

get '/fake404-1' do
  status 200
  'This is a fake 404 page!'
end
get '/fake404-2' do
  status 200
  'The page cannot be found page!'
end
get '/fake404-3' do
  status 200
  'Page not found!'
end

# GET /301
# GET /302
# - Redirects you to after-redirect with a 301 or 302 response code
get '/301' do
  redirect to('/after-redirect'), 301
end
get '/302' do
  redirect to('/after-redirect'), 302
end
get '/after-redirect' do
  'landing page after redirect'
end

# GET /
# - Returns hello world
get '/' do
  'hello world'
end

# GET /redirect-chain-test
# - A 302 to 404 redirect chain
get '/redirect-chain-test' do
  redirect to('/redirect-chain-test-end')
end
get '/redirect-chain-test-end' do
  status 404
  '302 to 404 chain'
end

# GET /redirect-3-times
# - A chain of three 302 redirects
get '/redirect-3-times' do
  redirect to('/redirect-3-times/1')
end
get '/redirect-3-times/1' do
  redirect to('/redirect-3-times/2')
end
get '/redirect-3-times/2' do
  redirect to('/redirect-3-times/3')
end
get '/redirect-3-times/3' do
  status 404
end
