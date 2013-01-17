// Photo Collage
// Chris Bartley <bartley@cmu.edu>
// Dependancies:
// * jQuery
// * jquery.shuffle.js
//
// TODO: Clean up and make into a component

var photoCollageImages = [
   {
      "imageUrl" : "images/collage/100blackmen1.jpg",
      "title" : "100 Black Men",
      "projectUrl" : "projects/100_Black_Men_of_Western,_PA"
   },
   {
      "imageUrl" : "images/collage/bbbs_pgh1.jpg",
      "title" : "Big Brothers Big Sisters",
      "projectUrl" : "projects/Big_Brothers_Big_Sisters_of_Greater_Pittsburgh"
   },
 {
      "imageUrl" : "images/collage/bbbs_bc1.jpg",
      "title" : "Big Brothers Big Sisters",
      "projectUrl" : "projects/Big_Brothers_Big_Sisters_of_Beaver_County"
   },
   {
      "imageUrl" : "images/collage/familytyes1.jpg",
      "title" : "Family Tyes",
      "projectUrl" : "projects/Family_Tyes"
   },
   {
      "imageUrl" : "images/collage/rif1.jpg",
      "title" : "Reading Is Fundamental",
      "projectUrl" : "projects/Reading_is_Fundamental_Everybody_Wins!"
   },
   {
      "imageUrl" : "images/collage/swsg1.jpg",
      "title" : "Strong Women, Strong Girls",
      "projectUrl" : "projects/Strong_Women_Strong_Girls"
   },
   {
      "imageUrl" : "images/collage/beginningbooks1.jpg",
      "title" : "Beginning with Books",
      "projectUrl" : "projects/Beginning_with_Books"
   },
   {
      "imageUrl" : "images/collage/amachi1.jpg",
      "title" : "Amachi Pittsburgh",
      "projectUrl" : "projects/Amachi_Pittsburgh"
   },
   {
      "imageUrl" : "images/collage/gwensgirls1.jpg",
      "title" : "Gwens Girls",
      "projectUrl" : "projects/Gwens_Girls"
   },
   {
      "imageUrl" : "images/collage/mgr1.jpg",
      "title" : "MGR Foundation Murals Program",
      "projectUrl" : "projects/MGR_Foundation_Murals_Program"
   },
   {
      "imageUrl" : "images/collage/alleghenyyouth1.jpg",
      "title" : "Allegheny Youth Development",
      "projectUrl" : "projects/Allegheny_Youth_Development"
   },
{
      "imageUrl" : "images/collage/harlequins1.jpg",
      "title" : "Pittsburgh Harlequins Rugby Football Association",
      "projectUrl" : "projects/Pittsburgh_Harlequins_Rugby_Football_Association"
   }



];

var photoCollageCells;
var NUM_COLLAGE_ANIMATORS = 5;
var timeoutMillis = [2000, 3000, 5000, 7000];

function initializePhotoCollage()
   {
   // shuffle the images
   $.shuffle(photoCollageImages);

   // initialize the collage images
   var photoCells = $(".photo_collage_cell");
   $.each(photoCells,
          function(index, cell)
          {
          $(cell).html(createPhotoCollageImageElement(getNextArrayElement(photoCollageImages)));
          });

   // initialize the order in which cells will be animated
   photoCollageCells = new Array(photoCells.length);
   $.each(photoCollageCells,
          function(index)
          {
          photoCollageCells[index] = index;
          });
   $.shuffle(photoCollageCells);

   // fade in all the images
   $(".photo_collage_cell div").fadeIn(2000);

   // start the collage animators
   for (var i = 0; i < NUM_COLLAGE_ANIMATORS; i++)
      {
      setTimeout(animateCollageCell, getRandomArrayElement(timeoutMillis));
      }
   }

function getNextArrayElement(theArray)
   {
   // pop off the first element, and add it to the end
   var element = theArray.shift();
   theArray.push(element);
   return element;
   }

function getRandomArrayElement(theArray)
   {
   return theArray[Math.floor(Math.random() * theArray.length)];
   }

function createPhotoCollageImageElement(imageObj)
   {
   var anchorElement;
   if (imageObj['projectUrl'] !== 'undefined' && imageObj['projectUrl'].length > 0)
      {
      anchorElement = $('<a href="' + imageObj['projectUrl'] + '"></a>');
      }

   var imageElement = $('<img style="border-style: none"; title="' + imageObj['title'] + '" src="' + imageObj['imageUrl'] + '">');

   if (anchorElement)
      {
      anchorElement.html(imageElement);
      imageElement = anchorElement;
      }

   return $('<div style="display:none"></div>').html(imageElement);
   }

function animateCollageCell()
   {
   var cellIndexToAnimate = getNextArrayElement(photoCollageCells);

   var cell = $("#photo_collage_cell_" + cellIndexToAnimate);
   var cellContents = $("#photo_collage_cell_" + cellIndexToAnimate + " div");
   cellContents.fadeOut(4000,
                        function()
                        {
                        cell.empty();
                        var imageElement = createPhotoCollageImageElement(getNextArrayElement(photoCollageImages));
                        cell.html(imageElement);
                        imageElement.fadeIn(4000,
                                            function()
                                            {
                                            // set the timeout to trigger again in 3, 5, 7, or 9 seconds
                                            var millis = getRandomArrayElement(timeoutMillis);
                                            setTimeout(animateCollageCell, millis);
                                            });
                        });
   }