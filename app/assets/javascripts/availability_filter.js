function Filter() {
  this.monthSelect = $("#date_month");
}

Filter.prototype.show_selected_months = function() {
  var _this = this
  if(this.monthSelect.val()) {
    $('.availability').each(function(index) {
      var selectedMonth = parseInt(_this.monthSelect.val()),
          startMonth = (new Date($(this).children('.start_date').text())).getMonth() + 1,
          endMonth = (new Date($(this).children('.end_date').text())).getMonth() + 1;

      $(this).hide();
      _this.checkAndShowAvailability(startMonth, endMonth, selectedMonth, $(this))
    });
  }
  else {
    $('.availability').show()
  }

}

Filter.prototype.checkAndShowAvailability = function(startMonth, endMonth, selectedMonth, $availability) {
  if(startMonth < endMonth) {
    if(startMonth <= selectedMonth && endMonth >= selectedMonth) {
      $availability.show()
    }
  }
  else if(startMonth == endMonth) {
    if(selectedMonth == startMonth) {
      $availability.show()
    }
  }
  else {
    if((startMonth <= selectedMonth || endMonth >= selectedMonth)) {
      $availability.show()
    }
  }
}

Filter.prototype.bindEvents = function() {
  var _this = this;
  this.monthSelect.on("change", function() {
    _this.show_selected_months();
  })
}

$(function() {
  var filter = new Filter();
  filter.bindEvents();
})