module Game.Objects exposing (..)

type Level
    = Planetary
    | Stellar
    | Interstellar
    | Galactic
    | Universal

initialLevel: Level
initialLevel = Planetary

allLevels: List Level
allLevels = [ Planetary, Stellar, Interstellar, Galactic, Universal ]

levelNumber: Level -> Int
levelNumber l = case l of
    Planetary -> 1
    Stellar -> 2
    Interstellar -> 3
    Galactic -> 4
    Universal -> 5

type Building
    = SawMill
    | Quarry
    | Mine
    | Laboratory

type Technology
    = Thermodynamics

type TechnologyState
    = Locked
    | Unlocked
    | Researched


