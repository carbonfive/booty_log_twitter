$(function() {

  function update_stream(opts) {
    var stream_url = document.location.href + "stream"
    var data = $.extend({page : 1}, opts);
    $.get(stream_url, data, function(data) {
      $("#stream").html(data);
    })
  }

  function queue_update() {
    setTimeout(function() {
      update_stream({});
      queue_update();
    }, REFRESH_RATE);
  }

  queue_update();

});