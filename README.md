# MARC2Map
an xslt that converts the cartographic data tag from a [MARC21 bibliographic record](http://www.loc.gov/marc/marcdocz.html) into a GeoRSS tag

This xslt will take the [034 tag](http://www.loc.gov/marc/bibliographic/bd034.html) in a MARC21 record that might be used in a library catalogue system and transforms it into a georss tag that can be displayed in most web map tools. The conversion should cope with any coordinate formats allowed by the 034 standard and handles points, polygons and bounding boxes.

To run the xslt, you need a tool such as [xsltproc](https://en.wikipedia.org/wiki/Xsltproc) compiled for your platform. Many operating systems have it as part of their standard distribution.

If xsltproc is available, you can test the xslt with the following command

`xsltproc MARC21slim2GeoRSS.xsl tests/sample-record.xml > out.xml`

You can compare the output with that found in `tests/test-output.xml`