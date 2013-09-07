package entities.game;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import entities.game.misc.Projectile;
import entities.game.ships.PlayerShip;

import model.events.HUDEvent;

import model.proxy.PlayerProxy;
import model.proxy.ProjectileProxy;

import nme.events.TimerEvent;
import nme.utils.Timer;

import org.events.EventManager;

import scenes.GameScene;

class Player
{
	private var entity:PlayerShip;
	private var scene:GameScene;

	private var shootTimer:Float = 0.25;
	private var energyRegenTimer:Float = 0.1;

	private var em:EventManager;
	private var playerProxy:PlayerProxy;

	public function new(x:Float, y:Float, scene:GameScene)
	{
		this.scene = scene;

		em = EventManager.cloneInstance();
		playerProxy = PlayerProxy.cloneInstance();

		entity = scene.add(new PlayerShip(x, y, playerProxy.playerData.shipTemplate));
		entity.layer = 0;

		defineInput();
	}

	public function handleInput()
	{
		var xAcc:Int = 0, yAcc:Int = 0;

		if(Input.check("up"))
			yAcc = -1;			

		if(Input.check("down"))
			yAcc = 1;

		if(Input.check("left"))
			xAcc = -1;

		if(Input.check("right"))
			xAcc = 1;

		if(Input.check("shoot") && shootTimer < 0)
			shoot(ProjectileProxy.cloneInstance().projectileTemplate, playerProxy.getAvailableEnergy(), 10);

		if(energyRegenTimer < 0)
			regenerateEnergy(playerProxy.playerData.shipTemplate.energyRegen);

		entity.setAcceleration(xAcc, yAcc);

		shootTimer -= HXP.elapsed;
		energyRegenTimer -=  HXP.elapsed;
	}

	public function shoot(template:Dynamic, ?availableEnergy:Float, ?requiredEnergy:Float)
	{
		if((availableEnergy != null && requiredEnergy != null) && availableEnergy < requiredEnergy)
			return;

		scene.add(createNewProjectile(entity.width / 2 - 40, 10, template));
		scene.add(createNewProjectile(entity.width / 2 + 32, 10, template));

		shootTimer = 0.25;

		// parse items, call "fire" on weapons
	}

	private function createNewProjectile(xOffset:Float, yOffset:Float, projectileData:Dynamic):Projectile
	{
		return new Projectile(entity.x + xOffset, entity.y + yOffset, projectileData);
	}

	private function defineInput()
	{
		Input.define("up", [Key.UP, Key.W]);
		Input.define("down", [Key.DOWN, Key.S]);
		Input.define("shoot", [Key.X]);
		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("regen", [Key.Z]);
	}

	private function regenerateEnergy(amount:Int)
	{
		em.dispatchEvent(new HUDEvent(HUDEvent.UPDATE_ENERGY, 0, 0, 0, amount));

		energyRegenTimer = 0.1;
	}
}