#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerMoney', 40
    @newHand()

  newHand: =>
    if (@get 'deck').length < 10
      @set 'deck', new Deck()
      alert('Deck has been shuffled!')
    @set 'playerHand', (@get 'deck').dealPlayer()
    @set 'dealerHand', (@get 'deck').dealDealer()
    @set 'blackjack', false
    @trigger 'render'

    if @immediateBlackJack()
      @trigger 'disableButtons'

    # event triggers listed below
    (@get 'playerHand').on 'bust', => @trigger('disableButtons')
    (@get 'playerHand').on 'stand', =>
      @trigger('disableButtons')
      # built in delay between player finishing and dealer going
      setTimeout (@get 'dealerHand').play, 800

    (@get 'dealerHand').on 'bust', => (@get 'playerHand').status 'WIN!'
    (@get 'dealerHand').on 'stand', =>
      # to prevent overwriting player win, dealer bust statuses
      if (@get 'dealerHand').status() != 'BUSTS!'
        @figureOutWhoWon()

  figureOutWhoWon: =>
    player = @get 'playerHand'
    dealer = @get 'dealerHand'
    playerScore = player.scores()
    dealerScore = dealer.scores()
    if(playerScore > dealerScore)
      player.status 'WIN!'
      dealer.status 'loses!'
    else if(playerScore < dealerScore)
      player.status 'lose!'
      dealer.status 'WINS!'
    else
      player.status 'PUSH!'
      dealer.status 'PUSH!'

  immediateBlackJack: =>
    playerScore = (@get 'playerHand').scores()
    dealer = @get 'dealerHand'
    dealer.array[0].flip()

    if(dealer.array[1].get('value') == 1)
      dealerScore = (@get 'dealerHand').scores()
    else
      # console.log('Dealer not showing Ace!')

    if(playerScore == 21 and dealerScore == 21)
      (@get 'playerHand').status 'have Blackjack! Push!'
      (@get 'dealerHand').status 'has Blackjack! Push!'
      @set 'blackjack', true
      true
    else if(playerScore == 21)
      (@get 'playerHand').status 'have BLACKJACK! WINNER!'
      (@get 'dealerHand').status 'Loses!'
      @set 'blackjack', true
      true
    else if(dealerScore == 21)
      (@get 'playerHand').status 'Lose!'
      (@get 'dealerHand').status 'has BLACKJACK! WINNER!'
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
