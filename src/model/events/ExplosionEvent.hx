package model.events;

import flash.events.Event;

class ExplosionEvent extends Event
{
	public var x:Float;
	public var y:Float;

	public function new(type:String, x:Float, y:Float, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);

		this.x = x;
		this.y = y;
	}
}