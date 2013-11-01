package entities.game;

import com.haxepunk.HXP;
import com.haxepunk.Scene;

import entities.game.misc.Projectile;

import model.dto.ProjectileDTO;
import model.dto.WeaponDTO;
import model.events.HUDEvent;
import model.proxy.PlayerProxy;

import org.events.EventManager;

class Weapon
{
	private var data:WeaponDTO;
	private var timer:Float = 0;
	private var xOffset:Float;
	private var yOffset:Float;
	//private var em:EventManager;

	private var flipped:Bool;

	public function new(data:WeaponDTO, xOffset:Float = 0, yOffset:Float = 0, isFlipped:Bool = false)
	{
		this.data = data;

		this.xOffset = xOffset;
		this.yOffset = yOffset;

		this.flipped = isFlipped;
		//em = EventManager.cloneInstance();
	}

	public function fire(xSource:Float, ySource:Float, scene:Scene, flipped:Bool = false)
	{
		timer -= HXP.elapsed;

		if(timer >= 0)// || PlayerProxy.cloneInstance().getAvailableEnergy() < data.energy)
			return;

		if(timer < 0)
			timer = data.fireDelay;

		scene.add(createProjectile(xSource + xOffset, ySource + yOffset, data.projectile));
		//em.dispatchEvent(new HUDEvent(HUDEvent.UPDATE_ENERGY, 0, 0, 0, -Std.int(data.energy)));
		// let the player handle this
	}

	private function createProjectile(x:Float, y:Float, projectileData:ProjectileDTO):Projectile
	{
		var copy:ProjectileDTO = projectileData;

		copy.damage = data.damage;

		return new Projectile(x, y, copy, flipped);
	}
}