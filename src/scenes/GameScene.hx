package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;

import flash.events.Event;

import entities.Explosion;

import hud.GameHUD;

import level.Level;

import model.events.EntityEvent;

import nme.geom.Point;

import org.events.EventManager;
import org.actors.Player;

class GameScene extends Scene
{
	private var hud:GameHUD;
	private var enemyImages:Hash<String>;
	private var level:Level;
	private var player:Player;

	public function new()
	{
		super();
	}

	override public function begin()
	{
		level.init();
	}

	override public function end()
	{
		clearListeners(EventManager.cloneInstance(), [EntityEvent.ENTITY_EXPLOSION], [onEnemyExplode]);
	}	

	override public function update()
	{
		super.update();

		//camera.x += PlayerConsts.DEFAULT_SPEED;

		player.handleInput();
	}

	public function restart()
	{
		init();
	}

	private function init()
	{
		removeAll();

		initListeners(EventManager.cloneInstance(), [EntityEvent.ENTITY_EXPLOSION], [onEnemyExplode]);

		loadEnemies();
		initLevel();
		initHUD();

		player = new Player({x: 16, y: HXP.halfHeight}, this);

		camera.x = 0;
		camera.y = 0;
	}

	private function initHUD()
	{
		hud = new GameHUD();

		addGraphic(hud);
	}

	private function initListeners(listener:EventManager, events:Array<Dynamic>, handlers:Array<Dynamic>)
	{
		for(i in 0...events.length)
			listener.addEventListener(events[i], handlers[i], false, 0 , true);
	}

	private function clearListeners(listener:EventManager, events:Array<Dynamic>, handlers:Array<Dynamic>)
	{
		for(i in 0...events.length)
			listener.removeEventListener(events[i], handlers[i]);
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

	private function onEnemyExplode(e:EntityEvent)
	{
		var ex:Explosion = new Explosion(e.x, e.y);

		add(ex);
		ex.explode();
	}
}