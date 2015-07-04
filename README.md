# Gravatation
A jQuery plugin to validate email addresses and retrieve associated Gravatar images based on work by [Gavyn McKenzie][1] and [Lea Verou][2]

[![](https://david-dm.org/craigmdennis/gravatation.svg)](https://david-dm.org/craigmdennis/gravatation)

## Browser support
IE10+ as it uses the HTML5 [constraint validation API](https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/HTML5/Constraint_validation) rather than a complex regex that will always have *something* missing. You can easily swap this out though.

[1]: http://labs.etchapps.com/prototypes/gravatar-validation/
[2]: http://lea.verou.me/2009/12/quickly-find-the-gravatar-that-corresponds-to-a-given-email/

## Getting Started

#### Bower
Install with [Bower][bower] using `bower install jquery.gravatation --save-dev`

[bower]: http://bower.io/

#### Download
The script is available with the dependcied bundled in (md5.js and debounce.js) or you can download the standalone script without dependencies if you already have them as part of your project. Neither contain jQuery.

- Bundled [minified version][bundlemin] or [development version][bundlemax] (recommended)
- Standalone [minified version][min] or [development version][max]

[min]: https://raw.githubusercontent.com/craigmdennis/gravatation/master/dist/jquery.gravatation.min.js
[max]: https://raw.githubusercontent.com/craigmdennis/gravatation/master/dist/jquery.gravatation.js
[bundlemin]: https://raw.githubusercontent.com/craigmdennis/gravatation/master/dist/jquery.gravatation.bundled.min.js
[bundlemax]: https://raw.githubusercontent.com/craigmdennis/gravatation/master/dist/jquery.gravatation.bundled.js

## Useage

```html
<script src="jquery.js"></script>
<script src="dist/jquery.gravatation.bundled.min.js"></script>
<script>
$(document).ready( function(){
  $('[data-gravatation]').gravatation();
});
</script>
```

**Note that this will not actually do anything by itself.**
Currently the plugin returns the image object and src within callbacks for you to do with as you wish.

## Options

```js
{
  size: 40 // (int) - anything up to 2048
  secure: false // (bool) - serve via https or not
  timeout: 500 // (ms) - debounce on the input
  ext: true // (bool) - add .jpg to the image src
  validate: 'input' // (string) - any jQuery event or false to disable
  d: '' // (string) default avatar https://en.gravatar.com/site/implement/images/
}
```

## Callbacks
Each callback returns jQuery objects to be used.

- `$input` - the input in which the user is typing
- `$img` - the image object to be inserted where you want
- `src` - the Gravatar image request url. It will either return a Gravatar or a default image
- `email` - the validated email address

```js
$('[data-gravatation]').gravatation({
  onInit: function( $input ){},
  onEmpty: function( $input ){},
  onInput: function( $input ){},
  onValid: function( $input, email ){},
  onInvalid: function( $input ){},
  onGravatarSuccess: function( $img, src, $input ){},
  onGravatarFail: function( $img, src, $input ){}
});
```

Gravatar always returns an image, even when no Gravatar is found. So if you provide a callback for `onGravatarFail` then the plugin automatically uses `404` as the default Gravatar image so it can detect a failure and match the callback. Otherwise it will never be called.

## Examples
#### Set error and valid states on the input
```js
$('[data-gravatation]').gravatation({
  onValid: function( $input ){
    $input.removeClass('is-invalid').addClass('is-valid')
  },
  onInvalid: function( $input ){
    $input.removeClass('is-valid').addClass('is-invalid');
  }
});
```
View on CodePen: http://codepen.io/craigmdennis/full/rVwmEN/

#### Remove an error state when empty
```js
$('[data-gravatation]').gravatation({
  onEmpty: function( $input ){
    $input.removeClass('is-invalid');
  },
});
```

#### Insert the image after the input
```js
$('[data-gravatation]').gravatation({
  onGravatarSuccess: function( $img, src, $input ){
    $img.insertAfter( $input );
  }
});
```

#### Insert the image as a background image
```js
$('[data-gravatation]').gravatation({
  onGravatarSuccess: function( $img, src, $input ){
    $('#gravatar').attr( 'background-image', src );
  }
});
```

#### Disable validation
Rolling your own validation? No problem.
Simply pass in `false` as the `validate` option and the plugin will bypass validation and instead check for a Gravatar every time the input changes (after the `timeout` duration).

```js
$('[data-gravatation]').gravatation({
  validate: false,
  onValid: function( $input, email ){
    console.log('This will never be called.');
  },
  onGravatarSuccess: function( $img, src, $input ){
    console.log('Found a Gravatar image', src);
  }
});
```
View on CodePen: http://codepen.io/craigmdennis/full/BNraWj/

#### Validate on blur instead of input
If you only want to validate when the user switches fields the pass in `blur` as the `validate` option.

```js
$('[data-gravatation]').gravatation({
  validate: 'blur',
  onValid: function( $input, email ){
    console.log('Field is valid and no longer has focus.');
  }
});
```

#### Unbind event handlers
```js
// Unbind all event handlers
$('[data-gravatation]').gravatation('unbind');

// Unbind specific inputs
$('#myInput').gravatation('unbind');
```

## Release History
Please consult the official [changelog][changelog]

[changelog]: https://github.com/craigmdennis/gravatation/blob/master/CHANGELOG.md
