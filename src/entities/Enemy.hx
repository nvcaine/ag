package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

import events.ExplosionEvent;
import events.HUDEvent;

import flash.events.EventDispatcher;

class Enemy extends Entity
{
	/*
	 * at one point, when we will use a single enemy class
	 * (or maybe we won't, but in case we do), 
	 * this property will come in handy
	 */
	//private var enemyData:EnemyVO

	private var dispatcher:EventDispatcher;

	public function new(g:Image, x:Float, y:Float, d:EventDispatcher)
	{
		super(x, y);

		graphic = g;//new Image("gfx/enemy.png");//Image.createRect(32, 32);
		setHitbox(32, 32);

		type = "enemy";
		dispatcher = d;
	}

	override public function moveCollideX(e:Entity)
	{
		dispatcher.dispatchEvent(new ExplosionEvent("explode", this.x - 16, this.y - 16));

		//scene.remove(e);
		scene.remove(this);

		dispatcher.dispatchEvent(new HUDEvent(HUDEvent.ENEMY_COLLISION));

		return true;
	}

	public override function update()
	{
		moveBy(-2, 0, "player");

		super.update();
	}
}