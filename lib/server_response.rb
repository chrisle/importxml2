require 'net/http'

class ServerResponse

  FAKE_404 = /(404|not found|cannot be found)/i

  # Returns the response codes of a given URL.
  #
  # If we get a redirect chain (like 301 to 301 to 301...) then you will get
  # an array.  The first element will be the response code, the second will
  # be the URL.
  #
  # If the server responds with a 200 server code but contains the word
  # "cannot be found" or "not found" or "404" on the page then it will report
  # that as a possible fake 404.
  #
  # === Attributes
  #
  # * +url+ - URl to get the response code for
  #
  # === Example
  #
  #   # Returns a 200
  #   ServerResponse.new("http://www.yahoo.com").detect
  #
  #   # Returns the first 301 redirect
  #   ServerResponse.new('http://localhost:9393/301').detect
  #   # => ["301", "http://localhost:9393/after-redirect"]
  #
  def initialize(url)
    @url = url
    @follow_redirect = false
    max_redirects(5)
    @retval = Array.new
  end

  # Sets the maximum number of redirects before giving up.
  def max_redirects(times)
    @redirects = times
  end

  # Returns an array of response codes for Google Docs. If an error occurrs
  # then you'll get ??? with some explanation.
  #
  # == Example
  #   r = RedirectChain.new("http://www.example.com")
  #   r.detect  # => ["301", "http://www.example.com/somewhere", "200"]
  #
  # Detects
  def detect_chain
    @follow_redirect = true
    detect
  end

  # Returns an array of response codes for Google Docs. If an error occurrs
  # then you'll get ??? with some explanation.
  #
  # == Example
  #   r = RedirectChain.new("http://www.example.com")
  #   r.detect  # => ["301", "http://www.example.com/somewhere", "200"]
  #
  def detect
    get
    handle_response_code
    return @retval
  rescue Errno::ECONNREFUSED
    return ["??? Cannot connect to #{@url}"]
  rescue Exception => e
    return ["??? Error: #{e.message}"]
  end

  # Get response from a URL. It only handles GET requests for now.
  def get
    @response = Net::HTTP.get_response(URI(@url))
  end

  # Handles response codes
  def handle_response_code
    if (@response.code.to_i == 301) || (@response.code.to_i == 302)
      handle_redirect
    else
      if @follow_redirect
        @retval << response_code
      else
        @retval = [response_code]
      end
    end
    @retval
  end

  # Follows redirects up to the allowed maxiumum if @follow_redirect is true.
  def handle_redirect
    location = @response.header['Location']
    if @follow_redirect
      @retval << response_code
      @retval << location
      @url = location
      @redirects -= 1
      if @redirects > 0
        detect_chain
      else
        @retval << "Max redirects allowed."
      end
    else
      @retval = [response_code, location]
    end
  end

  # Returns the response code as a string. Appends "Possible fake 404" if
  # we detect it might be a possbile fake 404
  def response_code
    if @response.code.to_i != 404 && is_fake_404?
      return "#{@response.code.to_s} Possible fake 404"
    else
      return @response.code.to_s
    end
  end

  # Looks at the body for the regular expression FAKE_404
  def is_fake_404?
    matches = @response.body.match(FAKE_404)
    !matches.nil?
  end

end
