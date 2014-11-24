function FillSelect() {
  this.parentSelect = $("#availability_staff");
  this.childSelect = $("#availability_service_ids");
}

FillSelect.prototype.init = function() {
  this.fillChild();
  this.bindEvents();
}

FillSelect.prototype.fillChild = function() {
  var service_ids = String($("#availability_staff option:selected").data('service_ids')).split(' '),
      _this = this;
  this.childSelect.children().hide()
  if(this.parentSelect.val()) {

    $.each(service_ids, function(index, service) {
      _this.childSelect.children('option[value = "' + service + '"]').show()
    });
  }
  else {
    _this.childSelect.children().first().show()
  }

}

FillSelect.prototype.bindEvents = function() {
  var _this = this;
  this.parentSelect.on("change", function() {
    _this.fillChild();
  })
}

$(function() {
  var fillSelect = new FillSelect();
  fillSelect.init();
})