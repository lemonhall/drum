extends Node

# 音频播放器引用
@onready var bgm_player = $BGMPlayer           # 背景音乐播放器
@onready var drum_player = $DrumPlayer         # 鼓声播放器 (don/ka)
@onready var feedback_player = $FeedbackPlayer # 反馈音效播放器 (perfect/miss)

# 音效类型
enum SFXType {
	DON_HIT,
	KA_HIT,
	MISS,
	PERFECT
}

# 音效文件路径配置
var audio_files = {
	SFXType.DON_HIT: "res://audio/don_hit.wav",      # 红色音符击中音效
	SFXType.KA_HIT: "res://audio/ka_hit.wav",        # 蓝色音符击中音效
	SFXType.MISS: "res://audio/miss.wav",            # 错过音符音效
	SFXType.PERFECT: "res://audio/perfect.wav"       # 完美击中音效
}

# 背景音乐文件路径
var bgm_file = "res://audio/bgm.ogg"

# 预加载的音效
var loaded_sounds = {}

func _ready():
	print("AudioManager 初始化中...")
	# 设置音频播放器
	setup_audio_players()
	# 预加载音效
	preload_sounds()
	print("AudioManager 初始化完成")

func setup_audio_players():
	# 设置背景音乐播放器
	if bgm_player:
		bgm_player.volume_db = -10.0
		bgm_player.autoplay = false
		print("BGM播放器设置完成")
	
	# 设置鼓声播放器
	if drum_player:
		drum_player.volume_db = -3.0  # 鼓声稍微大一点
		print("鼓声播放器设置完成")
	
	# 设置反馈音效播放器
	if feedback_player:
		feedback_player.volume_db = -8.0  # 反馈音效稍微小一点
		print("反馈音效播放器设置完成")

func preload_sounds():
	print("开始预加载音效文件...")
	# 预加载所有音效文件
	for sfx_type in audio_files:
		var file_path = audio_files[sfx_type]
		if ResourceLoader.exists(file_path):
			var audio_stream = load(file_path)
			loaded_sounds[sfx_type] = audio_stream
			print("✅ 已加载音效: ", file_path)
		else:
			print("❌ 音效文件不存在: ", file_path)
	
	# 加载背景音乐
	if ResourceLoader.exists(bgm_file):
		bgm_player.stream = load(bgm_file)
		print("✅ 已加载背景音乐: ", bgm_file)
	else:
		print("❌ 背景音乐文件不存在: ", bgm_file)
	
	print("音效预加载完成，已加载 ", loaded_sounds.size(), " 个音效文件")

func play_sfx(sfx_type: SFXType):
	print("收到播放音效请求: ", sfx_type)
	
	# 根据音效类型选择合适的播放器
	var player
	match sfx_type:
		SFXType.DON_HIT, SFXType.KA_HIT:
			# 鼓声使用专门的鼓声播放器
			player = drum_player
		SFXType.MISS, SFXType.PERFECT:
			# 反馈音效使用反馈播放器
			player = feedback_player
	
	if not player:
		print("❌ 找不到合适的播放器")
		return
	
	# 播放预加载的音效
	if sfx_type in loaded_sounds:
		player.stream = loaded_sounds[sfx_type]
		player.play()
		print("✅ 播放音效: ", audio_files[sfx_type])
	else:
		# 如果没有音效文件，使用占位符音调
		print("⚠️ 使用占位符音效: ", sfx_type)
		match sfx_type:
			SFXType.DON_HIT:
				create_and_play_tone(200.0, 0.1, player)
			SFXType.KA_HIT:
				create_and_play_tone(400.0, 0.1, player)
			SFXType.MISS:
				create_and_play_tone(100.0, 0.2, player)
			SFXType.PERFECT:
				create_and_play_tone(600.0, 0.15, player)

func create_and_play_tone(frequency: float, duration: float, player: AudioStreamPlayer):
	# 创建简单的音调（占位符功能）
	# 这个函数在没有音频文件时作为备用
	print("播放占位符音调: ", frequency, "Hz")
	var audio_stream = AudioStreamGenerator.new()
	audio_stream.mix_rate = 22050
	audio_stream.buffer_length = duration
	
	player.stream = audio_stream
	player.play()

func play_bgm():
	# 播放背景音乐
	if bgm_player and bgm_player.stream:
		bgm_player.play()
		print("🎵 开始播放背景音乐")
	else:
		print("❌ 没有背景音乐可播放")

func stop_bgm():
	# 停止背景音乐
	if bgm_player:
		bgm_player.stop()
		print("⏹️ 停止背景音乐")

func set_bgm_volume(volume: float):
	# 设置背景音乐音量 (0.0 - 1.0)
	if bgm_player:
		bgm_player.volume_db = linear_to_db(volume)

func set_drum_volume(volume: float):
	# 设置鼓声音量 (0.0 - 1.0)
	if drum_player:
		drum_player.volume_db = linear_to_db(volume)

func set_feedback_volume(volume: float):
	# 设置反馈音效音量 (0.0 - 1.0)
	if feedback_player:
		feedback_player.volume_db = linear_to_db(volume)

# 重新加载音效文件（用于运行时更新音效）
func reload_sounds():
	loaded_sounds.clear()
	preload_sounds()

# 便捷函数：播放鼓声
func play_drum_sound(drum_type: String):
	if drum_type == "DON":
		play_sfx(SFXType.DON_HIT)
	elif drum_type == "KA":
		play_sfx(SFXType.KA_HIT)

# 便捷函数：播放反馈音效
func play_feedback(feedback_type: String):
	if feedback_type == "PERFECT":
		play_sfx(SFXType.PERFECT)
	elif feedback_type == "MISS":
		play_sfx(SFXType.MISS) 