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
