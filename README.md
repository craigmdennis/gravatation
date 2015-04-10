# Gravitation
A jQuery plugin to validate email addresses and retrieve associated Gravatar images based on work by [Gavyn McKenzie][1] and [Lea Verou][2]

[1]: http://labs.etchapps.com/prototypes/gravatar-validation/
[2]: http://lea.verou.me/2009/12/quickly-find-the-gravatar-that-corresponds-to-a-given-email/

[![Code Climate](https://codeclimate.com/github/craigmdennis/gravitation.png)](https://codeclimate.com/github/craigmdennis/gravitation)

## Getting Started

#### Bower
Install with [Bower][bower]
`bower install jquery.gravitation`

[bower]: http://bower.io/

#### Download
Download the bundled [production version][min] or the unbundled [development version][max].

[min]: https://raw.github.com/craigmdennis/animateCSS/master/dist/jquery.gravitation.min.js
[max]: https://raw.github.com/craigmdennis/animateCSS/master/dist/jquery.gravitation.js

## Useage

```html
<script src="jquery.js"></script>
<script src="dist/gravitation.min.js"></script>
<script>
$(document).ready( function(){
  $('[data-gravitation]').gravitation();
});
</script>
```

Note that this will not actually do anything by itself.
Currently the plugin returns the image object and src within callbacks for you to do with as you will.

## Options

```js
{
  size: 40 // (int) - anything up to 2048
  secure: false // (bool) - serve via https or not
  timeout: 500 // (ms) - debounce on the input
  ext: true // (bool) - add .jpg to the image src 
  d: '' // (string) default avatar to return when no Gravatar
}
```

## Callbacks
Each callback returns jQuery objects to be used.

- `$input` - the input in which the user is typing
- `$img` - the image object to be inserted where you want
- `src` - the request url to gravatar. It will either return the Gravatar or a default image.

```js
$('[data-gravitation]').gravitation({
  onInit: function( $input ){},
  onValid: function( $input ){},
  onInvalid: function( $input ){},
  onGravatarSuccess: function( $img, src, $input ){},
  onGravatarFail: function( $img, src, $input ){}
});
```

Gravatar always returns an image, even when no gravatar is found. So if you provide a callback for `onGravatarFail` then the plugin automatically uses `404` as the default Gravatar image so it can detect a failure and match the callback. Otherwise it will never be called.

## Examples
#### Set an error state on the input
```js
$('[data-gravitation]').gravitation({
  onValid: function( $input ){
    $input.removeClass('.is-invalid');
  },
  onInvalid: function( $input ){
    $input.addClass('.is-invalid');
  }
});
```

#### Insert the image after the input
```js
$('[data-gravitation]').gravitation({
  onGravatarSuccess: function( $img, src, $input ){
    $img.insertAfter( $input );
  }
});
```

## Release History
Please consult the official [changelog][changelog]

[changelog]: https://github.com/craigmdennis/animateCSS/blob/master/CHANGELOG.md
