function LoadCalendar() {
}

LoadCalendar.prototype.initialize = function() {
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
    // eventClick: function(calEvent, jsEvent, view) {
    //   var appointmentStartAt = new Date(calEvent['start']['_i'])
    //   if(appointmentStartAt > (new Date)) {
    //     $.ajax({
    //       url: 'admin/appointments/' + calEvent['id'] + '?cancellable=true'
    //     })
    //   } else {
    //     $.ajax({
    //       url: 'admin/appointments/' + calEvent['id']
    //     })
    //   }
    // },
    // selectOverlap: function(event) {
    //   return event.rendering === 'background';
    // }
  })
}

$(document).ready(function() {
  var loadCalendar = new LoadCalendar;
  loadCalendar.initialize()
});
