extends Marker2D

func _ready():
	GameManager.EightyOfLife.connect(eightyOfLife)
	GameManager.SixtyOfLife.connect(sixtyOfLife)
	GameManager.FortyOfLife.connect(fortyOfLife)
	GameManager.TwentyOfLife.connect(twentyOfLife)
	GameManager.TenOfLife.connect(tenOfLife)
	GameManager.tutorialCompletedSignal.connect(tutorialComplete)
	await get_tree().create_timer(2)
	var layout = Dialogic.Styles.load_style("textbubble")
	layout.register_character(load("res://dialogue/characters/testboss.dch"), $".")
	if GameManager.tutorialCompleted:
		if Dialogic.VAR.cobra_selected:
			Dialogic.start("res://dialogue/timelines/BF1_OX/OxStart.dtl")
		else:
			Dialogic.start("res://dialogue/timelines/BF2_COBRA/cobra_start.dtl")

func eightyOfLife():
	var layout = Dialogic.Styles.load_style("textbubble")
	layout.register_character(load("res://dialogue/characters/testboss.dch"), $".")
	if GameManager.numCombat == 1:
		Dialogic.start("res://dialogue/timelines/BF1_OX/OX_90HP.dtl")
	else:
		Dialogic.start("res://dialogue/timelines/BF2_COBRA/CB_90HP.dtl")


func sixtyOfLife():
	var layout = Dialogic.Styles.load_style("textbubble")
	layout.register_character(load("res://dialogue/characters/testboss.dch"), $".")
	if GameManager.numCombat == 1:
		Dialogic.start("res://dialogue/timelines/BF1_OX/OX_80HP.dtl")
	else:
		Dialogic.start("res://dialogue/timelines/BF2_COBRA/CB_80HP.dtl")

func fortyOfLife():
	var layout = Dialogic.Styles.load_style("textbubble")
	layout.register_character(load("res://dialogue/characters/testboss.dch"), $".")
	if GameManager.numCombat == 1:
		Dialogic.start("res://dialogue/timelines/BF1_OX/OX_70HP.dtl")
	else:
		Dialogic.start("res://dialogue/timelines/BF2_COBRA/CB_70HP.dtl")

func twentyOfLife():
	var layout = Dialogic.Styles.load_style("textbubble")
	layout.register_character(load("res://dialogue/characters/testboss.dch"), $".")
	if GameManager.numCombat == 1:
		Dialogic.start("res://dialogue/timelines/BF1_OX/OX_60HP.dtl")
	else:
		Dialogic.start("res://dialogue/timelines/BF2_COBRA/CB_60HP.dtl")

func tenOfLife():
	var layout = Dialogic.Styles.load_style("textbubble")
	layout.register_character(load("res://dialogue/characters/testboss.dch"), $".")
	if GameManager.numCombat == 1:
		Dialogic.start("res://dialogue/timelines/BF1_OX/OX_50HP.dtl")
	else:
		Dialogic.start("res://dialogue/timelines/BF2_COBRA/CB_50HP.dtl")

func tutorialComplete():
	if Dialogic.VAR.cobra_selected:
		Dialogic.VAR.testboss_name = "ox"
		#Dialogic.set_variable("testboss_name","ox")
		Dialogic.start("res://dialogue/timelines/BF1_OX/OxStart.dtl")
	else:
		Dialogic.VAR.testboss_name = "cobra"
		#Dialogic.set_variable("testboss_name","cobra")
		Dialogic.start("res://dialogue/timelines/BF2_COBRA/cobra_start.dtl")
