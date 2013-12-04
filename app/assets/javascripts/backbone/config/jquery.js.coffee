do ($) ->
	$.fn.toggleWrapper = (obj = {}, init = true) ->
		_.defaults obj,
			className: ""
			backgroundColor: "rgb(100,100,100)"
			zIndex: 999999999

		$offset = @offset()
		$offset.top -= 15
		$offset.left -= 15
		$width 	= @outerWidth(false) + 30
		$height = @outerHeight(false) + 30
		
		if init
			$("<div>")
				.appendTo("body")
					.addClass(obj.className)
						.attr("data-wrapper", true)
							.css
								width: $width
								height: $height 
								top: $offset.top
								left: $offset.left
								position: "absolute"
								zIndex: obj.zIndex + 1
								backgroundColor: obj.backgroundColor
		else
			$("[data-wrapper]").remove()