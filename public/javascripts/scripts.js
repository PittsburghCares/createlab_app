var filtered_locations = new Array();
var current_selection_locations = new Array();
var xhrArray = new Array();

var IEVer = getInternetExplorerVersion();
if ( IEVer > -1 && IEVer < 8.0) {
	window.location = '/browser_not_supported';
}

function getInternetExplorerVersion()
// Returns the version of Internet Explorer or a -1
// (indicating the use of another browser).
{
  var rv = -1; // Return value assumes failure.
  if (navigator.appName == 'Microsoft Internet Explorer')
  {
    var ua = navigator.userAgent;
    var re  = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
    if (re.exec(ua) != null)
      rv = parseFloat( RegExp.$1 );
  }
  return rv;
}

function initialize_maps() {

  var marker;
  var locations = current_selection_locations
  var all_locations = filtered_locations
	var fMap1Bounds = new google.maps.LatLngBounds();
	var fMap2Bounds = new google.maps.LatLngBounds();
	var infowindow = new google.maps.InfoWindow();
	//var numProjectsVisibile;
	//var numPagesVisible;

  var myOptions = {
    zoom: 2,
    minZoom: 2,
    streetViewControl: false,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);



  $(".currentstats .statlocations").click(function () {
    google.maps.event.trigger(map, 'resize');
    map.setCenter(fMap1Bounds.getCenter());
  });

  for (i = 0; i < locations.length; i++) {
    marker = new google.maps.Marker({
      title: locations[i][0],
      position: new google.maps.LatLng(locations[i][1], locations[i][2]),
      map: map
    });
    fMap1Bounds.extend(marker.position);

		google.maps.event.addListener(marker, 'click', (function(marker, i) { return function(){
			infowindow.setContent("<p style='color:#000; font-size: 14px !important;'>"+marker.title+"</p>");
			infowindow.open(map, marker);
		} }) (marker, i));

 }

  var map2 = new google.maps.Map(document.getElementById("map_canvas2"), myOptions);

  $("#mainstats .statlocations").click(function () {
    google.maps.event.trigger(map2, 'resize');
    map2.setCenter(fMap2Bounds.getCenter());
  });

  for (i = 0; i < all_locations.length; i++) {
    marker = new google.maps.Marker({
      title: all_locations[i][0],
      position: new google.maps.LatLng(all_locations[i][1], all_locations[i][2]),
      map: map2
    });

    fMap2Bounds.extend(marker.position);

		google.maps.event.addListener(marker, 'click', (function(marker, i) { return function(){
			infowindow.setContent("<p style='color:#000; font-size: 14px !important;'>"+marker.title+"</p>");
			infowindow.open(map2, marker);
		} }) (marker, i));

  }

}

$(document).ready(function () {

	currentPage = window.location.pathname.slice(1).split('/')[0];
	$("#" + currentPage).css("font-weight","bold");

	if ($('#photo_collage_container').is(':visible')) return;
	if ($('#main_table').is(':visible')) return;

	//numProjectsVisibile = $("a.viewing").parent().parent().children("span").length;
	//numPagesVisible = $("a.viewing").parent().parent().children("span").children("a").length - numProjectsVisibile;

  xhrArray.push($.ajax('/application/get_stats', {
    type: 'GET',
    dataType: "json",
    success: function (data) {

      var people_stats = "";
			var totalPeople = numberWithCommas(data[0].total_participants);
			var people_filter_text = "People involved with";
			var people_filter_choice = "All outreach";
			var organizations_filter_text = "Organizations actively involved with";
			var organizations_filter_choice = "All outreach";
			var affiliated_organizations_text = "Organizations affiliated with";
			var affiliated_organizations_choice = "All outreach";
			var locations_filter_text = "Locations of impact for";
			var locations_filter_choice = "All outreach";

			if (filter_type == "project") {

			  locations_filter_text = "Locations impacted by";

				people_filter_text = "People involved with"
				people_filter_choice = filter_query
				organizations_filter_text = "Organizations actively involved with"
				organizations_filter_choice = filter_query
				affiliated_organizations_text = "Affiliated organizations involved with"
				affiliated_organizations_choice = filter_query
			} else if (filter_type == "funder") {

				locations_filter_text = "Locations of impact provided by"


				people_filter_text = "People involved in efforts funded by"
				people_filter_choice = filter_query
				organizations_filter_text = "Organizations actively involved in efforts funded by"
				organizations_filter_choice = filter_query
				affiliated_organizations_text = "Affiliated organizations involved in efforts funded by"
				affiliated_organizations_choice = filter_query
				locations_filter_choice = filter_query;
			} else if (filter_type == "age") {
				age_filter_query = "";
				age_total_count = "";

				locations_filter_text = "Locations of impact for"


				if (filter_query.indexOf("Pre") != -1) {
					age_total_count = numberWithCommas(data[0].total_pre_school)
					age_filter_query = "children 4 or younger"
				} else if (filter_query.indexOf("Elementary") != -1) {
					age_total_count = numberWithCommas(data[0].total_elementary_school)
					age_filter_query = "participants ages 5-10"
				} else if (filter_query.indexOf("Middle") != -1) {
					age_total_count = numberWithCommas(data[0].total_middle_school)
					age_filter_query = "participants ages 11-13"
				} else if (filter_query.indexOf("High") != -1) {
					age_total_count = numberWithCommas(data[0].total_high_school)
					age_filter_query = "participants ages 14-17"
				} else if (filter_query.indexOf("Adult") != -1) {
					age_total_count = numberWithCommas(data[0].total_adults)
					age_filter_query = "adults"
				} else if (filter_query.indexOf("Mentors") != -1) {
					age_total_count = numberWithCommas(data[0].total_mentors)
					age_filter_query = "mentors"
				}

				totalPeople = age_total_count;
				people_filter_choice = ""
				people_filter_text = age_total_count + " " + age_filter_query + " impacted"
				organizations_filter_text = "Organizations actively involved in efforts impacting"
				organizations_filter_choice = age_filter_query
				affiliated_organizations_text = "Affiliated organizations involved in efforts impacting"
				affiliated_organizations_choice = age_filter_query
				locations_filter_choice = age_filter_query
			} else if (filter_type == "arena") {
				people_filter_text = ""
				people_filter_choice = ""
				organizations_filter_choice = ""
				organizations_filter_text = ""
				affiliated_organizations_text = ""
				affiliated_organizations_choice = ""
			} else if (filter_type == "geo_scope") {

				locations_filter_text = "Locations of impact"


				people_filter_text = "People involved from"
				var filter_query_text = ""
				organizations_filter_text = "Organizations actively involved in impact"

				if (filter_query.indexOf("International") != -1) {

					filter_query_text = "Outside the United States";
				} else if (filter_query.indexOf("National") != -1) {
					organizations_filter_text += " in"
					locations_filter_text += " in"
					filter_query_text = "The United States";
				} else if (filter_query.indexOf("Regional") != -1) {
					organizations_filter_text += " in"
					locations_filter_text += " in"
					filter_query_text = "SW PA and WV";
				}
				people_filter_choice = filter_query_text
				organizations_filter_choice = filter_query_text
				affiliated_organizations_text = "Affiliated organizations involved in impact"
				affiliated_organizations_choice = filter_query_text
				locations_filter_choice = filter_query_text
			}

      $("#filtered_statpeople").html(totalPeople + " People");
      $("#filtered_statorganizations").html(numberWithCommas(data[0].total_organizations.length) + " Organizations");

      $("#current_statpeople").html(numberWithCommas(data[1].current_selection_participants) + " People");
      $("#current_statorganizations").html(numberWithCommas(data[1].current_selection_organizations.length) + " Organizations");

			$("#people_filter_text").text(people_filter_text)
			$("#people_filter_choice").text(people_filter_choice)

			$("#organizations_filter_text").text(organizations_filter_text)
			$("#organizations_filter_choice").text(organizations_filter_choice)

			$("#affiliated_organizations_text").text(affiliated_organizations_text)
			$("#affiliated_organizations_choice").text(affiliated_organizations_choice)

			$("#locations_filter_text").text(locations_filter_text)
			$("#locations_filter_choice").text(locations_filter_choice)

			if (data[1].current_selection_pre_school > 0) people_stats += "<li>" + numberWithCommas(data[1].current_selection_pre_school) + " Pre-School" + "</li>"
			if (data[1].current_selection_elementary_school > 0) people_stats += "<li>" + numberWithCommas(data[1].current_selection_elementary_school) + " Elementary School" + "</li>"
			if (data[1].current_selection_middle_school > 0) people_stats += "<li>" + numberWithCommas(data[1].current_selection_middle_school) + " Middle School" + "</li>"
			if (data[1].current_selection_high_school > 0) people_stats += "<li>" + numberWithCommas(data[1].current_selection_high_school) + " Highschool" + "</li>"
			if (data[1].current_selection_adults > 0) people_stats += "<li>" + numberWithCommas(data[1].current_selection_adults) + " Adults" + "</li>"
            if (data[1].current_selection_mentors > 0) people_stats += "<li>" + numberWithCommas(data[1].current_selection_mentors) + " mentors" + "</li>"
			$("#list_current_selection_people_stats").append(people_stats);

			people_stats = ""
			if (filter_type != "age") {
				if (data[0].total_pre_school > 0) people_stats += "<li>" + numberWithCommas(data[0].total_pre_school) + " Pre-School" + "</li>"
				if (data[0].total_elementary_school > 0) people_stats += "<li>" + numberWithCommas(data[0].total_elementary_school) + " Elementary School" + "</li>"
				if (data[0].total_middle_school > 0) people_stats += "<li>" + numberWithCommas(data[0].total_middle_school) + " Middle School" + "</li>"
				if (data[0].total_high_school > 0) people_stats += "<li>" + numberWithCommas(data[0].total_high_school) + " Highschool" + "</li>"
				if (data[0].total_adults > 0) people_stats += "<li>" + numberWithCommas(data[0].total_adults) + " Adults" + "</li>"
                if (data[0].total_mentors > 0) people_stats += "<li>" + numberWithCommas(data[0].total_mentors) + " Mentors" + "</li>"
				$("#list_total_people_stats").append(people_stats);
			}

      var org_stats = ""
      var affiliated_stats = ""

      $.each(data[0].total_organizations, function (i, org) {
        org_stats += org.name + "<br/>"
      });
      $("#list_total_org_stats").append(org_stats);

      org_stats = ""
      $.each(data[1].current_selection_organizations, function (i, org) {
        org_stats += org.name + "<br/>"
      });
      $("#list_current_selection_org_stats").append(org_stats);


      num_affiliated_orgs = data[0].total_affiliated_organizations.length;
      if (num_affiliated_orgs > 0) $("#list_total_org_stats").after("<br/><a href=\"javascript:void(0)\" onclick=\"$('#all_organizations').hide(); $('#all_affiliations').slideDown('slow');\">See " + (num_affiliated_orgs > 1 ? numberWithCommas(num_affiliated_orgs) + " affiliated organizations" : numberWithCommas(num_affiliated_orgs) + " affiliated organization") + "</a>")


      $.each(data[0].total_affiliated_organizations, function (i, aff_org) {
        affiliated_stats += aff_org.name + "<br/>"
      });
      $("#list_total_affiliated_stats").append(affiliated_stats);

      num_orgs = data[0].total_organizations.length;
      $("#list_total_affiliated_stats").after("<br/><a href=\"javascript:void(0)\" onclick=\"$('#all_affiliations').hide(); $('#all_organizations').slideDown('slow');\">See " + (num_orgs > 1 ? numberWithCommas(num_orgs) + " actively involved organizations" : numberWithCommas(num_orgs) + " actively involved organization") + "</a>")

      //
      affiliated_stats = ""
      num_affiliated_orgs = data[1].current_selection_affiliated_organizations.length;
      if (num_affiliated_orgs > 0) $("#list_current_selection_org_stats").after("<br/><a href=\"javascript:void(0)\" onclick=\"$('#organizations').hide(); $('#affiliations').slideDown('slow');\">See " + (num_affiliated_orgs > 1 ? numberWithCommas(num_affiliated_orgs) + " affiliated organizations" : numberWithCommas(num_affiliated_orgs) + " affiliated organization") + "</a>")


      $.each(data[1].current_selection_affiliated_organizations, function (i, aff_org) {
        affiliated_stats += aff_org.name + "<br/>"
      });
      $("#list_current_selection_affiliated_stats").append(affiliated_stats);

      num_orgs = data[1].current_selection_organizations.length;
      $("#list_current_selection_affiliated_stats").after("<br/><a href=\"javascript:void(0)\" onclick=\"$('#affiliations').hide(); $('#organizations').slideDown('slow');\">See " + (num_orgs > 1 ? numberWithCommas(num_orgs) + " actively involved organizations" : numberWithCommas(num_orgs) + " actively involved organization") + "</a>")


      $.each(data[0].total_locations, function (i, location) {
        filtered_locations.push(location);
      });

      $.each(data[1].current_selection_locations, function (i, location) {
        current_selection_locations.push(location);
      });

      initialize_maps();

      $(".loading").hide();
      $("#filteredstats").slideToggle("slow");
      $("#current_stats").slideToggle("slow");
    }, error: function () {
      //console.log("Failed to retrieve filtered stats");
    }
  }));


  //122px is the size of the largest thumbnail (120px) + 2px of border
  $('#bottomcontent a.right').click(function () {
    var outer = $("#thumbnails");
    var inner = $("#thumbnailscontainer");
    var leftValue = parseInt($("#thumbnailscontainer").css('left'), 10);
    $("#thumbnailscontainer").css("left", leftValue - Math.min(122, Math.abs(outer.width() - (inner.width() + leftValue))) + "px");
    hideShowSliderArrows();
    //console.log(Math.min(122,Math.abs(outer.width()-(inner.width()+leftValue))));
  });

  $('#bottomcontent a.left').click(function () {
    var leftValue = parseInt($("#thumbnailscontainer").css('left'), 10);
    $("#thumbnailscontainer").css("left", leftValue + Math.min(122, Math.abs(leftValue)) + "px");
    hideShowSliderArrows();
    //console.log(Math.abs(leftValue));
  });

  // intro animation: right and left images fade and slide right
  $('a#leftimg').animate({
    left: '-=40',
    opacity: 0
  }, 1);
  $('a#leftimg').animate({
    opacity: 1,
    left: '+=40'
  }, 200);

  $('a#rightimg').animate({
    left: '-=40',
    opacity: 0
  }, 1);
  $('a#rightimg').animate({
    opacity: 1,
    left: '+=40'
  }, 200);


  // when right image is clicked, slide and fade right
  $("a#leftimg").click(function (event) {
    event.preventDefault();
    linkLocation = this.href;
    $("#currentinfo").removeClass("viewingpopup");
    $("#thumbnailstats #currentinfo").removeClass("viewingpopup");
    $("#leftbar").css("display", "none");

    $('a#leftimg').animate({
      left: '-=10'
    }, 200);
    $('a#leftimg').animate({
      opacity: 0,
      left: '+=40'
    }, 200);

    $('a#rightimg').animate({
      left: '+=0'
    }, 200);
    $('a#rightimg').animate({
      opacity: 0,
      left: '+=40'
    }, 200, redirectPage);
  });

  // when left image is clicked, slide and fade left
  $("a#rightimg").click(function (event) {
    event.preventDefault();
    linkLocation = this.href;
    $("#currentinfo").removeClass("viewingpopup");
    $("#thumbnailstats #currentinfo").removeClass("viewingpopup");
    $("#leftbar").css("display", "none");

    $('a#rightimg').animate({
      left: '+=10'
    }, 200);
    $('a#rightimg').animate({
      opacity: 0,
      left: '-=40'
    }, 200);

    $('a#leftimg').animate({
      left: '+=0'
    }, 200);
    $('a#leftimg').animate({
      opacity: 0,
      left: '-=40'
    }, 200, redirectPage);
  });

  function redirectPage() {
		$.each(xhrArray, function (i, xhr) {
				xhr.abort();
		});
    window.location = linkLocation;
  }

  // when right image is clicked, slide and fade right
  $(".location a.showinfo").click(function (event) {
    $("#programinfo.current").css("display", "block");
    $("#share").css("display", "none");

  });

  $(".projectinfo a.showinfo").click(function (event) {
    $("#programinfo.all").css("display", "block");
    $("#share").css("display", "none");

  });

  $("a.close, #thumbnailcontrols a").click(function (event) {
    //$(".share").css("display","none");
    $("#currentinfo").removeClass("viewingpopup");
    $("#thumbnailstats #currentinfo").removeClass("viewingpopup");
    $("#currentinfo a").removeClass("selected");
    $("#currentinfo .statspopup span").removeClass("selected");
  });

  $(".currentstats a").click(function (event) {
    if ($(this).hasClass('selected')) {
      $('a.close').trigger('click');
    } else {
      $("#thumbnailstats .statspopup").css("margin", "0px");
      $("#text #currentinfo").removeClass("viewingpopup");
      $("#thumbnailstats #currentinfo").removeClass("viewingpopup");
      $("#currentinfo .statspopup span").removeClass("selected");
      $("#currentinfo a").removeClass("selected");
      $("#mainfilter ul").css("display", "none");

      $(this).parent("span").parent("span").parent("div").addClass("viewingpopup");
      $(this).addClass("selected");


      if ($(this).hasClass('statpeople')) {
        $(".popuppeople").addClass("selected");
        $("#currentinfo .statspopup").css("margin", "0px 0px 0px 93px");
        $("#thumbnailstats .statspopup").css("margin", "0px 0px 130px 51px");
        $(".statspopup").css("min-width", "457px");
      }
      if ($(this).hasClass('statorganizations')) {
        $(".popuporganizations").addClass("selected");
        $("#currentinfo .statspopup").css("margin", "0px 0px 0px 53px");
        $("#thumbnailstats .statspopup").css("margin", "0px 0px 130px 11px");
        $(".statspopup").css("min-width", "497px");
      }
      if ($(this).hasClass('statlocations')) {
        $(".popuplocations").addClass("selected");
        $("#currentinfo .statspopup").css("margin", "0px 0px 0px -70px")
        $("#thumbnailstats .statspopup").css("margin", "0px 0px 130px -332px");
      }
    }
  });

  $(document).click(function (event) {
  	//nasty hacks in here...
  	var mapCloseIcon = $($(event.target).closest(event.target).get(0)).attr("src");
    mapCloseIcon = mapCloseIcon == null ? "" : mapCloseIcon;
    if ($(event.target).closest(".statspopup").get(0) == null && $(event.target).closest(".currentstats").get(0) == null && $(event.target).closest("#filter").get(0) == null && mapCloseIcon.indexOf("map") < 0) {
      $("#currentinfo").removeClass("viewingpopup");
      $("#thumbnailstats #currentinfo").removeClass("viewingpopup");
      $("#currentinfo a").removeClass("selected");
      $("#currentinfo .statspopup span").removeClass("selected");
      $("#mainfilter ul").css("display", "none");
      $("#subfilter ul").css("display", "none");
    }
  });

  $("#mainfilter a.current").click(function (event) {
    $("#mainfilter ul").css("display", "block");
    $("#subfilter ul").css("display", "none");

    $("#thumbnailstats .statspopup").css("margin", "0px");
		$("#text #currentinfo").removeClass("viewingpopup");
		$("#thumbnailstats #currentinfo").removeClass("viewingpopup");
		$("#currentinfo .statspopup span").removeClass("selected");
    $("#currentinfo a").removeClass("selected");
  });

  //user filters
  $("#mainfilter ul a:not(.all)").click(function (event) {
    $("#mainfilter ul").css("display", "none");
    $("#subfilter").css("display", "none");
    $("#subfilter.project").css("display", "none");
    $("#subfilter.funder").css("display", "none");
    $("#subfilter.age").css("display", "none");
    $("#subfilter.arena").css("display", "none");
    $("#subfilter.geo_scope").css("display", "none");

    // Add new items to the filter drop down on the frontend
    var txt = $("#subfilter.project a.filtering").text();
    var showText = (txt == "") ? "Select a project" : txt;
    $("#subfilter.project a.current").html(showText);
    txt = $("#subfilter.funder a.filtering").text();
    showText = (txt == "") ? "Select a funder" : txt;
    $("#subfilter.funder a.current").html(showText);
    txt = $("#subfilter.age a.filtering").text();
    showText = (txt == "") ? "Select an age group" : txt;
    $("#subfilter.age a.current").html(showText);
    showText = (txt == "") ? "Select an arena" : txt;
    $("#subfilter.arena a.current").html(showText);
    showText = (txt == "") ? "Select a geographic scope" : txt;
    $("#subfilter.geo_scope a.current").html(showText);

    if ($(this).attr("class") == "project") $("#subfilter.project").css("display", "inline-block");
    else if ($(this).attr("class") == "funder") $("#subfilter.funder").css("display", "inline-block");
    else if ($(this).attr("class") == "age") $("#subfilter.age").css("display", "inline-block");
    else if ($(this).attr("class") == "arena") $("#subfilter.arena").css("display", "inline-block");
    else if ($(this).attr("class") == "geo_scope") $("#subfilter.geo_scope").css("display", "inline-block");

    $("#mainfilter ul a").removeClass("filtering");
    $(this).addClass("filtering");

    $("#mainfilter a.current").html($(this).html());
    $("a.clearfilter").css("display", "block");
  });

  $("#subfilter a.current").click(function (event) {
    $("#subfilter ul").css("display", "block");
    $("#mainfilter ul").css("display", "none");

    $("#thumbnailstats .statspopup").css("margin", "0px");
    $("#text #currentinfo").removeClass("viewingpopup");
    $("#thumbnailstats #currentinfo").removeClass("viewingpopup");
    $("#currentinfo .statspopup span").removeClass("selected");
    $("#currentinfo a").removeClass("selected");
  });

  $("#subfilter ul a").click(function (event) {

    $("#subfilter ul").css("display", "none");
    $("#subfilter ul a").removeClass("filtering");
    $(this).addClass("filtering");
    $("#subfilter ul").css("display", "none");

    $("#subfilter a.current").html($(this).html());


    xhrArray.push($.ajax({
      type: 'GET',
      url: "/application/set_filter_session_variable",
      data: { 'filter_type': $("#subfilter a.filtering").parent().attr("class"), 'filter_query': $(this).text() },
      dataType: "text",
      success: function (data) {
        if (data && data.length > 1) {
          $.each(xhrArray, function (i, xhr) {
            xhr.abort();
          });
          window.location.href = data;
        } else {
          //need a better way to do all this
          alert('No results found.');
        }
      }
    }));
  });

  $("a.all").click(function (event) {
    $('a.clearfilter').trigger('click');
    $("#mainfilter ul a").removeClass("filtering");
    $(this).addClass("filtering");
    $("#mainfilter ul").css("display", "none");
    $("#mainfilter a.current").html($(this).html());
  });

  $("a.thumbtoggle").click(function (event) {

    if ($("#thumbnailscontainer").hasClass('thumbs')) {
      $.cookie('projectView', 'list', { path: '/' });
      listView();
    } else {
    	$.cookie('projectView', 'thumbnail', { path: '/' });
      thumbnailView();
			positionCurrentSelection();
			hideShowSliderArrows();
    }

  });

  function thumbnailView() {
		$("a.thumbtoggle img").attr("src", "/images/list.png");
		$("#thumbnails").css("overflow", "hidden");
		$(this).attr("title", "View outreach as list");
		$(this).css("padding", "9px 12px 7px");
		$("#thumbnailcontrols a:not(.thumbtoggle)").show();
		$("#thumbnailscontainer a").css("padding", "0px");
		$("#thumbnailcontrols").css("width", "124px");
		$("#thumbnailscontainer").removeClass("list");
		$("#thumbnailscontainer").addClass("thumbs");
		$("#bottomcontent").css("height", "150px");
		$("#footer").css("margin","30px 0px 10px 80px");
		$('#thumbnails a.viewing p.hovertitle').css("font-size", "12px");
  }

  function listView() {
  	//console.log($("a.right").css("display"));
		$("a.thumbtoggle img").attr("src", "/images/thumbs.png");
		$("#thumbnails").css("overflow", "visible");
		$(this).attr("title", "View outreach as thumbnails");
		$(this).css("padding", "9px 8px 7px");
		$("#thumbnailcontrols a:not(.thumbtoggle)").hide();
		$("#thumbnailcontrols").css("width", "44px");
		$("#thumbnailscontainer a").css("padding", "5px");
		$("#thumbnailscontainer").removeClass("thumbs");
		$("#thumbnailscontainer").css("left",0);
		$("#thumbnailscontainer").addClass("list");
		$("#bottomcontent").css("height", "100%");
		$('#bottomcontent a.right').hide();
		$('#bottomcontent a.left').hide();
		$('#thumbnails a.viewing p.hovertitle').css("font-size", "13px");

		$("#footer").css("margin",$("#thumbnailscontainer").height()+"px"+" 0px 0px 80px");
  	//console.log($("a.right").css("display"));
  }

  ///
  $("#thumbnailscontainer a.about").hover(function () {
    $(this).parent("span").css("color", "#fff");
  }, function () {
    $(this).parent("span").css("color", "#888");
  });

  //rollover thumbnail (main about thumbnail does not show thumbnail title but highlights the project title)
  //so much of this does not need to be done via javascript but we will keep this for now until I do a cleanup of Yoni's code
  $("span#section").each(function () {
    var caption = $(this).attr('title');
    $(this).append('<p class="sectiontitle">' + caption + '<span></span></p>');
  });

  var viewingtitle = $("a.viewing").attr('title');
  $(".viewingtitle").text(viewingtitle);

  // surely a better/more efficient way to do this
  var thumbnailLinkChoices = $("#thumbnailscontainer a");
  var numChoices = thumbnailLinkChoices.size();
  var currentIndex;
  $(thumbnailLinkChoices).each(function (index) {
    if ($(this).hasClass("viewing")) {
      currentIndex = index;
      return false;
    }
  });

  var parentOfSelection = $("a.viewing").parent();
  if (parentOfSelection.attr("id") == 'section' && !parentOfSelection.hasClass("selected")) parentOfSelection.toggleClass("collapsed selected");

  var nextLink = ((currentIndex + 1) >= numChoices) ? thumbnailLinkChoices[0] : thumbnailLinkChoices[currentIndex + 1];
  var prevLink = ((currentIndex - 1) < 0) ? thumbnailLinkChoices[numChoices - 1] : thumbnailLinkChoices[currentIndex - 1];

	var prevImage = $(prevLink).css('background-image').replace("crop","original");;
	if (prevImage.indexOf("original") != -1) {
		$('#leftimg').css('background-image',prevImage);
	}

  $("#rightimg").attr('href', nextLink)
  $("#leftimg").attr('href', prevLink)

  var projecttitle = $("a.viewing").parent("span").attr('title');
  $(".projecttitle").text(projecttitle);
  $(".projecttitle").attr("title", projecttitle);

  // reverts to normal, shows all thumbnail, gets rid of filters
  $("a.clearfilter").click(function (event) {
    if (filter_query) {
      $.each(xhrArray, function (i, xhr) {
        xhr.abort();
      });
    	window.location = "/projects";
    }

    $("#subfilter.project").css("display", "none");
    $("#subfilter.funder").css("display", "none");
    $("#subfilter.age").css("display", "none");
    $("#subfilter.arena").css("display", "none");
    $("#subfilter.geo_scope").css("display", "none");
    $("a.clearfilter").css("display", "none");
    $("#mainfilter a").removeClass("filtering");
    $("#mainfilter a.all").addClass("filtering");
    $("#mainfilter a.current").html("View all");
		$("#mainfilter ul").css("display", "none");
		$("#subfilter ul").css("display", "none");
  });

  // Click Projects link and all projects are collapsed
  $("#expandcollapse").click(function () {
		$("#thumbnailscontainer").css("left", "0px");

    if ($("#expandcollapse").hasClass("expand")) {
      $('#thumbnails span#section').removeClass('collapsed');
      $(this).attr({
        'title': "Collapse projects",
        'class': "collapse"
      });
      $(this).find("img").attr("src", "/images/collapse.png");

    } else {
      $('#thumbnails span#section').addClass('collapsed');
      $(this).attr({
        'title': "Expand projects",
        'class': "expand"
      });
      $(this).find("img").attr("src", "/images/expand.png");

    }

    hideShowSliderArrows();

  });

  // Expand/collapse project thumbnail groups
  $("#thumbnails span p.sectiontitle").click(

  function () {
    if ($(this).parent("span").hasClass("collapsed")) {
      $(this).parent("span").removeClass('collapsed');
      $(this).find("span").html("&nbsp;&nbsp;x");
    } else {
      $(this).parent("span").addClass('collapsed');
      $(this).find("span").html("&nbsp;&nbsp;+");

      var outer = $("#thumbnails");
      var inner = $("#thumbnailscontainer");
      var leftValue = parseInt($("#thumbnailscontainer").css('left'), 10);
      var lastElementLeftValue = parseInt($(".lastElement").offset().left, 10);
      var tmp = Math.abs(outer.width() - (inner.width() + leftValue));

      //console.log("tmp: " + tmp);
      //console.log("leftValue: " + leftValue);
      //console.log("lastElementLeftValue: " + lastElementLeftValue);

      if (tmp < Math.abs(leftValue))
        $("#thumbnailscontainer").css("left", outer.width() - inner.width());

    };

    hideShowSliderArrows();

  });

  // Hover over thumbnail group and +/ x appears
  $(".thumbs span p.sectiontitle").hover( function () {
    if ($(this).parent().find("a").length < 2) return;
      if ($(this).parent("span").hasClass("collapsed")) {
        $(this).find("span").html("&nbsp;&nbsp;+");
      } else {
        $(this).find("span").html("&nbsp;&nbsp;x");
      }
      $(this).find("span").show();
    }, function () {
      $(this).find("span").hide();
    }
  );

	$(document).keyup(function(event) {

    // handle cursor keys
    if (event.keyCode == 37) {
      // go left
      $("a#leftimg").trigger('click');
    } else if (event.keyCode == 39) {
      // go right
      $("a#rightimg").trigger('click');
    }
	});

  if (filter_type) {
    $("#mainfilter ul a").removeClass("filtering");
    //$("#subfilter ul a" + filter_query).addClass("filtering");
    if (filter_type == "project") {
      $("#subfilter.project").css("display", "inline-block");
      $("#mainfilter a.project").addClass("filtering");
      $("#subfilter.project a.current").html(filter_query);
      $('#subfilter.project li').each(function () {
        if ($(this).text() == filter_query) {
          $(this).find("a").addClass("filtering");
          return false;
        }
      });
    } else if (filter_type == "funder") {
      $("#subfilter.funder").css("display", "inline-block");
      $("#mainfilter a.funder").addClass("filtering");
      $("#subfilter.funder a.current").html(filter_query);
      $('#subfilter.funder li').each(function () {
        if ($(this).text() == filter_query) {
          $(this).find("a").addClass("filtering");
          return false;
        }
      });
    } else if (filter_type == "age") {
      $("#subfilter.age").css("display", "inline-block");
      $("#mainfilter a.age").addClass("filtering");
      $("#subfilter.age a.current").html(filter_query);
      $('#subfilter.age li').each(function () {
        if ($(this).text() == filter_query) {
          $(this).find("a").addClass("filtering");
          return false;
        }
      });
    } else if (filter_type == "arena") {
      $("#subfilter.arena").css("display", "inline-block");
      $("#mainfilter a.arena").addClass("filtering");
      $("#subfilter.arena a.current").html(filter_query);
      $('#subfilter.arena li').each(function () {
        if ($(this).text() == filter_query) {
          $(this).find("a").addClass("filtering");
          return false;
        }
      });
    } else if (filter_type == "geo_scope") {
      $("#subfilter.geo_scope").css("display", "inline-block");
      $("#mainfilter a.geo_scope").addClass("filtering");
      $("#subfilter.geo_scope a.current").html(filter_query);
      $('#subfilter.geo_scope li').each(function () {
        if ($(this).text() == filter_query) {
          $(this).find("a").addClass("filtering");
          return false;
        }
      });
    }
    $("#mainfilter a.current").html($("#mainfilter ul a.filtering").html());
    $("a.clearfilter").css("display", "block");
  }

  function hideShowSliderArrows() {
    var outer = $("#thumbnails");
    var inner = $("#thumbnailscontainer");
    var leftValue = parseInt($("#thumbnailscontainer").css('left'), 10);

    if ($("#thumbnailscontainer").css("left") == "0px") $('#bottomcontent a.left').hide();
    else $('#bottomcontent a.left').show();

    if (outer.width() > inner.width() || Math.abs(outer.width() - (inner.width() + leftValue)) == 0) $('#bottomcontent a.right').hide();
    else $('#bottomcontent a.right').show();
  }

  function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }

	function positionCurrentSelection() {
		var thumbnailViewPortSize = parseInt($("#thumbnails").css('width'), 10);
		var currentParentItemOffset = $("a.viewing").offset().left;
		var currentItemOffset = $("a.viewing").parent().children('a').last().offset().left-21;
		var currentParentItemHasChildren = $("a.viewing").parent().children('a').length - 1;
		var subOrAdd = currentParentItemHasChildren > 0 ? -1 : 1
		//No idea where the 39px comes from, but it is needed. Probably some padding, etc that I am not taking into account..
		//Honestly, this needs to be cleaned up. Too many magic numbers and unnecessary complexity
		if (currentItemOffset > thumbnailViewPortSize) {
			$("#thumbnailscontainer").css("left", 0 - Math.max((currentParentItemOffset+(39*subOrAdd))-thumbnailViewPortSize,currentItemOffset-thumbnailViewPortSize) + "px");
		}
	}

	positionCurrentSelection();

  hideShowSliderArrows();

  $("#thumbnailscontainer > span").last().addClass("lastElement");
  $("#section a, span#section").removeAttr("title");

  if ($.cookie('projectView') == null) $.cookie('projectView', 'thumbnail', { path: '/' });

	if ($.cookie('projectView') == "thumbnail") thumbnailView();
	else listView();

});
