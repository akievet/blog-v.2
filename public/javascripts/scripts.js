// **** NAV BAR **** //

var didScroll;
var lastScrollTop = 0;
var delta = 5;
var navbarHeight = $('nav').outerHeight();


$(window).scroll(function(event){
	didScroll = true;
});

setInterval(function(){
	if (didScroll){
		hasScrolled();
		didScroll = false;
	}
}, 250);

function hasScrolled(){
	var st = $(this).scrollTop();
	if(Math.abs(lastScrollTop - st) <= delta)
		return;
	if (st > lastScrollTop && st > navbarHeight){
		$('nav').removeClass('nav-down').addClass('nav-up');
	}else{
		if(st + $(window).height() < $(document).height()){
			$('nav').removeClass('nav-up').addClass('nav-down');
		}
	}
	lastScrollTop = st;
}


// **** TAGS **** //

function getTagState(){
	var $postShowPath = $('form.edit-post').attr('action');
	$.ajax({
		method: 'GET',
		url: $postShowPath + '/tags',
		dataType: 'json',
		success: renderTags
	});

	function renderTags(data){
		console.log(data);
		var $currentTagsArray = data.current_tags;
		var $otherTagsArray = data.other_tags;
		tagsToHtml($currentTagsArray, $otherTagsArray);
	}

	function tagsToHtml(currentTags, otherTags){
		var $tagList = $('ul.edit-tags');
		$tagList.empty();
		currentTags.forEach(function(tag){
			var $li = $("<li class='current-tag' id=" + tag.id + ">").text(tag.word);
			var $button = $("<button onclick='removeTag(" + tag.id + ")'>&times</button>");
			$li.append($button);
			$tagList.append($li);
		});
		otherTags.forEach(function(tag){
			var $li = $("<li class='other-tag' id=" + tag.id + ">").text(tag.word);
			var $button = $("<button onclick='addTag(" + tag.id + ")'> </button>");
			$li.append($button);
			$tagList.append($li);
		});
	}

}

function removeTag(tagId){
	var $postShowPath = $('form.edit-post').attr('action');
	$.ajax({
		method: 'DELETE',
		url: $postShowPath + '/tags',
		dataType: 'json',
		data: {tagId: tagId},
		success: function(data){
			console.log(data);
			getTagState();
		}
	});
}

function addTag(tagId){
	var $postShowPath = $('form.edit-post').attr('action');
	$.ajax({
		method: 'POST',
		url: $postShowPath + '/tags',
		dataType: 'json',
		data: {tagId: tagId},
		success: function(data){
			console.log(data);
			getTagState();
		}
	});
}

























