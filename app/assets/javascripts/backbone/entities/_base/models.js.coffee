@Envelope.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

	class Entities.Model extends Backbone.Model

		unauthorized: ->
			App.execute "unauthorized:request"
			App.execute "unauthorized"
			
		destroy: (options = {}) ->
			_.defaults options,
				wait: true
			
			@set _destroy: true
			super options
		
		isDestroyed: ->
			@get "_destroy"

		fetch: (options = {}) ->
			options.data = options.data || {}

			_.defaults options,
				cache: false

			_.defaults options.data,
				auth_token: App.user.auth_token
				client_application: App.clientApplication

			xhr = super options

			if options.cache
				xhr.done =>
					App.cache[@cacheName] = @

			xhr

		destroy: (options = {}) ->
			_.defaults options,
				processData: true

			options.data or= {}

			_.defaults options.data,
				auth_token: App.user.auth_token
				client_application: App.clientApplication

			super options

		save: (data = {}, options = {}) ->
			isNew = @isNew()
			
			_.defaults options,
				wait: true
				success: 	_.bind(@saveSuccess, @, isNew, options.collection)
				error:		_.bind(@saveError, @)

			_.defaults data,
				auth_token: App.user.auth_token
				client_application: App.clientApplication

			@unset "_errors"
			super data, options
		
		saveSuccess: (isNew, collection) =>
			if isNew ## model is being created
				collection.add @ if collection
				collection.trigger "model:created", @ if collection
				@trigger "created", @
			else ## model is being updated
				collection ?= @collection ## if model has collection property defined, use that if no collection option exists
				collection.trigger "model:updated", @ if collection
				@trigger "updated", @
		
		saveError: (model, xhr, options) =>
			## set errors directly on the model unless status returned was 500 or 404
			@set _errors: $.parseJSON(xhr.responseText)?.errors unless xhr.status is 500 or xhr.status is 404