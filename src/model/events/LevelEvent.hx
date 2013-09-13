package model.events;

import flash.events.Event;

class LevelEvent extends Event
{
	public static inline var FINISHED_LEVEL:String = "finishedLevel";

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);
	}
}