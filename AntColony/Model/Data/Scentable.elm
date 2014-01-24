module AntColony.Model.Data.Scentable where

type Pheromone = Int

type Scentable a = { a | scent : Maybe(Pheromone) }

scent : Scentable a -> Scentable a
scent scentable = let scent' = case scentable.scent of
                                    Nothing -> 1
                                    Just sc -> sc + 1
                   in 
                      { scentable | scent <- Just scent' }

unscent : Scentable a -> Maybe(Scentable a)
unscent scentable = case scentable.scent of
                         Nothing -> Nothing
                         Just sc -> if sc > 0
                                    then Just { scentable | scent <- Just sc }
                                    else Nothing