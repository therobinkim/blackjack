#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerMoney', 40
    @newHand()

  newHand: ->
    @set 'playerHand', (@get 'deck').dealPlayer()
    @set 'dealerHand', (@get 'deck').dealDealer()
    (@get 'playerHand').on 'bust', =>
      @trigger('playerBust')
    (@get 'playerHand').on 'stand', =>
      @trigger('playerStand')
      (@get 'dealerHand').play()
    (@get 'dealerHand').on 'bust', =>
      @trigger('dealerBust')
    (@get 'dealerHand').on 'stand', =>
      @trigger('dealerStand')
      # figure out who won and set their statuses
    @immediateBlackJack()

  immediateBlackJack: =>
    playerScore = (@get 'playerHand').scores()[1]
    dealerScore = (@get 'dealerHand').scores()[1]
    if(playerScore == 21 and dealerScore == 21)
      (@get 'playerHand').status 'BLACKJACK! PUSH!'
      (@get 'dealerHand').status 'BLACKJACK! PUSH!'
    else if(playerScore == 21)
      (@get 'playerHand').status 'BLACKJACK!'
      (@get 'dealerHand').status 'Loses!'
    else if(dealerScore == 21)
      (@get 'playerHand').status 'Lose!'
      (@get 'dealerHand').status 'BLACKJACK!'


    # TO DO FEATURE!!
    # on new hand, if deck size is <= 20%, then shuffle deck!