// TODO: LoadCalendar defined twice? Move to a common class. DRY.

LoadCalendar.prototype.initializeCalendarForAdmin = function() {
  $('#calendar').fullCalendar({
    contentHeight: 400,
    aspectRatio: 2,
    defaultView: 'agendaWeek',
    allDaySlot: false,
    slotDuration: '00:15:00',
    snapDuration: '00:15:00',
    slotEventOverlap: true,
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    eventSources: [
      {
        url: '/admin/past_appointments',
        color: 'red',
        textColor: 'blue'
      },
      {
        url: '/admin/active_appointments',
        color: 'yellow',
        textColor: 'blue'
      }
    ],
    // TODO: Handle if Ajax fails.
    eventClick: function(calEvent, jsEvent, view) {
      var appointmentStartAt = new Date(calEvent['start']['_i'])
      if(appointmentStartAt > (new Date)) {
        $.ajax({
          url: 'admin/appointments/' + calEvent['id'] + '?cancellable=true',
          error: function (xhr, ajaxOptions, thrownError) {
            alert(xhr.status);
            alert(thrownError);
          }
        })
      } else {
        $.ajax({
          url: 'admin/appointments/' + calEvent['id'],
          error: function (xhr, ajaxOptions, thrownError) {
            alert(xhr.status);
            alert(thrownError);
          }
        })
      }
    },
    selectOverlap: function(event) {
      return event.rendering === 'background';
    }
  })
}

$(document).ready(function() {
  var loadCalendar = new LoadCalendar;
  loadCalendar.initializeCalendarForAdmin()
});
