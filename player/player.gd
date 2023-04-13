extends Node2D


@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_timer := $Timer

@onready var last_click_time = 0

func _ready():
	animation_timer.timeout.connect(_on_timer_timeout)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_mouse") :
			animated_sprite.play("mine")
			animation_timer.start(0.5)
			var time_delta = Time.get_ticks_msec() - last_click_time
			animated_sprite.speed_scale = (200.0 / time_delta)**2.0 + 0.5
			last_click_time = Time.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	await animated_sprite.animation_looped
	animated_sprite.play("idle")

#func _draw():
#	draw_set_transform(Vector2(3,27),0,Vector2(2,1))
#	draw_circle(Vector2(0,0), 5.0, Color(0, 0, 0, 0.48))
