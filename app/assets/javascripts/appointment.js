function LoadCalendar() {
  this.serviceSelect = $("#service");
  this.staffSelect = $("#staff");
}

LoadCalendar.prototype.init = function() {
  this.bindEvents();
}

LoadCalendar.prototype.loadStaffAndCalendar = function(obj) {
  var value = $(obj).val();
  var staff_ids = String($("#service option:selected").data('staff_ids')).split(' '),
      _this = this;
  $('#staff').children().hide()
  if(value) {
    $.each(staff_ids, function(index, staff) {
    $('#staff').children().first().show();
    $('#staff').val('')
      $('#staff').children('option[value = "' + staff + '"]').show();
    });
    $('#calendar').fullCalendar('destroy');
    _this.initialiseCalendar(value, '')
  }
  else {
    $('#staff').val('')
    $('#calendar').fullCalendar('destroy');
  }
}

LoadCalendar.prototype.initialiseCalendar = function(service_id, staff_id) {
  $('#calendar').fullCalendar({
        contentHeight: 400,
        aspectRatio: 2,
        defaultView: 'agendaWeek',
        allDaySlot: false,
        selectable: true,
        slotDuration: '00:15:00',
        snapDuration: '00:15:00',
        slotEventOverlap: false,
        header: {
          left: 'prev,next today',
          center: 'title',
          right: 'agendaWeek,agendaDay'
        },
        eventSources: [
          {
            color: 'green',
            url: '/availabilities',
            data: { 'service_id': service_id, 'staff_id': staff_id },
            textColor: 'blue'
          },
          {
            url: '/appointments',
            color: 'red',
            textColor: 'blue'
          }

        ],
        eventClick: function(calEvent, jsEvent, view) {
          $.ajax({
            url: 'appointments/' + calEvent['id'] + '/edit'
          })
        },
        select: function(start, end, jsEvent, view) {
          $.ajax({
            url: 'appointments/new?start=' + start['_d'] + '&end=' + end['_d']
          })
        },
        selectOverlap: function(event) {
          return event.rendering === 'background';
        }
      })
}

LoadCalendar.prototype.bindEvents = function() {
  var _this = this;
  this.serviceSelect.on("change", function() {
    _this.loadStaffAndCalendar(this);
  })
  this.staffSelect.on("change", function() {
    $('#calendar').fullCalendar('destroy');
    _this.initialiseCalendar($('#service').val() ,$(this).val());
  })
}

$(document).ready(function() {
  var loadCalendar = new LoadCalendar;
  loadCalendar.init()
  // $('#staff').children().hide()
  // $('#staff').children().first().show()

  // $('#service').on('change', function() {
  //   var value = $(this).val();
  //   var staff_ids = String($("#service option:selected").data('staff_ids')).split(' '),
  //       _this = this;
  //   $('#staff').children().hide()
  //   if(value) {
  //     $.each(staff_ids, function(index, staff) {
  //       $('#staff').children('option[value = "' + staff + '"]').show();
  //     });
  //     // $('#staff').val($('#staff').children(':visible').first().val())

  //     $('#calendar').fullCalendar('destroy');

  //     $('#calendar').fullCalendar({
  //       contentHeight: 400,
  //       aspectRatio: 2,
  //       defaultView: 'agendaWeek',
  //       allDaySlot: false,
  //       selectable: true,
  //       slotDuration: '00:15:00',
  //       snapDuration: '00:15:00',
  //       slotEventOverlap: false,
  //       header: {
  //         left: 'prev,next today',
  //         center: 'title',
  //         right: 'agendaWeek,agendaDay'
  //       },
  //       eventSources: [
  //         {
  //           color: 'green',
  //           url: '/availabilities',
  //           data: { 'service_id': value },
  //           textColor: 'blue'
  //         },
  //         {
  //           url: '/appointments',
  //           color: 'red',
  //           textColor: 'blue'
  //         }

  //       ],
  //       eventClick: function(calEvent, jsEvent, view) {
  //         $.ajax({
  //           url: 'appointments/' + calEvent['id'] + '/edit'
  //         })
  //       },
  //       select: function(start, end, jsEvent, view) {
  //         $.ajax({
  //           url: 'appointments/new?start=' + start['_d'] + '&end=' + end['_d']
  //         })
  //       },
  //       selectOverlap: function(event) {
  //         return event.rendering === 'background';
  //       }
  //     })
  //   }
  //   else {
  //     $('#staff').children().first().show();
  //     $('#staff').val('')
  //     $('#calendar').fullCalendar('destroy');
  //   }
  // })
});