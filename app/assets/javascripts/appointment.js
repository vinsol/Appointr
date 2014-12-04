function LoadCalendar() {
  // TODO: Rename to this.$serviceSelect.
  this.serviceSelect = $("#service");
  this.staffSelect = $("#staff");
}

LoadCalendar.prototype.init = function() {
  this.bindEvents();
}

// TODO: What is obj? Give proper name.
LoadCalendar.prototype.loadStaffAndCalendar = function(obj) {
  var value = $(obj).val();
  // TODO: Refactor.
  var staff_ids = String($("#service option:selected").data('staff_ids')).split(' '),
      _this = this;
  // TODO: Semicolon??? Also, use already created variables. serviceSelect etc.
  $('#staff').children().hide()
  if(value) {
    // TODO: No indentation.
    $.each(staff_ids, function(index, staff) {
      // TODO: Bad selector.
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

// TODO: DRY.
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
          var appointmentStartAt = new Date(calEvent['start']['_i']);
          if(appointmentStartAt > (new Date)) {
            $.ajax({
              url: 'appointments/' + calEvent['id'] + '/edit'
            })
          } else {
            $.ajax({
              url: 'appointments/' + calEvent['id']
            })
          }
        },
        select: function(start, end, jsEvent, view) {
          if(start['_d'] > (new Date)) {
            $.ajax({
              url: 'appointments/new?start=' + start['_d'] + '&end=' + end['_d']
            })
          } else {

          }
        },
        selectOverlap: function(event) {
          return event.rendering === 'background';
        }
      })
}

LoadCalendar.prototype.bindEvents = function() {
  var _this = this;
  this.serviceSelect.on("change", function() {
    // TODO: No need to pass this
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
});