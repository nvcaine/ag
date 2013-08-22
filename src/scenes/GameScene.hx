package scenes;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Scene;

import flash.events.Event;

import entities.game.Explosion;
import entities.game.Pickup;

import hud.GameHUD;

import level.Level;

import model.events.EntityEvent;

import nme.geom.Point;

import org.events.EventManager;
import org.actors.Player;

class GameScene extends Scene
{
	private var enemyImages:Hash<String>;
	private var level:Level;
	private var player:Player;
	private var hud:GameHUD;

	override public function begin()
	{
		init();
	}

	override public function end()
	{
		hud.clearListeners();

		this.removeAll();

		clearListeners(EventManager.cloneInstance(), [EntityEvent.ENTITY_EXPLOSION, EntityEvent.DROP_PICKUP], [onEnemyExplode, onDropPickup]);
	}	

	override public function update()
	{
		super.update();

		player.handleInput();
	}

	private function init()
	{
		removeAll();

		initListeners(EventManager.cloneInstance(), [EntityEvent.ENTITY_EXPLOSION, EntityEvent.DROP_PICKUP], [onEnemyExplode, onDropPickup]);

		loadEnemies();
		initLevel();
		initHUD();

		player = new Player({x: (HXP.width / 2), y: HXP.height - 50, assetPath: "gfx/nava_1.png", width: 98, height: 98}, this);

		camera.x = 0;
		camera.y = 0;
	}

	private function initHUD()
	{
		hud = new GameHUD();

		addGraphic(hud, 0, 0, 653);
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
		enemyImages.set("enemy2", "gfx/bonb.png");
	}

	private function onEnemyExplode(e:EntityEvent)
	{
		var ex:Explosion = new Explosion(e.x, e.y);

		add(ex);
		ex.explode();
	}

	private function onDropPickup(e:EntityEvent)
	{
		var p:Pickup = new Pickup(e.x, e.y, {assetPath: "gfx/pickup.png", width: 16, height: 16});

		add(p);
	}
}