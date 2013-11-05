package model.events;

import flash.events.Event;

class HUDEvent extends Event
{
	public static inline var KILL_SCORE:String = "killScore";
	//public static inline var ENEMY_COLLISION:String = "enemyCollision";
	public static inline var UPDATE_HEALTH:String = "updateHealth";
	public static inline var UPDATE_ENERGY:String = "updateEnergy";
	public static inline var PLAYER_DIED:String = "playerDied";

	public var score:Int;
	public var health:Float;
	public var energy:Float;
	public var xp:Int;

	public function new(type:String, score:Int = 0, health:Float = 0, xp:Int = 0, energy:Float = 0, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);

		this.score = score;
		this.health = health;
		this.xp = xp;
		this.energy = energy;
	}
}