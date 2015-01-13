function StateFilter() {

}

StateFilter.prototype.set = function(filterSelect) {
  $('.appointment').removeClass('state_filtered').hide();
  if($(filterSelect).val() == 'confirmed') {
    $('.confirmed').addClass('state_filtered').filter('.date_filtered').show();
  } else if($(filterSelect).val() == 'cancelled') {
    $('.cancelled').addClass('state_filtered').filter('.date_filtered').show();
  } else if($(filterSelect).val() == 'attended') {
    $('.attended').addClass('state_filtered').filter('.date_filtered').show();
  } else if($(filterSelect).val() == 'missed') {
    $('.missed').addClass('state_filtered').filter('.date_filtered').show();
  } else {
    $('.appointment').addClass('state_filtered').filter('.date_filtered').show();
  }
}

StateFilter.prototype.bindEvents = function() {
  var _this = this;
  $('#state').on('change', function() {
    _this.set(this);
  })
}

$(function() {
  var stateFilter = new StateFilter();
  stateFilter.bindEvents();
});