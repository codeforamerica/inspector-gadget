window.Parsley
  .addValidator('mindate', function (value, requirement) {
      // is valid date?
      var timestamp = Date.parse(value),
          minTs = Date.parse(requirement);

      return isNaN(timestamp) ? false : timestamp >= minTs;    
  }, 32)
  .addMessage('en', 'mindate', 'Date must be on or after %s.');

$(document).ready(function () {

  $('#new_inspection').parsley({
    excluded: 'input[type=button], input[type=submit], input[type=reset]',
    inputs: 'input, textarea, select, input[type=hidden], :hidden',
  });

});
