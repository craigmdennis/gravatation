/**
 * jquery.gravatation - A jQuery plugin to validate email addresses and retrieve associated Gravatar images.
 * @version v1.1.0
 * @link https://github.com/craigmdennis/gravatation
 * @license MIT
 */
(function() {
  var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    slice = [].slice;

  (function($, window) {
    var Gravatation;
    Gravatation = (function() {
      Gravatation.prototype.defaults = {
        size: 40,
        secure: false,
        onInit: function() {},
        onInput: function() {},
        onInvalid: function() {},
        onValid: function() {},
        onGravatarSuccess: function() {},
        onGravatarFail: function() {},
        onEmpty: function() {},
        timeout: 500,
        validate: 'input',
        ext: true,
        d: ''
      };

      function Gravatation(el, options) {
        this.returnGravatar = bind(this.returnGravatar, this);
        this.getInputValidity = bind(this.getInputValidity, this);
        this.getInputValue = bind(this.getInputValue, this);
        this.options = $.extend({}, this.defaults, options);
        this.$el = $(el);
        this.bind();
        this.options.onValid(this.$el);
        console.log('Gravatation Loaded');
      }

      Gravatation.prototype.bind = function() {
        if (this.options.validate) {
          this.getInputValidity();
        }
        if (this.options.validate === 'blur') {
          this.$el.on(this.options.validate, this.getInputValidity);
        } else if (this.options.validate) {
          this.$el.on(this.options.validate, $.debounce(this.options.timeout, this.getInputValidity));
        }
        return this.$el.on('input', $.debounce(this.options.timeout, this.returnGravatar));
      };

      Gravatation.prototype.unbind = function() {
        return this.$el.off('input ' + this.options.validate);
      };

      Gravatation.prototype.getInputValue = function() {
        var value;
        value = this.$el.val();
        if (value.length === 0) {
          return false;
        } else {
          return value;
        }
      };

      Gravatation.prototype.getInputValidity = function() {
        var validity, value;
        validity = this.$el.context.validity.valid;
        value = this.getInputValue();
        if (value) {
          if (validity) {
            this.options.onValid(this.$el, value);
            return value;
          } else {
            this.options.onInvalid(this.$el);
            return false;
          }
        } else {
          return this.options.onEmpty(this.$el);
        }
      };

      Gravatation.prototype.gravatarRequest = function() {
        var ext, md5, params, url;
        url = this.options.secure ? 'https://secure' : 'http://www';
        url += '.gravatar.com/avatar/';
        md5 = hex_md5(this.getInputValue());
        ext = this.options.ext ? '.jpg' : '';
        if ($.isFunction(this.options.onGravatarFail)) {
          this.options.d = '404';
        }
        params = {
          size: this.options.size,
          d: this.options.d
        };
        return url + md5 + ext + '?' + $.param(params);
      };

      Gravatation.prototype.returnGravatar = function() {
        var $img;
        this.options.onInput(this.$el);
        $img = $('<img />');
        return $img.error((function(_this) {
          return function() {
            _this.options.onGravatarFail($img, _this.gravatarRequest(), _this.$el);
            return false;
          };
        })(this)).load((function(_this) {
          return function() {
            return _this.options.onGravatarSuccess($img, _this.gravatarRequest(), _this.$el);
          };
        })(this)).attr('src', this.gravatarRequest());
      };

      return Gravatation;

    })();
    return $.fn.extend({
      gravatation: function() {
        var args, option;
        option = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
        return this.each(function() {
          var $this, data;
          $this = $(this);
          data = $this.data('gravatation');
          if (!data) {
            $this.data('gravatation', (data = new Gravatation(this, option)));
          }
          if (typeof option === 'string') {
            return data[option].apply(data, args);
          }
        });
      }
    });
  })(window.jQuery, window);

}).call(this);
