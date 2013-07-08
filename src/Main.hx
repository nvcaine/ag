import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.Scene;

import model.events.EntityEvent;
import model.events.MenuEvent;

import nme.events.Event;

import org.events.EventManager;

import scenes.GameScene;
import scenes.MenuScene;

class Main extends Engine
{
	private var eventManager:EventManager;

	private var scenes:Hash<Scene>;

	override public function init()
	{
//#if debug
		//HXP.console.enable();
//#end

		initScenes();
		addHandlers();

		HXP.scene = scenes.get("menu");
	}

	public static function main()
	{
		new Main();
	}

	private function addHandlers()
	{
		eventManager = EventManager.cloneInstance();

		eventManager.addEventListener(EntityEvent.PLAYER_DEAD, onPlayerDead, false, 0, true); // has const
		eventManager.addEventListener(MenuEvent.NEW_GAME, onNewGame, false, 0, true); // has const
	}

	private function initScenes()
	{
		scenes = new Hash<Scene>();

		scenes.set("game", new GameScene());
		scenes.set("menu", new MenuScene());
	}

	private function onPlayerDead(e:Event)
	{
		HXP.scene = cast(scenes.get("menu"), MenuScene);
	}

	private function onNewGame(e:Event)
	{
		var gameScene:GameScene = cast(scenes.get("game"), GameScene);

		gameScene.restart();

		HXP.scene = gameScene;
	}
}