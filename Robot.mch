/* Robot
* Author: NUVIN
* Creation date: 18/12/2022
*/
MACHINE
    Robot
    
INCLUDES 
    Maze
    
PROMOTES
    getPosition, 
    foundExit, 
    hasVisitedSquare, 
    robotsRoute,
    resetMaze
    
SETS
    REPORT_MESSAGE = {
        Move_Viable,
        Move_Blocked_By_Internal_Wall,
        Move_Blocked_By_Maze_Boundary,
        Teleport_Viable,
        Teleport_Blocked_By_Internal_Wall,
        Teleport_Blocked_By_Maze_Boundary,
        Exit_Teleport_Illegal,
        Robot_Already_At_Exit
    }
    
VARIABLES
    coordX, 
    coordY
    
INVARIANT
    coordX : dom(validSquares) & 
    coordY : ran(validSquares) 
    
INITIALISATION
    coordX,coordY :=  prj1(NATURAL1,NATURAL1)(entranceSquare) , prj2(NATURAL1,NATURAL1)(entranceSquare) 
    
OPERATIONS
    // move NORTH operation
    moveStatus <-- MoveNorth = 
    IF (coordX |-> coordY) /= exitSquare
    THEN
        IF ((coordX |-> (coordY + 1)) : validSquares)
        THEN 
            coordY := (coordY + 1) ||
            updatePath((coordX |-> (coordY + 1))) ||
            moveStatus := Move_Viable
        ELSIF (coordX |-> (coordY + 1)) : internalWalls
        THEN 
            moveStatus := Move_Blocked_By_Internal_Wall
        ELSE 
            moveStatus := Move_Blocked_By_Maze_Boundary
        END
    ELSE
        moveStatus := Robot_Already_At_Exit
    END;
    
    // move EAST operation
    moveStatus  <-- MoveEast = 
    IF (coordX |-> coordY) /= exitSquare
    THEN
        IF (((coordX + 1) |-> coordY) : validSquares)
        THEN 
            coordX := (coordX + 1) 
            ||
            updatePath(((coordX + 1) |-> coordY))
            ||
            moveStatus := Move_Viable
        ELSIF ((coordX + 1) |-> coordY) : internalWalls
        THEN 
            moveStatus := Move_Blocked_By_Internal_Wall
        ELSE 
            moveStatus := Move_Blocked_By_Maze_Boundary
        END
    ELSE
        moveStatus := Robot_Already_At_Exit
    END;
    
    // move SOUTH operation
    moveStatus <-- MoveSouth = 
    IF (coordX |-> coordY) /= exitSquare
    THEN
        IF ((coordX |-> (coordY - 1)) : validSquares)
        THEN 
            coordY := (coordY - 1) ||
            updatePath((coordX |-> (coordY - 1))) ||
            moveStatus := Move_Viable
        ELSIF (coordX |-> (coordY - 1)) : internalWalls
        THEN 
            moveStatus := Move_Blocked_By_Internal_Wall
        ELSE 
            moveStatus := Move_Blocked_By_Maze_Boundary
        END
    ELSE
        moveStatus := Robot_Already_At_Exit
    END;
    
    // move WEST operation
    moveStatus  <--  MoveWest = 
    IF (coordX |-> coordY) /= exitSquare
    THEN
        IF (((coordX - 1) |-> coordY) : validSquares)
        THEN 
            coordX := (coordX - 1) ||
            updatePath(((coordX - 1) |-> coordY))||
            moveStatus := Move_Viable
        ELSIF ((coordX - 1) |-> coordY) : internalWalls
        THEN 
            moveStatus := Move_Blocked_By_Internal_Wall
        ELSE 
            moveStatus := Move_Blocked_By_Maze_Boundary
        END
    ELSE
        moveStatus := Robot_Already_At_Exit
    END;
    
    // teleport robot operation
    teleportStatus <-- Teleport(targetXCoord, targetYCoord) = 
    PRE 
        targetXCoord : NATURAL & targetYCoord : NATURAL
    THEN
        IF (coordX |-> coordY) /= exitSquare
        THEN
            IF ((targetXCoord |-> targetYCoord) : validSquares & (targetXCoord |-> targetYCoord) /= exitSquare)
            THEN 
                coordX := targetXCoord || 
                coordY := targetYCoord ||
                updatePath((targetXCoord |-> targetYCoord))||
                teleportStatus := Teleport_Viable
            ELSIF (targetXCoord |-> targetYCoord) : internalWalls
            THEN 
                teleportStatus := Teleport_Blocked_By_Internal_Wall
            ELSIF((targetXCoord |-> targetYCoord) = exitSquare)
            THEN
                teleportStatus := Exit_Teleport_Illegal
            ELSE        
                teleportStatus := Teleport_Blocked_By_Maze_Boundary
            END
        ELSE
            teleportStatus := Robot_Already_At_Exit
        END
    END;
    
    // reset robot & maze operation
    Reset = 
    BEGIN
        coordX,coordY :=  prj1(NATURAL1,NATURAL1)(entranceSquare) , prj2(NATURAL1,NATURAL1)(entranceSquare) || 
        resetMaze
    END
    
    
END
