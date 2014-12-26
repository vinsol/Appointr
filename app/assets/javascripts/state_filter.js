// TODO: Object Oriented JS???
function StateFilter() {

}

StateFilter.prototype.set = function(filterSelect) {
  $('.appointment').hide();
  switch($(filterSelect).val()) {
    case 'approved':
      $('.approved').show();
      break;
    case 'attended':
      $('.attended').show();
      break;
    case 'cancelled':
      $('.cancelled').show();
      break;
    case 'missed':
      $('.missed').show();
      break;
    default:
      $('.appointment').show();
  }
}

StateFilter.prototype.bindEvents = function() {
  var _this = this;
  $('#filter').on('change', function() {
    _this.set(this);
  })
}

$(function() {
  var stateFilter = new StateFilter();
  stateFilter.bindEvents();
});