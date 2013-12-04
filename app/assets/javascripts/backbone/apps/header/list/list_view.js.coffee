@Envelope.module "HeaderApp.List", (List, App, Backbone, Marionette, $, _) ->
	
	class List.Header extends App.Views.ItemView
		template: "header/list/home_header"

		modelEvents: ->
			"change": "render"

		className: "navbar navbar-inverse navbar-fixed-top"