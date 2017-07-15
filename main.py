import itertools

def in_map(pos, w, h):
    x, y = pos
    return 0 <= x < w and 0 <= y < h

def is_block(pos, the_map):
    x, y = pos
    return the_map[y][x][1] == '#'

def not_visited(pos, the_map):
    x, y = pos
    return the_map[y][x][0] == 'f'

def adjacents(the_map, pos):
    """
    Return the list of nodes that are not visited
    and space to walk.
    """
    x,y = pos
    w = len(the_map[0])
    h = len(the_map)
    neighbours = [ (x, y+1), (x+1, y), (x-1, y), (x, y-1) ]
    return [pos for pos in neighbours if in_map(pos, w, h) and
            not_visited(pos, the_map) and not is_block(pos, the_map)]

def is_outcome(pos, w, h):
    x, y = pos
    return x==0 or x==w-1 or y==0 or y==h-1


def get_outcome(init_pos, the_map):
    result = []
    def check_neighbours(pos, the_map, outcomes=None):
        h = len(the_map)
        w = len(the_map[0])
        for (x,y) in adjacents(the_map, pos):
            the_map[y][x]=('t', the_map[y][x][1])
            if is_outcome((x,y), w, h):
                outcomes.append((x,y))
            check_neighbours((x,y), the_map, outcomes=outcomes)
    check_neighbours(init_pos, the_map, outcomes=result)
    result.sort()
    return result

def solve(the_map, x, y):
    outcomes = get_outcome((x,y), the_map)
    print(len(outcomes))
    for outcome in outcomes:
        if outcome == (x,y):
            continue
        else:
            print(*outcome, sep=' ')

def test():
    the_map =[ "###########"
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
    the_map = [ list(zip(itertools.repeat('f'), x)) for x in the_map ]
    w = len(the_map[0])
    h = len(the_map)
    solve(the_map, 5, 5)

def main():
    w,h=map(int, input().split())
    x,y=map(int, input().split())
    the_map = [list(zip(itertools.repeat('f'), input())) for k in range(h)]
    solve(the_map, x, y)

main = test
if __name__=='__main__':
    main()
