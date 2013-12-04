@Envelope.module "Components.Loading", (Loading, App, Backbone, Marionette, $, _) ->

	class Loading.Controller extends App.Controllers.Base

		initialize: (options) ->
			{ view, config, isModal } = options

			config = if _.isBoolean(config) then {} else config

			_.defaults config,
				loadingType: "spinner"
				entities: @getEntities(view)
				debug: false
				className: "loading-container"

			switch config.loadingType
				when "opacity"
					@region.currentView.$el.css "opacity", "0.5"
				when "spinner"
					loadingView = @getLoadingView config, isModal
					@show loadingView

			@showRealView view, loadingView, config
			
		showRealView: (realView, loadingView, config) ->
			App.execute "when:fetched", config.entities, =>
				switch config.loadingType
					when "opacity"
						@region.currentView.$el.css "opacity", "1.0"
					when "spinner"
						return realView.close() if !@region || @region.currentView isnt loadingView
	
				@show realView unless config.debug


		getEntities: (view) ->
			_.chain(view).pick("model","collection").toArray().compact().value()

		getLoadingView: (config, isModal) ->
			if isModal
				new Loading.LoadingModal
			else
				new Loading.LoadingView
					className: config.className

	App.commands.setHandler "show:loading", (view, options, isModal) ->
		new Loading.Controller
			view: view
			region: options.region
			config: options.loading
			isModal: isModal


