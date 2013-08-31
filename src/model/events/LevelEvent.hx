package model.events;

import flash.events.Event;

class LevelEvent extends Event
{
	public static inline var PASSED_CHECKPOINT:String = "passedCheckpoint";
	public static inline var KILLED_BOSS:String = "killedBoss";

	public var checkpoint:Int;

	public function new(type:String, checkpoint:Int, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);

		this.checkpoint = checkpoint;
	}
}