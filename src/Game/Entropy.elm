module Game.Entropy exposing (prodMult)

-- some math utils
atanh : Float -> Float
atanh x =
    (logBase e ((1.0+x) / (1.0-x))) / 2.0

-- entropy multipliers computation

-- multiplicative malus of automated production on current entropy
-- currentEntropy -> maxEntropy -> prodMult
prodMult : Float -> Float -> Float
prodMult e maxe =
    if e < maxe then (1.0 / (1.0 + (atanh (e/maxe)))) else 0.0
