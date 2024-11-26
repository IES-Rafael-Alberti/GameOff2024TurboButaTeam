extends Marker2D

func _ready():
	GameManager.EightyOfLife.connect(eightyOfLife)
	GameManager.SixtyOfLife.connect(sixtyOfLife)
	GameManager.FortyOfLife.connect(fortyOfLife)
	GameManager.TwentyOfLife.connect(twentyOfLife)
	GameManager.TenOfLife.connect(tenOfLife)
	await get_tree().create_timer(2)
	var layout = Dialogic.Styles.load_style("textbubble")
	layout.register_character(load("res://dialogue/characters/testboss.dch"), $".")
	Dialogic.start("res://dialogue/timelines/BF1_OX/OxStart.dtl")

func eightyOfLife():
	var layout = Dialogic.Styles.load_style("textbubble")
	layout.register_character(load("res://dialogue/characters/testboss.dch"), $".")
	Dialogic.start("res://dialogue/timelines/BF1_OX/OX_90HP.dtl")

func sixtyOfLife():
	var layout = Dialogic.Styles.load_style("textbubble")
	layout.register_character(load("res://dialogue/characters/testboss.dch"), $".")
	Dialogic.start("res://dialogue/timelines/BF1_OX/OX_80HP.dtl")

func fortyOfLife():
	var layout = Dialogic.Styles.load_style("textbubble")
	layout.register_character(load("res://dialogue/characters/testboss.dch"), $".")
	Dialogic.start("res://dialogue/timelines/BF1_OX/OX_70HP.dtl")

func twentyOfLife():
	var layout = Dialogic.Styles.load_style("textbubble")
	layout.register_character(load("res://dialogue/characters/testboss.dch"), $".")
	Dialogic.start("res://dialogue/timelines/BF1_OX/OX_60HP.dtl")

func tenOfLife():
	Dialogic.start("res://dialogue/timelines/BF1_OX/OX_50HP.dtl")
