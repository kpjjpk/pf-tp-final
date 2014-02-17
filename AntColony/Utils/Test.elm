module AntColony.Utils.Test where

import open AntColony.Utils.List
import open AntColony.Utils.Tuple
import open AntColony.Utils.Maybe
import open AntColony.Utils.SignalFunction

import open AntColony.Geography.Coords
import open AntColony.Geography.Direction

import open AntColony.Model.Terrain
import open AntColony.Model.Scent
import open AntColony.Model.AntT

import open AntColony.Logic.Perceiving
import open AntColony.Logic.LoadSensing
--import open AntColony.Logic.Loading
import open AntColony.Logic.Moving
import open AntColony.Logic.Rotating
import open AntColony.Logic.Scenting
import open AntColony.Logic.Seeing
import open AntColony.Logic.Smelling

import open AntColony.Model.AntT
import open AntColony.Model.AntNestT
import open AntColony.Model.Food
import open AntColony.Model.Scent

--step : SF (Float, Maybe(T.Terrain)) (Maybe(T.Terrain))
--step = (arr snd)                    -- : SF (Float, Maybe(T.Terrain)) (Maybe(T.Terrain))
--        >>> 

setWidthMF : (Maybe(Terrain)) -> (Maybe(Terrain))
setWidthMF mbterr = mbterr
                     >>= (\terrain -> return (terrainMF 15 (height terrain) (toList terrain)))


--move : Terrain -> Coords -> Coords -> Maybe(Terrain)
moveMF : Coords -> Coords -> (Maybe(Terrain)) -> (Maybe(Terrain))
moveMF from to mbterr = let move' terrain = move terrain from to
                         in
                            mbterr              -- : Maybe(Terrain)
                             >>= (move')        -- : Terrain -> Maybe(Terrain,Occupant)

--evict : Terrain -> Coords -> Maybe(Terrain, Occupant)
evictMF : Coords -> (Maybe(Terrain)) -> (Maybe(Terrain))
evictMF coords mbterr = let evict' terrain = evict terrain coords
                         in
                            mbterr              -- : Maybe(Terrain)
                             >>= (evict')       -- : Terrain -> Maybe(Terrain,Occupant)
                             >>= (return . fst) -- : (Terrain, Occupant) -> Maybe(Terrain)


--occupy : Terrain -> Coords -> Occupant -> Maybe(Terrain)
occupyMF : Coords -> Occupant -> (Maybe(Terrain)) -> (Maybe(Terrain))
occupyMF whr occ mbterr = let occupy' terrain = occupy terrain whr occ
                           in
                              mbterr
                               >>= occupy'