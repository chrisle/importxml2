require 'domainatrix'

class String

  # Converts string to an array
  #
  # === Example
  #
  #   "hello world".to_a  # => ["hello world"]
  def to_a
    [self]
  end

  # Normalizes domain names. Returns false if the string is not a domain name.
  #
  # === Example
  #
  #   "http://www.example.com".normalize_domain  # => "www.example.com"
  #
  def normalize_domain
    raise "String #{self} is not a domain" if self.match(/([\w]+\.)?.+\..+/).nil?
    self.downcase!                    # Make everything lower case
    self.gsub!(',','.')               # Change commas to periods (fix typos)
    self.gsub!(/https?:\/\//, '')     # Remove http(s)?
    self.gsub!(/ .+$/, '')            # Remove whitespace then anything
    self.gsub!(/\W$/, '')             # Remove non-words at end of the string
    self.gsub!(/\/.*$/, '')           # Remove paths
    self
  end

  # Returns true if the string is a root domain
  #
  # === Example
  #
  #   "www.example.com".is_a_root_domain?   # => false
  #   "example.com".is_a_root_domain?       # => true
  #   "example.co.uk".is_a_root_domain?     # => true
  #
  def is_a_root_domain?
    (self == self.root_domain)
  end

  # Returns the root domain of a URL.
  #
  # === Example
  #
  #   "http://www.example.com/path/page.html".root_domain
  #   # => "example.com"
  #
  def root_domain
    url = url_parse(self)
    url.domain + "." + url.public_suffix
  end

  # Returns the domain without subdomain or the TLD.
  #
  # === Example
  #
  #   "http://www.example.com/path/page.html".root_domain
  #   # => "example"
  #
  def root_name
    url_parse(self).domain
  end

  # Returns the host of the URL.
  #
  # === Example
  #
  #   "http://www.example.com/path/page.html".root_domain
  #   # => "www.example.com"
  #
  def host_domain
    url = url_parse(self)
    url.host
  end

  # Returns true if the URL is valid
  #
  # ==== Example
  #
  #   "http://www.example.com".valid_url?   # => true
  #   "http://example.com".valid_url?       # => true
  #   "example.com".valid_url?              # => false
  #   "http://Awards".valid_url?            # => false
  #
  def valid_url?
    # http://www.igvita.com/2006/09/07/validating-url-in-ruby-on-rails/
    valid = self.match(/(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix)
    valid.present?
  end

private

  def url_parse(url)
    url.downcase!
    unless url.match(/^https?:\/\//).present?
      url = "http://" + url
    end
    url = Domainatrix.parse(url)
  rescue Exception => e
    raise "Could not parse URL #{url}! #{e.message}"
  end

end
