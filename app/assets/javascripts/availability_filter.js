function AvailabilityFilter() {
}

AvailabilityFilter.prototype.set = function() {
  $.ajax({
          url: 'availabilities' + '?enabled=' + $('#enabled_filter').val() + '&month=' + $('#date_filter').val(),
          dataType: 'script',
          beforeSend: function() {
            $('#loader_div').show();
          },
          complete: function() {
            $('#loader_div').hide();
          },
          error: function (xhr, ajaxOptions, thrownError) {
            alert(xhr.status);
            alert(thrownError);
          }
        })
}

AvailabilityFilter.prototype.bindEvents = function() {
  var _this = this;
  $('.availability_filter').on('change', function() {
    _this.set();
  })
}

$(function() {
  var availabilityFilter = new AvailabilityFilter();
  availabilityFilter.bindEvents();
});