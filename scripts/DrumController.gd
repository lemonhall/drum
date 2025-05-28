extends Node

# 信号
signal note_hit(note_type: String, timing_accuracy: float)
signal note_missed()

# 判定设置
var perfect_window = 50.0  # 完美判定窗口（像素）
var good_window = 100.0    # 良好判定窗口（像素）
var hit_zone_x = 1000.0    # 击打区域X坐标

# 音符类型常量
const DON = 0
const KA = 1

# 获取AudioManager引用
@onready var audio_manager = get_node("../AudioManager")

func _ready():
	print("太鼓达人游戏已准备就绪！")

func _input(event):
	if event.is_action_pressed("drum_don"):
		print("按下DON按键")
		# 立即播放DON音效
		play_drum_sound("DON")
		handle_drum_hit(DON)
	elif event.is_action_pressed("drum_ka"):
		print("按下KA按键")
		# 立即播放KA音效
		play_drum_sound("KA")
		handle_drum_hit(KA)

func play_drum_sound(drum_type: String):
	# 按键时立即播放对应的鼓声
	print("尝试播放鼓声: ", drum_type)
	if audio_manager:
		audio_manager.play_drum_sound(drum_type)
		print("播放", drum_type, "鼓声")
	else:
		print("AudioManager未找到!")

func handle_drum_hit(input_type: int):
	# 查找最近的匹配音符
	var closest_note = find_closest_matching_note(input_type)
	
	if closest_note:
		var distance = closest_note.get_distance_to_hit_zone()
		print("找到音符，距离: ", distance)
		
		if distance <= good_window:
			# 计算准确度
			var accuracy = calculate_accuracy(distance)
			
			# 击中音符
			closest_note.hit()
			
			# 发送信号（用于分数计算）
			var note_type_string = "DON" if input_type == DON else "KA"
			note_hit.emit(note_type_string, accuracy)
			print("击中音符! 准确度: ", accuracy)
			
			# 如果是完美击中，播放额外的完美音效
			if accuracy >= 0.9 and audio_manager:
				audio_manager.play_feedback("PERFECT")
				print("完美击中!")
		else:
			# 音符距离太远，算作错过
			print("音符距离太远，错过了")
			note_missed.emit()
	else:
		# 没有找到匹配的音符，但这不算错过，只是没有音符可以击打
		print("没有找到匹配的音符（这是正常的，不算错过）")

func find_closest_matching_note(note_type: int) -> Note:
	var notes = get_tree().get_nodes_in_group("notes")
	var closest_note: Note = null
	var closest_distance = INF
	
	print("查找音符，场景中音符数量: ", notes.size())
	
	for note in notes:
		if note is Note and note.note_type == note_type and not note.is_hit:
			var distance = note.get_distance_to_hit_zone()
			print("音符类型: ", note.note_type, " 距离: ", distance)
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
				print("音符超出区域，自动错过")
				note.queue_free()
				note_missed.emit() 