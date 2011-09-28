class App.Views.GeoPointLayer extends Backbone.View
  initialize: ->
    @geoPointDefaultRadius = @options.geoPointDefaultRadius
    @geoPointSelectedRadius = @options.geoPointSelectedRadius
    @geoPointConnectedRadius = @options.geoPointConnectedRadius
    
    @render()
    @geo_points = @options.geo_points
    @geo_points.bind 'reset',   @render, this
    @geo_points.bind 'add',     @render, this
    @geo_points.bind 'remove',  @render, this
    @geo_points.bind 'change',  @render, this
  drawFeatures: (e) ->
    for f in e.features
      c = f.element
      g = f.element = po.svg("g")
    
      g.setAttribute "transform", c.getAttribute("transform")
    
      c.setAttribute "class", "geo-point-circle"
      c.setAttribute "id", "geo-point-circle-#{f.data.cid}"
      if location.hash.startsWith "#project/#{masterRouter.projects.getCurrentProjectId()}/map/geo_point/#{f.data.cid}"
        c.setAttribute "r", masterRouter.geo_point_layer.geoPointSelectedRadius
        c.setAttribute "class", "geo-point-circle selected"
      else if location.hash.startsWith "#project/#{masterRouter.projects.getCurrentProjectId()}/map/geo_point/connect/#{f.data.cid}"
        c.setAttribute "r", masterRouter.geo_point_layer.geoPointConnectedRadius
        c.setAttribute "class", "geo-point-circle connected"
      else
        c.setAttribute "r", masterRouter.geo_point_layer.geoPointDefaultRadius
        
      if masterRouter.geo_points.getByCid(f.data.cid)?.get("markedForDelete")?
        $(c).remove()
      else
        $(c).bind "click", (event) ->
           cid = event.currentTarget.id.split('-').pop()
           masterRouter.geo_points.getByCid(cid).toggle()
  render: ->
    $('#geo-point-layer').remove()
    layer = po.geoJson()
              .features(masterRouter.geo_points.geojson().features)
              .id("geo-point-layer")
              .tile(false)
              .scale("fixed")
              .on "load", @drawFeatures   
    map.add(layer)
  # add: (model) ->
  #   # TODO: http://groups.google.com/group/d3-js/browse_thread/thread/b2009ed9afc05974
  # remove: (model) ->
  #   $("#geo-point-circle-#{model.cid}").remove()
  setGeoPointDefaultRadius: (geoPointDefaultRadius) ->
    @geoPointDefaultRadius = geoPointDefaultRadius
    @render()
  setGeoPointSelectedRadius: (geoPointSelectedRadius) ->
    @geoPointSelectedRadius = geoPointSelectedRadius
    @render()
  setGeoPointConnectedRadius: (geoPointConnectedRadius) ->
    @geoPointConnectedRadius = geoPointConnectedRadius
    @render()