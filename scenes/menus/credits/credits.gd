extends Control

@onready var richTextLabel: RichTextLabel = $RichTextLabel
var isMaxScrolled = false
var maxOffset = 0
var lastVscrollValue = 0
var playFrame = true
var timeout = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(2).timeout
	timeout = true
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timeout:
		if playFrame:
			lastVscrollValue = richTextLabel.get_v_scroll_bar().value
			if !isMaxScrolled:
				richTextLabel.get_v_scroll_bar().value += 1
				maxOffset = richTextLabel.get_v_scroll_bar().value
			if maxOffset == lastVscrollValue:
				isMaxScrolled = true
			playFrame = false
		else:
			playFrame = true
