@Envelope.module "DashboardApp", (DashboardApp, App, Backbone, Marionette, $, _) ->
	@startWithParent = false
	
	class DashboardApp.Router extends Marionette.AppRouter
		appRoutes:
			"dashboard"	: "show"

	API =
		show: ->
			console.log "called show"
			new DashboardApp.Show.Controller
	
	App.addInitializer ->
		new DashboardApp.Router
			controller: API