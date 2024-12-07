class_name Player extends Node2D

signal winning_combination(winning_combo)
signal board_update(board)


@export var tile_scene: PackedScene

var helpers = Helpers.new()
var pieces:Array[Piece]

var current_piece_index:int = 0
var current_piece:Piece
var current_tile: Tile

var is_game_over = false

var board:Array = helpers.generate_board(13, 6)
var winning_combos : Array[Array] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func game_over(): 
	is_game_over = true 	
	

func initiate() -> void:
	current_piece = pieces[current_piece_index]
	var tile: Tile = tile_scene.instantiate()
	tile.piece_placed.connect(on_pice_placed)
	tile.colors = current_piece.colors
	tile.position = Vector2i(32 * 6,0)
	
	current_tile = tile

	add_child(tile)

func on_pice_placed(position, colors):
	var board_postion = helpers.get_board_indices(position, get_node("Board").global_position)
	if board_postion.x < 0:
		game_over()
		pass
	else:
		current_tile.board_position = board_postion
		helpers.update_board_configuration(board, board_postion, colors)
		
		var winning_combo = helpers.get_winning_combo(board)
		if winning_combo.size() > 0:
			winning_combos.append(winning_combo)
			winning_combination.emit(winning_combo)
			helpers.shift_down_values(board, winning_combo)
		
		board_update.emit(board)
		
		current_piece_index = (current_piece_index + 1) % pieces.size()
		initiate() 
	
