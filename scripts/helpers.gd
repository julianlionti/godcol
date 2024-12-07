class_name Helpers extends Node

func generate_board(rows: int, cols: int) -> Array:
	var board : Array[Array]  = []
	var cell_id = 1
	for r in rows:
		var row : Array[BoardCell] = []
		for c in cols:
			row.append(BoardCell.new(0, 0, cell_id))
			cell_id += 1
			
		board.append(row)
	return board

func generate_matrix(rows: int, cols: int, numbers:int = 6) -> Array[Piece]:
	var matrix : Array[Piece] = []
	for i in range(rows):
		var row : Array[int] = []
		for j in range(cols):
			row.append((randi() % numbers) + 1)
		matrix.append(Piece.new(row,i))
	return matrix
	
func flatten(array: Array):
	var result = []
	for element in array:
		if typeof(element) == TYPE_ARRAY:
			result += flatten(element)
		else:
			result.append(element)
	return result

func shift_array(array:Array) -> Array:
	if array.size() > 0:
		var last_element = array.pop_back()
		array.insert(0, last_element)
	return array

func shift_down_values(board:Array, winning_combinations:Array):
	for coords in winning_combinations:
		for cell in coords:
			var x = cell[1]
			var y = cell[0]
	
	# Shift down values and colors from rows above
	for combination in winning_combinations:
		for cell in combination:
			for i in range(cell[0], 0, -1):
				board[i][cell[1]].value = board[i - 1][cell[1]].value
				board[i][cell[1]].color = board[i - 1][cell[1]].color
				
			board[0][cell[1]].value = 0
			board[0][cell[1]].color = 0
			
func get_board_indices(position: Vector2i, start_position: Vector2i) -> Vector2i:
	var row = round((position.y - start_position.y) / 32.0)
	var col = round((position.x - start_position.x) / 32.0)

	return Vector2i(row, col)
	
func update_board_configuration(board:Array, position:Vector2i, colors: Array) -> void:
	for i in range(colors.size()):
		board[position.x + i - 1][position.y - 1]["value"] = 1
		board[position.x + i - 1][position.y - 1]["color"] = colors[i]
			
func get_winning_combo(board:Array, combo_multiplier = 1):
	var winning_combo = []
	#var points = 0

	# Check rows and columns
	for i in range(board.size()):
		for j in range(board[i].size()):
			if board[i][j].value == 1:
				# Check row
				if j < board[i].size() - 2 and board[i][j].color == board[i][j + 1].color and board[i][j].color == board[i][j + 2].color:
					winning_combo.append([[i, j], [i, j + 1], [i, j + 2]])
					#points += 1 * combo_multiplier  # Add points for each combination
					
				# Check column
				if i < board.size() - 2 and board[i][j].color == board[i + 1][j].color and board[i][j].color == board[i + 2][j].color:
					winning_combo.append([[i, j], [i + 1, j], [i + 2, j]])
					#points += 1 * combo_multiplier  # Add points for each combination
					

				
	return winning_combo
