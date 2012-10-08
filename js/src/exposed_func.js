// ===========================================================================
// EXPOSED GOOGLE DOCS FUNCTIONS
// ===========================================================================

/**
 * Get information from xml or xml. By using a function and a proxy we can
 * break Google Doc's limit of 50 ImportXML fomulas in a single sheet. 
 * 
 * @param  {string|array} urls    URL you want to scrape
 * @param  {string}       xpath   XPath to use
 * 
 * @return {string|array} Returns a string or an array of strings containing
 *                        the results of the XPath query
 */
function importXml2(urls, xpath) {
  return GdocHelper.fetch('/v1/importxml2', {
    "url" : GdocHelper.encodedStringify(urls),
    "xpath" : xpath
  });
}

/**
 * Returns the server response code for one or more URLs
 * 
 * @param  {string|array} urls URL(s) you want to get response codes for
 * 
 * @return {string|array} Returns the response codes or response code chains
 */
function serverResponse(urls) {
  return GdocHelper.fetch('/v1/response-code', {
    "url" : GdocHelper.encodedStringify(urls),
  });
}
