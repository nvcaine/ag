package entities.game;

import com.haxepunk.HXP;

import model.consts.EntityTypeConsts;
import model.consts.PlayerConsts;

class PlayerShip extends GameEntity
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
		super.update();

		moveVertically();
		moveHorizontally();

		moveBy(xVelocity, -PlayerConsts.DEFAULT_SPEED + yVelocity, EntityTypeConsts.LEVEL);
	}

	public function setAcceleration(xAcc:Float, yAcc:Float)
	{
		xAcceleration = xAcc;
		yAcceleration = yAcc;
	}

	public function shoot(availableEnergy:Float, requiredEnergy:Float)
	{
		if(availableEnergy < requiredEnergy)
			return;

		scene.add(createNewProjectile(x + width / 2 - 40, y + 10));
		scene.add(createNewProjectile(x + width / 2 + 32, y + 10));
	}

	private function createNewProjectile(x:Float, y:Float):Projectile
	{
		var data:Dynamic = {
			assetPath: "gfx/glontz.png",
			sound: "sfx/laser.mp3",
			width: 20, height: 5,
			damage: 50, energy: 5
		};

		return new Projectile(x, y, data);
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