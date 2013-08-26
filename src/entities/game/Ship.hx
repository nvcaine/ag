package entities.game;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;

import model.consts.EntityTypeConsts;
import model.consts.PlayerConsts;
import model.events.HUDEvent;

import nme.geom.Point;

import org.actors.MessageEntity;

class Ship extends MessageEntity
{
	private var maxSpeed:Float = 0;
	private var xVelocity:Float = 0;
	private var yVelocity:Float = 0;
	private var yAcceleration:Float = 0;
	private var xAcceleration:Float = 0;

	public function new(x:Float, y:Float, data:Dynamic)
	{
		super(x, y);

		init(data);
	}

	override public function update()
	{
		super.update();

		moveVertically();
		moveHorizontally();

		moveBy(xVelocity, -PlayerConsts.DEFAULT_SPEED + yVelocity, EntityTypeConsts.LEVEL);
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
		scene.add(createNewProjectile(x + width / 2 - 40, y + 10));
		scene.add(createNewProjectile(x + width / 2 + 40, y + 10));
	}

	private function createNewProjectile(x:Float, y:Float):Projectile
	{
		var data:Dynamic = {assetPath: "gfx/glontz.png", sound: "sfx/laser.mp3", width: 20, height: 5, damage: 50};

		return new Projectile(x, y, data);
	}

	override private function initGraphic(data:Dynamic)
	{
		var layers:Array<Image> = [];
		var g:Graphiclist = new Graphiclist();

		if(data.addedStuff != null)
			for(i in 0...data.addedStuff.length)
				layers.push(new Image(data.addedStuff[i].assetPath));

		layers.push(new Image(data.assetPath));

		graphic = new Graphiclist(layers);

		setGraphicHitbox(data);
	}

	private function init(data:Dynamic)
	{
		type = EntityTypeConsts.PLAYER;

		initGraphic(data);
		maxSpeed = data.speed;
	}

	private function onLevelCollision()
	{
		//sendMessage(new HUDEvent(HUDEvent.ENEMY_COLLISION));
	}

	private function moveVertically()
	{
		if(y < scene.camera.y)
		{
			yVelocity = 0;
			y = scene.camera.y;
			return;
		}

		if(y > scene.camera.y + HXP.height - 150)
		{
			y = scene.camera.y + HXP.height - 150;
			yVelocity = 0;
			return;
		}

		yVelocity += yAcceleration;

		if(Math.abs(yVelocity) > maxSpeed)
			yVelocity = maxSpeed * HXP.sign(yAcceleration);

		if(yVelocity < 0)
			yVelocity = Math.min(yVelocity + PlayerConsts.DRAG, 0);
		else if(yVelocity > 0)
			yVelocity = Math.max(yVelocity - PlayerConsts.DRAG, 0);
	}

	private function moveHorizontally()
	{
		if(x < 0)
		{
			xVelocity = 0;
			x = 0;
			return;
		}

		if(x > HXP.width - width)
		{
			xVelocity = 0;
			x = HXP.width - width;
			return;
		}

		xVelocity += xAcceleration;

		if(Math.abs(xVelocity) > maxSpeed)
			xVelocity = maxSpeed * HXP.sign(xAcceleration);

		if(xVelocity < 0)
			xVelocity = Math.min(xVelocity + PlayerConsts.DRAG, 0);
		else if(xVelocity > 0)
			xVelocity = Math.max(xVelocity - PlayerConsts.DRAG, 0);
	}
}