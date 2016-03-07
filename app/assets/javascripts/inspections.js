// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function () {
  if ( $('.inspection-new').length > 0 ) {
    enableInspectionDropdowns()
  }
});

function enableInspectionDropdowns () {

  $('.inspection-supercategories').on('change', function () {
    $.getJSON('/api/v1/inspection_types?supercategory='+this.value, function (inspection_types) {
      var uniq_types = _.uniqBy(inspection_types, function (i) { return i.inspection_category; })

      // set up subsequent dropdown (categories) with options
      $('.inspection-categories').show().html( $("<option>") ) // start with a blank
      $('.inspection-names').html( $("<option>") ) // start with a blank
      $(uniq_types).each(function (index, type) {
        $('.inspection-categories').append( $("<option>", { value: type.inspection_category, html: type.inspection_category }) )
      })
    })
  })
  
  $('.inspection-categories').on('change', function (event) {
    var supercategory = $('.inspection-supercategories').val()
    $.getJSON('/api/v1/inspection_types?supercategory='+supercategory+'&category='+this.value, function (inspection_types) {

      // set up subsequent dropdown (names) with options
      $('.inspection-names').show().html( $("<option>") ) // start with a blank
      $(inspection_types).each(function (index, type) {
        $('.inspection-names').append( $("<option>", { value: type.id, html: type.inspection_name }) )
      })
    })
  })
  
  $('.inspection-names').on('change', function () {
    $('#inspection_inspection_type_id').val(this.value);
  })

}
