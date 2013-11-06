package scenes;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Scene;

import entities.game.Player;
import entities.game.level.EndLevelText;
import entities.game.level.Level;
import entities.game.misc.Explosion;
import entities.game.misc.Pickup;
import entities.game.ui.HUDEntityWrapper;

import model.events.EntityEvent;
import model.events.HUDEvent;
import model.events.MenuEvent;
import model.events.LevelEvent;

import model.proxy.PlayerProxy;
import model.proxy.LevelProxy;

import nme.events.TimerEvent;
import nme.utils.Timer;

import org.events.EventManager;

//import org.actors.BackgroundParticle;

class GameScene extends Scene
{
	private var player:Player;

	private var endTimer:Float = 0.05;
	private var killedBoss:Bool = false;
	private var playerDead:Bool = false;
	private var endCount:Int = 0;
	private var returnTimer:Timer;

	private var levelIndex:Int;

	override public function begin()
	{
		this.removeAll();

		init();

		initListeners(
			EventManager.cloneInstance(),
			[EntityEvent.ENTITY_EXPLOSION, EntityEvent.DROP_PICKUP, LevelEvent.FINISHED_LEVEL, HUDEvent.PLAYER_DIED],
			[onEnemyExplode, onDropPickup, onLevelFinished, onPlayerDied]);
	}

	override public function end()
	{
		this.removeAll();

		clearListeners(
			EventManager.cloneInstance(),
			[EntityEvent.ENTITY_EXPLOSION, EntityEvent.DROP_PICKUP, LevelEvent.FINISHED_LEVEL],
			[onEnemyExplode, onDropPickup, onLevelFinished, onPlayerDied]);
	}	

	public function setLevelIndex(index:Int)
	{
		levelIndex = index;
	}

	override public function update()
	{
		super.update();

		player.handleInput();

		if(killedBoss || playerDead)
			showEndLevelText(0.15);
	}

	/*public function getBackgroundParticles(size:Float):Array<BackgroundParticle>
	{
		var result:Array<BackgroundParticle> = [];

		getClass(BackgroundParticle, result);

		for(particle in result)
			if(particle.size != size)
				result.remove(particle);

		return result;
	}*/

	private function init()
	{
		add(new Level(LevelProxy.cloneInstance().waves[levelIndex].concat([])));
		add(new HUDEntityWrapper(0, 668));

		player = new Player(HXP.width / 2, HXP.height - 150, this);

		endTimer = 0.15;
		killedBoss = playerDead = false;
		endCount = 0;
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

	private function startReturnTimer()
	{
		returnTimer = new Timer(5000, 1);

		returnTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onLevelDoneTimer, false, 0, true);
		returnTimer.start();
	}

	private function addEndLevelText(x:Float, y:Float, asset:String)
	{
		var endText:Dynamic = {
			assetPath: asset,
			path: [{x: 0, y: 0}, {x: -70, y: 100}, {x: 70, y: 100}, {x: 0, y: 0}],
			duration: 3,
			layer: endCount
		};

		add(new EndLevelText(x, y, endText));
	}

	private function showEndLevelText(endTextDelay:Float)
	{
		if(endCount > 10)
			return;

		endTimer -= HXP.elapsed;

		if(endTimer >= 0)
			return;

		addEndLevelText(74, 200, getTextAssetPath(playerDead));

		endCount++;
		endTimer = endTextDelay;
	}

	private function getTextAssetPath(playerDied:Bool = false)
	{
		if(playerDied)
			return "gfx/lolnoob.png";

		return "gfx/welldone.png";
	}

	private function onLevelDoneTimer(e:TimerEvent)
	{
		returnTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onLevelDoneTimer);

		EventManager.cloneInstance().dispatchEvent(new MenuEvent(MenuEvent.SHOW_INVENTORY));
	}

	private function onEnemyExplode(e:EntityEvent)
	{
		add(new Explosion(e.x, e.y));
	}

	private function onDropPickup(e:EntityEvent)
	{
		add(new Pickup(e.x, e.y, {assetPath: "gfx/bonb.png", width: 16, height: 16}));
	}

	private function onLevelFinished(e:LevelEvent)
	{
		killedBoss = true;

		startReturnTimer();
	}

	private function onPlayerDied(e:HUDEvent)
	{
		playerDead = true;

		startReturnTimer();
	}
}