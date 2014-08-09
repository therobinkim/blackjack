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
    "click .new-button": ->
      $('button').removeAttr('disabled')
      @model.newHand();
      @render()

  initialize: ->
    # if BUST or STAND, then disable action button
    @model.on 'playerBust', => @disableButtons()
    @model.on 'playerStand', => @disableButtons()
    @render()

  disableButtons: ->
    $('.hit-button').attr('disabled', 'disabled')
    $('.stand-button').attr('disabled', 'disabled')

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
