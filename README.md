# Steriods for Spreadsheets

A pill bottle of custom functions created by <a href="http://www.chrisle.me">Chris Le</a> for Google Docs and Excel <i>(coming soon)</i>.

This is an active project, so if you run into issues, tweet me <a href="https://twitter.com/iamchrisle">@iamchrisle</a>.

## Examples

    // Get all the links from http://www.example.com
    =ImportXml2("http://www.example.com", "//a/[@href]")

    // Get all the links from http://www.example.com ... and deduplicate them automatically! Nice!
    =ImportXml2("http://www.example.com", "//a/[@href]", "deduplicate")

    // Go ahead... put as many as you want on the spreadsheet!
    =ImportXml2(A1, "//a/[@href]")
    =ImportXml2(A2, "//a/[@href]")
    =ImportXml2(A3, "//a/[@href]")
    .....
    =ImportXml2(A75, "//a/[@href]")
    =ImportXml2(A76, "//a/[@href]")
    =ImportXml2(A77, "//a/[@href]")

    // Check http://www.sitedoesntexist.com for 404s
    =ServerResponse("http://www.sitedoesntexist.com")

    // Check to see if http://www.thisRedirects.com 301 or 302 redirects
    =ServerResponse("http://www.thisRedirects.com")

## Current Features

* <b>ImportXml2</b>: Same as ImportXML but without the 50 ImportXML's limit and a couple of extra bonuses.
* <b>ServerResponse</b>: Returns a URL's redirect chain of responses.

-----------------------------------------------------------------------------
