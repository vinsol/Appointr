function EnabledFilter() {
}

EnabledFilter.prototype.set = function(filterSelect) {
  $('.filter_row').hide();
  if($('#enabled')[0].checked == $('#disabled')[0].checked) {
    $('.filter_row').show();
  } else if($('#enabled')[0].checked == true) {
    $('.enabled').show();
  } else {
    $('.disabled').show();
  }
}

EnabledFilter.prototype.bindEvents = function() {
  var _this = this;
  $('.filter').on('change', function() {
    _this.set(this);
  })
}

$(function() {
  var enabledFilter = new EnabledFilter();
  enabledFilter.bindEvents();
});