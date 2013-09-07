package entities.game.ships;

import com.haxepunk.HXP;

import entities.game.misc.Projectile;

import model.consts.EntityTypeConsts;
import model.consts.PlayerConsts;

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

	override public function update()
	{
		moveVertically();
		moveHorizontally();

		moveBy(xVelocity, yVelocity, EntityTypeConsts.LEVEL);
	}

	public function setAcceleration(xAcc:Float, yAcc:Float)
	{
		xAcceleration = xAcc;
		yAcceleration = yAcc;
	}

	public function shoot(template:Dynamic, ?availableEnergy:Float, ?requiredEnergy:Float)
	{
		if((availableEnergy != null && requiredEnergy != null) && availableEnergy < requiredEnergy)
			return;

		scene.add(createNewProjectile(width / 2 - 40, 10, template));
		scene.add(createNewProjectile(width / 2 + 32, 10, template));
	}

	private function createNewProjectile(xOffset:Float, yOffset:Float, projectileData:Dynamic):Projectile
	{
		return new Projectile(this.x + xOffset, this.y + yOffset, projectileData);
	}

	private function moveVertically()
	{
		yVelocity += yAcceleration;

		yVelocity = getVelocity(scene.camera.y, scene.camera.y + HXP.height - height, y, yVelocity);
		yVelocity = getClampedVelocity(yVelocity, yAcceleration, data.speed);
		yVelocity = getDraggedVelocity(yVelocity, PlayerConsts.DRAG);
	}

	private function moveHorizontally()
	{
		xVelocity += xAcceleration;

		xVelocity = getVelocity(0, HXP.width - this.width, this.x, xVelocity);
		xVelocity = getClampedVelocity(xVelocity, xAcceleration, data.speed);
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