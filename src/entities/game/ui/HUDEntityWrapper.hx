package entities.game.ui;

import com.haxepunk.graphics.Image;

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
		layer = 0;
	}

	override public function added()
	{
		graphic = hud;

		playerProxy = PlayerProxy.cloneInstance();

		currentHealth = playerProxy.getMaxHealth();
		currentEnergy = playerProxy.getMaxEnergy();

		playerProxy.updateEnergy(currentEnergy);

		initListener();
	}

	override public function removed()
	{
		hud = null;

		clearListeners();
	}

	private function initListener()
	{
		em = EventManager.cloneInstance();

		//em.addEventListener(HUDEvent.KILL_SCORE, onScore, false, 0, true);
		em.addEventListener(HUDEvent.UPDATE_HEALTH, onUpdateHealth, false, 0, true);
		em.addEventListener(HUDEvent.UPDATE_ENERGY, onUpdateEnergy, false, 0, true);
	}


	public function clearListeners()
	{
		em.removeEventListener(HUDEvent.UPDATE_HEALTH, onUpdateHealth);
		em.removeEventListener(HUDEvent.UPDATE_ENERGY, onUpdateEnergy);
	}

	private function onUpdateHealth(e:HUDEvent)
	{
		currentHealth = getUpdatedStatValue(currentHealth, e.health, playerProxy.getMaxHealth());

		hud.drawHealth(currentHealth, playerProxy.getMaxHealth());

		if(currentHealth == 0)
			em.dispatchEvent(new EntityEvent(EntityEvent.PLAYER_DEAD));
	}

	private function onUpdateEnergy(e:HUDEvent)
	{
		currentEnergy = getUpdatedStatValue(currentEnergy, e.energy, playerProxy.getMaxEnergy());

		hud.drawEnergy(currentEnergy, playerProxy.getMaxHealth());

		playerProxy.updateEnergy(currentEnergy);			
	}

	private function getUpdatedStatValue(stat:Int, value:Int, statMax:Int):Dynamic
	{
		stat += value;

		if(stat > statMax)
			stat = statMax;

		if(stat < 0)
			stat = 0;

		return stat;
	}

}