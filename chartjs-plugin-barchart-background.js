(function (global, factory) {
	typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory(require('chart.js')) :
	typeof define === 'function' && define.amd ? define(['chart.js'], factory) :
	(global.PluginBarchartBackground = factory(global.Chart));
}(this, (function (Chart) { 'use strict';

Chart = Chart && Chart.hasOwnProperty('default') ? Chart['default'] : Chart;

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) {
  return typeof obj;
} : function (obj) {
  return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj;
};

var defaultOptions = {
  color: '#f3f3f3',
  axis: 'category',
  mode: 'odd'
};

function getLineValue(scale, index, offsetGridLines) {
  // see core.scale.js -> getLineValue
  var lineValue = scale.getPixelForTick(index);

  if (offsetGridLines) {
    if (index === 0) {
      lineValue -= (scale.getPixelForTick(1) - lineValue) / 2;
    } else {
      lineValue -= (lineValue - scale.getPixelForTick(index - 1)) / 2;
    }
  }
  return lineValue;
}

var plugin = {
  id: 'chartJsPluginBarchartBackground',

  _hasData: function _hasData(data) {
    return data && data.datasets && data.datasets.length > 0;
  },
  _findScale: function _findScale(chart, options) {
    var scales = Object.keys(chart.scales).map(function (d) {
      return chart.scales[d];
    });
    if (options.axis === 'category') {
      return scales.find(function (d) {
        return d.type === 'hierarchical' || d.type === 'category';
      });
    }
    return scales.find(function (d) {
      return d.id.startsWith(options.axis);
    });
  },
  beforeDraw: function beforeDraw(chart, _easingValue, options) {
    options = Object.assign({}, defaultOptions, options);

    var scale = this._findScale(chart, options);
    if (!this._hasData(chart.config.data) || !scale) {
      return;
    }
    var ticks = scale.getTicks();
    if (!ticks || ticks.length === 0) {
      return;
    }

    var isHorizontal = scale.isHorizontal();
    var chartArea = chart.chartArea;

    var soptions = scale.options;
    var gridLines = soptions.gridLines;

    // push the current canvas state onto the stack
    var ctx = chart.ctx;
    ctx.save();

    // set background color
    ctx.fillStyle = options.color;

    // based on core.scale.js
    var tickPositions = ticks.map(function (_, index) {
      return getLineValue(scale, index, gridLines.offsetGridLines && ticks.length > 1);
    });

    var shift = options.mode === 'odd' ? 0 : 1;
    if (tickPositions.length % 2 === 1 - shift) {
      // add the right border as artifical one
      tickPositions.push(isHorizontal ? chartArea.right : chartArea.bottom);
    }

    if (isHorizontal) {
      var chartHeight = chartArea.bottom - chartArea.top;
      for (var i = shift; i < tickPositions.length; i += 2) {
        var x = tickPositions[i];
        var x2 = tickPositions[i + 1];
        ctx.fillRect(x, chartArea.top, x2 - x, chartHeight);
      }
    } else {
      var chartWidth = chartArea.right - chartArea.left;
      for (var _i = shift; _i < tickPositions.length; _i += 2) {
        var y = tickPositions[_i];
        var y2 = tickPositions[_i + 1];
        ctx.fillRect(chartArea.left, y, chartWidth, y2 - y);
      }
    }

    // restore the saved state
    ctx.restore();
  }
};

if (!(typeof define === 'function' && define.amd) && !((typeof module === 'undefined' ? 'undefined' : _typeof(module)) === 'object' && module.exports)) {
  Chart.pluginService.register(plugin);
}

return plugin;

})));
