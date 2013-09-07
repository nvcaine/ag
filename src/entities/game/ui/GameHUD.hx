package entities.game.ui;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;

import model.events.HUDEvent;
import model.events.EntityEvent;

import nme.geom.Rectangle;

import org.events.EventManager;

import model.proxy.PlayerProxy;

class GameHUD extends Graphiclist
{
	private var currentHealth:Int;
	private var currentEnergy:Int;
	private var healthBar:Image;
	private var energyBar:Image;

	private var data:Dynamic;
	private var em:EventManager;

	private var playerProxy:PlayerProxy;

	public function new(data:Dynamic)
	{
		super();

		this.data = data;
		init(this.data);
		initListener();
	}

	private function init(data:Dynamic)
	{
		playerProxy = PlayerProxy.cloneInstance();

		currentHealth = playerProxy.getMaxHealth();
		currentEnergy = playerProxy.getMaxEnergy();

		playerProxy.updateEnergy(currentEnergy);

		add(new Image(data.background));

		healthBar = createBar(data.healthBar, 13, 4);
		energyBar = createBar(data.energyBar, 348, 4);
	}

	private function createBar(asset:String, xOffset:Int, yOffset:Int):Image
	{
		var bar:Image = cast(add(new Image(asset)), Image);

		bar.x = xOffset;
		bar.y = yOffset;

		return bar;
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
		remove(energyBar);

		energyBar = getBarImage(data.energyBar, 348, 4, 239, 26, currentEnergy, playerProxy.getMaxEnergy(), true);

		add(energyBar);
	}

	private function drawHealth()
	{
		remove(healthBar);

		healthBar = getBarImage(data.healthBar, 13, 4, 239, 26, currentHealth, playerProxy.getMaxHealth());

		add(healthBar);
	}

	private function getBarImage(asset:String, xOffset:Int, yOffset:Int, width:Int, height:Int, value:Int, max:Int, reversed:Bool = false):Image
	{
		var length:Int = getBarLength(value, max, width);
		var startOffset:Int = 0;
		var endOffset:Int = length;

		if(reversed)
		{
			startOffset = width - length;
			endOffset = width;
		}

		var bar:Image = new Image(asset, new Rectangle(startOffset, 0, endOffset, height));

		bar.x = xOffset + startOffset;
		bar.y = yOffset;

		return bar;
	}

	private function getBarLength(health:Float, maxHealth:Float, maxLength:Float):Int
	{
		return Std.int(health * maxLength / maxHealth);
	}

	private function onUpdateHealth(e:HUDEvent)
	{
		currentHealth = getUpdatedStatValue(currentHealth, e.health, playerProxy.getMaxHealth());

		drawHealth();

		if(currentHealth == 0)
			em.dispatchEvent(new EntityEvent(EntityEvent.PLAYER_DEAD));
	}

	private function onUpdateEnergy(e:HUDEvent)
	{
		currentEnergy = getUpdatedStatValue(currentEnergy, e.energy, playerProxy.getMaxEnergy());

		drawEnergy();

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