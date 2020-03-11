extends KinematicBody2D

export(float) var increase: float = 100

onready var anim: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = $Sprite
onready var col_timer: Timer = $CollisionTimer

var should_colide: bool = true
var direction: Vector2
var velocity: Vector2

func _ready():
	randomize()
	velocity = random_dir() * 100

func random_dir() -> Vector2:
	return Vector2(randf(), randf()).normalized()

func _physics_process(delta):
	var col: KinematicCollision2D = move_and_collide(velocity * delta)
	if col != null:
		bounce(col.normal, false)
		
func speed_up():
	velocity = velocity + (velocity.normalized() * increase)

func bounce(normal: Vector2, from_player: bool):
	if should_colide:
		if from_player:
			should_colide = false
			col_timer.start()
		velocity = velocity.bounce(normal)
		sprite.rotation = velocity.angle()
		anim.play("bounce")

func _on_CollisionTimer_timeout():
	should_colide = true
	col_timer.stop()
