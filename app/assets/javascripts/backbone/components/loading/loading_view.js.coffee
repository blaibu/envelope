@Envelope.module "Components.Loading", (Loading, App, Backbone, Marionette, $, _) ->

	class Loading.LoadingView extends App.Views.ItemView
		template: false
		className: "loading-container"

		onShow: ->
			opts = @_getOptions()
			@$el.spin opts

		onClose: ->
			@$el.spin false

		_getOptions: ->
			lines: 10
			length: 6
			width: 2.5
			radius: 7
			corners: 1
			rotate: 9
			direction: 1
			color: '#000'
			speed: 1
			trail: 60
			shadow: false
			hwaccel: true
			className: 'spinner'
			zIndex: 2e9
			top: 'auto'
			left: 'auto'

		class Loading.LoadingModal extends App.Views.ItemView
			template: false
			className: "modal-dialog"

			onShow: ->
				@$el.append("<div class='modal-content'><div style='padding:50px' class='modal-body'></div></div>")
				opts = @_getOptions()
				@$el.find(".modal-body").spin opts

			onClose: ->
				@$el.spin false

			_getOptions: ->
				lines: 10
				length: 6
				width: 2.5
				radius: 7
				corners: 1
				rotate: 9
				direction: 1
				color: '#000'
				speed: 1
				trail: 60
				shadow: false
				hwaccel: true
				className: 'spinner'
				zIndex: 2e9
				top: 'auto'
				left: 'auto'
