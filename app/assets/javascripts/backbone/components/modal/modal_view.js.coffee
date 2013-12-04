@Envelope.module "Components.Modal", (Modal, App, Backbone, Marionette, $, _) ->

	class Modal.ModalWrapper extends App.Views.Layout
		template: "modal/modal"

		regions:
			modalContentRegion: "#modal-content-region"

		initialize: (options) ->
			@options = options
			@config = options.config

		serializeData: ->
			data = {}
			data.hideFooter = @config.hideFooter
			data.title = @config.title || ''
			data.columnWidth = @config.columnWidth || 4
			data.columnOffset = @config.columnOffset || 4
			data