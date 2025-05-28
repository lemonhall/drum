extends Area2D
class_name Note

# 音符类型
enum NoteType {
	DON,    # 红色音符（咚）
	KA      # 蓝色音符（咔）
}

var note_type: NoteType = NoteType.DON
var speed: float = 116.7  # 调整为适合70 BPM的速度 (1000像素 / 8.57秒 ≈ 116.7)
var is_hit: bool = false

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

# 音符颜色
var don_color = Color.RED
var ka_color = Color.BLUE

# 击打区域位置
var hit_zone_x = 1000.0

func _ready():
	# 添加到notes组
	add_to_group("notes")
	
	# 设置音符外观
	setup_note_appearance()
	
	# 连接信号
	area_entered.connect(_on_area_entered)
	
	# 计算到达击打区域的时间
	var travel_distance = hit_zone_x - position.x
	var travel_time = travel_distance / speed
	print("音符生成: 类型=", ("DON" if note_type == NoteType.DON else "KA"), 
		  " 距离=", travel_distance, "px 预计", travel_time, "秒后到达")

func setup_note_appearance():
	# 创建圆形精灵
	if not sprite:
		sprite = Sprite2D.new()
		add_child(sprite)
	
	# 创建碰撞形状
	if not collision:
		collision = CollisionShape2D.new()
		var circle_shape = CircleShape2D.new()
		circle_shape.radius = 25
		collision.shape = circle_shape
		add_child(collision)
	
	# 根据类型设置颜色
	var color = don_color if note_type == NoteType.DON else ka_color
	
	# 创建简单的圆形纹理
	var image = Image.create(50, 50, false, Image.FORMAT_RGBA8)
	image.fill(color)
	
	# 绘制圆形
	for x in range(50):
		for y in range(50):
			var distance = Vector2(x - 25, y - 25).length()
			if distance > 25:
				image.set_pixel(x, y, Color.TRANSPARENT)
			elif distance > 20:
				image.set_pixel(x, y, Color.WHITE)
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	sprite.texture = texture

func _process(delta):
	if not is_hit:
		# 向右移动
		position.x += speed * delta
		
		# 如果超出屏幕，删除自己
		if position.x > 1200:
			queue_free()

func _on_area_entered(area):
	if area.name == "HitZone" and not is_hit:
		# 进入击打区域
		pass

func hit():
	if not is_hit:
		is_hit = true
		# 播放击中效果
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.1)
		tween.tween_property(self, "modulate:a", 0.0, 0.2)
		tween.tween_callback(queue_free)

func get_distance_to_hit_zone() -> float:
	# 计算到击打区域的距离
	return abs(position.x - hit_zone_x)

# 设置音符速度（用于动态调整）
func set_speed(new_speed: float):
	speed = new_speed 