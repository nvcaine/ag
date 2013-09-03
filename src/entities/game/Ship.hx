package entities.game;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;

import model.consts.EntityTypeConsts;
import model.consts.PlayerConsts;
import model.events.HUDEvent;
import model.proxy.PlayerProxy;

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
		if(PlayerProxy.cloneInstance().getAvailableEnergy() >= 10)
			scene.add(createNewProjectile(x + width / 2 - 40, y + 10));

		if(PlayerProxy.cloneInstance().getAvailableEnergy() >= 10)
			scene.add(createNewProjectile(x + width / 2 + 40, y + 10));
	}

	public function updateEnergy(energy:Int)
	{
		sendMessage(new HUDEvent(HUDEvent.UPDATE_ENERGY, 0, 0, 0, energy));
	}

	private function createNewProjectile(x:Float, y:Float):Projectile
	{
		var data:Dynamic = {assetPath: "gfx/glontz.png", sound: "sfx/laser.mp3", width: 20, height: 5, damage: 50, energy: 5};

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
		yVelocity += yAcceleration;

		yVelocity = getVelocity(scene.camera.y, scene.camera.y + HXP.height - height, y, yVelocity);
		yVelocity = getClampedVelocity(yVelocity, yAcceleration, maxSpeed);
		yVelocity = getDraggedVelocity(yVelocity, PlayerConsts.DRAG);
	}

	private function moveHorizontally()
	{
		xVelocity += xAcceleration;

		xVelocity = getVelocity(0, HXP.width - this.width, this.x, xVelocity);
		xVelocity = getClampedVelocity(xVelocity, xAcceleration, maxSpeed);
		xVelocity = getDraggedVelocity(xVelocity, PlayerConsts.DRAG);
	}

	private function getVelocity(min:Float, max:Float, currentY:Float, currentVelocity:Float):Float
	{
		if(currentY + currentVelocity < min)
			return (min - currentY);

		if(currentY + currentVelocity > max)
			return (max - currentY);

		return currentVelocity;
	}

	private function getClampedVelocity(velocity:Float, acceleration:Float, maxSpeed:Float)
	{
		if(Math.abs(velocity) > maxSpeed)
			return maxSpeed * HXP.sign(acceleration);

		return velocity;
	}

	private function getDraggedVelocity(velocity:Float, drag:Float):Float
	{
		if(velocity < 0)
			return Math.min(velocity + drag, 0);

		else if(velocity > 0)
			return Math.max(velocity - drag, 0);

		return 0;
	}
}