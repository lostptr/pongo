extends Sprite

onready var anim: AnimationPlayer = $AnimationPlayer

func _ready():
	Globals.black_background = self
	
func show():
	anim.play("show")

func hide():
	anim.play("hide")
