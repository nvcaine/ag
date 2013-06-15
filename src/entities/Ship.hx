package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import flash.events.TimerEvent;
import flash.utils.Timer;

import model.consts.EntityTypeConsts;
import model.events.HUDEvent;

import org.actors.MessageEntity;

class Ship extends MessageEntity
{
	private var velocity:Float;
	private var xVelocity:Float;
	private var acceleration:Float;
	private var xAcceleration:Float;
	private var t:Timer;
	private var canShoot:Bool;

	static private inline var maxVelocity:Float = 8;
	static private inline var speed:Float = 3;
	static private inline var drag:Float = 0.4;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		setHitbox(32, 32);

		init();
	}

	override public function update()
	{
		handleInput();

		moveVertically();
		moveHorizontally();

		moveBy(1.5 + xVelocity, velocity, EntityTypeConsts.LEVEL);

		super.update();
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

	private function init()
	{
		canShoot = true;
		type = EntityTypeConsts.PLAYER;
		velocity = xVelocity = 0;

		graphic = new Image("gfx/ship.png");

		t = new Timer(200);
		t.addEventListener("timer", onTimer);

		defineInput();
	}

	private function onLevelCollision()
	{
		sendMessage(new HUDEvent(HUDEvent.ENEMY_COLLISION));
	}

	private function defineInput()
	{
		Input.define("up", [Key.UP, Key.W]);
		Input.define("down", [Key.DOWN, Key.S]);
		Input.define("shoot", [Key.X]);
		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
	}

	private function handleInput()
	{
		acceleration = xAcceleration = 0;

		if(Input.check("up"))
			acceleration = -1;

		if(Input.check("down"))
			acceleration = 1;

		if(Input.check("left"))
			xAcceleration = -1;

		if(Input.check("right"))
			xAcceleration = 1;

		if(Input.check("shoot") && canShoot)
			shoot();
	}

	private function shoot()
	{
		t.start();
		canShoot = false;

		scene.add(new Projectile(x + width, y + height / 2, {assetPath: "gfx/plasma.png", sound: "sfx/laser.mp3", width: 20, height: 5, damage: 50}));
	}

	private function onTimer(e:TimerEvent)
	{
		//t.removeEventListener("timer", onTimer); - // should remove the listener, so as not to prevent garbage collection

		canShoot = true;
	}

	private function moveVertically()
	{
		velocity += acceleration * speed;

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