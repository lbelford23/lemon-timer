extends Control

## The length of time in seconds that each lemon should last.
@export var lemon_length:int = 23 * 60

## How many lemons should be queued in a row, with no breaks bewtween.
@export var num_lemons:int = 1

## The length of time in seconds that each break should last.
@export var break_length:int = 7 * 60

## The string format template for the time display
@export var time_format:String = "%02d:%02d"

@onready var timer = $Timer
@onready var timeDisplay = $TimerBox/TimeDisplay
@onready var numDisplay = $NumberPanel/NumberDisplay

enum TimerState{
	Setup,
	Running,
	BreakSetup,
	BreakRunning
}

var currentState


# Called when the node enters the scene tree for the first time.
func _ready():
	currentState = TimerState.Setup
	display_num()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not timer.is_stopped():
		display_time()
	

# Display Functions

## Gets the current time from the timer
## Then formats as MM:SS and updates display
func display_time():
	var current_time = int(timer.time_left)
	var minutes = current_time / 60
	var seconds = current_time % 60
	timeDisplay.text = time_format % [minutes, seconds]

func display_num():
	#Make selectable number match variable value
	numDisplay.text = str(num_lemons)
	

# State Transitions:

## Sets timer value as lemon_length * num_lemons
## then Starts the timer
func start_lemon():
	print("start_lemon")
	var length = lemon_length * num_lemons
	timer.wait_time = length
	timer.start()
	currentState = TimerState.Running

func end_lemon():
	print("end_lemon")
	timer.stop()
	currentState = TimerState.BreakSetup
	

func start_break():
	print("start_break")
	var length = break_length * num_lemons
	timer.wait_time = length
	timer.start()
	currentState = TimerState.BreakRunning

func end_break():
	print("end_break")
	timer.stop()
	currentState = TimerState.Setup
	

# Signal Functions:
func _on_start_button_pressed():
	print("start pressed")
	if currentState == TimerState.Setup:
		start_lemon()
	if currentState == TimerState.BreakSetup:
		start_break()

func _on_timer_timeout():
	print("timer ended")
	if currentState == TimerState.Running:
		end_lemon()
	if currentState == TimerState.BreakRunning:
		end_break()

func _on_minus_button_pressed():
	print("minus pressed")
	if currentState == TimerState.Setup:
		num_lemons -= 1
		if num_lemons < 1:
			num_lemons = 1
		display_num()

func _on_plus_button_pressed():
	print("plus pressed")
	if currentState == TimerState.Setup:
		num_lemons += 1
		display_num()
