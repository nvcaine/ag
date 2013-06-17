package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

import model.consts.EntityTypeConsts;
import model.events.HUDEvent;

import org.actors.MessageEntity;

class Ship extends MessageEntity
{
	private var velocity:Float;
	private var xVelocity:Float;
	private var yAcceleration:Float;
	private var xAcceleration:Float;

	static private inline var maxVelocity:Float = 8;
	static private inline var speed:Float = 3;
	static private inline var drag:Float = 0.4;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		init();
		velocity = xVelocity = 1;

		trace("cons:" + velocity);
	}

	override public function update()
	{
		super.update();

		moveVertically();
		//moveHorizontally();
		moveBy(1.5 /*+ xVelocity*/, velocity, EntityTypeConsts.LEVEL);
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

	public function setAcceleration(xAcc:Float, yAcc:Float)
	{
		xAcceleration = xAcc;
		yAcceleration = yAcc;
	}

	public function shoot()
	{
		scene.add(new Projectile(x + width, y + height / 2, {assetPath: "gfx/plasma.png", sound: "sfx/laser.mp3", width: 20, height: 5, damage: 50}));
	}

	private function init()
	{
		type = EntityTypeConsts.PLAYER;

		graphic = new Image("gfx/ship.png");

		setHitbox(32, 32);
	}

	private function onLevelCollision()
	{
		sendMessage(new HUDEvent(HUDEvent.ENEMY_COLLISION));
	}

	private function moveVertically()
	{
		trace("v:" + velocity);

		velocity += yAcceleration * speed;
		trace("*:" + (yAcceleration * speed));
		//trace("v:" + velocity + " " + yAcceleration + " " + speed);

		if(velocity == 0)
			return;

		if(Math.abs(velocity) > maxVelocity)
			velocity = maxVelocity * HXP.sign(velocity);

		if(velocity < 0)
			if(y <= 0)
			{
				velocity = 0;
				y = 0;
			}
			else
				velocity = Math.min(velocity + drag, 0);

		else
			if(y >= HXP.height - height)
			{
				velocity = 0;
				y = HXP.height - height;
			}
			else
				velocity = Math.max(velocity - drag, 0);
	}

	private function moveHorizontally()
	{
		xVelocity += xAcceleration * speed;

		if(Math.abs(xVelocity) > maxVelocity)
			xVelocity = maxVelocity * HXP.sign(xVelocity);

		if(xVelocity < 0)
		{
			xVelocity = Math.min(xVelocity + drag, 0);

			if(x - scene.camera.x < 5)
				xVelocity = 0;
		}
		else if (xVelocity > 0)
		{
			xVelocity = Math.max(xVelocity - drag, 0);

			if(x > scene.camera.x + HXP.width - width)
				xVelocity = 0;
		}
	}
}