@Envelope.module "Components.Form", (Form, App, Backbone, Marionette, $, _) ->
	
	class Form.Controller extends App.Controllers.Base
		
		initialize: (options = {}) ->
			@contentView = options.view
			@formLayout = @getFormLayout options.config

			@listenTo @formLayout, "show", @formContentRegion
			@listenTo @formLayout, "form:submit", @formSubmit
			@listenTo @formLayout, "form:cancel", @formCancel
		
		formCancel: ->
			@contentView.triggerMethod "form:cancel"
		
		formSubmit: ->
			@contentView.model.rawPassword = @formLayout.$el.find("input[type=password]").val()
			data = Backbone.Syphon.serialize @formLayout
			data = @formLayout.config.afterSerialize data, @contentView.model

			if @contentView.triggerMethod("form:submit", data) isnt false
				model = @contentView.model
				collection = @contentView.collection

				@processFormSubmit data, model, collection
		
		processFormSubmit: (data, model, collection) ->

			model.on "invalid", (m, error_code) ->
				m.trigger("sync:error", error_code, data)

			model.on "sync", (m, resp, options) =>
				m.trigger "sync:success"

			model.save data,
				collection: collection,
				error: (model, xhr, options) =>
					if xhr.responseJSON
						error_code = xhr.responseJSON.error_code
						data = xhr.responseJSON.data
					else
						error_code = "default"
						data = {}
					model.trigger("sync:error", error_code, data)
		
		onClose: ->
		
		formContentRegion: ->
			@region = @formLayout.formContentRegion
			@show @contentView
		
		getFormLayout: (options = {}) ->
			config = @getDefaultConfig _.result(@contentView, "form")
			_.extend config, options			
			buttons = @getButtons config.buttons

			new Form.FormWrapper
				config: config
				model: @contentView.model
				buttons: buttons
				contentView: @contentView
		
		getDefaultConfig: (config = {}) ->
			_.defaults config,
				footer: true
				focusFirstInput: true
				errors: true
				syncing: true
				afterSerialize: (data) ->
					data
		
		getButtons: (buttons = {}) ->
			App.request("form:button:entities", buttons, @contentView.model) unless buttons is false
	
	App.reqres.setHandler "form:wrapper", (contentView, options = {}) ->
		throw new Error "No model found inside of form's contentView" unless contentView.model
		formController = new Form.Controller
			view: contentView
			config: options
		formController.formLayout