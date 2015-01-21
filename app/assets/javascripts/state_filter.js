function StateFilter() {

}

StateFilter.prototype.set = function(filterSelect) {
  // $('.appointment').removeClass('state_filtered').hide();
  // if($(filterSelect).val() == 'confirmed') {
  //   $('.confirmed').addClass('state_filtered').filter('.date_filtered').show();
  // } else if($(filterSelect).val() == 'cancelled') {
  //   $('.cancelled').addClass('state_filtered').filter('.date_filtered').show();
  // } else if($(filterSelect).val() == 'attended') {
  //   $('.attended').addClass('state_filtered').filter('.date_filtered').show();
  // } else if($(filterSelect).val() == 'missed') {
  //   $('.missed').addClass('state_filtered').filter('.date_filtered').show();
  // } else {
  //   $('.appointment').addClass('state_filtered').filter('.date_filtered').show();
  // }
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

  $.ajax({
          url: 'admin/appointments/' + queryString,
          dataType: 'script',
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