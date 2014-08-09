class window.Hand extends Backbone.Collection

  model: Card

  initialize: (@array, @deck, @isDealer) ->

  hit: =>
    console.log('hit')
    pop = @deck.pop() 
    @add(pop).last()
    if(pop == undefined)
      alert 'no more cards :('
    if @scores() == 21
      @stand()
    if @scores() > 21
      @status('BUST!')
      @trigger('bust')
      # trigger a bust event that disables the HIT button

  stand: ->
    @trigger('stand')

  play: =>
    @array[0].flip()
    # need to reveal first card, then do the following
    while(@scores() < 17)
      # console.log('inside play loop')
      @hit()
    @stand()

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false
    score = @reduce (score, card) ->
      score + if card.get 'revealed' then card.get 'value' else 0
    , 0
    if hasAce
      if score >= 21 then score
      else if score + 10 > 21 then score
      else score + 10
    else score

  status: (st) =>
    if st!= undefined
      @st = st
      @trigger('rerender')
    @st
