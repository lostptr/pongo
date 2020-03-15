extends Camera2D

signal close_ended
onready var close_tween: Tween = $CloseTween
onready var close_timer: Timer = $CloseTimer
onready var original_position: Vector2 = self.position
var close_duration: float = 0.02
var close_zoom: float = 0.75

func _ready():
	Globals.camera = self

func close_in(pos: Vector2):
	self.global_position = pos
	self.zoom = Vector2(close_zoom, close_zoom)
	Engine.time_scale = 0.01
	close_timer.start()
	
func close_out():
	Engine.time_scale = 1
	emit_signal("close_ended")
	close_tween.interpolate_property(self, "position", self.position, original_position, close_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	close_tween.interpolate_property(self, "zoom", Vector2(close_zoom, close_zoom), Vector2(1,1), close_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	close_tween.start()
	

func _on_CloseTimer_timeout():
	close_out()
