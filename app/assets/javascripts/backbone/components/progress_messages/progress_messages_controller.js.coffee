@Envelope.module "Components.ProgressMessages", (ProgressMessages, App, Backbone, Marionette, $, _) ->

	class ProgressMessages.Controller extends App.Controllers.Base

		initialize: (options) ->
			@currentElement = options.currentElement
			@parentElement = options.parentElement
			@messages = options.messages

		getLayout: ->
			new ProgressMessages.Layout

		changeMessage: (message) ->
			$(@layout.progressMessageRegion.el).html message

		show: ->
			@layout = @getLayout()
			@layout.render()

			@currentElement.hide()
			@parentElement.parent().after(@layout.$el)
			if @messages && @messages.length > 0
				@changeMessage(@messages[0])
				i = 1
				@interval = setInterval(
					=>
						@changeMessage(@messages[i])
						i += 1
						if i == @messages.length
							clearInterval(@interval)
							App.vent.trigger "progress:messages:finished"
					5000
				)

		clear: ->
			clearInterval(@interval)
			@layout.$el.remove()
			@currentElement.show()

	# could make this more generic in future
	# requires parent element id to insert view after
	# and hide current form region immediately to be replaced with progress view
	App.reqres.setHandler "new:progress:messages", (parentElement, currentElement, messages) ->
		new ProgressMessages.Controller
			parentElement: parentElement
			currentElement: currentElement
			messages: messages


