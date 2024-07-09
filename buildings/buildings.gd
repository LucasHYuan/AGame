class_name Buildings
extends StaticBody2D

enum State{
	UNBUILT,
	FRAME,
	BUILDING,
	IDLE,
}
var current_state: State = State.UNBUILT

