extends CPUParticles2D

onready var timer = $AutoDestroyTimer

func _ready():
	timer.wait_time = self.lifetime
	timer.start()
	emitting = true

func _on_AutoDestroyTimer_timeout():
	queue_free()
