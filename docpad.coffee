# DocPad Configuration File
# http://docpad.org/docs/config

# Define the DocPad Configuration
docpadConfig = {
  templateData:
    site:
      title: "Pat McGee | Web Developer"
      copyright: "© Pat McGee 2014"

    getPreparedTitle: ->
      if @document.title
        "#{@site.title} | #{@document.title}"
      else
        @site.title

    getPostSummary: (content) ->
      beginCut = content.search('<!-- begin summary -->')
      offset = "<!-- begin summary -->".length
      cutOff = content.search('<!-- read more -->')
      content[beginCut + offset..cutOff - 1]

  collections:
    pages: ->
      @getCollection("html").findAllLive({isPage: true})
    posts: ->
      @getCollection("html").findAllLive({relativeOutDirPath: 'blog/posts'}).on "add", (model) ->
        model.setMetaDefaults({layout: "blog", isPage: false})
}

# Export the DocPad Configuration
module.exports = docpadConfig
