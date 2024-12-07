extends Node2D

@export var total_pieces:int = 200 

@onready var helpers = Helpers.new()
@onready var player:Player = $Player



var pieces: Array[Piece]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pieces = helpers.generate_matrix(total_pieces, 3, 6)
	player.pieces = pieces


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_game_timer_timeout() -> void:
	player.initiate()
