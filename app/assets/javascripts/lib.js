function form_to_json(e){
  e.preventDefault();
  return $(e.currentTarget).toObject({rails: true});
}

$(".attach-text-box").hide();
$('.attach-message').click(function(e){
	{e.preventDefault(); 
				if (!$(".attach-text-box").is(':visible')) 
					$('.attach-text-box').show('fast');}
});
