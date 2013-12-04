@Envelope.module "Views", (Views, App, Backbone, Marionette, $, _) ->

	class Views.Layout extends Marionette.Layout

		initialize: (options) ->
			super(options)
			@options = _.omit options, ['model', 'collection', 'el', 'id', 'attributes', 'className', 'tagName', 'events']