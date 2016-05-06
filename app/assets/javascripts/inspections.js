$(document).ready(function () {
  if ( $('#inspection-type-basic').length > 0 ) {
    enableInspectionDropdowns()
  }
});

function enableInspectionDropdowns () {

  $('.inspection-supercategories').on('change', function () {
    $.getJSON('/api/v1/inspection_types?supercategory='+this.value, function (inspection_types) {
      var uniq_types = _.uniqBy(inspection_types, function (i) { return i.inspection_category; })

      // set up subsequent dropdown (categories) with options
      $('.inspection-categories').show().html( $("<option value='', disabled='true', selected='true'>Select an inspection category</option>") ) // start with a blank
      $('.inspection-names').html( $("<option>") ) // start with a blank
      $(uniq_types).each(function (index, type) {
        $('.inspection-categories').append( $("<option>", { value: type.inspection_category, html: type.inspection_category_name }) )
      })
    })
  })
  
  $('.inspection-categories').on('change', function (event) {
    var supercategory = $('.inspection-supercategories').val()
    $.getJSON('/api/v1/inspection_types?supercategory='+supercategory+'&category='+this.value, function (inspection_types) {

      // set up multiselect (names) with options
      var $field = $('.inspection-names')

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
        width: '400px',
      });
    })
  })
  
  $('.inspection-names').on('change', function () {
    $('#inspection_inspection_type_id').val( $(this).val() );
    $('.inspection-type-comments').html(function () {
      var allComments = $.map( $('.inspection-names').children(':selected'), function (el) { 
        return $(el).data('comments');
      });
      return allComments.join('<br />');
    }());
  });

}
