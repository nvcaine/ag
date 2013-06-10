package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

import events.ExplosionEvent;
import events.HUDEvent;

import flash.events.EventDispatcher;

import dto.EnemyDTO;

class Enemy extends Entity
{
	/*
	 * at one point, when we will use a single enemy class
	 * (or maybe we won't, but in case we do), 
	 * this property will come in handy
	 */
	//private var enemyData:EnemyVO

	private var dispatcher:EventDispatcher;
	private var data:EnemyDTO;

	public function new(g:Image, x:Float, y:Float, d:EventDispatcher)
	{
		type = "enemy";

		super(x, y);

		graphic = g;
		setHitbox(32, 32);

		dispatcher = d;

		data = new EnemyDTO({type: "asd", health: 100, damage: 10});
	}

	// this is triggered when the player collides with an enemy, the enemy dying instantly
	override public function moveCollideX(e:Entity)
	{
		//scene.remove(e);
		scene.remove(this);

		dispatcher.dispatchEvent(new HUDEvent(HUDEvent.ENEMY_COLLISION));

		return true;
	}

	public override function update()
	{
		moveBy(-2, 0, "player");

		super.update();

		checkProjectileCollision(["bullet"]);

		if(data.health <= 0)
			die();		
	}

	private function checkProjectileCollision(projectileEntityTypes:Array<String>)
	{
		var bullet = collideTypes(projectileEntityTypes, x, y);

		if(bullet != null && Type.getClassName(Type.getClass(bullet)) == "entities.Bullet")
		{
			scene.remove(bullet);

			data.health -= 50;
		}
	}

	private function die()
	{
		dispatcher.dispatchEvent(new ExplosionEvent("explode", this.x - 16, this.y - 16));

		scene.remove(this);
	}
}