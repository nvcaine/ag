package entities.game.ships;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.motion.LinearPath;

import entities.game.misc.Projectile;

import model.consts.EntityTypeConsts;
import model.events.HUDEvent;
import model.events.EntityEvent;

import com.haxepunk.tweens.TweenEvent;

class EnemyShip extends ShipEntity
{
	private var tween:LinearPath;

	private var waypoints:Dynamic;

	public function new(x:Float, y:Float, data:Dynamic, ?waypoints:Array<Dynamic>)
	{
		super(x, y, data);

		this.type = EntityTypeConsts.ENEMY; // don't confuse with data.type (which refers to the type of enemy)

		if(waypoints != null)
			this.waypoints = waypoints;
	}

	override public function added()
	{
		super.added();

		if(waypoints != null)
			initWaypointsTween(waypoints, data.speed);
	}

	override public function update()
	{
		checkCollision(EntityTypeConsts.PROJECTILE, collideWithProjectile);
		checkCollision(EntityTypeConsts.PLAYER, collideWithPlayer);
		checkHealth();

		move();
	}

	private function move()
	{
		if(waypoints != null)
			updateTween();
		else
			moveBy(0, data.speed);
	}

	private function checkHealth()
	{
		if(data.health <= 0)
		{
			die(true, true);
			dropPickup(100);
		}

		if(this.y > HXP.height)
			die(false);
	}

	private function initWaypointsTween(waypoints:Array<Dynamic>, duration:Float)
	{
		tween = new LinearPath();

		for(waypoint in waypoints)
			tween.addPoint(this.x + waypoint.x, this.y + waypoint.y);

		tween.setMotion(duration);
		tween.addEventListener(TweenEvent.FINISH, onPassedWaypoints, false, 0, true);

		this.addTween(tween);

		tween.start();
	}

	private function updateTween()
	{
		this.x = tween.x;
		this.y = tween.y;// + data.speed;		
	}

	private function checkCollision(entityType:String, handler:Entity->Void)
	{
		var entity:Entity = collide(entityType, this.x, this.y);

		if(entity != null)
			handler(entity);
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

		if(waypoints != null)
			tween.removeEventListener(TweenEvent.FINISH, onPassedWaypoints);

		scene.remove(this);
	}

	private function dropPickup(chance:Float)
	{
		sendMessage(new EntityEvent(EntityEvent.DROP_PICKUP, this.x + width / 2, this.y + height / 2));
	}

	private function onPassedWaypoints(e:TweenEvent)
	{
		tween.removeEventListener(TweenEvent.FINISH, onPassedWaypoints);

		this.waypoints = null;
	}
}