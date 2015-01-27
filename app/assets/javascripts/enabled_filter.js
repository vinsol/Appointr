function EnabledFilter() {
}

EnabledFilter.prototype.set = function(filterSelect) {
  var enabled = filterSelect.value;
  $.ajax({
          url: window.location['pathname'].substring(7) + '?enabled=' + enabled,
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
}

EnabledFilter.prototype.bindEvents = function() {
  var _this = this;
  $('#enabled').on('change', function() {
    _this.set(this);
  })
}

$(function() {
  var enabledFilter = new EnabledFilter();
  enabledFilter.bindEvents();
});