/* Maze
* Author: NUVIN
* Creation date: 18/12/2022
*/
MACHINE
    Maze
    
SETS
    MAZE_MESSAGE = {Yes, No, Internal_Wall_NA, Invalid_Error}
    
CONSTANTS
    entranceSquare,
    exitSquare,
    mazeBoundry,
    internalWalls,
    validSquares
    
PROPERTIES
    mazeBoundry: POW (NATURAL1 * NATURAL1) &
    mazeBoundry = { xx, yy | 
        xx : NATURAL1 & 
        yy : NATURAL1 & 
        xx <= 7 & 
        yy <= 5 } &
    
    internalWalls <: mazeBoundry &
    internalWalls = {(1 |-> 3), (2 |-> 3), (2 |-> 5), (2 |-> 1), (4 |-> 2), (4 |-> 3), (4 |-> 4), (3 |-> 3), (6 |-> 1), (6 |-> 2), (6 |-> 4), (7 |-> 4)} &
    
    validSquares = mazeBoundry - internalWalls &
    
    entranceSquare: validSquares & 
    entranceSquare = (1 |-> 1) &
    
    exitSquare: validSquares & 
    exitSquare = (1 |-> 5) 
    
VARIABLES
    visitedPath,
    squareCord
    
INVARIANT
    squareCord: validSquares &
    visitedPath: seq(INTEGER * INTEGER)
    
INITIALISATION
    squareCord, visitedPath := entranceSquare, []
    
OPERATIONS
    // keeps track of the path the robot has taken
    updatePath(squareCoordinate)  =
    PRE
        squareCoordinate : validSquares
    THEN
        squareCord := squareCoordinate ||
        visitedPath := visitedPath <- squareCord
    END;
    
    // extract the current square coordinates of the robot
    position <-- getPosition  =
    BEGIN 
        position := squareCord
    END;
    
    // checks if robot has found the exit
    isExitFound <-- foundExit  =
    IF (squareCord = exitSquare) 
    THEN
        isExitFound := Yes
    ELSE
        isExitFound := No
    END;
    
    // checks if the square has already been visited
    isVisitedSquare <-- hasVisitedSquare (xCord, yCord) =
    PRE
        xCord : dom(validSquares) & yCord: ran(validSquares) & ((xCord |-> yCord) : validSquares)
    THEN
        IF ((xCord |-> yCord) : validSquares)
            
        THEN
            IF ((xCord |-> yCord) : ran(visitedPath)) 
            THEN
                isVisitedSquare := Yes
            ELSE
                isVisitedSquare := No
            END
        ELSE
            isVisitedSquare := Internal_Wall_NA
        END
    END;
    
    // returns the route the robot took
    route <-- robotsRoute =
    BEGIN 
        route := visitedPath
    END;
    
    // resets the maze variables
    resetMaze = 
    BEGIN
        squareCord, visitedPath := entranceSquare, []
    END
    
END
