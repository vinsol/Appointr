function LoadCalendar() {
  // TODO: Rename to this.$serviceSelect.
  this.$serviceSelect = $("#service");
  this.$staffSelect = $("#staff");
}

LoadCalendar.prototype.init = function() {
  this.initializeCalendarForCustomer('', '', false)
  this.bindEvents();
}

// TODO: What is obj? Give proper name.
LoadCalendar.prototype.loadStaffAndCalendar = function(dynamicServiceSelect) {
  var value = $(dynamicServiceSelect).val();
  // TODO: Refactor.
  var staff_ids = String(this.$serviceSelect.children(':selected').data('staff_ids')).split(' '),
      _this = this;
  // TODO: Semicolon??? Also, use already created variables. serviceSelect etc.
  $('#staff').children().hide();
  if(value) {
    // TODO: No indentation.
    $.each(staff_ids, function(index, staff) {
      // TODO: Bad selector.
      $('#staff :first-child').show();
      _this.$staffSelect.val('');
        _this.$staffSelect.children('option[value = "' + staff + '"]').show();
      });
    $('#calendar').fullCalendar('destroy');
    _this.initializeCalendarForCustomer(value, '', true);
  }
  else {
    _this.$staffSelect.val('');
    $('#calendar').fullCalendar('destroy');
    _this.initializeCalendarForCustomer('', '', false);
  }
}

// TODO: DRY.
LoadCalendar.prototype.initializeCalendarForCustomer = function(service_id, staff_id, selectable) {
  $('#calendar').fullCalendar({
        contentHeight: 400,
        aspectRatio: 2,
        defaultView: 'agendaWeek',
        allDaySlot: false,
        selectable: selectable,
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
            url: 'customers/availabilities',
            data: { 'service_id': service_id, 'staff_id': staff_id },
            textColor: 'blue'
          },
          {
            url: 'customers/active_appointments',
            color: 'yellow',
            textColor: 'blue'
          },
          {
            url: 'customers/past_appointments',
            color: 'red',
            textColor: 'blue'
          }

        ],
        eventClick: function(calEvent, jsEvent, view) {
          var appointmentStartAt = new Date(calEvent['start']['_i']);
          if(appointmentStartAt > (new Date) && calEvent['state'] == 'approved') {
            $.ajax({
              url: 'customers/appointments/' + calEvent['id'] + '/edit',
              error: function (xhr, ajaxOptions, thrownError) {
                alert(xhr.status);
                alert(thrownError);
              }
            })
          } else {
            $.ajax({
              url: 'customers/appointments/' + calEvent['id'],
              error: function (xhr, ajaxOptions, thrownError) {
                alert(xhr.status);
                alert(thrownError);
              }
            })
          }
        },
        select: function(start, end, jsEvent, view) {
          if((new Date(start['_d'].getTime() - 19800000)) > (new Date)) {
            $.ajax({
              url: 'customers/appointments/new?start=' + start['_d'] + '&end=' + end['_d'],
              error: function (xhr, ajaxOptions, thrownError) {
                alert(xhr.status);
                alert(thrownError);
              }
            })
          }
        },
        selectOverlap: function(event) {
          return(event.rendering === 'background' || event.state !== 'approved');
        }
      })
}

LoadCalendar.prototype.bindEvents = function() {
  var _this = this;
  this.$serviceSelect.on("change", function() {
    _this.loadStaffAndCalendar(this);
  })
  this.$staffSelect.on("change", function() {
    $('#calendar').fullCalendar('destroy');
    _this.initializeCalendarForCustomer($('#service').val() ,$(this).val(), true);
  })
}

$(document).ready(function() {
  var loadCalendar = new LoadCalendar;
  $('#staff').children().hide();
  loadCalendar.init()
});