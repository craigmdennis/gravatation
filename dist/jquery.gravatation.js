/**
 * jquery.gravatation - A jQuery plugin to validate email addresses and retrieve associated Gravatar images.
 * @version v1.0.0
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
        onInit: null,
        onInvalid: null,
        onValid: null,
        onGravatarSuccess: null,
        onGravatarFail: null,
        onEmpty: null,
        timeout: 500,
        ext: true,
        d: ''
      };

      function Gravatation(el, options) {
        this.returnGravatar = bind(this.returnGravatar, this);
        this.validate = bind(this.validate, this);
        this.getInputValidity = bind(this.getInputValidity, this);
        this.getInputValue = bind(this.getInputValue, this);
        this.options = $.extend({}, this.defaults, options);
        this.$el = $(el);
        this.bind();
        this.options.onValid(this.$el);
        console.log('gravatation Loaded');
      }

      Gravatation.prototype.bind = function() {
        this.validate();
        return this.$el.on('input', $.debounce(this.options.timeout, this.validate));
      };

      Gravatation.prototype.unbind = function() {
        return this.$el.off('input');
      };

      Gravatation.prototype.getInputValue = function() {
        return this.$el.val();
      };

      Gravatation.prototype.getInputValidity = function() {
        return this.$el.context.validity.valid;
      };

      Gravatation.prototype.validate = function() {
        var value;
        value = this.getInputValue();
        if (value.length > 0) {
          if (this.getInputValidity()) {
            this.options.onValid(this.$el);
            return this.returnGravatar();
          } else {
            return this.options.onInvalid(this.$el);
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
        $img = $('<img />');
        return $img.error((function(_this) {
          return function() {
            _this.options.onGravatarFail($img, _this.gravatarRequest(), _this.$el);
            return false;
          };
        })(this)).load((function(_this) {
          return function() {
            _this.options.onGravatarSuccess($img, _this.gravatarRequest(), _this.$el);
            return true;
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
