LoadCalendar.prototype.initializeCalendarForStaff = function() {
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
        url: '/staffs/active_appointments',
        color: 'yellow',
        textColor: 'blue'
      },
      {
        url: '/staffs/past_appointments',
        color: 'red',
        textColor: 'blue'
      }
    ],
    eventClick: function(calEvent, jsEvent, view) {
      var appointmentStartAt = new Date(calEvent['end']['_i'])
      if(appointmentStartAt < (new Date)) {
        $.ajax({
          url: 'staffs/appointments/' + calEvent['id'] + '/edit'
        })
      } else {
        $.ajax({
          url: 'staffs/appointments/' + calEvent['id']
        })
      }
    }
  })
}

$(document).ready(function() {
  var loadCalendar = new LoadCalendar;
  loadCalendar.initializeCalendarForStaff();
});
