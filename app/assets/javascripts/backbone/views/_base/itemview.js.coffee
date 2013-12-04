@Envelope.module "Views", (Views, App, Backbone, Marionette, $, _) ->

	class Views.ItemView extends Marionette.ItemView

		initialize: (options) ->
			super(options)
			@options = _.omit options, ['model', 'collection', 'el', 'id', 'attributes', 'className', 'tagName', 'events']