class App.Collections.CountSessions extends Backbone.Collection
  model: App.Models.CountSession
  url: ->
    "/api/projects/#{masterRouter.projects.getCurrentProjectId()}/count_sessions"
  initialize: ->
    @bind "reset", @loadCountsIntoSegments
  selected: ->
    @filter (cs) -> cs.get 'selected'
  selectAll: ->
    @each (cs) -> cs.select()
  selectNone: ->
    @each (cs) -> cs.deselect()
  arrayForDataTables: ->
    # columns: start, duration (minutes), total count
    array = []
    @each (cs) =>
      # only include the CountSession's that are finished
      # otherwise this will refresh after NewCountSessionModal completes 
      # and creates a new CountSession that is in progress and incomplete
      if cs.get('stop')
        array.push [
          cs.id
          cs.get('segment_id')
          cs.get('start')
          cs.get('duration')
          cs.get('user_id')
          cs.get('counts_count')
          if !cs.get('selected') then false else cs.get('selected')
        ]
    return array
  loadCountsIntoSegments: ->
    # TODO: cache this computation by version number
    masterRouter.segments.each (s) =>
      s.set
        measuredClass: 0 # reset the coloring
    countTotals = masterRouter.count_sessions.pluck('counts_count')
    min = _.min countTotals
    max = _.max countTotals
    fullRange = max - min
    classRange = fullRange / 5
    breaks = [min, min + classRange, min + classRange * 2, min + classRange * 3, min + classRange * 2, max]
    masterRouter.count_sessions.each (cs) =>
      value = cs.get('counts_count')
      for i in [1..breaks.length]
        if value <= breaks[i]
          b = i
          break
      masterRouter.segments.get(cs.get('segment_id')).set
        measuredClass: b    
    # # reloading SegmentLayer will draw the coloring
    # masterRouter.segment_layer.layer.reload()