function select_page_funders() {
	jQuery(".funders option").prop("selected", function(i, val) {
		if (jQuery.inArray(jQuery(this).text(), page_funders) != -1) {
			return !val;
		}
	});
}

function show_page_status_field() {
	jQuery("#page_status_div").show();
}

function hide_page_status_field() {
	jQuery("#page_status").val("");
	jQuery("#countdown2").val("30");
	jQuery("#page_status_div").hide();
}

jQuery(document).ready(function () {
	$('page_has_outreach_true').observe('click', hide_page_status_field);
	$('page_has_outreach_false').observe('click', show_page_status_field);
});