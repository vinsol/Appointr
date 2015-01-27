function StateFilter() {

}

StateFilter.prototype.set = function(filterSelect) {
  var queryString = '?state=' + $(filterSelect).val(),
      start_date = $('#start').val(),
      end_date = $('#end').val();
  if(start_date.length != 0 && end_date != 0) {
    queryString += '&start_date=' + (new Date(start_date).toDateString()) + '&end_date=' + (new Date(end_date).toDateString());
  } else if(end_date.length != 0) {
    queryString += '&start_date=' + (new Date(end_date).toDateString());
  } else if(start_date.length != 0) {
    queryString += '&start_date=' + (new Date(start_date).toDateString());
  }

  if($('#search').val().length != 0) {
    queryString += '&search=' + $('#search').val();
  }

  $.ajax({
          url: 'admin/appointments/' + queryString,
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

StateFilter.prototype.bindEvents = function() {
  var _this = this;
  $('#state').on('change', function() {
    _this.set(this);
  })
}

$(function() {
  var stateFilter = new StateFilter();
  stateFilter.bindEvents();
});