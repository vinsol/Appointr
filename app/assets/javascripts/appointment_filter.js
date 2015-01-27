// TODO: Object Oriented JS???
function AppointmentsFilter() {

}

AppointmentsFilter.prototype.set = function(start, end) {
  start.datepicker({ onSelect: function() {
    var $appointmentRows = $('.appointment'),
        startDate = (new Date($(this).val())),
        _this = this;
    var queryString = '?state=' + $('#state').val();
    if(end.val() == '') {
      queryString += '&start_date=' + startDate.toDateString();
    } else {
      queryString += '&start_date=' + (new Date($('#start').val())).toDateString() + '&end_date=' + (new Date($('#end').val())).toDateString();
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
          $('#loader_div').hide();
          alert(xhr.status);
          alert(thrownError);
        }
      })
  } });
}


$(function() {
  var appointmentsFilter = new AppointmentsFilter();
  appointmentsFilter.set($('#start'), $('#end'));
  appointmentsFilter.set($('#end'), $('#start'));

  $( '#clear_dates' ).on('click', function() {
    $.ajax({
          url: 'admin/appointments/' + '?state=' + $('#state').val() + '&search=' + $('#search').val(),
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
    $('#start').val('');
    $('#end').val('');
  })
});
