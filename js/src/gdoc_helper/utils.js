
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
