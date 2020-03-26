extends Camera2D

# Close Ins ==================================================
signal close_ended
onready var close_tween: Tween = $CloseTween
onready var close_timer: Timer = $CloseTimer
onready var original_position: Vector2 = self.position
var close_duration: float = 0.02
var close_zoom: float = 0.75
# ============================================================

# Camera Shake
export var decay_rate = 0.4
export var max_yaw = 0.05
export var max_pitch = 0.05
export var max_roll = 0.1
export var max_offset = 0.2

onready var _start_offset = self.get_offset()
var _start_position
var _start_rotation
var _trauma

var _duration = 0.0
var _period_in_ms = 0.0
var _amplitude = 0.0
var _timer = 0.0
var _last_shook_timer = 0
var _previous_x = 0.0
var _previous_y = 0.0
var _last_offset = Vector2(0, 0)
# =====================================================

func _ready():
	Globals.camera = self


# Shake with decreasing intensity while there's time remaining.
func _process(delta):
	# Only shake when there's shake time remaining.
	if _timer == 0:
		return
	# Only shake on certain frames.
	_last_shook_timer = _last_shook_timer + delta
	# Be mathematically correct in the face of lag; usually only happens once.
	while _last_shook_timer >= _period_in_ms:
		_last_shook_timer = _last_shook_timer - _period_in_ms
		# Lerp between [amplitude] and 0.0 intensity based on remaining shake time.
		var intensity = _amplitude * (1 - ((_duration - _timer) / _duration))
		# Noise calculation logic from http://jonny.morrill.me/blog/view/14
		var new_x = rand_range(-1.0, 1.0)
		var x_component = intensity * (_previous_x + (delta * (new_x - _previous_x)))
		var new_y = rand_range(-1.0, 1.0)
		var y_component = intensity * (_previous_y + (delta * (new_y - _previous_y)))
		_previous_x = new_x
		_previous_y = new_y
		# Track how much we've moved the offset, as opposed to other effects.
		var new_offset = Vector2(x_component, y_component)
		set_offset(get_offset() - _last_offset + new_offset)
		_last_offset = new_offset
	# Reset the offset when we're done shaking.
	_timer = _timer - delta
	if _timer <= 0:
		_timer = 0
		set_offset(_start_offset)

# Kick off a new screenshake effect.
func shake(duration, frequency, amplitude):
	# Initialize variables.
	_duration = duration
	_timer = duration
	_period_in_ms = 1.0 / frequency
	_amplitude = amplitude
	_previous_x = rand_range(-1.0, 1.0)
	_previous_y = rand_range(-1.0, 1.0)
	# Reset previous offset, if any.
	set_offset(get_offset() - _last_offset)
	_last_offset = Vector2(0, 0)


func close_in(pos: Vector2):
	Globals.black_background.show()
	self.global_position = pos
	self.zoom = Vector2(close_zoom, close_zoom)
	Engine.time_scale = 0.01
	close_timer.start()
	
func close_out():
	Engine.time_scale = 1
	Globals.black_background.hide()
	emit_signal("close_ended")
	close_tween.interpolate_property(self, "position", self.position, original_position, close_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	close_tween.interpolate_property(self, "zoom", Vector2(close_zoom, close_zoom), Vector2(1,1), close_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	close_tween.start()

func _on_CloseTimer_timeout():
	close_out()
