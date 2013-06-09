package hud;

import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.prototype.Rect;

import com.haxepunk.HXP;

class GameHUD extends Graphiclist
{
	static inline var ENEMY_SCORE_TEMPLATE = "Score: ";
	static inline var CHECKPOINTS_TEMPLATE = "Checkpoints: ";

	private var enemyScoreT:Text;
	private var checkpointsText:Text;
	private var healthBar:Canvas;
	private var enemyScore:Int = 0;
	private var currentHealth:Int = 100;

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

	public function decreaseHealth(damage:Int)
	{
		if(count > 2)
			removeAt(2);

		currentHealth -= damage;

		if(currentHealth <= 0)
			return;

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
	}

	private function drawHealth(value:Int)
	{
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
}