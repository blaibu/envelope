@Envelope.module "HeaderApp.List", (List, App, Backbone, Marionette, $, _) ->
	
	class List.Controller extends App.Controllers.Base
		
		initialize: ->
			console.log "initialized headerapp"
			@headerView = @getHeaderView()
			
			@show @headerView

		getHeaderView: (user) ->
			new List.Header
				model: user