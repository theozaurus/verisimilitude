var Verisimilitude = (function(){

  return function(selector){

    var initialize = function(){
    };

    this.update = function(data){
      console.log(data[0].running);
      var p = d3.select(selector).selectAll('circle')
        .data(data)
      .enter();

      p.append('circle')
        .attr('r', '100px')
        .attr('cx', '150px')
        .attr('cy', '150px')
        .style('stroke', 'black')
        .style('stroke-width', '1px')
        .style("fill","white");

      p.append('text')
        .text(function(d){ return d.name; })
        .attr('x', '150px')
        .attr('y', '150px');

      p.append('text')
        .text(function(d){ return d.running; })
        .attr('x', '150px')
        .attr('y', '170px');

      p.append('text')
        .text(function(d){ return d.booting; })
        .attr('x', '150px')
        .attr('y', '190px');

    };

    initialize();
  };

}());

var Poller = (function(){
  return function(url, func){
    var run = function(){
      window.setTimeout(runFunc, 1000);
    };

    var runFunc = function(){
      getData(function(data){
        func(data);
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

  console.log("LOADED! Let's get weird")

  var chart = new Verisimilitude('.visuals');
  var poller = new Poller('/distributions', function(data){ chart.update(data); });
  poller.run();
});
