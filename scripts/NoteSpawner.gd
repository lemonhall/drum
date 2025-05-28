extends Node2D

# 预加载音符场景
var note_scene = preload("res://scenes/Note.tscn")

# 生成设置
var spawn_position = Vector2(0, 300)
var is_spawning = false

# 节拍设置 (70 BPM)
var bpm = 70.0
var beat_interval: float  # 每拍的时间间隔
var beat_timer: Timer
var current_beat = 0

# 音符类型常量
const DON = 0
const KA = 1

# 预设的节拍模式 (适合70 BPM的简单模式)
var beat_patterns = [
	# 模式1: 简单的四拍模式
	[DON, null, DON, null],  # 咚 - 咚 -
	
	# 模式2: 交替模式
	[DON, KA, DON, KA],      # 咚 咔 咚 咔
	
	# 模式3: 重音模式
	[DON, DON, null, KA],    # 咚 咚 - 咔
	
	# 模式4: 简单模式
	[DON, null, null, null], # 咚 - - -
	
	# 模式5: 连击模式
	[DON, DON, DON, null],   # 咚 咚 咚 -
	
	# 模式6: 混合模式
	[KA, null, DON, DON],    # 咔 - 咚 咚
]

var current_pattern_index = 0
var current_beat_in_pattern = 0

func _ready():
	# 计算节拍间隔 (70 BPM = 70拍/分钟)
	beat_interval = 60.0 / bpm  # 约0.857秒每拍
	print("节拍间隔: ", beat_interval, " 秒 (", bpm, " BPM)")
	
	# 创建节拍定时器
	beat_timer = Timer.new()
	beat_timer.wait_time = beat_interval
	beat_timer.timeout.connect(_on_beat_timer_timeout)
	add_child(beat_timer)

func start_spawning():
	is_spawning = true
	current_beat = 0
	current_pattern_index = 0
	current_beat_in_pattern = 0
	beat_timer.start()
	print("开始按节拍生成音符 (", bpm, " BPM)")

func stop_spawning():
	is_spawning = false
	beat_timer.stop()
	print("停止生成音符")

func _on_beat_timer_timeout():
	if is_spawning:
		process_beat()
		current_beat += 1

func process_beat():
	# 获取当前模式
	var current_pattern = beat_patterns[current_pattern_index]
	
	# 获取当前拍子应该生成的音符类型
	var note_type = current_pattern[current_beat_in_pattern]
	
	# 如果不是null，就生成音符
	if note_type != null:
		spawn_note(note_type)
		print("第", current_beat + 1, "拍: 生成", ("DON" if note_type == DON else "KA"), "音符")
	else:
		print("第", current_beat + 1, "拍: 休止")
	
	# 移动到下一拍
	current_beat_in_pattern += 1
	
	# 如果当前模式结束，切换到下一个模式
	if current_beat_in_pattern >= current_pattern.size():
		current_beat_in_pattern = 0
		current_pattern_index += 1
		
		# 如果所有模式都用完了，重新开始
		if current_pattern_index >= beat_patterns.size():
			current_pattern_index = 0
		
		print("切换到模式", current_pattern_index + 1)

func spawn_note(note_type: int):
	# 创建音符实例
	var note_instance = note_scene.instantiate()
	
	# 设置音符类型
	note_instance.note_type = note_type
	
	# 设置位置
	note_instance.position = spawn_position
	
	# 添加到场景
	get_parent().add_child(note_instance)

# 动态调整BPM (如果需要的话)
func set_bpm(new_bpm: float):
	bpm = new_bpm
	beat_interval = 60.0 / bpm
	if beat_timer:
		beat_timer.wait_time = beat_interval
	print("BPM调整为: ", bpm)

# 切换到指定的模式
func set_pattern(pattern_index: int):
	if pattern_index >= 0 and pattern_index < beat_patterns.size():
		current_pattern_index = pattern_index
		current_beat_in_pattern = 0
		print("切换到模式: ", pattern_index + 1) 