(($, window) ->

  # Define the plugin class
  class Gravatation

    defaults:
      size: 40 # int
      secure: false # bool
      onInit: -> # function
      onInput: -> # function
      onInvalid: -> # function
      onValid: -> # function
      onGravatarSuccess: -> # function
      onGravatarFail: -> # function
      onEmpty: -> # function
      timeout: 500 # int
      validate: 'input' # Any jQuery event or false
      ext: true # bool
      d: '' # https://en.gravatar.com/site/implement/images/


    # Construct / init the plugin
    constructor: (el, options) ->
      @options = $.extend({}, @defaults, options)

      @$el = $(el)
      @bind()

      # Callback
      @options.onInit( @$el )

    # Bind event handlers
    bind: ->

      # Validate the input in case of browser auto-fill
      if @options.validate
        @getInputValidity()

      # Check the validity of the field on blur but not with a delay
      if @options.validate == 'blur'
        @$el.on @options.validate, @getInputValidity

      # Otherwise check it on whatever option is specified
      else if @options.validate
        @$el.on @options.validate,
          $.debounce( @options.timeout, @getInputValidity )

      # Get the Gravatar on input
      @$el.on 'input', $.debounce( @options.timeout, @returnGravatar )

    unbind: ->
      @$el.off 'input ' + @options.validate

    # Test the input's current value
    getInputValue: =>
      value = @$el.val()

      # Return false
      if value.length == 0
        return false

      # Otherwise return the value if the input has text
      else
        return value



    # Get the input's current validity
    # You could easily replace this with a regex for older browser support
    # Should return a `bool` value
    getInputValidity: =>
      validity = @$el.context.validity.valid
      value = @getInputValue()

      # If the field has a valid email address
      if value && validity

        # Call the valid callback and return the input
        @options.onValid( @$el, value )
        return value

      # If the field doesn't have a valid email address
      else if value && !validity

        @options.onInvalid( @$el )
        return false


    gravatarRequest: ->

      if @getInputValue()

        # Ask Gravatar for the image
        url = if @options.secure then 'https://secure' else 'http://www'
        url += '.gravatar.com/avatar/'
        md5 = SparkMD5.hash( @getInputValue() )
        ext = if @options.ext then '.jpg' else ''

        if $.isFunction( @options.onGravatarFail )
          @options.d = '404'

        # Gravatar options
        params =
          size: @options.size
          d: @options.d

        # Return the full request string
        return url + md5 + ext + '?' + $.param( params )

      else
        @options.onEmpty( @$el )


    returnGravatar: =>

      # Callback when input changes
      @options.onInput( @$el )
      request = @gravatarRequest()

      # Create an image and attempt to load the URL
      $img = $('<img />')

      $img
        .error =>
          # No gravatar
          @options.onGravatarFail( $img, request, @$el )
          return false

        .load =>
          # Do something with the Gravatar
          @options.onGravatarSuccess( $img, request, @$el )

        .attr( 'src', request )


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
