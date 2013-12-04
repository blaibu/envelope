@Envelope.module "DashboardApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Dashboard extends App.Views.Layout
		template: "dashboard/show/show"
		className: "col-xs-12"