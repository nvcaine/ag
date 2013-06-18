package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

import model.consts.EntityTypeConsts;
import model.consts.PlayerConsts;
import model.events.HUDEvent;

import nme.geom.Point;

import org.actors.MessageEntity;

class Ship extends MessageEntity
{
	private var velocity:Point;
	private var yAcceleration:Int;
	private var xAcceleration:Int;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		init();
	}

	override public function update()
	{
		super.update();

		moveVertically();
		moveHorizontally();

		moveBy(PlayerConsts.DEFAULT_SPEED + velocity.x, velocity.y, EntityTypeConsts.LEVEL);
	}

	override public function moveCollideX(e:Entity):Bool
	{
		onLevelCollision();

		return true;
	}

	override public function moveCollideY(e:Entity):Bool
	{
		onLevelCollision();

		return true;
	}

	public function setAcceleration(xAcc:Int, yAcc:Int)
	{
		xAcceleration = xAcc;
		yAcceleration = yAcc;
	}

	public function shoot()
	{
		scene.add(createNewProjectile());
	}

	private function createNewProjectile():Projectile
	{
		var data:Dynamic = {assetPath: "gfx/plasma.png", sound: "sfx/laser.mp3", width: 20, height: 5, damage: 50};

		return new Projectile(x + width, y + height / 2, data);
	}

	private function init()
	{
		type = EntityTypeConsts.PLAYER;

		graphic = new Image("gfx/ship.png");

		setHitbox(32, 32);

		velocity = new Point(0, 0);
	}

	private function onLevelCollision()
	{
		sendMessage(new HUDEvent(HUDEvent.ENEMY_COLLISION));
	}

	private function moveVertically()
	{
		velocity.y += yAcceleration * PlayerConsts.SPEED;

		if(velocity.y == 0)
			return;

		if(Math.abs(velocity.y) > PlayerConsts.MAX_VELOCITY)
			velocity.y = PlayerConsts.MAX_VELOCITY * HXP.sign(velocity.y);

		if(velocity.y < 0)
		{
			if(y <= 0)
			{
				velocity.y = 0;
				y = 0;
			}
			else
				velocity.y = Math.min(velocity.y + PlayerConsts.DRAG, 0);

			return;
		}

		if(y >= HXP.height - height)
		{
			velocity.y = 0;
			y = HXP.height - height;

			return;
		}

		velocity.y = Math.max(velocity.y - PlayerConsts.DRAG, 0);
	}

	private function moveHorizontally()
	{
		velocity.x += xAcceleration * PlayerConsts.SPEED;

		if(velocity.x == 0)
			return;

		if(Math.abs(velocity.x) > PlayerConsts.MAX_VELOCITY)
			velocity.x = PlayerConsts.MAX_VELOCITY * HXP.sign(velocity.x);

		if(velocity.x < 0)
		{
			velocity.x = Math.min(velocity.x + PlayerConsts.DRAG, 0);

			if(x - scene.camera.x < 5)
				velocity.x = 0;

			return;
		}

		velocity.x = Math.max(velocity.x - PlayerConsts.DRAG, 0);

		if(x > scene.camera.x + HXP.width - width)
			velocity.x = 0;
	}
}