/*
 * GOOGLE DOC HELPER
 * 
 * Copyright (C) 2012 SEER Interactive
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE. 
 *  
 */

var GdocHelper = {};


/**
 * Fetches data from the SEER Gdoc Helper API. The API always uses POST
 * calls. Don't judge me ;)
 * 
 * @param  {string} helperPath Path of the API call
 * @param  {hash} args Hash of arguments to pass to the API
 * @return {string} Returns response or error message
 *
 * @example
 * 
 *    // Returns the version number of the GDocHelper
 *    GdocHelper.fetch('/v1/test', { 'url': 'http://www.example.com' });
 */
GdocHelper.fetch = function(helperPath, payload) {
  var 
    BASE_URL  = "http://fierce-badlands-6509.herokuapp.com",
    url       = BASE_URL + helperPath,
    payload   = payload || {},
    args      = { method: "POST", payload: payload },
    response  = UrlFetchApp.fetch(url, args).getContentText(),
    obj       = JSON.parse(response),
    retval    = "";

  if (obj["error"] != undefined) {
    retval = "Fetch Error: " + obj["error"];
  } else {
    retval = obj["response"]["content"];
  }  
  return retval;
};


/**
 * Returns a URL encoded string. If the object is an Array then it will 
 * stringify the array first.
 * 
 * @param  {object} obj Object to stringify
 *
 * @example
 * 
 *    GdocHelper.encodedStringify('hello world');
 *    // => "hello%20world"
 *    
 *    GdocHelper.encodedStringify(["hello", "world"]);
 *    // => '["hello","world"]';
 */
GdocHelper.encodedStringify = function(obj) {
  if( typeof obj === 'string' ) {
    retval = encodeURIComponent(obj);
  } else {
    retval = encodeURIComponent(JSON.stringify(obj));
  }
  return retval;
};

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
