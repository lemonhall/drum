extends Node

# 音频播放器引用
@onready var bgm_player = $BGMPlayer
@onready var sfx_player = $SFXPlayer

# 音效类型
enum SFXType {
	DON_HIT,
	KA_HIT,
	MISS,
	PERFECT
}

func _ready():
	# 设置音频播放器
	setup_audio_players()

func setup_audio_players():
	# 设置背景音乐播放器
	if bgm_player:
		bgm_player.volume_db = -10.0
		bgm_player.autoplay = false
	
	# 设置音效播放器
	if sfx_player:
		sfx_player.volume_db = -5.0

func play_sfx(sfx_type: SFXType):
	# 根据音效类型播放不同的声音
	# 这里可以加载不同的音频文件
	match sfx_type:
		SFXType.DON_HIT:
			play_don_sound()
		SFXType.KA_HIT:
			play_ka_sound()
		SFXType.MISS:
			play_miss_sound()
		SFXType.PERFECT:
			play_perfect_sound()

func play_don_sound():
	# 播放咚的音效
	# 这里可以加载实际的音频文件
	if sfx_player:
		# 创建简单的音调作为占位符
		create_and_play_tone(200.0, 0.1)

func play_ka_sound():
	# 播放咔的音效
	if sfx_player:
		# 创建不同音调的音效
		create_and_play_tone(400.0, 0.1)

func play_miss_sound():
	# 播放错过音效
	if sfx_player:
		create_and_play_tone(100.0, 0.2)

func play_perfect_sound():
	# 播放完美击中音效
	if sfx_player:
		create_and_play_tone(600.0, 0.15)

func create_and_play_tone(frequency: float, duration: float):
	# 创建简单的音调（占位符功能）
	# 在实际项目中，你应该使用预录制的音频文件
	var audio_stream = AudioStreamGenerator.new()
	audio_stream.mix_rate = 22050
	audio_stream.buffer_length = duration
	
	sfx_player.stream = audio_stream
	sfx_player.play()

func play_bgm():
	# 播放背景音乐
	if bgm_player and bgm_player.stream:
		bgm_player.play()

func stop_bgm():
	# 停止背景音乐
	if bgm_player:
		bgm_player.stop()

func set_bgm_volume(volume: float):
	# 设置背景音乐音量 (0.0 - 1.0)
	if bgm_player:
		bgm_player.volume_db = linear_to_db(volume)

func set_sfx_volume(volume: float):
	# 设置音效音量 (0.0 - 1.0)
	if sfx_player:
		sfx_player.volume_db = linear_to_db(volume) 