@Envelope.module "Controllers", (Controllers, App, Backbone, Marionette, $, _) ->

	class Controllers.Base extends Marionette.Controller

		constructor: (options = {}) ->
			if options.authenticate_user && !App.user?.auth_token
				App.execute "unauthorized", { redirect: options.authenticate_user }
				console.log "execute unauthorized"
				return

			if options.logged_in && App.user?.auth_token
				App.execute "authorized", { redirect: options.logged_in, auth_token: App.user.auth_token }
				return

			@region = options.region or App.request "default:region"
			super options
			@_instance_id = _.uniqueId("controller")
			App.execute "register:instance", @, @_instance_id

		close: (args...) ->
			delete @region
			delete @options
			super args
			App.execute "unregister:instance", @, @_instance_id

		show: (view, options = {}) ->
				_.defaults options,
					loading: false
					region: @region

				@_setMainView view
				@_manageView view, options

		_setMainView: (view) ->
			return if @_mainView
			@_mainView = view
			@listenTo view, "close", @close

		_manageView: (view, options) ->
			if options.loading
				App.execute "show:loading", view, options, @region == App.modalRegion
			else
				options.region.show view