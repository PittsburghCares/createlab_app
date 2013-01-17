function insert_message_validation(msg,element){
  //hack to hide the try/catch message that comes up in the select field
  //no idea why this bug is happening...  
  jQuery('.auto_complete').hide();

  //do not display failure message more than once
  //var validation_element = $(element).nextSiblings().last();
  ///var validation_element = jQuery("#"+element).parent().parent().find('td#message_validation')
  ///if (validation_element.length > 0 && jQuery(validation_element).get(0).id == "message_validation") return;
  
  //display the failure message
  ///jQuery($(element)).closest('tr, div').append(msg);
}

function add_child(element, child_name, new_child) {
  $(element).up(0).insert({
    bottom: new_child.replace(/NEW/g, new Date().getTime())
  });
}

function remove_message_validation() {
  if ($('message_validation')) $('message_validation').remove();
}

function remove_child(element) {
  $(element).up(".child").remove();
}

function remove_child2(element) {
  $(element).up(".child").hide();
  $(element).previous("input[type=hidden]").value = "1";
}
