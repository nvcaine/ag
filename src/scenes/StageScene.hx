package scenes;

import com.haxepunk.Scene;

import entities.game.level.StageButton;

import model.events.MenuEvent;

import org.events.EventManager;
import org.ui.Button;
import org.ui.TooltipButton;

import nme.events.MouseEvent;

class StageScene extends Scene
{
	private var backB:Button;
	private var em:EventManager;

	override public function begin()
	{
		em = EventManager.cloneInstance();

		backB = new Button(10, 10, {
			defaultImage: "gfx/menu/back.png",
			downImage: "gfx/menu/back_down.png",
			overImage: "gfx/menu/back_over.png"
		});

		backB.addListener(MouseEvent.CLICK, onBack);
		add(backB);

		initLevels([
			{x: 100, y: 100, name: "Level 1", levelIndex: 0, asset: "gfx/hardpoint.png"},
			{x: 200, y: 100, name: "Level 2", levelIndex: 1, asset: "gfx/hardpoint.png"},
			{x: 100, y: 200, name: "Level 3", levelIndex: 2, asset: "gfx/hardpoint.png"}
		]);
	}

	override public function end()
	{
		backB.clearListener(MouseEvent.CLICK, onBack);

		removeAll();
	}

	private function initLevels(levelInfo:Array<Dynamic>)
	{
		for(info in levelInfo)
			add(new StageButton(info));
	}

	private function onBack(e:MouseEvent)
	{
		em.dispatchEvent(new MenuEvent(MenuEvent.SHOW_MENU));
	}
}