extends Node2D

# 游戏状态
enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

var current_state = GameState.MENU
var score = 0
var combo = 0
var max_combo = 0

# UI引用
@onready var score_label = $UI/ScoreLabel
@onready var combo_label = $UI/ComboLabel
@onready var note_spawner = $GameArea/NoteSpawner
@onready var drum_controller = $DrumController
@onready var audio_manager = $AudioManager

# 游戏设置
var note_speed = 200.0
var hit_window = 100.0  # 判定窗口（毫秒）

func _ready():
	# 连接信号
	drum_controller.note_hit.connect(_on_note_hit)
	drum_controller.note_missed.connect(_on_note_missed)
	
	# 开始游戏
	start_game()

func start_game():
	current_state = GameState.PLAYING
	score = 0
	combo = 0
	max_combo = 0
	update_ui()
	
	# 开始生成音符
	note_spawner.start_spawning()
	
	# 播放背景音乐
	if audio_manager:
		audio_manager.play_bgm()

func _on_note_hit(note_type: String, timing_accuracy: float):
	# 根据准确度计算分数
	var base_score = 100
	var accuracy_bonus = int(timing_accuracy * 50)
	var combo_bonus = min(combo * 10, 500)
	
	var points = base_score + accuracy_bonus + combo_bonus
	score += points
	combo += 1
	max_combo = max(max_combo, combo)
	
	update_ui()
	
	# 鼓声和完美音效已经在DrumController中播放了

func _on_note_missed():
	combo = 0
	update_ui()
	
	# 播放错过音效
	if audio_manager:
		audio_manager.play_feedback("MISS")

func update_ui():
	score_label.text = "分数: " + str(score)
	combo_label.text = "连击: " + str(combo)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if current_state == GameState.PLAYING:
			pause_game()
		elif current_state == GameState.PAUSED:
			resume_game()

func pause_game():
	current_state = GameState.PAUSED
	get_tree().paused = true
	if audio_manager:
		audio_manager.stop_bgm()

func resume_game():
	current_state = GameState.PLAYING
	get_tree().paused = false
	if audio_manager:
		audio_manager.play_bgm()

func game_over():
	current_state = GameState.GAME_OVER
	note_spawner.stop_spawning()
	if audio_manager:
		audio_manager.stop_bgm()
	
	print("游戏结束！")
	print("最终分数: ", score)
	print("最高连击: ", max_combo) 