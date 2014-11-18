function FillSelect() {
  this.parentSelect = $("#availability_staff");
  this.childSelect = $("#availability_service_ids");
}

FillSelect.prototype.fillChild = function() {
  var services = $("#availability_staff option:selected").data('services'),
      _this = this

  this.childSelect.html('')
  if(this.parentSelect.val()) {
    $.each(services, function(index, service) {
      $option = $("<option>", { 'value': service['id'], 'text': service['name'] });
      _this.childSelect.append($option);
    });
  }
  else {
    this.childSelect.append($('<option>', { 'value': '', 'text': 'select staff' }))
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
  fillSelect.fillChild();
  fillSelect.bindEvents();
})