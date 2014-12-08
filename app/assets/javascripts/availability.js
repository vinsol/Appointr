function FillSelect() {
  // TODO: Rename to this.$serviceSelect. This is a convention...
  this.$staffSelect = $("#availability_staff");
  this.$serviceSelect = $("#availability_service_ids");
}

FillSelect.prototype.init = function() {
  this.fillServices();
  this.bindEvents();
}

FillSelect.prototype.fillServices = function() {
  // TODO: What is the need to typecast?
  // Because if there is only one service id it gives it as an integer, otherwise as a string.
  var service_ids = String($("#availability_staff option:selected").data('service_ids')).split(' '),
      _this = this;
  this.$serviceSelect.children().hide();
  if(this.$staffSelect.val()) {

    $.each(service_ids, function(index, service) {
      _this.$serviceSelect.children('option[value = "' + service + '"]').show();
    });
  }
  else {
    _this.$serviceSelect.children().first().show();
  }

}

FillSelect.prototype.bindEvents = function() {
  var _this = this;
  this.$staffSelect.on("change", function() {
    _this.fillServices();
  })
}

$(function() {
  var fillSelect = new FillSelect();
  fillSelect.init();
})