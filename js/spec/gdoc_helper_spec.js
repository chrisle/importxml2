
var UrlFetchApp = {
  fetch: function(a,b) { return {
    getContentText: function() { 
      return '{"response": { "content": "hello world" }}';
    }
  };}
};

eval(require('fs').readFileSync(__dirname + '/../dist/gdoc_helper.js') + '');

describe ('GdocHelper', function() {

  // == GdocHelper
  it ('GdocHelper should be defined', function() {
    expect(GdocHelper).toBeTruthy();
  });

  // == GdocHelper.fetch
  it('GdocHelper.fetch should be defined', function() {
    expect(GdocHelper.fetch).toBeTruthy();
  });

  // == GdocHelper.encodedStringify
  it('GdocHelper.encodedStringify should be defined', function() {
    expect(GdocHelper.encodedStringify).toBeTruthy();
  });

  // ------------------------------------------------------------------------
  describe ('exposed Gdoc functions', function() {

    // == importXml2
    it('importXml2 should be defined', function() {
      expect(importXml2).toBeTruthy();
    });
    describe ('importXml2', function() {
      spyOn(GdocHelper, 'fetch').andReturn('ok');
      it('importXml2 should fetch', function() {
        var response = importXml2('http://www.example.com', '//a/@href');
        expect(response).toEqual("hello world");
      });
    });

    // == serverResponse
    // TODO Hey, you! Lazy shit! Fix dis!!

  });
});

