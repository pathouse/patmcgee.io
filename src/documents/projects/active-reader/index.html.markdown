---
title: "Projects - ActiveReader"
layout: "default"
isPage: false
---

#### ActiveReader

ActiveReader is a long and ambitious project I've started working on, the goal of which is to enable active and critical reading of serious
texts. The methods and ideas I am trying to enable can be found in Mortimer J. Adler's [How to Read a Book](http://www.amazon.com/How-Read-Book-Intelligent-Touchstone/dp/0671212095). 

##### Service Objects

From a technical perspective, it's an experiment on my part to build a Rails app composed entirely of service objects. Although this project is in its infancy, you'll notice that there's almost no code in the models or the controllers. The vast majority of the logic is handled by PORO's designed around specific services.

I did this for two reasons. First, the functionality that exists right now - namely the ability to parse a Kindle's `clippings.txt` file and then organize the contents and export them to an Evernote notebook - was first written to be run from the command line. When I decided to attempt to integrate it into a rails application with a much broader focus, I took the path of least resistance. I was able to change almost nothing about the code while moving it into the app, which was a pretty gratifying experience. Secondly, in my work at Artsicle, I've found more and more that encapsulating logic in this manner pays off in the long term. Structural changes are easier, functionality is easier to find, and code becomes less cluttered. I'm excited to see where this approach takes me as I slowly grow this app to the expansive proportions I have in mind for it. 
