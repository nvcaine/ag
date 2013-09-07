package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;

import entities.game.EndLevelText;
import entities.game.level.Level;
import entities.game.misc.Explosion;
import entities.game.misc.Pickup;
import entities.game.ui.GameHUD;

import model.events.EntityEvent;
import model.events.LevelEvent;
import model.proxy.PlayerProxy;

import org.actors.Player;
import org.events.EventManager;

class GameScene extends Scene
{
	private var player:Player;

	override public function begin()
	{
		init();
	}

	override public function end()
	{
		//hud.clearListeners();

		this.removeAll();

		clearListeners(
			EventManager.cloneInstance(),
			[EntityEvent.ENTITY_EXPLOSION, EntityEvent.DROP_PICKUP, LevelEvent.KILLED_BOSS],
			[onEnemyExplode, onDropPickup, onKilledBoss]);
	}	

	override public function update()
	{
		super.update();

		player.handleInput();
	}

	private function init()
	{
		removeAll();

		initListeners(
			EventManager.cloneInstance(),
			[EntityEvent.ENTITY_EXPLOSION, EntityEvent.DROP_PICKUP, LevelEvent.KILLED_BOSS],
			[onEnemyExplode, onDropPickup, onKilledBoss]);

		add(new Level());
		addGraphic(new GameHUD({background: "gfx/hud2.png", healthBar: "gfx/hp.png", energyBar: "gfx/energy.png"}), 0, 0, 668);

		player = new Player({x: (HXP.width / 2), y: HXP.height - 150, assetPath: "gfx/nava_1.png", width: 98, height: 98}, this);
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

	private function onEnemyExplode(e:EntityEvent)
	{
		add(new Explosion(e.x, e.y));
	}

	private function onDropPickup(e:EntityEvent)
	{
		add(new Pickup(e.x, e.y, {assetPath: "gfx/pickup.png", width: 16, height: 16}));
	}

	private function onKilledBoss(e:LevelEvent)
	{
		add(new EndLevelText(74, camera.y + 200));
	}

}