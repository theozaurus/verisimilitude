var Verisimilitude = (function(){

  return function(selector){
    var width = 800;
    var height = 800;

    var force = d3.layout.force()
        .charge(-500)
        .linkDistance(300)
        .size([width, height]);

    this.update = function(graph){
      force
        .nodes(graph.nodes)
        .links(graph.links)
        .start();

      var link = d3.select(selector).selectAll(".link").data(graph.links);
      link
        .enter()
        .append("line");
      link
        .attr("class", "link")
        .style("stroke-width", function(d) { return Math.sqrt(d.value); });

      var circles = d3.select(selector).selectAll('circle').data(graph.nodes);
      circles
        .enter()
        .append('circle');
      circles
        .attr('r', '40px')
        .style('stroke', 'black')
        .style('stroke-width', '1px')
        .style("fill","white")
        .call(force.drag);
      circles.exit().remove();


      var names = d3.select(selector).selectAll('text.name').data(graph.nodes);
      names
        .enter()
        .append('text');
      names
        .attr('class', 'name')
        .attr('transform', "translate(-30,-10)")
        .text(function(d) { return d.name; });
      names.exit().remove();

      var running = d3.select(selector).selectAll('text.running').data(graph.nodes);
      running
        .enter()
        .append('text');
      running
        .attr('class', 'running')
        .attr('transform', "translate(-30,10)")
        .text(function(d) { return "Running: " + d.running; });
      running.exit().remove();

      var booting = d3.select(selector).selectAll('text.booting').data(graph.nodes);
      booting
        .enter()
        .append('text');
      booting
        .attr('class', 'booting')
        .attr('transform', "translate(-30,30)")
        .text(function(d) { return "booting: " + d.booting; });
      booting.exit().remove();


      force.on('tick', function(){
        link
          .attr("x1", function(d) { return d.source.x; })
          .attr("y1", function(d) { return d.source.y; })
          .attr("x2", function(d) { return d.target.x; })
          .attr("y2", function(d) { return d.target.y; });

        circles
          .attr("cx", function(d) { return d.x; })
          .attr("cy", function(d) { return d.y; });

        names
          .attr("x", function(d) { return d.x; })
          .attr("y", function(d) { return d.y; });

        running
          .attr("x", function(d) { return d.x; })
          .attr("y", function(d) { return d.y; });

        booting
          .attr("x", function(d) { return d.x; })
          .attr("y", function(d) { return d.y; });
      });
    };
  };

}());

var Linker = (function(){
  return function(){
    this.call = function(data){
      var hash = {};

      hash.nodes = data;
      hash.links = [];

      var link_num = Math.round(Math.random() * 50);
      for (i = 0; i < link_num; i++) {
        hash.links = hash.links.concat({
          source: Math.floor(Math.random() * data.length),
          target: Math.floor(Math.random() * data.length),
          value:  Math.floor(Math.random() * 3)
        });
      }

      return hash;
    };

  };
}());

var Poller = (function(){
  return function(url, func){
    var run = function(){
      window.setTimeout(runFunc, 2000);
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
  var linker = new Linker();
  var chart = new Verisimilitude('.visuals');
  var poller = new Poller('/distributions', function(data){
    chart.update(linker.call(data));
  });
  poller.run();
});
