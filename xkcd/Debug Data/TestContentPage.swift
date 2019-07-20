//
//  TestContentPage.swift
//  xkcd
//
//  Created by James Froggatt on 12.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Foundation

#if DEBUG
let testContentPage = """
<html><head>
<link rel="stylesheet" type="text/css" href="/s/b0dcca.css" title="Default">
<title>xkcd: Lunar Cycles</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="shortcut icon" href="/s/919f27.ico" type="image/x-icon">
<link rel="icon" href="/s/919f27.ico" type="image/x-icon">
<link rel="alternate" type="application/atom+xml" title="Atom 1.0" href="/atom.xml">
<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="/rss.xml">
<script type="text/javascript" src="/s/b66ed7.js" async=""></script>
<script type="text/javascript" src="/s/1b9456.js" async=""></script>

<meta property="og:site_name" content="xkcd">

<meta property="og:title" content="Lunar Cycles">
<meta property="og:url" content="https://xkcd.com/2172/">
<meta property="og:image" content="https://imgs.xkcd.com/comics/lunar_cycles_2x.png">
<meta name="twitter:card" content="summary_large_image">

</head>
<body>
<div id="topContainer">
<div id="topLeft">
<ul>
<li><a href="/archive">Archive</a></li>
<li><a href="http://what-if.xkcd.com">What If?</a></li>
<li><a href="http://blag.xkcd.com">Blag</a></li>
<li><a href="/how-to/">How To</a></li>
<li><a href="http://store.xkcd.com/">Store</a></li>
<li><a rel="author" href="/about">About</a></li>
<li><a href="/atom.xml">Feed</a> • <a href="/newsletter/">Email</a></li>
</ul>
</div>
<div id="topRight">
<div id="masthead">
<span><a href="/"><img src="/s/0b7742.png" alt="xkcd.com logo" height="83" width="185"></a></span>
<span id="slogan">A webcomic of romance,<br> sarcasm, math, and language.</span>
</div>
<div id="news">
<div id="htNews"><a href="https://www.southbankcentre.co.uk/whats-on/135680-randall-munroe-how-2019"><img border="0" src="//imgs.xkcd.com/static/uk_tour.png"></a><br>I'll be in the UK for a How To book tour in October, with an<br>event in London at the Royal Festival Hall on Monday, Oct 7th.<br>Tickets are available <a href="https://www.southbankcentre.co.uk/whats-on/135680-randall-munroe-how-2019">here</a>. More UK tour dates coming soon!</div>
<script>
var client = new XMLHttpRequest();
client.open("GET", "//c.xkcd.com/how-to/news", true);
client.send();
client.onreadystatechange = function() {
if(client.readyState == 4 && client.status == 200) {
document.getElementById("htNews").innerHTML = client.responseText;
}
}
</script>

</div>
</div>
<div id="bgLeft" class="bg box"></div>
<div id="bgRight" class="bg box"></div>
</div>
<div id="middleContainer" class="box">

<div id="ctitle">Lunar Cycles</div>
<ul class="comicNav">
<li><a href="/1/">|&lt;</a></li>
<li><a rel="prev" href="/2171/" accesskey="p">&lt; Prev</a></li>
<li><a href="//c.xkcd.com/random/comic/">Random</a></li>
<li><a rel="next" href="/2173/" accesskey="n">Next &gt;</a></li>
<li><a href="/">&gt;|</a></li>
</ul>
<div id="comic">
<img src="//imgs.xkcd.com/comics/lunar_cycles.png" title="The Antikythera mechanism had a whole set of gears specifically to track the cyclic popularity of skinny jeans and low-rise waists." alt="Lunar Cycles" srcset="//imgs.xkcd.com/comics/lunar_cycles_2x.png 2x">
</div>
<ul class="comicNav">
<li><a href="/1/">|&lt;</a></li>
<li><a rel="prev" href="/2171/" accesskey="p">&lt; Prev</a></li>
<li><a href="//c.xkcd.com/random/comic/">Random</a></li>
<li><a rel="next" href="/2173/" accesskey="n">Next &gt;</a></li>
<li><a href="/">&gt;|</a></li>
</ul>
<br>
Permanent link to this comic: https://xkcd.com/2172/<br>
Image URL (for hotlinking/embedding): https://imgs.xkcd.com/comics/lunar_cycles.png
<div id="transcript" style="display: none"></div>
</div>
<div id="bottom" class="box">
<img src="//imgs.xkcd.com/s/a899e84.jpg" width="520" height="100" alt="Selected Comics" usemap="#comicmap">
<map id="comicmap" name="comicmap">
<area shape="rect" coords="0,0,100,100" href="/150/" alt="Grownups">
<area shape="rect" coords="104,0,204,100" href="/730/" alt="Circuit Diagram">
<area shape="rect" coords="208,0,308,100" href="/162/" alt="Angular Momentum">
<area shape="rect" coords="312,0,412,100" href="/688/" alt="Self-Description">
<area shape="rect" coords="416,0,520,100" href="/556/" alt="Alternative Energy Revolution">
</map>
<br>
<a href="//xkcd.com/1732/"><img border="0" src="//imgs.xkcd.com/s/temperature.png" width="520" height="100" alt="Earth temperature timeline"></a>
<br>
<div>
<!--
Search comic titles and transcripts:
<script type="text/javascript" src="//www.google.com/jsapi"></script>
<script type="text/javascript">google.load('search', '1');google.setOnLoadCallback(function() {google.search.CustomSearchControl.attachAutoCompletion('012652707207066138651:zudjtuwe28q',document.getElementById('q'),'cse-search-box');});</script>
<form action="//www.google.com/cse" id="cse-search-box">
<div>
<input type="hidden" name="cx" value="012652707207066138651:zudjtuwe28q"/>
<input type="hidden" name="ie" value="UTF-8"/>
<input type="text" name="q" id="q" size="31"/>
<input type="submit" name="sa" value="Search"/>
</div>
</form>
<script type="text/javascript" src="//www.google.com/cse/brand?form=cse-search-box&amp;lang=en"></script>
-->
<a href="/rss.xml">RSS Feed</a> - <a href="/atom.xml">Atom Feed</a> - <a href="/newsletter/">Email</a>
</div>
<br>
<div id="comicLinks">
Comics I enjoy:<br>
<a href="http://threewordphrase.com/">Three Word Phrase</a>,
<a href="http://www.smbc-comics.com/">SMBC</a>,
<a href="http://www.qwantz.com">Dinosaur Comics</a>,
<a href="http://oglaf.com/">Oglaf</a> (nsfw),
<a href="http://www.asofterworld.com">A Softer World</a>,
<a href="http://buttersafe.com/">Buttersafe</a>,
<a href="http://pbfcomics.com/">Perry Bible Fellowship</a>,
<a href="http://questionablecontent.net/">Questionable Content</a>,
<a href="http://www.buttercupfestival.com/">Buttercup Festival</a>,
<a href="http://www.mspaintadventures.com/?s=6&amp;p=001901">Homestuck</a>,
<a href="http://www.jspowerhour.com/">Junior Scientist Power Hour</a>
</div>
<br>
<div id="comicLinks">
Other things:<br>
<a href="https://medium.com/civic-tech-thoughts-from-joshdata/so-you-want-to-reform-democracy-7f3b1ef10597">Tips on technology and government</a>,<br>
<a href="https://www.nytimes.com/interactive/2017/climate/what-is-climate-change.html">Climate FAQ</a>,
<a href="https://twitter.com/KHayhoe">Katharine Hayhoe</a>
</div>
<br>
<center>
<div id="footnote" style="width:70%">xkcd.com is best viewed with Netscape Navigator 4.0 or below on a Pentium 3±1 emulated in Javascript on an Apple IIGS<br>at a screen resolution of 1024x1. Please enable your ad blockers, disable high-heat drying, and remove your device<br>from Airplane Mode and set it to Boat Mode. For security reasons, please leave caps lock on while browsing.</div>
</center>
<div id="licenseText">
<p>
This work is licensed under a
<a href="http://creativecommons.org/licenses/by-nc/2.5/">Creative Commons Attribution-NonCommercial 2.5 License</a>.
</p><p>
This means you're free to copy and share these comics (but not to sell them). <a rel="license" href="/license.html">More details</a>.</p>
</div>
</div>

<!-- Layout by Ian Clasbey, davean, and chromakode -->


</body></html>
"""
#endif

