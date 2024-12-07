class_name Pieces extends Node2D

var board
@onready var player: Player
@onready var piecesTileMapLayer  = $PiecesTileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_parent()
	player.board_update.connect(_on_board_updated)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update()
	pass

func update():
	if not board: return
	for row in range(board.size()):
		for col in range(board[row].size()):
			var cell = board[row][col]
			if cell.value == 1:
				piecesTileMapLayer.set_cell(Vector2i(col, row),0, Vector2i(cell.color,0))
	
func _on_board_updated(_board):
	board = _board
