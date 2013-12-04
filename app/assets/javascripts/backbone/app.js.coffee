@Envelope = do (Backbone, Marionette) ->

	App = new Marionette.Application

	console.log("app", App);

	App.on "initialize:before", (options) ->
		console.log "initializing"
		App.rootRoute = "dashboard"

	App.addRegions
		headerRegion:	"#header-region"
		mainRegion:		"#main-region"
		breadcrumbRegion: "#breadcrumb-region"
		flashRegion: "#flash-region"
		modalRegion:	Marionette.Region.Modal.extend el: "#modal-region"

	App.reqres.setHandler "default:region", ->
		App.mainRegion

	App.addInitializer ->
		console.log "calling header app start"
		App.module("HeaderApp").start()

	App.commands.setHandler "register:instance", (instance, id) ->
		App.register instance, id if App.environment is "development"

	App.commands.setHandler "unregister:instance", (instance, id) ->
		App.unregister instance, id if App.environment is "development"

	App.commands.setHandler "unauthorized", (options = {}) ->
		App.vent.trigger "unauthorized"
		App.user = {}
		appStorage.removeItem("auth_token")
		App.cache = {}
		App.module("HeaderApp").trigger("refresh")
		_.defaults options,
			redirect: "login"
		App.navigate(options.redirect, trigger: true)

	App.commands.setHandler "authorized", (options) ->
		App.user = {auth_token: options.auth_token}
		appStorage.setItem("has_authorized", true)
		appStorage.setItem("auth_token", App.user.auth_token)
		App.module("HeaderApp").trigger("refresh")
		if options.redirect
			App.navigate(options.redirect, trigger: true)

	App.on "initialize:after", (options) ->
		console.log "initialize after called"
		@startHistory()
		@navigate(@rootRoute, trigger: true) unless @getCurrentRoute()

	console.log "sup"
	App