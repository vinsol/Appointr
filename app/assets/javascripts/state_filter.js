// TODO: Object Oriented JS???
function StateFilter() {

}

StateFilter.prototype.set = function(filterSelect) {
  $('.appointment').hide();
  if($(filterSelect).val() == 'approved') {
    $('.approved').show();
  } else if($(filterSelect).val() == 'cancelled') {
    $('.cancelled').show();
  } else if($(filterSelect).val() == 'attended') {
    $('.attended').show();
  } else if($(filterSelect).val() == 'missed') {
    $('.missed').show();
  } else {
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