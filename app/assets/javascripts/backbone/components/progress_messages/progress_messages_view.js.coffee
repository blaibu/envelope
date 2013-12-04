@Envelope.module "Components.ProgressMessages", (ProgressMessages, App, Backbone, Marionette, $, _) ->

	class ProgressMessages.Layout extends App.Views.Layout
		template: "progress_messages/layout"

		regions:
			progressMessageRegion: "#progress-message-region"
