extends Node

# 信号
signal note_hit(note_type: String, timing_accuracy: float)
signal note_missed()

# 判定设置
var perfect_window = 50.0  # 完美判定窗口（像素）
var good_window = 100.0    # 良好判定窗口（像素）
var hit_zone_x = 1000.0    # 击打区域X坐标

# 输入映射
var don_keys = ["z", "x"]  # 红色音符按键
var ka_keys = ["c", "v"]   # 蓝色音符按键

func _ready():
	# 设置输入映射
	setup_input_map()

func setup_input_map():
	# 创建输入动作
	if not InputMap.has_action("drum_don"):
		InputMap.add_action("drum_don")
		var event1 = InputEventKey.new()
		event1.keycode = KEY_Z
		InputMap.action_add_event("drum_don", event1)
		var event2 = InputEventKey.new()
		event2.keycode = KEY_X
		InputMap.action_add_event("drum_don", event2)
	
	if not InputMap.has_action("drum_ka"):
		InputMap.add_action("drum_ka")
		var event3 = InputEventKey.new()
		event3.keycode = KEY_C
		InputMap.action_add_event("drum_ka", event3)
		var event4 = InputEventKey.new()
		event4.keycode = KEY_V
		InputMap.action_add_event("drum_ka", event4)

func _input(event):
	if event.is_action_pressed("drum_don"):
		handle_drum_hit(Note.NoteType.DON)
	elif event.is_action_pressed("drum_ka"):
		handle_drum_hit(Note.NoteType.KA)

func handle_drum_hit(input_type: Note.NoteType):
	# 查找最近的匹配音符
	var closest_note = find_closest_matching_note(input_type)
	
	if closest_note:
		var distance = closest_note.get_distance_to_hit_zone()
		
		if distance <= good_window:
			# 计算准确度
			var accuracy = calculate_accuracy(distance)
			
			# 击中音符
			closest_note.hit()
			
			# 发送信号
			var note_type_string = "DON" if input_type == Note.NoteType.DON else "KA"
			note_hit.emit(note_type_string, accuracy)
		else:
			# 未命中
			note_missed.emit()
	else:
		# 没有找到匹配的音符
		note_missed.emit()

func find_closest_matching_note(note_type: Note.NoteType) -> Note:
	var notes = get_tree().get_nodes_in_group("notes")
	var closest_note: Note = null
	var closest_distance = INF
	
	for note in notes:
		if note is Note and note.note_type == note_type and not note.is_hit:
			var distance = note.get_distance_to_hit_zone()
			if distance < closest_distance and distance <= good_window:
				closest_distance = distance
				closest_note = note
	
	return closest_note

func calculate_accuracy(distance: float) -> float:
	# 根据距离计算准确度 (0.0 - 1.0)
	if distance <= perfect_window:
		return 1.0  # 完美
	elif distance <= good_window:
		return 1.0 - (distance - perfect_window) / (good_window - perfect_window)
	else:
		return 0.0  # 未命中

func _process(delta):
	# 检查是否有音符错过了击打区域
	check_missed_notes()

func check_missed_notes():
	var notes = get_tree().get_nodes_in_group("notes")
	
	for note in notes:
		if note is Note and not note.is_hit:
			# 如果音符已经超过击打区域太远，标记为错过
			if note.position.x > hit_zone_x + good_window:
				note.queue_free()
				note_missed.emit() 