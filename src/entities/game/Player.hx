package entities.game;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import entities.game.Weapon;
import entities.game.misc.Projectile;
import entities.game.ships.PlayerShip;

import model.consts.EntityTypeConsts;
import model.consts.ItemTypeConsts;
import model.dto.HardpointDTO;
import model.dto.ItemDTO;
import model.dto.WeaponDTO;
import model.events.EntityEvent;
import model.events.HUDEvent;
import model.proxy.PlayerProxy;
import model.proxy.ProjectileProxy;

import nme.Assets;
import nme.display.BitmapData;

import org.events.EventManager;

import scenes.GameScene;

class Player
{
	private var entity:PlayerShip;
	private var scene:GameScene;

	private var energyRegenTimer:Float;
	private var weapons:Array<Weapon>;

	private var em:EventManager;
	private var playerProxy:PlayerProxy;

	public function new(x:Float, y:Float, scene:GameScene)
	{
		this.scene = scene;

		em = EventManager.cloneInstance();
		playerProxy = PlayerProxy.cloneInstance();

		entity = new PlayerShip(x, y, playerProxy.playerData.shipTemplate);
		scene.add(entity);

		energyRegenTimer = playerProxy.getEnergyRegenRate();

		defineInput();
	}

	public function handleInput()
	{
		handleAcceleration();

		if(Input.check("shoot"))
			entity.fire([EntityTypeConsts.ENEMY], true);

		regenerateEnergy(playerProxy.playerData.shipTemplate.energyRegen, playerProxy.getEnergyRegenRate());

	}

	public function die()
	{
		em.dispatchEvent(new EntityEvent(EntityEvent.ENTITY_EXPLOSION, entity.x + entity.width / 2, entity.y + entity.height / 2));

		scene.remove(entity);

		entity = null;
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

	private function handleAcceleration()
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

		entity.setAcceleration(xAcc, yAcc);
	}

	private function regenerateEnergy(amount:Int, regenRate:Float = 0.1)
	{
		if(playerProxy.getAvailableEnergy() == playerProxy.getMaxEnergy())
			return;

		if(energyRegenTimer < 0)
		{
			em.dispatchEvent(new HUDEvent(HUDEvent.UPDATE_ENERGY, 0, 0, 0, amount));

			energyRegenTimer = regenRate;
		}

		energyRegenTimer -=  HXP.elapsed;
	}
}