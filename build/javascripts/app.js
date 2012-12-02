(function() {

  if (!(window.console && console.log)) {
    (function() {
      var console, length, methods, noop, _results;
      noop = function() {};
      methods = ['assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error', 'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log', 'markTimeline', 'profile', 'profileEnd', 'markTimeline', 'table', 'time', 'timeEnd', 'timeStamp', 'trace', 'warn'];
      length = methods.length;
      console = window.console = {};
      _results = [];
      while (length--) {
        _results.push(console[methods[length]] = noop);
      }
      return _results;
    })();
  }

}).call(this);
(function() {
  var Datepicker, Momento, PubSub, join, splice, split,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  split = String.prototype.split;

  splice = Array.prototype.splice;

  join = Array.prototype.join;

  PubSub = (function() {

    function PubSub() {
      this.events = {};
    }

    PubSub.prototype.suscribe = function(ev, fn) {
      var event, splitted_events, _i, _len, _results,
        _this = this;
      if (typeof ev !== "string") {
        ev = join.call(ev, ' ');
      }
      splitted_events = split.call(ev, /\s+/);
      _results = [];
      for (_i = 0, _len = splitted_events.length; _i < _len; _i++) {
        event = splitted_events[_i];
        _results.push((function(event) {
          var _base, _ref;
          if ((_ref = (_base = _this.events)[event]) == null) {
            _base[event] = [];
          }
          return _this.events[event].push(fn);
        })(event));
      }
      return _results;
    };

    PubSub.prototype.unsuscribe = function(ev, fn) {
      var event, splitted_events, _i, _len, _results,
        _this = this;
      if (typeof ev !== "string") {
        ev = join.call(ev, ' ');
      }
      splitted_events = split.call(ev, /\s+/);
      _results = [];
      for (_i = 0, _len = splitted_events.length; _i < _len; _i++) {
        event = splitted_events[_i];
        _results.push((function(event) {
          var index;
          if (_this.events[event] != null) {
            if (typeof fn === "function") {
              index = _this.events[event].indexOf(fn);
              if (index !== -1) {
                return splice.call(_this.events[event], index, 1);
              } else {
                return delete _this.events[event];
              }
            }
          }
        })(event));
      }
      return _results;
    };

    PubSub.prototype.publish = function(ev) {
      var event, splitted_events, _i, _len, _results,
        _this = this;
      if (typeof ev !== "string") {
        ev = join.call(ev, ' ');
      }
      splitted_events = split.call(ev, /\s+/);
      _results = [];
      for (_i = 0, _len = splitted_events.length; _i < _len; _i++) {
        event = splitted_events[_i];
        _results.push((function(event) {
          var fn, _j, _len1, _ref, _results1;
          _ref = _this.events[event];
          _results1 = [];
          for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
            fn = _ref[_j];
            _results1.push((function(fn) {
              return fn.apply(null, split.call(arguments));
            })(fn));
          }
          return _results1;
        })(event));
      }
      return _results;
    };

    return PubSub;

  })();

  Momento = (function() {

    function Momento() {
      this;

    }

    Momento.prototype.is_valid = function(date) {
      var components, num, test_date, user_date, _ref;
      components = this.has_format(date);
      if (components === null) {
        return false;
      }
      _ref = (function() {
        var _i, _len, _ref, _results;
        _ref = components.slice(1);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          num = _ref[_i];
          _results.push(~~num);
        }
        return _results;
      })(), this.day = _ref[0], this.month = _ref[1], this.year = _ref[2];
      test_date = '' + this.day + this.month + this.year;
      user_date = new Date(this.year, this.month - 1, this.day);
      return test_date === this.get_full_date(user_date);
    };

    Momento.prototype.has_format = function(date) {
      return date.match(/^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])[\/\-](\d{4})$/);
    };

    Momento.prototype.get_full_date = function(date, sep) {
      var day, month, year, _ref;
      if (sep == null) {
        sep = '';
      }
      _ref = this.components(date), day = _ref[0], month = _ref[1], year = _ref[2];
      return '' + day + sep + (month + 1) + sep + year;
    };

    Momento.prototype.now = function() {
      return this.get_full_date(new Date(), '/');
    };

    Momento.prototype.components = function(date) {
      return [+date.getDate(), +date.getMonth(), +date.getFullYear()];
    };

    Momento.prototype.up = function(days) {
      var date, offset;
      if (days == null) {
        days = 1;
      }
      offset = days * 24 * 60 * 60 * 1000;
      date = new Date(Date.UTC(this.year, this.month - 1, this.day) + offset);
      return this.get_full_date(date, '/');
    };

    Momento.prototype.down = function(days) {
      var date, offset;
      if (days == null) {
        days = 1;
      }
      offset = days * 24 * 60 * 60 * 1000;
      date = new Date(Date.UTC(this.year, this.month - 1, this.day) - offset);
      return this.get_full_date(date, '/');
    };

    return Momento;

  })();

  Datepicker = (function(_super) {

    __extends(Datepicker, _super);

    function Datepicker() {
      this.handler = __bind(this.handler, this);
      this.momento = new Momento();
      Datepicker.__super__.constructor.apply(this, arguments);
      this;

    }

    Datepicker.prototype.select = function(selector) {
      this.elem = document.querySelector(selector);
      this.elem.value = this.momento.now();
      this.bind('keyup', this.handler);
      return this;
    };

    Datepicker.prototype.bind = function(event, cb) {
      if (this.elem.addEventListener) {
        return this.elem.addEventListener(event, cb, false);
      } else if (this.elem.attachEvent) {
        return this.elem.attachEvent('on' + event, function() {
          return cb.call(event.srcElement, event);
        });
      }
    };

    Datepicker.prototype.handler = function(event) {
      if (this.momento.is_valid(this.elem.value)) {
        this.publish('datepicker.valid');
        if (event.keyCode === 38) {
          this.elem.value = (event.shiftKey ? this.momento.up(15) : this.momento.up());
        }
        if (event.keyCode === 40) {
          return this.elem.value = (event.shiftKey ? this.momento.down(15) : this.momento.down());
        }
      } else {
        return this.publish('datepicker.error');
      }
    };

    return Datepicker;

  })(PubSub);

  if (typeof window !== "undefined" && window !== null) {
    window._ = new Datepicker();
  }

  if (typeof exports !== "undefined" && exports !== null) {
    exports.Datepicker = Datepicker;
    exports.Momento = Momento;
    exports.PubSub = PubSub;
  }

}).call(this);
(function() {



}).call(this);
(function() {
  var feedback;

  _.select('.datepicker');

  feedback = document.querySelector('.feedback');

  _.suscribe('datepicker.error', function(event) {
    console.log("Invalid date " + feedback);
    return feedback.className = 'feedback show';
  });

  _.suscribe('datepicker.valid', function(event) {
    console.log("Correct date");
    return feedback.className = 'feedback hide';
  });

}).call(this);
