package entities.game;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.tweens.motion.LinearPath;

import entities.game.Projectile;

import model.consts.EntityTypeConsts;
import model.events.HUDEvent;
import model.events.EntityEvent;

class EnemyShip extends GameEntity
{
	private var tween:LinearPath;

	public function new(x:Float, y:Float, data:Dynamic)
	{
		super(x, y, data);

		this.type = EntityTypeConsts.ENEMY; // don't confuse with data.type (which refers to the type of enemy)
	}

	override public function added()
	{
		super.added();

		initWaypointsTween(data.waypoints, data.speed);
	}

	override public function update()
	{
		super.update();

		checkCollision([EntityTypeConsts.PROJECTILE, EntityTypeConsts.PLAYER], [collideWithProjectile, collideWithPlayer]);

		updateTween();

		if(data.health <= 0)
		{
			die(true, true);
			dropPickup(100);
		}

		if(this.y > scene.camera.y + HXP.height)
			die(false);
	}

	private function initWaypointsTween(waypoints:Array<Dynamic>, duration:Float)
	{
		tween = new LinearPath();

		for(waypoint in waypoints)
			tween.addPoint(this.x + waypoint.x, this.y + waypoint.y);

		tween.setMotion(duration);
		tween.start();

		this.addTween(tween);
	}

	private function updateTween()
	{
		this.x = tween.x;
		this.y = tween.y + data.speed;		
	}

	private function checkCollision(entityType:Array<String>, handler:Array<Entity->Void>)
	{
		for(i in 0...entityType.length)
		{
			var entity:Entity = collide(entityType, this.x, this.y);

			if(entity != null)
				handler[i](entity);
		}
	}

	private function collideWithProjectile(e:Entity)
	{
		var entity:Projectile = cast(e, Projectile);

		data.health -= entity.damage;
		scene.remove(entity);
	}

	private function collideWithPlayer(e:Entity)
	{
		sendMessage(new HUDEvent(HUDEvent.UPDATE_HEALTH, 0, Std.int(-data.damage)));
		die();
	}

	private function die(explode:Bool = true, score:Bool = false)
	{
		if(explode)
			sendMessage(new EntityEvent(EntityEvent.ENTITY_EXPLOSION, this.x + width / 2, this.y + height / 2));

		if(score)
			sendMessage(new HUDEvent(HUDEvent.KILL_SCORE, data.score, 0, data.xp));

		graphic = null;

		scene.remove(this);
	}

	private function dropPickup(chance:Float)
	{
		sendMessage(new EntityEvent(EntityEvent.DROP_PICKUP, this.x + width / 2, this.y + height / 2));
	}
}