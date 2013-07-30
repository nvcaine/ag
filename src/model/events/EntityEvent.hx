package model.events;

import flash.events.Event;

class EntityEvent extends Event
{
	public static inline var ENTITY_EXPLOSION:String = "entityExplosion";
	public static inline var PLAYER_DEAD:String = "playerDead";
	public static inline var DROP_PICKUP:String = "dropPickup";

	public var x:Float;
	public var y:Float;

	public function new(type:String, x:Float = 0, y:Float = 0, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);

		this.x = x;
		this.y = y;
	}
}