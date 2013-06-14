package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

import flash.events.EventDispatcher;

import events.ExplosionEvent;
import events.HUDEvent;

import dto.EnemyDTO;

import model.consts.EntityTypeConsts;

import entities.Projectile;

class Enemy extends Entity
{
	private var dispatcher:EventDispatcher;
	private var data:EnemyDTO;

	public function new(g:Image, x:Float, y:Float, d:EventDispatcher)
	{
		super(x, y);

		graphic = g;
		setHitbox(32, 32);

		dispatcher = d;

		data = new EnemyDTO({type: "asd", health: 200, damage: 10});

		type = EntityTypeConsts.ENEMY;
	}

	override public function moveCollideX(e:Entity):Bool
	{
		die();

		dispatcher.dispatchEvent(new HUDEvent(HUDEvent.ENEMY_COLLISION));

		return true;
	}

	public override function update()
	{
		moveBy(-2, 0, EntityTypeConsts.PLAYER);

		super.update();

		checkProjectileCollision([EntityTypeConsts.PROJECTILE]);

		if(data.health <= 0)
			die();

		if(x < scene.camera.x - width)
			die(false);
	}

	private function checkProjectileCollision(projectileEntityTypes:Array<String>)
	{
		var bullet:Projectile = cast(collideTypes(projectileEntityTypes, x, y), Projectile);

		if(bullet != null /*&& Type.getClassName(Type.getClass(bullet)) == "entities.Bullet"*/)
			data.health -= bullet.damage;
	}

	private function die(dispatchEvent:Bool = true)
	{
		if(dispatchEvent)
			dispatcher.dispatchEvent(new ExplosionEvent("explode", this.x - 16, this.y - 16));

		scene.remove(this);
	}
}