module Entropy exposing (costMult, prodMult)

-- some math utils
atanh : Float -> Float
atanh x =
    (logBase e ((1.0+x) / (1.0-x))) / 2.0

-- entropy multipliers computation

-- multicative cost depending on current entropy
-- currentEntropy -> maxEntropy -> costMult
costMult : Float -> Float -> Float
costMult e maxe =
    if e < maxe then (atanh (e/maxe) * maxe) + 1.0 else 1.0/0.0

-- multiplicative malus of automated production on current entropy
-- currentEntropy -> maxEntropy -> prodMult
prodMult : Float -> Float -> Float
prodMult e maxe =
    if e < maxe then sqrt ((e/maxe) / atanh (e/maxe)) else 0.0
