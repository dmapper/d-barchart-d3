d3 = require 'd3'

createCanvas = (el, width, height, margin, callFunc) ->
  result = d3.select(el).append("svg:svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("svg:g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    .style("font", "10px sans-serif")
  result = result.call(callFunc) if callFunc
  result

drawVerticalAxis = (canvas, component, title, id = "") ->
  canvas.append("g")
    .attr("id", id)
    .attr("class", "_y _axis axisLeft")
    .call(component)
  .append("text")
    #.attr("transform", "rotate(-90)")
    .attr("y", -12)
    .attr("dy", ".71em")
    .attr("x", 8)
    .style("text-anchor", "inherit")
    .text(title)

drawHorizontalAxis = (canvas, component, width, height, title, id) ->
  canvas.append("g")
      .attr("id", if id? then id else "")
      .attr("class", "_x _axis")
      .attr("transform", "translate(0," + height + ")")
      .call(component)
    .append("text")
      .attr("class", "_x _title")
      .attr("x", width)
      .attr("y",  15)
      .attr("dy", "0.5em")
      .style("text-anchor", "start")
      .text(title)

toFixed2 = (x) -> ~~(x * 100) / 100

module.exports = { createCanvas, drawHorizontalAxis,  drawVerticalAxis, toFixed2 }