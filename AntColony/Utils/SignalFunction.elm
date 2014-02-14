module AntColony.Utils.SignalFunction where

import open Signal
import open List
import open AntColony.Utils.Tuple
import open AntColony.Utils.Maybe

data SF a b = SF (a -> b) (Signal a -> Signal b) | Switch 

arr : (a -> b) -> SF a b
arr f = SF f (lift f)

(>>>) : SF a b -> SF b c -> SF a c
(SF f1 _) >>> (SF f2 _) = arr (f2 . f1)

(<<<) : SF b c -> SF a b -> SF a c
sf1 <<< sf2 = sf2 >>> sf1

(>>^) : SF b c -> (c->d) -> SF b d
sf >>^ f = sf >>> (arr f)

(<<^) : SF c d -> (b -> c) -> SF b d
sf <<^ f = (arr f) >>> sf

--(&) : (a -> b) -> (a -> c) -> a -> (b,c)
--f1 & f2 = \x -> (f1 x, f2 x)

(&&&) : SF a b -> SF a c -> SF a (b,c)
(SF f1 _) &&& (SF f2 _) = arr (f1 & f2)

(***) : SF b c -> SF b' c' -> SF (b, b') (c, c')
f *** g = (arr fst >>> f) &&& (arr snd >>> g)

identity : SF a a
identity = arr id

first : SF b c -> SF (b,d) (c,d)
first sf1 = sf1 *** identity

second : SF a b -> SF (c,a) (c,b)
second sf1 = identity *** sf1

--The force is strong in this one. Seems to be right though
loop : SF (b,d) (c,d) -> SF b c
loop (SF f sf) = let loop' f b = let (c,d) = f (b,d) in c
                  in
                     arr (loop' f)

--type Event e = Maybe e

--switch : SF a (b,Event c) -> (c -> SF a b) -> SF a b
--switch sf1 f = let f' event = case event of
--                                   Nothing -> (sf1, event) -- (SF a b, Event c)
--                                   Just c -> (f c, event)  -- (SF a b, Event c)

--                   --(b, Event c)
--                in
--                   (second arr f') -- SF (a, Event c) (SF a b, Event c)
--                   >>> (\sf, event -> sf)
--                   >>> 

----                   loop 



                   --sf1 >>> (second switch')

--es un switch y el event es que la lista este vacia!
--despues podes hacer loop (switch (tu f de listas))

parB : [SF a b] -> SF a [b]
parB sfs = let f' : SF a b -> SF a [b] -> SF a [b]
               f' sf1 sf2 = (sf1 &&& sf2) >>> (arr (\(x,xs)->x::xs))
            in
               case sfs of
                    [sf] -> sf >>> (arr (\x -> [x]))
                    (sf::sfs') -> f' sf (parB sfs')