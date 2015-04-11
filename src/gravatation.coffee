(($, window) ->

  # Define the plugin class
  class Gravatation

    defaults:
      size: 40
      secure: false
      onInit: null
      onInvalid: null
      onValid: null
      onGravatarSuccess: null
      onGravatarFail: null
      onEmpty: null
      timeout: 500
      ext: true
      d: ''


    # Construct / init the plugin
    constructor: (el, options) ->
      @options = $.extend({}, @defaults, options)

      @$el = $(el)
      @bind()

      # Callback
      @options.onValid( @$el )

      console.log 'gravatation Loaded'


    # Bind event handlers
    bind: ->
      # Validate the input in case of browser auto-fill
      @validate()
      @$el.on 'input', $.debounce( @options.timeout, @validate )

    unbind: ->
      @$el.off 'input'

    # Get the input's current value
    getInputValue: =>
      @$el.val()

    # Get the input's current validity
    # You could easily replace this with a regex for older browser support
    getInputValidity: =>
      @$el.context.validity.valid


    # Validate the input's current value
    validate: =>

      # Get the current value for the input
      value = @getInputValue()

      # If the field is not empty
      if value.length > 0

        # If the field has a valid email address
        if @getInputValidity()
          @options.onValid( @$el )

          # Check to see if they have a gravatar
          @returnGravatar()

        # If the field doesn't have a valid email address
        else
          @options.onInvalid( @$el )

      # If the field is empty
      else
        @options.onEmpty( @$el )


    gravatarRequest: ->
      # Ask Gravatar for the image
      url = if @options.secure then 'https://secure' else 'http://www'
      url += '.gravatar.com/avatar/'
      md5 = hex_md5( @getInputValue() )
      ext = if @options.ext then '.jpg' else ''

      if $.isFunction( @options.onGravatarFail )
        @options.d = '404'

      # Gravatar options
      params =
        size: @options.size
        d: @options.d

      # Return the full request string
      return url + md5 + ext + '?' + $.param( params )

    returnGravatar: =>
      # Create an image and attempt to load the URL
      $img = $('<img />')

      $img
        .error =>
          # No gravatar
          @options.onGravatarFail( $img, @gravatarRequest(), @$el )
          return false

        .load =>
          # Do something with the Gravatar
          @options.onGravatarSuccess( $img, @gravatarRequest(), @$el )
          return true

        .attr( 'src', @gravatarRequest() )


  # Define the plugin
  $.fn.extend gravatation: (option, args...) ->
    @each ->
      $this = $(this)
      data = $this.data('gravatation')

      if !data
        $this.data 'gravatation', (data = new Gravatation(this, option))
      if typeof option == 'string'
        data[option].apply(data, args)

) window.jQuery, window
