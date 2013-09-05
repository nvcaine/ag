package entities.game;

import model.consts.EntityTypeConsts;
//import nme.geom.Point;

import com.haxepunk.tweens.motion.LinearPath;

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

		//trace(data.waypoints.length);
		initWaypointsTween(data.waypoints, data.speed);
	}

	override public function update()
	{
		super.update();

		//checkCollision(PROJECTILE, onProjectileCollision);
		//checkCollision(PLAYER, onPlayerCollision);

		this.x = tween.x;
		this.y = tween.y + data.speed;
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
}