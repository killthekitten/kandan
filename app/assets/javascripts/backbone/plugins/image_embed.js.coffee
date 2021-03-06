class Kandan.Plugins.ImageEmbed
  @options:
    regex: /http.*\.(jpg|jpeg|gif|png)/i

    template: _.template '''
      <div class="image-preview">
        <a target="_blank" href="<%= imageUrl %>">
          <img class="image-embed" src="<%= imageUrl %>" />
        </a>
        <div class="name"><%= subtitle %></div>
      </div>
    '''


  @init: ()->
    Kandan.Modifiers.register @options.regex, (message, state) =>
      url        = message.content.match(@options.regex)[0]
      fileName   = url.split("/").pop()
      comment    = $.trim(message.content.split(url).join(""))
      subtitle   = null
      subtitle   = comment if comment.length > 0
      subtitle ||= fileName

      message.content = @options.template({
        imageUrl: url,
        subtitle: subtitle
      })

      return Kandan.Helpers.Activities.buildFromMessageTemplate(message)
