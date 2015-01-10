<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:georss="http://www.georss.org/georss"     xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
  <xsl:import href="MARC21slimUtils.xsl"/>
  <xsl:output method="xml" indent="yes"/>  
  <xsl:template match="/">
      <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="marc:record">
    <xsl:variable name="leader" select="marc:leader"/>
    <xsl:variable name="leader6" select="substring($leader,7,1)"/>
    <xsl:variable name="leader7" select="substring($leader,8,1)"/>
    <xsl:variable name="controlField008" select="marc:controlfield[@tag=008]"/>

    <item>
      <xsl:for-each select="marc:datafield[@tag=245]">
        <title>
          <xsl:call-template name="subfieldSelect">
            <xsl:with-param name="codes">abfghk</xsl:with-param>
          </xsl:call-template>
        </title>
      </xsl:for-each>

  
      <xsl:for-each select="marc:datafield[@tag=100]">
        <author>
          <xsl:value-of select="."/>
        </author>
      </xsl:for-each>

      <xsl:for-each select="marc:datafield[@tag=110]|marc:datafield[@tag=111]|marc:datafield[@tag=700]|marc:datafield[@tag=710]|marc:datafield[@tag=711]|marc:datafield[@tag=720]">
        <dc:creator>
          <xsl:value-of select="."/>
        </dc:creator>
      </xsl:for-each>

      <dc:type>   
        <xsl:if test="$leader7='c'">
        <xsl:text>collection</xsl:text>
      </xsl:if>

        <xsl:if test="$leader6='d' or $leader6='f' or $leader6='p' or $leader6='t'">
          <xsl:text>manuscript</xsl:text>
        </xsl:if>

        <xsl:choose>
          <xsl:when test="$leader6='a' or $leader6='t'">text</xsl:when>
          <xsl:when test="$leader6='e' or $leader6='f'">cartographic</xsl:when>
          <xsl:when test="$leader6='c' or $leader6='d'">notated music</xsl:when>
          <xsl:when test="$leader6='i' or $leader6='j'">sound recording</xsl:when>
          <xsl:when test="$leader6='k'">still image</xsl:when>
          <xsl:when test="$leader6='g'">moving image</xsl:when>
          <xsl:when test="$leader6='r'">three dimensional object</xsl:when>
          <xsl:when test="$leader6='m'">software, multimedia</xsl:when>
          <xsl:when test="$leader6='p'">mixed material</xsl:when>
        </xsl:choose>
      </dc:type>
      <!--GeoRSS-->
      <xsl:for-each select="marc:datafield[@tag=034]">
        <!-- g - Coordinates - southernmost latitude (NR) -->
        <xsl:variable name="miny" select="marc:subfield[@code='g']"/>
        <!-- d - Coordinates - westernmost longitude (NR) -->
        <xsl:variable name="minx" select="marc:subfield[@code='d']"/>
        <!-- f - Coordinates - northernmost latitude (NR) -->
        <xsl:variable name="maxy" select="marc:subfield[@code='f']"/>
        <!-- e - Coordinates - easternmost longitude (NR) -->
        <xsl:variable name="maxx" select="marc:subfield[@code='e']"/>
        
        <xsl:if test="$miny and $minx and $maxy and $maxx">
          <!-- if we have a bbox, return geo:polygon, otherwise geo:point -->
          <!-- N.B. google does not support geo:box -->
          <xsl:choose>
            <xsl:when test="($miny = $maxy) and ($minx = $maxx)">
              <georss:point>
                <xsl:call-template name="decimal_degrees">
                  <xsl:with-param name="value" select="$miny"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>            
                <xsl:call-template name="decimal_degrees">
                  <xsl:with-param name="value" select="$minx"/>
                </xsl:call-template>
              </georss:point>
            </xsl:when>
            <xsl:otherwise>
              <georss:polygon>
                <xsl:call-template name="decimal_degrees">
                  <xsl:with-param name="value" select="$miny"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>            
                <xsl:call-template name="decimal_degrees">
                  <xsl:with-param name="value" select="$minx"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>            
                <xsl:call-template name="decimal_degrees">
                  <xsl:with-param name="value" select="$maxy"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>            
                <xsl:call-template name="decimal_degrees">
                  <xsl:with-param name="value" select="$minx"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>            
                <xsl:call-template name="decimal_degrees">
                  <xsl:with-param name="value" select="$maxy"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>            
                <xsl:call-template name="decimal_degrees">
                  <xsl:with-param name="value" select="$maxx"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>            
                <xsl:call-template name="decimal_degrees">
                  <xsl:with-param name="value" select="$miny"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>            
                <xsl:call-template name="decimal_degrees">
                  <xsl:with-param name="value" select="$maxx"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>            
                <xsl:call-template name="decimal_degrees">
                  <xsl:with-param name="value" select="$miny"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>            
                <xsl:call-template name="decimal_degrees">
                  <xsl:with-param name="value" select="$minx"/>
                </xsl:call-template>
              </georss:polygon>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
      <!-- end GeoRSS -->
      <xsl:for-each select="marc:datafield[@tag=655]">
        <category>
          <xsl:value-of select="."/>
        </category>
      </xsl:for-each>

      <xsl:for-each select="marc:datafield[@tag=260]">
        <dc:publisher>
          <xsl:call-template name="subfieldSelect">
            <xsl:with-param name="codes">ab</xsl:with-param>
          </xsl:call-template>
        </dc:publisher>
      </xsl:for-each>

      <!-- this is supposed to be RFC-822 compliant -->
      <xsl:for-each select="marc:datafield[@tag=260]/marc:subfield[@code='c']">
        <pubDate>
          <xsl:value-of select="."/>
        </pubDate>        
      </xsl:for-each>
      
      <xsl:for-each select="marc:datafield[@tag=856]/marc:subfield[@code='q']">
        <dc:format>
          <xsl:value-of select="."/>
        </dc:format>
      </xsl:for-each>

      <!-- specification only allows one description element per item -->
      <description>
        <xsl:for-each select="marc:datafield[500&lt;=@tag][@tag&lt;=599][not(@tag=506 or @tag=530 or @tag=540 or @tag=546)]">
            <xsl:value-of select="marc:subfield[@code='a']"/>
            <xsl:text> </xsl:text>
        </xsl:for-each>
      </description>

      <xsl:for-each select="marc:datafield[@tag=600]">
        <dc:subject>
          <xsl:call-template name="subfieldSelect">
            <xsl:with-param name="codes">abcdq</xsl:with-param>
          </xsl:call-template>
        </dc:subject>
      </xsl:for-each>

      <xsl:for-each select="marc:datafield[@tag=610]">
        <dc:subject>
          <xsl:call-template name="subfieldSelect">
            <xsl:with-param name="codes">abcdq</xsl:with-param>
          </xsl:call-template>
        </dc:subject>
      </xsl:for-each>

      <xsl:for-each select="marc:datafield[@tag=611]">
        <dc:subject>
          <xsl:call-template name="subfieldSelect">
            <xsl:with-param name="codes">abcdq</xsl:with-param>
          </xsl:call-template>
        </dc:subject>
      </xsl:for-each>
    
      <xsl:for-each select="marc:datafield[@tag=630]">
        <dc:subject>
          <xsl:call-template name="subfieldSelect">
            <xsl:with-param name="codes">abcdq</xsl:with-param>
          </xsl:call-template>
        </dc:subject>
      </xsl:for-each>

      <xsl:for-each select="marc:datafield[@tag=650]">
        <dc:subject>
          <xsl:call-template name="subfieldSelect">
            <xsl:with-param name="codes">abcdq</xsl:with-param>
          </xsl:call-template>
        </dc:subject>
      </xsl:for-each>

      <xsl:for-each select="marc:datafield[@tag=653]">
        <dc:subject>
          <xsl:call-template name="subfieldSelect">
            <xsl:with-param name="codes">abcdq</xsl:with-param>
          </xsl:call-template>
        </dc:subject>
      </xsl:for-each>

      <xsl:for-each select="marc:datafield[@tag=752]">
        <dc:coverage>
          <xsl:call-template name="subfieldSelect">
            <xsl:with-param name="codes">abcd</xsl:with-param>
          </xsl:call-template>
        </dc:coverage>
      </xsl:for-each>

      <xsl:for-each select="marc:datafield[@tag=530]">
        <dc:relation type="original">
          <xsl:call-template name="subfieldSelect">
            <xsl:with-param name="codes">abcdu</xsl:with-param>
          </xsl:call-template>
        </dc:relation>  
      </xsl:for-each>

      <xsl:for-each select="marc:datafield[@tag=760]|marc:datafield[@tag=762]|marc:datafield[@tag=765]|marc:datafield[@tag=767]|marc:datafield[@tag=770]|marc:datafield[@tag=772]|marc:datafield[@tag=773]|marc:datafield[@tag=774]|marc:datafield[@tag=775]|marc:datafield[@tag=776]|marc:datafield[@tag=777]|marc:datafield[@tag=780]|marc:datafield[@tag=785]|marc:datafield[@tag=786]|marc:datafield[@tag=787]">
        <dc:relation>
          <xsl:call-template name="subfieldSelect">
            <xsl:with-param name="codes">ot</xsl:with-param>
          </xsl:call-template>
        </dc:relation>  
      </xsl:for-each>

      <xsl:for-each select="marc:datafield[@tag=856]">
        <dc:identifier>
          <xsl:value-of select="marc:subfield[@code='u']"/>
        </dc:identifier>
      </xsl:for-each>
      
      <xsl:for-each select="marc:datafield[@tag=020]">
      <dc:identifier>
        <xsl:text>URN:ISBN:</xsl:text>
        <xsl:value-of select="marc:subfield[@code='a']"/>
      </dc:identifier>
    </xsl:for-each>

  <!-- link to full record -->
    <xsl:for-each select="marc:datafield[@tag=901]">
        <link>http://catalogue.nrcan.gc.ca/opac/en-CA/skin/nrcan-rncan/xml/rdetail.xml?r=<xsl:value-of select="marc:subfield[@code='c']"/>
        </link>
      </xsl:for-each>
    </item>
  </xsl:template>
  
  <!--GeoRSS-->
  <!-- template for coordinate transform -->
  <!-- supports all http://www.loc.gov/marc/bibliographic/bd034.html formats -->
  <xsl:template name="decimal_degrees">
      <xsl:param name="value"/>
      <xsl:variable name="prefix" select="substring($value, 1,1)"/>
      <!-- determine if there is a prefix and create an offset-->
      <xsl:variable name="offset">
        <xsl:choose>
          <xsl:when test="contains('NSEW+-', $prefix)">1</xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <!-- handle hemisphere prefix -->
      <xsl:if test="$prefix='W' or $prefix='S' or $prefix='-'">
        <xsl:text>-</xsl:text>
      </xsl:if>
      <!-- if input is not fractional, append .0 for later string manipulation -->
      <xsl:variable name="fractional">
        <xsl:choose>
          <xsl:when test="contains($value,'.')"></xsl:when>
          <xsl:otherwise>.0</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="raw_number" select="concat(substring($value, $offset+1), $fractional)"/>
      <!-- get the cleaned dms and fractional parts of the input -->
      <xsl:variable name="whole_number" select="substring-before($raw_number,'.')"/>
      <xsl:variable name="fraction" select="concat('0.',substring-after($raw_number,'.'))"/>
      <!-- get length needed to determine which dms components are present -->
      <xsl:variable name="whole_length" select="string-length($whole_number)"/>
      <!-- if whole number is less than 3 digits, add pre-padding -->
      <xsl:variable name="prepadding">
        <xsl:choose>
          <xsl:when test="$whole_length = 2">0</xsl:when>
          <xsl:when test="$whole_length = 1">00</xsl:when>
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="whole_dms" select="concat($prepadding, $whole_number)"/>
      <!-- get length needed to determine which dms components are present -->
      <xsl:variable name="length" select="string-length($whole_dms)"/>
      <!-- if no minutes or seconds, add padding -->
      <xsl:variable name="padding">
        <xsl:choose>
          <xsl:when test="$length = 3">0000</xsl:when>
          <xsl:when test="$length = 5">00</xsl:when>
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="dms" select="concat($whole_dms, $padding)"/>
      <!-- compute adjustment to fraction based on dms length -->
      <xsl:variable name="fraction_denominator">
        <xsl:choose>
          <xsl:when test="$length = 3">1</xsl:when>
          <xsl:when test="$length = 5">60</xsl:when>
          <xsl:otherwise>3600</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <!-- separate the normalized dms into components -->
      <xsl:variable name="degrees" select="substring($dms, 1, 3)"/>
      <xsl:variable name="minutes" select="substring($dms, 5, 2)"/>
      <xsl:variable name="seconds" select="substring($dms, 7, 2)"/>
      <!-- sum the components and return decimal value -->
      <xsl:value-of select="$degrees + (($minutes * 60 + $seconds) div 3600) + ($fraction div $fraction_denominator)"/>
      <!-- <xsl:value-of select="$whole_degrees"/> -->
  </xsl:template>
  <!-- end GeoRSS -->
</xsl:stylesheet>
