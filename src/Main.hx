import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.Scene;

import model.consts.SceneConsts;

import model.events.EntityEvent;
import model.events.MenuEvent;

import nme.events.Event;

import org.events.EventManager;

import scenes.GameScene;
import scenes.MenuScene;
import scenes.InventoryScene;

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

		HXP.scene = scenes.get(SceneConsts.MENU);
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
		eventManager.addEventListener(MenuEvent.SHOW_INVENTORY, onShowInventory, false, 0, true);
		eventManager.addEventListener(MenuEvent.SHOW_MENU, onShowMenu, false, 0, true);
	}

	private function initScenes()
	{
		scenes = new Hash<Scene>();

		scenes.set(SceneConsts.GAME, new GameScene());
		scenes.set(SceneConsts.MENU, new MenuScene());
		scenes.set(SceneConsts.INVENTORY, new InventoryScene());
	}

	private function onPlayerDead(e:Event)
	{
		HXP.scene = scenes.get(SceneConsts.MENU);
	}

	private function onShowMenu(e:Event)
	{
		HXP.scene = scenes.get(SceneConsts.MENU);
	}

	private function onNewGame(e:Event)
	{
		HXP.scene = scenes.get(SceneConsts.GAME);
	}

	private function onShowInventory(e:Event)
	{
		HXP.scene = scenes.get(SceneConsts.INVENTORY);
	}
}