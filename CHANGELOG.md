### 1.2.0
- Now requires Dart 3.
- `BoardController` can now take `overlays` and `underlays` as parameters, and passes them through to `Board`.
- `BoardBuilder` now takes a parameter `forceSquareAlignment`, which defaults to true, and forces elements to be aligned to their squares (previously this was not the case).
- `SquareBuilder` functions (such as those used by `BoardBuilder`) now return `Widget?`, i.e. they can return null. `BoardBuilder` will build an empty container in this case.
- `BoardBuilder.index()`: a `BoardBuilder` that uses an index, rather than rank and file.
- `InputOverlay`: an easy way to support common gestures like right clicks and long presses.
- `SquareNumberOverlay`: an overlay for debugging that shows the square index.
- `LabelConfig` is now exported correctly with the rest of the package.

### 1.1.6
- `dragFeedbackSize` and `dragFeedbackOffset` parameters in `Hand` (thanks @callumbeaney).

### 1.1.5
- Fixed premoves not getting cleared when the board updates after a move, in `BoardController`.
- Fixed check/mate squares not being shown for moves where the check square is the same as the destination, as is the case for variants like king of the hill.

### 1.1.4
- Fixed janky resizing behaviour on web (thanks @deathcoder).
- Example: opponent type options (AI, random mover, human).

### 1.1.3
- Fixed breaking conflict between Flutter 3.7 and the Badges package.
- Now using Badges 3.0.x, but with the intent to drop the dependency and move to the material badge at some point.

### 1.1.2
- Fixed a bug that would result in incorrect piece selections for optional promotion moves, e.g. Grand Chess (thanks @malaschitz).
- `theme` parameter is now optional everywhere.

### 1.1.1
- Drag permissions changes: `Board` and `BoardPieces` now take a `dragPermissions` param that defines which piece colours can be dragged. `BoardController` implements behaviour that only allows the player's pieces to be dragged (as defined by `playState`).
- Board editor improvements in the example.
  
### 1.1.0
- The Xiangqi Update!
- `BoardConfig` - used to configure the way `BoardBackground` is drawn.
- Two Xiangqi piece sets and one background image.
- Parameter on `Board`/`BoardConfig`/`BoardPieces` to allow padding pieces within their squares - `piecePadding`.

### 1.0.5
- Fixed move string parsing for moves from ranks larger than 9 (thanks @malaschitz).
- Fixed duplicate pieces appearing in piece selector for castling gating moves.

### 1.0.4
- Rank and file labels on the board using `LabelOverlay`.
- Fixed a bug that would cause custom piece sets to sometimes be misaligned.
- `MarkerTheme.cross()` - marker that builds a cross in a square.

### 1.0.3
- Board editor page in example.
- Added a way for external dragged pieces (e.g. from board editor, hands) to land on pieces.
- Improvements to `Hand` widget.

### 1.0.2
- Support for overlays and underlays in `Board`.
- `BoardOverlay`, which draws widgets on squares, and `PieceOverlay`.
- `BoardController` now shows translucent premove promo/gate pieces.
- Fixed a bug that stopped white playing hand drops.
- Fixed various bugs with colours of pieces in selectors.
- `BoardState.player` is now `turn`, for clarity.

### 1.0.1
- Fixed piece selectors not closing after premoves.
- Premoves can now be cancelled by selecting another square.
- `MarkerTheme.corners()` - piece marker that draws triangles in the corners of the square.
- `BoardController.promotionBehaviour` - this allows different behaviours to be specified: always show the selector (default), always auto select the best piece, or auto select only for premoves.
- `BoardController.pieceHierarchy` - allows the relative hierarchy of pieces to be specified, for use in auto promotion and ordering the pieces in the selector.

### 1.0.0
- Major refactor with improved stability, better performance and better organised code.
- Board is now composed of separate background, target and piece layers.
- BoardController has better composed logic.
- There are many breaking changes here, but if you're exclusively using `BoardController` you will likely only run into a few parameter name changes. `Board` has changed completely.

### 0.4.0
- Reworked promotion logic.
- Supported flex gating variants like Seirawan chess.
- Added a new simple example, using the `square_bishop` package.

### 0.3.4
- Added `dragFeedbackOffset` parameter.
- Documented some more things.

### 0.3.3
- Added `dragFeedbackSize` - customise the size of dragged pieces
- Prevented pieces from being simultaneously draggable multiple times on multitouch devices
- Added a start from position option to the example

### 0.3.2
- Fixed some piece widgets not filling their entire square
- PieceSet.text and PieceSet.letters now take `style` as an optional parameter
- Added an SVG piece set to the example

### 0.3.1
- Fixed pieces with no moves not being selectable
- Added ability to choose player colour in example project

### 0.3.0
- Now works with flutter web!
- Removed flutter_svg and replaced merida set with png images
- Move animations
- Fixed piece dragging
- HighlightThemes - customise the decorations that highlighted squares have
- Improved example
- Board orientation now works as expected

### 0.2.3
- Added some documentation
- *draggable* option for boards (allows for view-only boards)
- Piece count badge visual options for hands

### 0.2.2
- Promotion improvements
- Dragging improvements
- Piece scaling improvements
- Promotion premoves
- Hands & dropping

### 0.2.1
- Fixed dynamic piece sizing for non-svg widgets
- Fixed some issues with premoves

### 0.2.0
- Initial release
