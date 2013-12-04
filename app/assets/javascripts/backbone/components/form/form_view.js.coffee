@Envelope.module "Components.Form", (Form, App, Backbone, Marionette, $, _) ->
	
	class Form.FormWrapper extends App.Views.Layout
		template: "form/form"
		
		tagName: "form"
		attributes: ->
			"data-type": @getFormDataType()
			"datatype-ignore":"true"
		
		regions:
			formContentRegion: "#form-content-region"
			formErrorRegion: "#form-error-region"
		
		ui:
			buttonContainer: "ul.inline-list"
		
		triggers:
			"submit" : "form:submit"
			"click [data-form-button='cancel']"	: "form:cancel"
		
		modelEvents:
			"sync:start"	 :	"syncStart"
			"sync:stop"		 :	"syncStop"
			"sync:error"	 :  "syncError"
			"sync:success" :  "syncSuccess"
		
		initialize: (options) ->
			@options = options
			@errorMap = options.config.errorMap
			@errorHighlighting = options.config.errorHighlighting || {}
			@successMessage = options.config.successMessage
			@clearOnSuccess = options.config.clearOnSuccess
			# loop through and copy all contentView's events and event handlers
			# and let form wrapper listen to events
			for key, value of @options.contentView.events
				@[value] = _.bind(@options.contentView[value], @options.contentView)
			@events = @options.contentView.events
			#clear events on the content view and call delegate events
			# to rebind events with an empty events hash (so that events are only fired on form view)
			@options.contentView.events = {}
			@options.contentView.delegateEvents()

			@setInstancePropertiesFor "config", "buttons"
			@$el.addClass(@config.className)

		serializeData: ->
			footer: @config.footer
			buttons: @buttons?.toJSON() ? false
		
		onShow: ->
			_.defer =>
				@setupFlatUIJS()
				@$('input, textarea').placeholder();
				@focusFirstInput() if @config.focusFirstInput
				@buttonPlacement() if @buttons
				

		setupFlatUIJS: ->
			@$('[data-toggle="radio"]').each ->
				$(@).radio()

			@$('[data-toggle="checkbox"]').each ->
  			$(@).checkbox();

			@$("select").selectpicker
				style: 'btn btn-primary'
				menuStyle: 'dropdown'

		
		buttonPlacement: ->
			@ui.buttonContainer.addClass @buttons.placement
			@ui.buttonContainer.find("button").addClass @buttons.size
		
		focusFirstInput: ->
			if App.clientApplication.browser != "IE"
				@$(":input:visible:enabled:first").focus()
		
		getFormDataType: ->
			if @model.isNew() then "new" else "edit"
		
		changeErrors: (model, errors, options) ->
			if @config.errors
				if _.isEmpty(errors) then @removeErrors() else @addErrors errors
		
		removeErrors: ->
			@$(".error").removeClass("error").find("small").remove()
			@$("#form-error-region").addClass('hidden')

		removeErrorHighlighting: ->
			if @config.errorHighlighting
				@$(".has-error").removeClass("has-error")

		syncSuccess: ->
			if @successMessage
				@$("#form-error-region").addClass('hidden') unless @$("form-error-region").hasClass('hidden')
				@$("#form-success-region").html(@successMessage).removeClass('hidden')
			if @clearOnSuccess
				@$("input[type='text'], textarea", @formContentRegion.$el).each ->
					$(@).val ''
			if @config.modalOptions?.disableExitOnSubmit
				App.modalRegion.enableExit()
			if @progressMessage
				@progressMessage.clear()

		syncError: (error_code, data) ->
			errHandler = @errorMap[error_code]
			if typeof errHandler == "function"
				errMsg = errHandler.call @options.contentView, data
			else
				errMsg = errHandler
				
			errMsg = @errorMap['default'] unless errMsg		
			errMsg = "There was an error" unless errMsg
			@$("#form-success-region").addClass('hidden') unless @$("form-success-region").hasClass('hidden')
			@$("#form-error-region").html(errMsg).removeClass('hidden')

			@removeErrorHighlighting()
			if errHighlighterSelector = @errorHighlighting[error_code]
				if typeof errHighlighterSelector == "function"
					errHighlighterSelector = errHighlighterSelector.call @options.contentView, data
				@options.contentView.$el.find(errHighlighterSelector).addClass('has-error')

			if @config.modalOptions?.disableExitOnSubmit
				App.modalRegion.enableExit()
			if @progressMessage
				@progressMessage.clear()

		addErrors: (errors = {}) ->
			for name, array of errors
				@addError name, array[0]
		
		addError: (name, error) ->
			el = @$("[name='#{name}']")
			sm = $("<small>").text(error)
			el.after(sm).closest(".row").addClass("error")

		onClose: ->
			if @config.modalOptions?.disableExitOnSubmit
				App.modalRegion.enableExit()
			if @progressMessage
				@progressMessage.clear()
			else
				@addOpacityWrapper(false) if @config.syncing
		
		syncStart: (model) ->
			@$("#form-error-region").addClass('hidden') unless @$("form-error-region").hasClass('hidden')
			@removeErrorHighlighting()
			if @config.modalOptions?.disableExitOnSubmit
				App.modalRegion.disableExit()
			if @config.progressMessages
				@progressMessage = App.request "new:progress:messages", @formContentRegion.$el, @formContentRegion.currentView.$el, @config.progressMessages.messages
				@progressMessage.show()
				if @config.modalOptions?.disableExitOnSubmit
					App.vent.on "progress:messages:finished", ->
						App.modalRegion.enableExit()
			else
				@addOpacityWrapper() if @config.syncing
		
		syncStop: (model) ->
			if @config.modalOptions?.disableExitOnSubmit
				App.modalRegion.enableExit()
			if @progressMessage
				@progressMessage.clear()
			else
				@addOpacityWrapper(false) if @config.syncing


