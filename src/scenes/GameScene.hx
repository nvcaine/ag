package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
//import com.haxepunk.graphics.Image;

import flash.events.Event;

import entities.Ship;
import entities.Explosion;

import hud.GameHUD;

import level.Level;

import model.events.ExplosionEvent;

import nme.geom.Point;

import org.events.EventManager;

class GameScene extends Scene
{
	private var hud:GameHUD;
	private var enemyImages:Hash<String>;
	private var level:Level;
	private var player:Ship;

	public function new()
	{
		super();

		initListeners(EventManager.cloneInstance(), ["explode"], [onEnemyExplode]);

		loadEnemies();
		initLevel();
		initHUD();
	}

	override public function begin()
	{
		level.init();

		camera = new Point(0, 0);
		player = new Ship(16, HXP.halfHeight);

		add(player);
	}
	
	override public function update()
	{
		super.update();

		camera.x += 1.5;
	}

	private function initHUD()
	{
		hud = new GameHUD();

		addGraphic(hud);
	}

	private function initListeners(listener:EventManager, events:Array<Dynamic>, handlers:Array<Dynamic>)
	{
		for(i in 0...events.length)
			listener.addEventListener(events[i], handlers[i]);
	}

	private function initLevel()
	{
		level = new Level(enemyImages);

		add(level);
	}

	private function loadEnemies()
	{
		enemyImages = new Hash<String>();

		enemyImages.set("enemy1", "gfx/enemy.png");
		enemyImages.set("enemy2", "gfx/enemy2.png");
	}

	private function onEnemyExplode(e:ExplosionEvent)
	{
		var ex:Explosion = new Explosion(e.x, e.y);

		add(ex);
		ex.explode();
	}
}