@Envelope.module "DashboardApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Controller extends App.Controllers.Base
		initialize: ->
			console.log("initializing");
			@dashboardView = @getDashboardView()
			@show @dashboardView

		getDashboardView: ->
			new Show.Dashboard

		breadcrumbRegion: ->
			App.execute "update:breadcrumb", [{
					text:"Dashboard",
					class:"active",
					icon: "fui-home"
				}]