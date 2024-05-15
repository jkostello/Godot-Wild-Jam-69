extends Control

func _ready():
	update_controls()

# Called when scene is shown
# Ensures controls are displayed properly
func update_controls():
	%upLabel.text = "Up: " + InputMap.action_get_events("up")[0].as_text().trim_suffix(" (Physical)")
	%downLabel.text = "Down: " + InputMap.action_get_events("down")[0].as_text().trim_suffix(" (Physical)")
	%leftLabel.text = "Left: " + InputMap.action_get_events("left")[0].as_text().trim_suffix(" (Physical)")
	%rightLabel.text = "Right: " + InputMap.action_get_events("right")[0].as_text().trim_suffix(" (Physical)")
