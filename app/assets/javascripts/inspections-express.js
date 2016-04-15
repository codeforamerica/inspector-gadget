// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function () {
  if ( $('.inspection-new-express').length > 0 ) {
    enableExpressInspectionDropdowns()
  }
});

function enableExpressInspectionDropdowns () {

  $('.inspection-supercategories').on('change', function () {
    $.getJSON('/api/v1/inspection_types?supercategory='+this.value, function (inspection_types) {

      $field = $('.inspection-names')

      if ($('.chosen-container').length) {
        $field.chosen("destroy"); // only do this if the element is present - creates a phantom Chosen box if none exists
      }

      $field.show().html( $("<option>") ) // start with a blank
      $(inspection_types).each(function (index, type) {
        $field.append( $("<option>", { value: type.id, html: (type.inspection_category_name+' - '+type.inspection_name), "data-comments": type.comments }) )
      })
      $field.chosen({
        allow_single_deselect: true,
        no_results_text: 'No results matched',
        width: '300px',
      });
    })
  })

  $('.inspection-names').on('change', function () {
    $('#inspection_inspection_type_id').val( $(this).val() );
    $('.inspection-type-comments').empty().text($(this).find(':selected').data('comments'))
  })

}
