function EnabledFilter() {

}

EnabledFilter.prototype.set = function(filterSelect) {
  $('.filter_row').hide();
  if($(filterSelect).val() == 'enabled') {
    $('.enabled').show();
  } else if($(filterSelect).val() == 'disabled') {
    $('.disabled').show();
  } else {
    $('.filter_row').show();
  }
}

EnabledFilter.prototype.bindEvents = function() {
  var _this = this;
  $('#filter').on('change', function() {
    _this.set(this);
  })
}

$(function() {
  var enabledFilter = new EnabledFilter();
  enabledFilter.bindEvents();
});