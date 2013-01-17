function limitText(limitField, limitCount, limitNum) {
  if (limitField.value.length > limitNum) {
    limitField.value = limitField.value.substring(0, limitNum);
  } else {
   limitCount.value = limitNum - limitField.value.length;
  }
}

function autoTab(obj) {
	if (obj.value.length == obj.size){
		var x = parseInt(obj.id.charAt(obj.id.length-1)) + 1;
		var nwID = "tele" + x;
		if (x < 3){
			document.getElementById(nwID).focus();
		}
	}
}

function clear_preset_form_fields(preset) {
	// get all the inputs into an array.
	var inputs = jQuery('.pf-form :input');

	inputs.each(function() {
	  if (jQuery(this).val() == preset) {
		  jQuery(this).val("");
		}
	});
}

function setupDefaultFieldText() {
	jQuery(".defaultText").each( function() {
		if (jQuery(this).attr("value") == "") {
			jQuery(this).attr("value","Start typing name here...");
			jQuery(this).css("color","#A9A9A9");
		}
	});
}

function handleDefaultFieldText(field){
	if (jQuery(field)[0].defaultValue == jQuery(field).val()) {
		jQuery(field).css("color", "#000000"); 
		jQuery(field).val("");
	} else if (field.value == "") {
		jQuery(field).css("color", "#A9A9A9"); 
		jQuery(field).val(field.defaultValue); 
	}
}

function setupInfoIcon() {
	jQuery('.info').mouseover(function(){
		var newSrc = jQuery(this).attr("src").replace("info1", "info2");
		jQuery(this).attr("src", newSrc); 
	}).mouseout(function(){
		var newSrc = jQuery(this).attr("src").replace("info2", "info1");
		jQuery(this).attr("src", newSrc); 
	});
}

function setupSubmitButtons(submitButtons) {
  jQuery(submitButtons).click(function(){
    clear_preset_form_fields("Start typing name here...");
    jQuery(submitButtons).attr("value", "Please wait...");
    if(jQuery.data(this, 'clicked')){
      return false;
    }else{
      jQuery.data(this, 'clicked', true);
      return true;
    }
  });
}

function setupFaceBox() {
	jQuery.facebox.settings.opacity = 0.2
}

function createFaceBox(element) {
	 jQuery(document).bind('reveal.facebox', function() {
		 jQuery(element).submit(function() {
			 jQuery.post(this.action, jQuery(this).serialize(), null, "script");
			 return false;
		 });
	 });
}
