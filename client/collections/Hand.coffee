class window.Hand extends Backbone.Collection

  model: Card

  initialize: (@array, @deck, @isDealer) ->

  hit: =>
    pop = @deck.pop()
    @add(pop).last()
    if @scores() == 21
      @stand()
    if @scores() > 21
      if(@isDealer) then @status 'BUSTS!' else @status 'BUST!'
      @trigger('bust')
      # trigger a bust event that disables the HIT button

  stand: ->
    @trigger('stand')

  play: =>
    @array[0].flip()
    # need to reveal first card, then do the following
    while(@scores() < 17)
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
    # this logic deals with when dealer has a hidden ace
    if @isDealer and hasAce and (@.at(0).get 'value') == 1 and (@.at(0).get 'revealed') == false
      score
    else
      if hasAce
        if score >= 21 then score
        else if score + 10 > 21 then score
        # if flipped card is ace, DON'T ADD 10!
        else score + 10
      else
        score

  status: (st) =>
    if st!= undefined
      @st = st
      @trigger('rerender')
    @st
