{ drawBars } = require './bar.coffee'
d3 = require 'd3'
_ = require 'lodash'
dummyChartData = require './dummyChartData.yaml'

defaultColors = ['#4f81bd', '#c0504d']

module.exports = class BarChart
  view: __filename.replace /\..+$/, ''

  init: ->
    @margin = {top: 30, right: 40, bottom: 30, left: 40}
    @data = @model.get('data') || _.cloneDeep(dummyChartData)
    @colors = @model.get('colors') || defaultColors

  _initSvg: ->
    @width = @model.get('width') || @svg.offsetWidth || 800
    @height =  300 || @model.get('height') || @svg.offsetHeight
    @width = @width - @margin.left - @margin.right
    @height = @height - @margin.top - @margin.bottom

  _empty: ->
    d3.select(@svg).select('svg').remove()

  _sanitizeData: (data, propertyNames) ->
    for d in data
      d.properties = ({name: name, value: +d[name]} for name in propertyNames)
    data

  _draw: (groupByKey) ->
    drawBars(@svg, @data, @keys, groupByKey, @width, @height,
              @margin, @axisHeaders, @legendConfig, @colors)
  create: ->
    @_initSvg()
    @axisHeaders = ["Groups", "Value"]
    groupByKey = "role"
    @keys = (key for key of @data[0] when key isnt groupByKey)
    @legendConfig = for key, index in @keys
      text: key
      color: @colors[index % @colors.length]
      type: 'rect'

    @data = @_sanitizeData(@data, @keys)
    console.log @data
    @_draw(groupByKey)
