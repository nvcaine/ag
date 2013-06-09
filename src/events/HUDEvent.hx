package events;

import flash.events.Event;

class HUDEvent extends Event
{
	public static inline var KILL_SCORE:String = "killScore";
	public static inline var ENEMY_COLLISION:String = "enemyCollision";

	public var score:Int;

	public function new(type:String, score:Int = 0, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);

		this.score = score;
	}
}