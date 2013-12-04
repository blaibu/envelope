do (Backbone, Marionette) ->

	class Marionette.Region.Modal extends Marionette.Region

		constructor: ->
			_.extend @, Backbone.Events

		onShow: (view) ->
			@setupBindings view

			options = {}
			defaultOptions =
				backdrop: true
				keyboard: true

			if view?.modalOptions
				options = view.modalOptions

			@options = _.defaults options, defaultOptions

			@$el.modal
				backdrop: @options.backdrop
				keyboard: @options.keyboard
				show: true

			@$el.on 'hidden.bs.modal', =>
				@closeModal()

			@$el.on "click", "a.modal-close", (e) =>
				@hideModal()	

		setupBindings: (view) ->
			@listenTo view, "modal:close", @hideModal

		hideModal: ->
			if @$el
				@$el.modal('hide')

		closeModal: ->
			@stopListening()
			@close()

		disableExit: ->
			@$el.find('*[data-dismiss="modal"]').each (i, el) ->
				$(el).addClass('hidden') unless $(el).hasClass('hidden')
			@$el.data('bs.modal').options.backdrop = "static"
			@$el.data('bs.modal').options.keyboard = "false"
			@$el.data('bs.modal').escape()

		enableExit: ->
			@$el.find('*[data-dismiss="modal"]').each (i, el) ->
				$(el).removeClass('hidden')
			@$el.data('bs.modal').options.backdrop = true
			@$el.data('bs.modal').options.keyboard = true
			@$el.data('bs.modal').escape()



