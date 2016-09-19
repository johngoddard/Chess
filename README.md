# Chess

This is a terminal based implementation of chess that allows users to play against 2 levels of computer AI opponents. 

## User Interface

The chess game is played entirely in the terminal. Users can use the arrows keys to select a piece to move.
After selecting a piece, valid moves are highlighted. After each move, methods run to check if the board is in check or checkmate and game announcements are displayed when appropriate. 

## Computer opponents & AI

There are 2 differnt AI players a human player can play against. Both AIs have a system for scoring the board that take into account the following factors: 
- Material differences
- Threatened pieces (of both colors)
- Checks/checkmates
- Control of the center of the board
- Open movement lanes for pieces

The level 1 computer evaluates each of it's possible moves, and chooses the move with highest score. 

The level 2 computer player uses MiniMax looking 1 turn out, choosing the move where its opponent's best response is the weakest. 

## Future directions 

There are still a few pieces I'd like to add: 

- I'd like to make it easier to start a game and choose your opponent type / color from the command line
- I'd also like to start tweaking my board-scoring metric to take into account more advanced things like pawn structure
- Advanced moves (castling / en passant)
- A more targeted AI system: looking 1 move ahead MiniMax is slow, and looking any further ahead is intractable. I'd like to more research into how other common chess AIs work 
