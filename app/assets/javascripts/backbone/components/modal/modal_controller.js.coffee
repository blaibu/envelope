@Envelope.module "Components.Modal", (Modal, App, Backbone, Marionette, $, _) ->

	class Modal.Controller extends App.Controllers.Base

		initialize: (options = {}) ->
			@contentView = options.view
			@modalLayout = @getModalLayout options.config

			@listenTo @modalLayout, "show", =>
				@modalContentRegion()

			@modalLayout

		modalContentRegion: ->
			@region = @modalLayout.modalContentRegion
			@show @contentView

		getModalLayout: (options = {}) ->
			config = @getDefaultConfig _.result(@contentView, "modal")

			_.extend config, options

			new Modal.ModalWrapper
				config: config
				model: @contentView.model

		getDefaultConfig: (config = {}) ->
			_.defaults config,
				footer: true

	App.reqres.setHandler "modal:wrapper", (contentView, options = {}) ->
		modalController = new Modal.Controller
			view: contentView
			config: options
		modalController.modalLayout