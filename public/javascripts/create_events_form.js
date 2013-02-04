function show_student_dialogues_field() {
	jQuery("#student_dialogues_fields").show();
}

function hide_student_dialogues_field() {
	jQuery("#student_dialogues_fields").hide();
}

function show_page_related_fields() {
	show_student_dialogues_field();
}

function hide_page_related_fields() {
	hide_student_dialogues_field();
}

function calculate_total_participants() {
  var total_count = 0;
  jQuery(".icount").each(function( index, item ) {
    if (jQuery(item).val())
      total_count += parseInt(jQuery(item).val());
  });
  jQuery('#total_count').text(total_count);
}

jQuery(document).ready(function () {
	jQuery("#event_page_id").change(function() {
    jQuery.ajax({
      type: 'GET',
      url: "/events/show_hide_page_fields",
      data: { 'page_id': jQuery(this).val() },
      success: function (data) {
        if (data && data.length > 1) {
          //window.location.href = data;
        } else {
          //need a better way to do all this
          //alert('No results found.');
        }
      }
    });
	});
});