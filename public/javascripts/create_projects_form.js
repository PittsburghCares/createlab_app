function select_page_funders() {
	jQuery(".funders option").prop("selected", function(i, val) {
		if (jQuery.inArray(jQuery(this).text(), page_funders) != -1) {
			return !val;
		}
	});
}

function show_project_status_field() {
	jQuery("#project_status_div").show();
}

function hide_project_status_field() {
	jQuery("#project_status").val("");
	jQuery("#countdown2").val("30");
	jQuery("#project_status_div").hide();
	jQuery(".funders option").prop("selected", function() { return false; }); //clear out selected funders
}

jQuery(document).ready(function () {
	$('project_has_outreach_true').observe('click', hide_project_status_field);
	$('project_has_outreach_false').observe('click', show_project_status_field);
});