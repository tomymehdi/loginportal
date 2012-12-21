$(function () {

    FB.init({
      appId      : '438992236120376', // App ID
      status     : true, // check login status
      cookie     : true, // enable cookies to allow the server to access the session
      xfbml      : true  // parse XFBML
    });

    //FB.Event.subscribe('auth.login', function(response) {
    //    window.location.href=window.location.href;
    //});

    //FB.Event.subscribe('auth.authResponseChange', function(response) {
    //  window.location.reload();
    //});

    //FB.Event.subscribe('auth.statusChange', function(response) {
    //  window.location.reload();
    //});

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
    //var connection = new WebSocket("ws://localhost:7979");
    var resp;
    FB.login(function(response) {
      resp = response;
        if (response.authResponse) {
          FB.api('/me', function(data) {
            data['out'] = response;
            resp = data;
            //connection.send(JSON.stringify(resp));
            $.get('/auth/facebook/callback',resp).complete(
              function(){
                window.parent.document.location.reload();
              });
          });
        } else {
          alert("Bad authentication. Try again");
        }
      //setTimeout(function(){
        
      //},3000);
    },{scope: 'email,read_stream,publish_stream,manage_pages'});
  }
);