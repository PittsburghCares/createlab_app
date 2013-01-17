// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//keep the mouse over effect on the nav option that the user is currently on
function setCurrentPage(){
  var navigationContainer = document.getElementById("navigation")
  var navBarListCollection = navigationContainer.getElementsByTagName('li');
  var navBarLinkCollection = navigationContainer.getElementsByClassName('menulink');
    
  var currentPageArray = window.location.pathname.split('/');
  var currentPagePath = currentPageArray[1]	
  
  for (var j=0; j < navBarListCollection.length; j++) {
    
    navBarLinkPathCollectionArray = navBarLinkCollection[j].pathname.split('/')

		if (currentPagePath == 'home' || currentPagePath == "") {
	  	navBarLinkCollection[0].className = 'active';
      break;	
		}else if (currentPagePath == navBarLinkPathCollectionArray[1] || currentPagePath == navBarLinkPathCollectionArray[0]) {
	  	navBarLinkCollection[j].className = 'active';
	  	break;
		}
  }
}

//on document load, run the nav highlight funciton and setup ajax pagination
document.observe("dom:loaded", function() {
  setCurrentPage();
})