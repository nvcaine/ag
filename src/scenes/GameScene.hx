package scenes;

import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

import flash.events.EventDispatcher;

import nme.geom.Point;

import entities.Enemy;
import entities.Ship;
import entities.Explosion;

import events.ExplosionEvent;
import events.HUDEvent;
import events.LevelEvent;

import hud.GameHUD;

import level.Level;

class GameScene extends Scene
{
	private var spawnTimer:Float;
	private var d:EventDispatcher;

	private var hud:GameHUD;
	private var enemyImages:Hash<Image>;
	private var level:Level;

	public function new()
	{
		super();

		d = new EventDispatcher();

		initListeners(d, [
				"explode",
				HUDEvent.KILL_SCORE,
				HUDEvent.ENEMY_COLLISION,
				LevelEvent.PASSED_CHECKPOINT
			], [
				onEnemyExplode,
				onScore,
				onEnemyCollision,
				onLevelCheckpointPassed
			]);

		loadEnemies();
		initLevel();
		initHUD();
	}

	override public function begin()
	{
		level.init();

		add(new Ship(16, HXP.halfHeight, d));

		spawn();

		camera = new Point(0, 0);
	}
	
	override public function update()
	{
		spawnTimer -= HXP.elapsed;

		if(spawnTimer < 0)
			spawn();

		super.update();
		camera.x += 1.5;
	}

	private function initHUD()
	{
		hud = new GameHUD();

		addGraphic(hud);
	}

	private function initListeners(listener:EventDispatcher, events:Array<Dynamic>, handlers:Array<Dynamic>)
	{
		for(i in 0...events.length)
			listener.addEventListener(events[i], handlers[i]);
	}

	private function initLevel()
	{
		level = new Level(d);

		add(level);
	}

	private function loadEnemies()
	{
		enemyImages = new Hash<Image>();

		enemyImages.set("enemy1", new Image("gfx/enemy.png"));
		enemyImages.set("enemy2", new Image("gfx/enemy2.png"));
	}

	private function spawn()
	{
		var e = (Std.random(2) % 2 == 0) ? enemyImages.get("enemy1") : enemyImages.get("enemy2");
		var y = Math.random() * (HXP.height - 32);

		add(new Enemy(e, camera.x + HXP.width, y, d));

		spawnTimer = 1;
	}

	private function onEnemyExplode(e:ExplosionEvent)
	{
		var ex:Explosion = new Explosion(e.x, e.y);

		add(ex);
		ex.explode();
	}

	private function onScore(e:HUDEvent)
	{
		hud.updateScore(e.score);		
	}

	private function onEnemyCollision(e:HUDEvent)
	{
		hud.decreaseHealth(10);
	}

	private function onLevelCheckpointPassed(e:LevelEvent)
	{
		hud.updateCheckpoint(e.checkpoint);
	}
}