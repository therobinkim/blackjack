#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerMoney', 40
    @newHand()

  newHand: =>
    if (@get 'deck').length < 10
      @set 'deck', new Deck()
      console.log 'new deck'
    @set 'playerHand', (@get 'deck').dealPlayer()
    @set 'dealerHand', (@get 'deck').dealDealer()
    @set 'blackjack', false
    @trigger 'render'

    (@get 'playerHand').on 'bust', => @trigger('disableButtons')
    (@get 'playerHand').on 'stand', =>
      @trigger('disableButtons')
      # built in delay between player finishing and dealer going
      setTimeout (@get 'dealerHand').play, 800

    (@get 'dealerHand').on 'bust', =>
      (@get 'playerHand').status 'WIN!'
      @trigger('dealerBust')
    (@get 'dealerHand').on 'stand', =>
      if (@get 'dealerHand').status() != 'BUST!'
        @trigger('dealerStand')
        @figureOutWhoWon()
    if @immediateBlackJack()
      @trigger 'disableButtons'

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
      # console.log('Dealer not showing Ace!')

    if(playerScore == 21 and dealerScore == 21)
      (@get 'playerHand').status 'Blackjack! Push!'
      (@get 'dealerHand').status 'Blackjack! Push!'
      @set 'blackjack', true
      true
    else if(playerScore == 21)
      (@get 'playerHand').status 'BLACKJACK!'
      (@get 'dealerHand').status 'Loses!'
      @set 'blackjack', true
      true
    else if(dealerScore == 21)
      (@get 'playerHand').status 'Lose!'
      (@get 'dealerHand').status 'BLACKJACK!'
      @set 'blackjack', true
      true
    else
      (@get 'dealerHand').array[0].flip()
      false

    # TO DO FEATURE!!
    # on new hand, if deck size is <= 20%, then shuffle deck!

    # BUGS!
    # when dealer is hiding a card, dealer's score shows incorrectly
    # (especially with an Ace)
