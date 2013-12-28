package entities.game;

import com.haxepunk.HXP;
import com.haxepunk.Scene;

import entities.game.misc.Plasma;
import entities.game.misc.Projectile;

import model.consts.ProjectileTypeConsts;
import model.dto.ProjectileDTO;
import model.dto.WeaponDTO;
import model.events.HUDEvent;
import model.proxy.PlayerProxy;

import org.events.EventManager;

class Weapon
{
	private var data:WeaponDTO;
	private var fireTimer:Float = 0;
	private var xOffset:Float;
	private var yOffset:Float;

	private var flipped:Bool;

	public function new(data:WeaponDTO, xOffset:Float = 0, yOffset:Float = 0, isFlipped:Bool = false)
	{
		this.data = data;

		this.xOffset = xOffset;
		this.yOffset = yOffset;

		this.flipped = isFlipped;
	}

	public function update()
	{
		if(fireTimer <= 0)
			return;

		fireTimer -= HXP.elapsed;
	}

	public function fire(xSource:Float, ySource:Float, scene:Scene, flipped:Bool = false, entityTypes:Array<String> = null, drainEnergy:Bool = false)
	{
		if((fireTimer > 0) || (drainEnergy && PlayerProxy.cloneInstance().getAvailableEnergy() < data.energy))
			return;

		fireProjectile(xSource + xOffset, ySource + yOffset, scene, entityTypes, drainEnergy);
	}

	private function createProjectile(x:Float, y:Float, projectileData:ProjectileDTO, entityTypes:Array<String>):Projectile
	{
		var copy:ProjectileDTO = projectileData;

		copy.damage = data.damage;

		if(projectileData.type == ProjectileTypeConsts.PLASMA)
			return new Plasma(x, y, copy, flipped, entityTypes); //Projectile

		return new Projectile(x, y, copy, flipped, entityTypes);
	}

	private function fireProjectile(x:Float, y:Float, scene:Scene, entityTypes:Array<String>, drainEnergy:Bool = false)
	{
		fireTimer = data.fireDelay;
	
		scene.add(createProjectile(x, y, data.projectile, entityTypes));

		if(drainEnergy)
			EventManager.cloneInstance().dispatchEvent(new HUDEvent(HUDEvent.UPDATE_ENERGY, 0, 0, 0, -data.energy));
	}
}