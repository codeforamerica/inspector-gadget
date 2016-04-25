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

      // set up subsequent dropdown (names) with options
      $('.inspection-names').show().html( $("<option value='', disabled='true', selected='true'>Select an inspection type</option>") ) // start with a blank
      $(inspection_types).each(function (index, type) {
        $('.inspection-names').append( $("<option>", { value: type.id, html: type.inspection_name, "data-comments": type.comments }) )
      })
    })
  })
  
  $('.inspection-names').on('change', function () {
    $('#inspection_inspection_type_id').val(this.value);
    $('.inspection-type-comments').empty().text($(this).find(':selected').data('comments'))
  })

}


// MAP (LEAFLET.JS)
function launchMap () {

  // set in .html.haml when ready to launch this feature
  // var inspectionLocations = #{ @inspection_locations }
  // var inspectorRegions = #{ @inspector_regions }

  var customIcon = L.icon({
    iconUrl: "#{image_path('marker-icon.png')}",
    iconRetinaUrl: "#{image_path('marker-icon-2x.png')}",
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [-3, -76],
    shadowUrl: "#{image_path('marker-shadow.png')}",
    shadowRetinaUrl: "#{image_path('marker-shadow.png')}",
    shadowSize: [41, 41],
    shadowAnchor: [20, 41]
  });

  var map = L.map('map').setView([33.7683, -118.1956], 12);

  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    maxZoom: 18,
    id: 'mapbox.mapbox-streets-v6',
    accessToken: "pk.eyJ1IjoiY29kZWZvcmFtZXJpY2EiLCJhIjoiSTZlTTZTcyJ9.3aSlHLNzvsTwK-CYfZsG_Q",
  }).addTo(map);


  inspectionLocations.forEach(function (location) {
    L.marker(location, {icon: customIcon}).addTo(map)
  })

  inspectorRegions.forEach(function (region) {
    var poly = L.polygon(JSON.parse(region).coordinates)
    poly.addTo(map)
    map.fitBounds(poly.getBounds());
  })
}