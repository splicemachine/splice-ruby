$( document ).ready(function() {
    $('[data-toggle="collapse"]').on('click', function(e){
      e.preventDefault();
      var isVisible =  $($(this).attr('href')).is(":visible");

      $('.collapse.in').collapse('hide');

      if(isVisible)
        $($(this).attr('href')).collapse('hide');
      else{
        $($(this).attr('href')).collapse('show');
      }
      return false;
    })
});