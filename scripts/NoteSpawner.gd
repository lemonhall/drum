extends Node2D

# 预加载音符场景
var note_scene = preload("res://scenes/Note.tscn")

# 生成设置
var spawn_position = Vector2(0, 300)
var is_spawning = false
var spawn_timer: Timer

# 音符类型常量
const DON = 0
const KA = 1

# 音符模式
var note_patterns = [
	[DON],
	[KA],
	[DON, DON],
	[KA, KA],
	[DON, KA],
	[KA, DON],
]

var current_pattern_index = 0
var current_note_in_pattern = 0

func _ready():
	# 创建定时器
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 1.0  # 每秒生成一个音符
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)

func start_spawning():
	is_spawning = true
	spawn_timer.start()

func stop_spawning():
	is_spawning = false
	spawn_timer.stop()

func _on_spawn_timer_timeout():
	if is_spawning:
		spawn_note()

func spawn_note():
	# 创建音符实例
	var note_instance = note_scene.instantiate()
	
	# 设置音符类型（使用简单的随机模式）
	var note_type = DON if randf() > 0.5 else KA
	note_instance.note_type = note_type
	
	# 设置位置
	note_instance.position = spawn_position
	
	# 添加到场景
	get_parent().add_child(note_instance)
	
	# 调整生成间隔（可以根据音乐节拍调整）
	adjust_spawn_rate()

func adjust_spawn_rate():
	# 随机调整生成间隔，模拟不同的节奏
	var intervals = [0.5, 0.75, 1.0, 1.25, 1.5]
	spawn_timer.wait_time = intervals[randi() % intervals.size()]

func spawn_pattern_note():
	# 按预设模式生成音符
	if current_pattern_index >= note_patterns.size():
		current_pattern_index = 0
	
	var pattern = note_patterns[current_pattern_index]
	
	if current_note_in_pattern >= pattern.size():
		current_note_in_pattern = 0
		current_pattern_index += 1
		if current_pattern_index >= note_patterns.size():
			current_pattern_index = 0
	
	var note_instance = note_scene.instantiate()
	note_instance.note_type = pattern[current_note_in_pattern]
	note_instance.position = spawn_position
	
	get_parent().add_child(note_instance)
	
	current_note_in_pattern += 1 