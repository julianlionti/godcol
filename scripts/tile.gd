class_name Tile extends CharacterBody2D

signal piece_placed(position, colors)

@export var snap_speed = 60 

@onready var tile_timer = $TileTimer
@onready var collisionShape = $CollisionShape2D
	
var is_disabled = false
var is_solidificate = false
var is_moving = false
var colors:Array[int]

var board: Array
var board_position: Vector2i


var helpers = Helpers.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent_player: Player = get_parent()
	parent_player.winning_combination.connect(_on_winning_combination_detected)
	parent_player.board_update.connect(_on_board_update)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move()
	update()

func update() -> void:
	for row in colors.size():
		$TileMapLayer.set_cell(Vector2i(0,row),0,Vector2i(colors[row],0))

func move() -> void:
	if is_moving or is_solidificate:
		return

	var next_velocity = Vector2.ZERO

	if Input.is_action_just_pressed("move_right"):
		next_velocity.x += Shared.TILE_SIZE * snap_speed
	elif Input.is_action_just_pressed("move_left"):
		next_velocity.x -= Shared.TILE_SIZE * snap_speed
	elif Input.is_action_just_pressed("move_down"):
		next_velocity.y += Shared.TILE_SIZE * snap_speed
	#elif Input.is_action_just_pressed("move_up"):
		#next_velocity.y -= Shared.TILE_SIZE * snap_speed
	elif Input.is_action_just_pressed("rotate"):
		colors = helpers.shift_array(colors)

	if next_velocity != Vector2.ZERO:
		move_with_velocity(next_velocity)
		


func move_with_velocity(next_velocity:Vector2i, skip_moving=false):
	is_moving = not skip_moving
	velocity = next_velocity
	var collision = move_and_slide()

	if collision:
		var slide_count = get_slide_collision_count()
		for i in slide_count:
			var collision_info = get_slide_collision(i)
			var collision_normal = collision_info.get_normal()
			is_solidificate = collision_normal.is_equal_approx(Vector2.UP)
		
	is_moving = false		
	if is_solidificate and not is_disabled:
			solidify_tile()

func solidify_tile() -> void:
	piece_placed.emit(position,colors)
	set_physics_process(false)
	is_disabled = true
	#print(collisionShape.transform)


func _on_tile_timer_timeout() -> void:
	var next_velocity = Vector2.ZERO
	next_velocity.y += Shared.TILE_SIZE * snap_speed
	move_with_velocity(next_velocity, true)
	
func _on_board_update(_board) -> void:
	board = _board
	
func _on_winning_combination_detected(winning):
	print("winning")
