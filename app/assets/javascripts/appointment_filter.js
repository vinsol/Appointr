// TODO: Object Oriented JS???

$(function() {
  $( "#start" ).datepicker({ onSelect: function() {
    var $appointmentRows = $('.appointment'),
        startDate = (new Date($(this).val())),
        _this = this;
    $appointmentRows.hide();
    if($('#end').val() == '') {
      $appointmentRows.each( function(index) {
        var appointmentDate = new Date((new Date($(this).data('date'))).toDateString());
        if(appointmentDate.toDateString() == startDate.toDateString()) {
          $(this).show()
        }
      })
    } else {
      $appointmentRows.each( function(index) {
        var appointmentDate = new Date((new Date($(this).data('date'))).toDateString());
        if((appointmentDate >= startDate) && (appointmentDate <= (new Date($('#end').val())))) {
          $(this).show()
        }
      })
    }
  } });


  $( "#end" ).datepicker({ onSelect: function() {
    var $appointmentRows = $('.appointment'),
        endDate = (new Date($(this).val())),
        _this = this;
    $appointmentRows.hide();
    if($('#start').val() == '') {
      $appointmentRows.each( function(index) {
        var appointmentDate = new Date((new Date($(this).data('date'))).toDateString());
        if(appointmentDate.toDateString() == endDate.toDateString()) {
          $(this).show()
        }
      })
    } else {
      $appointmentRows.each( function(index) {
        var appointmentDate = new Date((new Date($(this).data('date'))).toDateString());
        if((appointmentDate <= endDate) && (appointmentDate >= (new Date($('#start').val())))) {
          $(this).show()
        }
      })
    }
  } });
  
  $( '#clear_dates' ).on('click', function() {
    $('.appointment').show();
    $('#start').val('');
    $('#end').val('');
  })
});