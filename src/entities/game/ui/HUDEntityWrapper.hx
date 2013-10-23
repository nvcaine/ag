package entities.game.ui;

import com.haxepunk.graphics.Image;

import model.consts.LayerConsts;
import model.events.HUDEvent;
import model.events.EntityEvent;
import model.proxy.PlayerProxy;

import org.actors.SimpleMessageEntity;
import org.events.EventManager;

class HUDEntityWrapper extends SimpleMessageEntity
{
	private var currentHealth:Int;
	private var currentEnergy:Int;

	private var data:Dynamic;
	private var em:EventManager;

	private var playerProxy:PlayerProxy;
	private var hud:GameHUD;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		hud = new GameHUD({background: "gfx/hud2.png", healthBar: "gfx/hp.png", energyBar: "gfx/energy.png"});
		layer = LayerConsts.TOP;

		eventHandlers = [
			{event: HUDEvent.UPDATE_HEALTH, handler: onUpdateHealth},
			{event: HUDEvent.UPDATE_ENERGY, handler: onUpdateEnergy}
		];
	}

	override public function added()
	{
		super.added();

		graphic = hud;

		playerProxy = PlayerProxy.cloneInstance();

		currentHealth = playerProxy.getMaxHealth();
		currentEnergy = playerProxy.getMaxEnergy();

		playerProxy.updateEnergy(currentEnergy);
	}

	override public function removed()
	{
		super.removed();

		hud = null;
	}

	private function onUpdateHealth(e:HUDEvent)
	{
		currentHealth = getClampedValue(currentHealth, e.health, playerProxy.getMaxHealth());

		hud.drawHealth(currentHealth, playerProxy.getMaxHealth());

		if(currentHealth == 0)
			sendMessage(new EntityEvent(EntityEvent.PLAYER_DEAD));
	}

	private function onUpdateEnergy(e:HUDEvent)
	{
		currentEnergy = getClampedValue(currentEnergy, e.energy, playerProxy.getMaxEnergy());

		hud.drawEnergy(currentEnergy, playerProxy.getMaxHealth());

		playerProxy.updateEnergy(currentEnergy);			
	}

	private function getClampedValue(current:Int, offset:Int, max:Int, min:Int = 0):Dynamic
	{
		return Math.max(min, Math.min(current + offset, max)); // min <= x <= max - ALWAYS
	}
}