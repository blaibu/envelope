@Envelope.module "HeaderApp", (HeaderApp, App, Backbone, Marionette, $, _) ->
	@startWithParent = false
	
	API =
		list: ->
			console.log "list called"
			new HeaderApp.List.Controller
				region: App.headerRegion
	
	HeaderApp.on "start", ->
		console.log "starting header"
		API.list()

	HeaderApp.on "refresh", ->
		API.list()