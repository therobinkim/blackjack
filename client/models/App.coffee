#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

    (@get 'playerHand').on 'bust', => @trigger('playerBust')
    (@get 'playerHand').on 'stand', => @trigger('playerStand')

  newHand: ->
    @set 'playerHand', (@get 'deck').dealPlayer()
    # I think the playerHand changes, so I need to recreate the trigger
    @set 'dealerHand', (@get 'deck').dealDealer()
    (@get 'playerHand').on 'bust', => @trigger('playerBust')
    (@get 'playerHand').on 'stand', => @trigger('playerStand')

    # TO DO FEATURE!!
    # on new hand, if deck size is <= 20%, then shuffle deck!