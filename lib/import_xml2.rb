require 'mechanize'
require 'open-uri'
require 'json'
require './lib/import_xml2/options'

class ImportXml2
  extend Options

  # Emulates Google Doc's ImportXML, but a few differences:
  #
  # === Attributes
  #
  # * +url+ - A JSON string of URLs you want to run through ImportXML.
  # * +xpath+ - The XPath selection query
  # * +options+ - (Optional) Hash of options
  #
  # === Example
  #
  #   # Returns an array of links from www.example.com
  #   ImportXml2.new("http://www.example.com").get
  #
  #   # Return the anchor text of the links from www.example.com
  #   ImportXml2.new("http://www.example.com", "//a/text()").get
  #
  #   # Return the links from www.example.com, deduplicates, and makes all
  #   # the URLS absolute.
  #   ImportXml2.new("http://www.example.com", "//a/@href", {
  #     :deduplicate => true
  #   }).get
  #
  def initialize(url, xpath=nil, options={})
    @url = CGI.unescape(url)
    @xpath = (xpath.nil? || xpath == '') ? '/a/@href' : xpath
    @options = options
  end

  # Returns the results from the query
  def get
    process_query
    process_options unless @options == {}
    return @results

  rescue Exception => e
    # Require there to be http or https for every URL
    if e.message.include?('absolute URL needed')
      return ["Error: (#{@url}) did not contain http or https."]
    else
      return ["Error: #{e.message}"]
    end
  end

private

  # Process the URLs with the XPath query
  def process_query
    @results = str_to_obj.flatten.collect do |url|
      doc = Mechanize.new.get(url)
      els = doc.search(CGI.unescape(@xpath))
      els.map { |el| [el.text] }
    end
    @results = @results.flatten.map { |r| [r] }
  end

  # Process any options given
  def process_options
    @options.each do |option, value|
      if value == true && VALID_OPTIONS.include?(option)
        self.send("option_#{option}")
      end
    end
  end

  # Returns true if the object is actually an array in a column format
  def is_columns?
    (@url.match(/^\[\[/)) ? true : false
  end

  # Returns true if the object is actually an array as a string
  def is_array_str?
    (@url.match(/^\[/)) ? true : false
  end

  # Converts a URL string into an object. Returns an Array.
  def str_to_obj
    if is_array_str?
      url_obj = eval(@url)
    else
      url_obj = [@url]
    end
    url_obj
  end

end
