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
      # built in delay between player finishing and dealer going
      setTimeout (@get 'dealerHand').play, 800

    (@get 'dealerHand').on 'bust', =>
      (@get 'playerHand').status('WIN!')
      @trigger('dealerBust')
    (@get 'dealerHand').on 'stand', =>
      if((@get 'dealerHand').status() != 'BUST!')
        @trigger('dealerStand')
        @figureOutWhoWon()
    @immediateBlackJack()

  figureOutWhoWon: =>
    player = @get 'playerHand'
    dealer = @get 'dealerHand'
    playerScore = player.scores()
    dealerScore = dealer.scores()
    if(playerScore > dealerScore)
      player.status 'WIN!'
      dealer.status 'Loses!'
    else if(playerScore < dealerScore)
      player.status 'Lose!'
      dealer.status 'Wins!'
    else
      player.status 'Push!'
      dealer.status 'Push!'

  immediateBlackJack: =>
    playerScore = (@get 'playerHand').scores()
    dealer = @get 'dealerHand'
    dealer.array[0].flip()
    if(dealer.array[1].get('value') == 1)
      dealerScore = (@get 'dealerHand').scores()
    else
      console.log('DEALER NOT SHOWING ACE!')
    if(playerScore == 21 and dealerScore == 21)
      (@get 'playerHand').status 'Blackjack! Push!'
      (@get 'dealerHand').status 'Blackjack! Push!'
    else if(playerScore == 21)
      (@get 'playerHand').status 'BLACKJACK!'
      (@get 'dealerHand').status 'Loses!'
    else if(dealerScore == 21)
      (@get 'playerHand').status 'Lose!'
      (@get 'dealerHand').status 'BLACKJACK!'
    else
      (@get 'dealerHand').array[0].flip()


    # TO DO FEATURE!!
    # on new hand, if deck size is <= 20%, then shuffle deck!