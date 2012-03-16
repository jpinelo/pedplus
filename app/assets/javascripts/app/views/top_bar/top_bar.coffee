class App.Views.TopBar extends Backbone.View
  template: JST["app/templates/top_bar/top_bar"]
  render: (mode) ->
    $('#top-bar').empty().html @template
      currentProject: masterRouter.projects.getCurrentProject()
      currentUser: masterRouter.users.getCurrentUser()
    $("##{mode}-pill").addClass('active')

    # activate tooltips (which are used to mark unactivated PedPlus 
    # tabs and the map tab pill, when user doesn't have map permission)
    $("[rel=tooltip]").tooltip
      placement: 'right'

    $('#dashboard-link').click (event) =>
    	bootbox.confirm "Do you want to exit and return to the dashboard?", (confirmed) =>
	    	window.location.href = "/" if confirmed

    $('#user-settings-link').click (event) =>
      userSettingsModal = new App.Views.UserSettingsModal
        user: masterRouter.users.getCurrentUser()

    $('#management-link').click (event) =>
    	bootbox.confirm "Do you want to exit and proceed to the management interface?", (confirmed) =>
	    	window.location.href = "/manage" if confirmed

    $('#sign-out-link').click (event) =>
    	bootbox.confirm "Do you want to exit and sign out?", (confirmed) =>
	    	window.location.href = "/users/sign_out" if confirmed