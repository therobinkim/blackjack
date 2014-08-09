model = new App()
view = new AppView(model: model)

view.$el.appendTo 'body'

# if somebody is dealt a blackjack, disable the buttons
# this logic must be here because we must wait for the AppView
# to be added to the DOM tree
if model.get 'blackjack'
  view.disableButtons()
