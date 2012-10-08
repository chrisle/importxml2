#
# Copyright (C) 2012 Seer Interactive
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'sinatra'
require 'json'
Dir['./gdoc_helper/*.rb'].each { |f| require f }
Dir['./lib/*.rb'].each { |f| require f }

# Returns "the GDoc Helper works"
get '/' do
  respond ["The GDoc Helper works!"]
end

post '/v1/importxml2' do
  respond with_content(ImportXml2.new(params[:url], params[:xpath]).get)
end

post '/v1/response-code' do
  respond with_content(ResponseCode.new(params[:url]).detect)
end

# Never, EVER send anything but a 200 response code back to Google Docs.
# The Gdoc function will fail and just put an unhelpful "error" in the cell.
# Instead, send a 200 response, but return the real error message so it shows
# up in the cell.
error do
  respond ["ERROR: Some other error in the API?"]
end
not_found do
  respond ["ERROR: Incorrect path to the API."]
end

#############################################################################

def respond(obj)
  headers \
    'Content-Type'  => 'application/json',
    'Server'        => "SEER_GDOC_HELPER_1.0",
    'X-WTF'         => 'Never gonna give you up, never gonna let you down.'
  body JSON.fast_generate({ :response => obj })
end

def with_content(content)
  { :count => content.count, :content => content }
end

