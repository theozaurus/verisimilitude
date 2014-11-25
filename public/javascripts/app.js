var Verisimilitude = (function(){

  return function(selector){
    this.update = function(data){
      var circles = d3.select(selector).selectAll('circle').data(data);
      circles.enter().append('circle');

      circles
        .attr('r', '100px')
        .attr('cx', '150px')
        .attr('cy', '150px')
        .style('stroke', 'black')
        .style('stroke-width', '1px')
        .style("fill","white");

      circles.exit().remove();

      var name = d3.select(selector).selectAll('text.name').data(data);
      name
        .enter().append('text');

      name.text(function(d){ return d.name; })
        .attr('class', 'name')
        .attr('x', '150px')
        .attr('y', '130px');

      name
        .exit().remove();

      var running = d3.select(selector).selectAll('text.running').data(data);
      running
        .enter().append('text');

      running.text(function(d){ return "Running: " + d.running; })
        .attr('class', 'running')
        .attr('x', '150px')
        .attr('y', '150px');

      running
        .exit().remove();

      var booting = d3.select(selector).selectAll('text.booting').data(data);
      booting
        .enter().append('text');

      booting.text(function(d){ return "Booting: " + d.booting; })
        .attr('class', 'booting')
        .attr('x', '150px')
        .attr('y', '170px');

      booting
        .exit().remove();
    };
  };

}());

var Poller = (function(){
  return function(url, func){
    var run = function(){
      window.setTimeout(runFunc, 1000);
    };

    var runFunc = function(){
      getData(function(data){
        try {
          func(data);
        } catch(e) {
          console.error(data);
          console.error(e);
        }
        run();
      });
    };

    var getData = function(callback){
      d3.json(url,callback);
    };

    this.run = run;
  };
}());


document.addEventListener('DOMContentLoaded', function () {
  var chart = new Verisimilitude('.visuals');
  var poller = new Poller('/distributions', function(data){ chart.update(data); });
  poller.run();
});
