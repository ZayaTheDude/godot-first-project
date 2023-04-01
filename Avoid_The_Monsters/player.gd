extends Area2D

signal hit

@export var speed = 400 # How fast the player will moce (pixels/sec).
var screen_size # Size of the game window

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector
	if Input.is_action_pressed("move_right"):
		set_rotation(PI/2)
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		set_rotation(-PI/2)
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		set_rotation(-PI)
		velocity.y +=1
	if Input.is_action_pressed("move_up"):
		set_rotation(0)
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"


func _on_body_entered(body):
	hide() # Player dissapears after being hit
	hit.emit()
	# Must be deffered as we can't change physics properties on a physics callback
	$CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
