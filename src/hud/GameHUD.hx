package hud;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.prototype.Rect;

import model.events.HUDEvent;
import model.events.EntityEvent;

import org.events.EventManager;

class GameHUD extends Graphiclist
{
	static inline var ENEMY_SCORE_TEMPLATE:String = "Score: ";
	static inline var CHECKPOINTS_TEMPLATE:String = "Checkpoints: ";

	static inline var MAX_HEALTH:Int = 100;

	private var enemyScoreT:Text;
	private var checkpointsText:Text;
	private var healthBar:Canvas;
	private var enemyScore:Int = 0;
	private var currentHealth:Int = 100;

	private var em:EventManager;

	public function new()
	{
		super();

		init();
	}

	public function updateScore(defaultScore:Int = 1)
	{
		enemyScore += defaultScore;

		enemyScoreT.text = ENEMY_SCORE_TEMPLATE + Std.string(enemyScore);
	}

	public function updateHealth(health:Int)
	{
		if(health == 0 || (currentHealth <= 0 && health < 0) || (currentHealth >= MAX_HEALTH && health > 0))
			return;

		currentHealth += health;

		if(currentHealth <= 0)
			em.dispatchEvent(new EntityEvent(EntityEvent.PLAYER_DEAD));

		if(count > 2)
			removeAt(2);

		trace(currentHealth);
		drawHealth(currentHealth);
	}

	public function updateCheckpoint(checkpointIndex:Int)
	{
		checkpointsText.text = CHECKPOINTS_TEMPLATE + Std.string(checkpointIndex);
	}

	private function init()
	{
		enemyScoreT = new Text(ENEMY_SCORE_TEMPLATE + Std.string(enemyScore), 10, 10, 0, 0);
		checkpointsText = new Text(CHECKPOINTS_TEMPLATE, 10, 30, 0, 0);

		add(enemyScoreT);
		add(checkpointsText);
		drawHealth(currentHealth);

		scrollX = 0;
		scrollY = 0;

		em = EventManager.cloneInstance();

		//em.addEventListener(HUDEvent.ENEMY_COLLISION, onEnemyCollision);
		em.addEventListener(HUDEvent.KILL_SCORE, onScore);
		em.addEventListener(HUDEvent.UPDATE_HEALTH, onUpdateHealth);
	}

	private function drawHealth(value:Int)
	{
		if(value <= 0)
			return;

		healthBar = new Canvas(HXP.width, 100);
		healthBar.drawGraphic(10, 50, new Rect(value, 20, getHealthBarColor())); // this will be dynamically rendered

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

	// ---------------------- Handlers ------------------------

	/*private function onEnemyCollision(e:HUDEvent)
	{
		updateHealth(-e.health);
	}*/

	private function onScore(e:HUDEvent)
	{
		updateScore(e.score);
	}

	private function onUpdateHealth(e:HUDEvent)
	{
		trace(e.health);
		updateHealth(e.health);
	}
}