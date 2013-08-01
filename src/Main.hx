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
	public static inline var GAME_SCENE:String = "game";
	public static inline var MENU_SCENE:String = "menu";

	private var eventManager:EventManager;
	private var scenes:Hash<Scene>;

	override public function init()
	{
//#if debug
		//HXP.console.enable();
//#end

		initScenes();
		addHandlers();

		HXP.scene = scenes.get(MENU_SCENE);
	}

	public static function main()
	{
		new Main();
	}

	private function addHandlers()
	{
		eventManager = EventManager.cloneInstance();

		eventManager.addEventListener(EntityEvent.PLAYER_DEAD, onPlayerDead, false, 0, true);
		eventManager.addEventListener(MenuEvent.NEW_GAME, onNewGame, false, 0, true);
	}

	private function initScenes()
	{
		scenes = new Hash<Scene>();

		scenes.set(GAME_SCENE, new GameScene());
		scenes.set(MENU_SCENE, new MenuScene());
	}

	private function onPlayerDead(e:Event)
	{
		HXP.scene = cast(scenes.get(MENU_SCENE), MenuScene);
	}

	private function onNewGame(e:Event)
	{
		var gameScene:GameScene = cast(scenes.get(GAME_SCENE), GameScene);

		gameScene.restart();

		HXP.scene = gameScene;
	}
}