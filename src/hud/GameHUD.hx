package hud;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.prototype.Rect;

import model.events.HUDEvent;
import model.events.EntityEvent;
import model.proxy.PlayerProxy;

import nme.text.TextFormatAlign;

import org.events.EventManager;

class GameHUD extends Graphiclist
{
	static inline var ENEMY_SCORE_TEMPLATE:String = "Score: ";
	//static inline var CHECKPOINTS_TEMPLATE:String = "Checkpoints: ";

	static inline var MAX_HEALTH:Int = 100;

	private var enemyScoreT:Text;
	private var xpText:Text;
	private var healthBar:Canvas;
	private var enemyScore:Int = 0;
	private var currentHealth:Int = 100;

	private var em:EventManager;

	private var playerProxy:PlayerProxy;

	public function new()
	{
		super();

		playerProxy = PlayerProxy.cloneInstance();

		currentHealth = MAX_HEALTH;

		//trace(currentHealth + "-----------------------------------------------------------");

		init();
	}

	public function clearListeners()
	{
		em.removeEventListener(HUDEvent.KILL_SCORE, onScore);
		em.removeEventListener(HUDEvent.UPDATE_HEALTH, onUpdateHealth);
	}

	public function updateScore(defaultScore:Int = 1)
	{
		enemyScore += defaultScore;

		enemyScoreT.text = Std.string(enemyScore);
	}

	public function updateHealth(health:Int)
	{
		if(health == 0 || (currentHealth <= 0 && health < 0) || (currentHealth >= MAX_HEALTH && health > 0))
			return;

		currentHealth += health;

		if(currentHealth > MAX_HEALTH)
			currentHealth = MAX_HEALTH;

		if(currentHealth < 0)
			currentHealth = 0;

		if(currentHealth == 0)
			em.dispatchEvent(new EntityEvent(EntityEvent.PLAYER_DEAD));

		remove(healthBar);

		drawHealth(currentHealth);
	}

	private function init()
	{
		var textOptions:TextOptions = {font: "font/xoloniumregular.ttf", color: 0x00FF00, align: TextFormatAlign.RIGHT};

		enemyScoreT = new Text(Std.string(enemyScore), 30, 27, 120, 16, textOptions);
		xpText = new Text("Level " + playerProxy.level + " - " + playerProxy.experience + " / " + playerProxy.levelLimit, 30, 3, 120, 16, textOptions);

		var c = new Canvas(HXP.width, 100); // healthBar mask
		c.drawGraphic(282, 13, new Rect(204 , 32 , 0x000000 ));

		add(c);
		add(new Image("gfx/hud.png"));
		add(enemyScoreT);
		add(xpText);

		drawHealth(currentHealth);

		scrollX = scrollY = 0;

		em = EventManager.cloneInstance();

		em.addEventListener(HUDEvent.KILL_SCORE, onScore, false, 0, true);
		em.addEventListener(HUDEvent.UPDATE_HEALTH, onUpdateHealth, false, 0, true);
	}

	private function drawHealth(value:Int)
	{
		if(value <= 0)
			return;

		healthBar = new Canvas(HXP.width, 100);
		healthBar.drawGraphic(287, 19, new Rect(value * 2 - 9, 20, getHealthBarColor())); // this will be dynamically rendered

		add(healthBar);
	}

	private function getHealthBarColor():Int
	{
		var colors:Array<Int> = [
			0xFF0000, 0xEE1100, 0xDD2200, 0xCC3300, 0xBB4400, 
			0x44CC00, 0x33CC00, 0x22DD00, 0x11EE00, 0x00FF00
		];

		return colors[Std.int(currentHealth / 10) - 1];
	}

	private function updateExperience(amount:Int)
	{
		playerProxy.increaseExperience(amount);

		xpText.text = "Level " + playerProxy.level + " - " + playerProxy.experience + " / " + playerProxy.levelLimit;
	}

	// ---------------------- Handlers ------------------------

	private function onScore(e:HUDEvent)
	{
		updateScore(e.score);
		updateExperience(e.xp);
	}

	private function onUpdateHealth(e:HUDEvent)
	{
		updateHealth(e.health);
	}
}