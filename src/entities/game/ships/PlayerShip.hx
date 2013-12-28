package entities.game.ships;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.masks.Pixelmask;

import entities.game.misc.Projectile;

import model.consts.EntityTypeConsts;
import model.consts.PlayerConsts;
import model.events.HUDEvent;

class PlayerShip extends ShipEntity
{
	private var xVelocity:Float = 0;
	private var yVelocity:Float = 0;

	private var yAcceleration:Float = 0;
	private var xAcceleration:Float = 0;

	public function new(x:Float, y:Float, data:Dynamic)
	{
		super(x, y, data);

		this.type = EntityTypeConsts.PLAYER;
	}

	override public function added()
	{
		super.added();

		mask = new Pixelmask(getEntityBitmapData(data.assetPath, data.hardpoints));
	}

	override public function moveCollideX(e:Entity):Bool
	{
		xVelocity = data.speed * -xAcceleration;

		return true;
	}

	override public function moveCollideY(e:Entity):Bool
	{
		yVelocity = data.speed * -yAcceleration;

		return true;
	}

	override public function update()
	{
		super.update();

		xVelocity = getAcceleratedVelocity(xVelocity, xAcceleration, 0, HXP.width - width, x, data.speed, PlayerConsts.DRAG);
		yVelocity = getAcceleratedVelocity(yVelocity, yAcceleration, 0, HXP.height - height, y, data.speed, PlayerConsts.DRAG);

		moveBy(xVelocity, yVelocity, EntityTypeConsts.LEVEL);

		if(yVelocity == 0 && collideTypes([EntityTypeConsts.LEVEL], x, y) != null)
			yVelocity = data.speed;
	}

	override public function takeDamage(damage:Float)
	{
		//sendMessage(new HUDEvent(HUDEvent.UPDATE_HEALTH, 0, -damage));
	}

	public function setAcceleration(xAcc:Float, yAcc:Float)
	{
		xAcceleration = xAcc;
		yAcceleration = yAcc;
	}

	private function getAcceleratedVelocity(velocity:Float, acceleration:Float, min:Float, max:Float, currentValue:Float, speed:Float, drag:Float)
	{
		var result:Float = velocity + acceleration;

		result = getVelocity(min, max, currentValue, result);
		result = getClampedVelocity(result, acceleration, speed);
		result = getDraggedVelocity(result, drag);

		return result;
	}

	private function getVelocity(min:Float, max:Float, currentValue:Float, velocity:Float):Float
	{
		if(currentValue + velocity < min)
			return (min - currentValue);

		if(currentValue + velocity > max)
			return (max - currentValue);

		return velocity;
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