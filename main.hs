import System.IO
import Control.Monad
import Data.Maybe
import qualified Data.Set as Set

type Coord = (Int, Int) -- (x,y coordinate)
type Tile = Char
type Labyrinth = [[Tile]]

get2Tuple :: IO (Int, Int)
get2Tuple = (fromMaybe (0,0) . tuplify2) . words <$> getLine

tuplify2 :: (Read t, Read t1) => [String] -> Maybe (t1, t)
tuplify2 [] = Nothing
tuplify2 [_] = Nothing
tuplify2 (a:b:_) = Just (read a, read b)

realstuff ::IO ()
realstuff = do
    hSetBuffering stdout NoBuffering
    (theMap, startPoint) <- readData
    let outcomes = filterResult theMap startPoint
    print (length outcomes)
    ptRes outcomes
    return ()

filterResult :: Labyrinth -> Coord ->[Coord]
filterResult theMap start = filter (start /=) allResults where
    allResults = Set.toAscList $ Set.fromList ( getOutcomes [start] theMap Set.empty)

readData :: IO (Labyrinth, Coord)
readData = do
    (_, h)  <- get2Tuple
    (startX, startY) <- get2Tuple
    theMap <- replicateM h getLine
    return (theMap, (startX, startY))


getOutcomes :: [Coord] -> Labyrinth -> Set.Set Coord -> [Coord]
getOutcomes [] _ _ = []
getOutcomes (tile:xs) maze visited
    | isOutcome tile maze = tile:recursive_call
    | otherwise = recursive_call where
        recursive_call = getOutcomes (xs++neighs) maze (Set.insert tile visited) where
            neighs = Prelude.filter (isNotBlock maze) $ getNeighbours maze tile visited

getNeighbours :: Labyrinth -> Coord -> Set.Set Coord -> [Coord]
getNeighbours maze pos visited = Prelude.filter (not.flip Set.member visited) (getAdjacentNodes pos (length maze, length (head maze)))

isOutcome :: Coord -> Labyrinth -> Bool
isOutcome (x,y) maze = y==0 || y==length maze - 1 || x==0  || (length . head) maze - 1 == x

getAdjacentNodes :: Coord -> Coord -> [Coord]
getAdjacentNodes (c, r) (w, h) = do
    (c', r') <- [(c+1,r),(c,r+1),(c-1,r),(c,r-1)]
    guard ( and [0<=c', c'<w, r'>=0, r'<h] )
    return (c',r')

isNotBlock :: Labyrinth -> Coord -> Bool
isNotBlock maze pos = getNode maze pos /= '#'

getNode :: Labyrinth -> Coord -> Tile
getNode theMap coord = theMap !! snd coord !! fst coord

ptRes :: [Coord] -> IO ()
ptRes = mapM_ putStrLn . map (\(x,y)-> show x ++" "++ show y)

test :: IO ()
test = do
    let maze=[ "###########"
              ,"......#...#"
              ,"#.###.###.#"
              ,"#...#.....#"
              ,"#.#.#######"
              ,"#.#...#...#"
              ,"#####.###.#"
              ,"#...#.....#"
              ,"#.#######.#"
              ,"#.........."
              ,"###########" ]
    let result = filterResult maze (5, 5)
    print (length result)
    ptRes result
    return ()

{- pick the one you want to execute -}
main = test
-- main = realstuff
