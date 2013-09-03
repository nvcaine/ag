package entities.game;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;

import model.events.HUDEvent;
import model.events.EntityEvent;

import nme.geom.Rectangle;

import org.events.EventManager;

import model.proxy.PlayerProxy;

class GameHUD extends Graphiclist
{
	static inline var MAX_HEALTH:Int = 100;
	static inline var MAX_ENERGY:Int = 100;

	private var currentHealth:Int;
	private var currentEnergy:Int;

	private var data:Dynamic;
	private var hpBar:Image;
	private var energyBar:Image;

	private var em:EventManager;

	public function new(data:Dynamic)
	{
		super();

		this.data = data;
		init(data);
		initListener();
	}

	public function takeDamage(damage:Int)
	{
		if(currentHealth <= 0)
			return;

		currentHealth += damage;

		if(currentHealth <= 0)
		{
			currentHealth = 0;
			em.dispatchEvent(new EntityEvent(EntityEvent.PLAYER_DEAD));
		}

		drawHealth();
	}

	public function useEnergy(energy:Int)
	{
		if(currentEnergy <= 0)
			return;

		currentEnergy += energy;

		if(currentEnergy <= 0)
			currentEnergy = 0;

		//remove(energyBar);

		PlayerProxy.cloneInstance().updateEnergy(currentEnergy);

		drawEnergy();
	}

	private function init(data:Dynamic)
	{
		var bg:Image = new Image(data.background);

		bg.scrollX = bg.scrollY = 0;

		add(bg);

		currentHealth = MAX_HEALTH;
		currentEnergy = MAX_ENERGY;

		drawHealth();
		drawEnergy();

		PlayerProxy.cloneInstance().updateEnergy(currentEnergy);
	}

	private function initListener()
	{
		em = EventManager.cloneInstance();

		//em.addEventListener(HUDEvent.KILL_SCORE, onScore, false, 0, true);
		em.addEventListener(HUDEvent.UPDATE_HEALTH, onUpdateHealth, false, 0, true);
		em.addEventListener(HUDEvent.UPDATE_ENERGY, onUpdateEnergy, false, 0, true);
	}

	private function drawEnergy()
	{
		if(currentEnergy <= 0)
			return;

		remove(energyBar);

		var length = 239 - getBarLength(currentEnergy, MAX_ENERGY, 239);

		energyBar = new Image(data.energyBar, new Rectangle(length, 0, 239, 26));
		energyBar.x = 348 + length;
		energyBar.y = 4;
		energyBar.scrollX = energyBar.scrollY = 0;

		add(energyBar);
	}

	private function drawHealth()
	{
		if(currentHealth <= 0)
			return;

		remove(hpBar);

		hpBar = new Image(data.hpBar, new Rectangle(0, 0, getBarLength(currentHealth, MAX_HEALTH, 239), 26));

		hpBar.x = 13;
		hpBar.y = 4;
		hpBar.scrollX = hpBar.scrollY = 0;

		add(hpBar);
	}

	private function getBarLength(health:Float, maxHealth:Float, maxLength:Float):Int
	{
		return Std.int(health * maxLength / maxHealth);
	}

	private function onUpdateHealth(e:HUDEvent)
	{
		if(e.health < 0)
		{
			takeDamage(e.health);
			return;
		}

		currentHealth += e.health;

		if(currentHealth > MAX_HEALTH)
			currentHealth = MAX_HEALTH;

		drawHealth();
	}

	private function onUpdateEnergy(e:HUDEvent)
	{
		if(e.energy < 0)
		{
			useEnergy(e.energy);
			return;
		}

		if(currentEnergy < MAX_ENERGY)
			currentEnergy += e.energy;

		if(currentEnergy > MAX_ENERGY)
			currentEnergy = MAX_ENERGY;

		drawEnergy();

		PlayerProxy.cloneInstance().updateEnergy(currentEnergy);
	}
}