helper = require './helper.coffee'
d3 = require 'd3'

drawBars = (dom, data, propertyNames, groupByKey, width,
              height, margin, axisHeaders, legendConfig, colors) ->

  require './d3.tip.min.js'

  # scales
  x0 = d3.scale.ordinal().rangeRoundBands([0, width], .1)
  x1 = d3.scale.ordinal()
  y = d3.scale.linear().range([height, 0])

  # colors
  color = d3.scale.ordinal().range(colors)

  # axis
  xAxis = d3.svg.axis().scale(x0).orient("bottom")
  yAxis = d3.svg.axis().scale(y).orient("left")

  # tip
  tip = d3.tip()
    .attr("class", "d3-tip").offset([-10, 0]).html((d) ->
      "<strong>Value:</strong> <span style='color:red'>#{helper.toFixed2(d.value)}</span>"
    )

  # svg
  canvas = helper.createCanvas(dom, width, height, margin, tip)

  # domains
  x0.domain data.map((d) -> d[groupByKey])
  x1.domain(propertyNames).rangeRoundBands [0, x0.rangeBand()]

  # Get Min and Max values
  minVal = d3.min(data, (d) ->
    d3.min d.properties, (d) ->
      d.value
  )
  minVal = Math.min(0, minVal)
  maxVal = d3.max(data, (d) ->
    d3.max d.properties, (d) ->
      d.value
  )
  y.domain([minVal, maxVal])

  # Get the x axis position whether we have negative values or not
  xAxisTransform = height
  if(minVal < 0 < maxVal)
    xAxisTransform =  height * (maxVal / (maxVal - minVal))

  # draw bars
  barSection = canvas.selectAll(".bar-section")
      .data(data)
    .enter()
      .append("g").attr("class", "g")
      .attr("transform", (d) -> "translate(" + x0(d[groupByKey]) + ",0)")

  barSection.selectAll("rect")
      .data((d) -> d.properties)
    .enter()
      .append("rect")
    .attr("width", x1.rangeBand())
    .attr("x", (d) -> x1(d.name) )
    .attr("y", (d) ->
      if(d.value < 0)
        y(0)
      else
        y(d.value)
    )
    .attr("height", (d) ->
      if(d.value < 0)
        y(d.value+maxVal)
      else
        height - y(d.value+minVal))
    .style("fill", (d) -> color(d.name) )
    .on("mouseover", tip.show)
    .on("mouseout", tip.hide)

  # draw axis
  helper.drawHorizontalAxis(canvas, xAxis, width, xAxisTransform, axisHeaders[0], "")
  helper.drawVerticalAxis(canvas, yAxis, axisHeaders[1], "")

  # add legend
  legend = canvas.append("g")
      .attr("class", "legend")
      .attr("height", 100)
      .attr("width", 100)
      .attr("transform", "translate(-5,#{height+5})")

  legend.selectAll("rect")
      .data(legendConfig)
    .enter()
      .append("rect")
      .attr("x", width - 65)
      .attr("y", (d, i) -> i * 20)
      .attr("width", 10)
      .attr("height", 10)
      .style "fill", (d, i) -> legendConfig[i].color

  legend.selectAll("text")
      .data(legendConfig)
    .enter()
      .append("text")
      .attr("x", width - 52)
      .attr("y", (d, i) -> i * 20 + 9)
      .text (d, i) -> legendConfig[i].text

module.exports = { drawBars }
