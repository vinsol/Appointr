// TODO: Object Oriented JS???
function AppointmentsFilter() {

}

AppointmentsFilter.prototype.set = function(start, end) {
  start.datepicker({ onSelect: function() {
    var $appointmentRows = $('.appointment'),
        startDate = (new Date($(this).val())),
        _this = this;
    $appointmentRows.removeClass('date_filtered').hide();
    if(end.val() == '') {
      $appointmentRows.each( function(index) {
        var appointmentDate = new Date((new Date($(this).data('date'))).toDateString());
        if(appointmentDate.toDateString() == startDate.toDateString()) {
          $(this).addClass('date_filtered').filter('.state_filtered').show()
        }
      })
    } else {
      $appointmentRows.each( function(index) {
        var appointmentDate = new Date((new Date($(this).data('date'))).toDateString());
        if((appointmentDate >= (new Date($('#start').val()))) && (appointmentDate <= (new Date($('#end').val())))) {
          $(this).addClass('date_filtered').filter('.state_filtered').show()
        }
      })
    }
  } });
}


$(function() {
  var appointmentsFilter = new AppointmentsFilter();
  appointmentsFilter.set($('#start'), $('#end'));
  appointmentsFilter.set($('#end'), $('#start'));

  $( '#clear_dates' ).on('click', function() {
    $('.appointment').addClass('date_filtered').filter('.state_filtered').show();
    $('#start').val('');
    $('#end').val('');
  })
});
