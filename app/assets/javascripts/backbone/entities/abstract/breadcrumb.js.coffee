@Envelope.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
	
	class Entities.Breadcrumb extends Entities.Model

	class Entities.BreadcrumbCollection extends Entities.Collection
		model: Entities.Breadcrumb
	

	App.reqres.setHandler "new:breadcrumb:collection", ->
		new Entities.BreadcrumbCollection