$(document).ready(function() {
  $(".color-chooser").draggable({helper: "clone"});
  $(".empty-peg").droppable({
    drop: function(event, ui) {
      var color = ui.draggable.attr("class").split(" ").shift();
      $(this).removeClass("red")
      $(this).removeClass("orange")
      $(this).removeClass("yellow")
      $(this).removeClass("green")
      $(this).removeClass("blue")
      $(this).removeClass("purple")
      $(this).addClass(color)
    }
  });
});
