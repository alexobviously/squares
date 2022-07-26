### 1.0.1
- `MarkerTheme.corners()` - piece marker that draws triangles in the corners of the square.
- Fixed piece selectors not closing on premoves.
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
