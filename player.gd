extends Area2D
@export var speed =400
var screen_size
signal hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size=get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var v =Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		v.x+=1
	if Input.is_action_pressed("move_left"):
		v.x-=1
	if Input.is_action_pressed("move_up"):
		v.y-=1
	if Input.is_action_pressed("move_down"):
		v.y+=1
	if v.length()>0:
		v=v.normalized()*speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += v * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if v.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = v.x < 0
	elif v.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = v.y > 0


func _on_body_entered(body: Node2D) -> void:
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
