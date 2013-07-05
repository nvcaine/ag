import com.haxepunk.Engine;
import com.haxepunk.HXP;

import nme.events.Event;
import org.events.EventManager;

import scenes.GameScene;
import scenes.MenuScene;

class Main extends Engine
{
	private var eventManager:EventManager;
	private var dead:Bool;

	override public function init()
	{
//#if debug
		//HXP.console.enable();
//#end
		// HXP.scene = new YourScene();
		HXP.scene = new MenuScene();//GameScene();

		eventManager = EventManager.cloneInstance();
		eventManager.addEventListener("playerDead", onPlayerDead); // has const

		dead = false;
	}

	override public function update()
	{
		super.update();

		if(dead)
			HXP.scene = new MenuScene();
	}

	public static function main()
	{
		new Main();
	}

	private function onPlayerDead(e:Event)
	{
		dead = true;
	}
}