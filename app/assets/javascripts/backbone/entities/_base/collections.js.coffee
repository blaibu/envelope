@Envelope.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
	
	class Entities.Collection extends Backbone.PageableCollection

		unauthorized: ->
			App.execute "unauthorized:request"
			App.execute "unauthorized"

		fetch: (options = {}) ->
			options.data = options.data || {}
			
			_.defaults options.data,
				auth_token: App.user.auth_token
				client_application: App.clientApplication

			super options

