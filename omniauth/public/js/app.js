$( function () {
  $("a[href='#mail']").click( function() {
    if ($("#email").hasClass("short")) {
      $("html, body").animate({ "scrollTop": 300 }, 500);
      $("#email").removeClass("short");    
    } else {
      $("html, body").animate({ "scrollTop": 0 }, 500);
      $("#email").addClass("short");          
    }
  });
});


$('#face').click(
  function(){
    w = window.open('https://fetcher.xaviervia.com.ar:8005/auth/facebook','_blank','width=700,height=500,toolbar=0,menubar=0,location=yes');
    w.focus();
    

    return false;
  });