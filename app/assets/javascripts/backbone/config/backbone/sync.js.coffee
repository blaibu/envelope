do (Backbone) ->
	_sync = Backbone.sync

	Backbone.sync = (method, entity, options = {}) ->
		_.defaults options,
			beforeSend: _.bind(methods.beforeSend, 	entity)
			complete:	_.bind(methods.complete,	entity)

		sync = _sync(method, entity, options)
		if !entity._fetch and method is "read"
			entity._fetch = sync

		sync
	
	methods =
		beforeSend: ->
			@trigger "sync:start", @
		
		complete: (jqxhr, err) ->
			if jqxhr.status == 401 && jqxhr.responseJSON?.error_code == "unauthorized bad token"
				@unauthorized()

			@trigger "sync:stop", @