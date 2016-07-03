# TODO

https://www.pandorabots.com/pandora/pics/wallaceaimltutorial.html
http://www.alicebot.org/aiml.html
http://www.alicebot.org/documentation/aiml101.html
https://github.com/raethlein/AIML.js

```
<get name="NAME"/>
<set name="NAME">TEXT</set>
<sr/>
<star/>
<that>TEXT</that>
<condition name="NAME" value="VALUE">TEXT</condition>
<condition><li name="NAME" value="VALUE">TEXT</li><li name="NAME" value="VALUE">TEXT</li><li>TEXT</li></condition>
<condition name="NAME"><li value="VALUE">TEXT</li><li value="VALUE">TEXT</li><li>TEXT</li></condition>

<think><set name="NAME">TEXT</set></think>
<anyElement/><random><li>A</li><li>B</li><li>C</li></random><anyElement/>
<random><li><think><set name="NAME">TEXT</set></think></li><li>B</li></random>
<random><li><srai>PATTERN TEXT</srai></li><li>B</li></random>
<condition name="NAME" value="VALUE"><srai>PATTERN TEXT</srai></condition>
<condition><li name="NAME" value="VALUE"><srai>PATTERN TEXT</srai></li><li name="NAME" value="VALUE">TEXT</li></condition>
<condition name="NAME"><li value="VALUE"><srai>PATTERN TEXT</srai></li><li value="VALUE">TEXT</li></condition>
```



# DONE

<bot name="NAME"/>
<random><li>A</li><li>B</li><li>C</li></random>
<srai>PATTERN TEXT</srai>
