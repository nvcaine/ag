package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import flash.events.EventDispatcher;

import events.ExplosionEvent;
import events.HUDEvent;

class Bullet extends Entity
{
	private var dispatcher:EventDispatcher;

	public function new(x:Float, y:Float, d:EventDispatcher, g:Image)
	{
		super(x, y);

		graphic = g;//Image.createRect(16, 4);
		setHitbox(16, 4);

		dispatcher = d;
		type = "bullet";
	}

	override public function moveCollideX(e:Entity)
	{
		dispatcher.dispatchEvent(new ExplosionEvent("explode", e.x - 16, e.y - 16));
		dispatcher.dispatchEvent(new HUDEvent(HUDEvent.KILL_SCORE, 10)); // default score 10 - why, you say ?! becasue, that's why

		scene.remove(e);
		scene.remove(this);

		return true;
	}

	override public function update()
	{
		moveBy(10, 0, "enemy");
		
		super.update();
	}
}