CKEDITOR.editorConfig = function( config ) {
	// config.contentsCss = 'contents.css';
	config.language = 'en';
	myFonts = ['Architects Daughter', 'Open Sans', 'Dancing Script', 'Roboto', 'Poppins','Proxima','Dkotago','Times New Roman','Georgia','Tahoma','Courier New','Verdana','Trebuchet MS','Open Sans'];

  config.font_names = 'sans serif';

  for(var i = 0; i<myFonts.length; i++){
     config.font_names = config.font_names+';'+myFonts[i];
     
    if(myFonts[i] != 'Proxima' && myFonts[i] != 'Dkotago'){
      myFonts[i] = 'http://fonts.googleapis.com/css?family='+myFonts[i].replace(' ','+');
    }
    else if(myFonts[i] == 'Proxima'){
      myFonts[i] = '/css/fonts/proxima/fonts.css';
    }
    else if(myFonts[i] == 'Dkotago'){
      myFonts[i] = '/css/fonts/dkotago/font.css';
    }


     //assuming you use jquery
     $("head").append("<link rel='stylesheet' href='"+ myFonts[i] +"'>");
  }
};