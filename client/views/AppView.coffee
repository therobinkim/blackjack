class window.AppView extends Backbone.View

  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button> <button class="new-button">New Hand</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '
  events:
    "click .hit-button": -> @model.get('playerHand').hit()
    "click .stand-button": -> @model.get('playerHand').stand()

    # enable all buttons
    # get new hands for PLAYER and DEALER
    # recreate bust listener to disable HIT button
    "click .new-button": -> @model.newHand()

  initialize: =>
    # if BUST or STAND, then disable action button
    @model.on 'disableButtons', => @disableButtons()
    @model.on 'render', =>  @render()
    @render()

  disableButtons: ->
    $('.hit-button').attr('disabled', 'disabled')
    $('.stand-button').attr('disabled', 'disabled')

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @player = new HandView(collection: @model.get 'playerHand')
    @dealer = new HandView(collection: @model.get 'dealerHand')
    @$('.player-hand-container').html @player.el
    @$('.dealer-hand-container').html @dealer.el
