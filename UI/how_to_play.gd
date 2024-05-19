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
	%struct1Label.text = "Select Structure 1: " + InputMap.action_get_events("select_structure_1")[0].as_text().trim_suffix(" (Physical)")
	%struct2Label.text = "Select Structure 2: " + InputMap.action_get_events("select_structure_2")[0].as_text().trim_suffix(" (Physical)")
	%struct3Label.text = "Select Structure 3: " + InputMap.action_get_events("select_structure_3")[0].as_text().trim_suffix(" (Physical)")
	%deselectLabel.text = "Deselect: " + InputMap.action_get_events("deselect")[0].as_text().trim_suffix(" (Physical)")
	%rotateLabel.text = "Rotate: " + InputMap.action_get_events("rotate")[0].as_text().trim_suffix(" (Physical)")

func _on_tab_container_tab_clicked(tab):
	if (tab == 3):
		%StructuresContainer.show()
	else:
		%StructuresContainer.hide()
