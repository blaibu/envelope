@Envelope.module "Views", (Views, App, Backbone, Marionette, $, _) ->

	_remove = Marionette.View::remove

	_.extend Marionette.View::,

		addOpacityWrapper: (init = true) ->
			@$el.toggleWrapper
				className: "opacity"
			, init

			if init
				@$el.spin @_getOptions()
			else
				@$el.spin false

		_getOptions: ->
			lines: 10
			length: 25
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

		setInstancePropertiesFor: (args...) ->
			for key, val of _.pick(@options, args...)
				@[key] = val

		remove: (args...) ->
			if @model?.isDestroyed?()

				wrapper = @$el.toggleWrapper
					className: "opacity"
					backgroundColor: "red"

				wrapper.fadeOut 400, ->
					$(@).remove()

				@$el.fadeOut 400, =>
					_remove.apply @, args
			else
				_remove.apply @, args

		templateHelpers: ->
			linkTo: (name, url, options = {}) ->
				_.defaults options,
					external: false

				url = "#" + url unless options.external

				"a <href='#{url}'>#{@escape(name)}</a>"