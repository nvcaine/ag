package scenes;

import com.haxepunk.Scene;

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

		backB = new Button(10, 10, {defaultImage: "gfx/menu/back.png", downImage: "gfx/menu/back_down.png", overImage: "gfx/menu/back_over.png"});
		backB.addListener(MouseEvent.CLICK, onBack);
		add(backB);

		initLevels([
			{x: 100, y: 100, name: "Level 1"},
			{x: 200, y: 100, name: "Level 2"},
			{x: 100, y: 200, name: "Level 3"}
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
			add(initLevelElement(info));
	}

	public function initLevelElement(data:Dynamic):TooltipButton
	{
		var result:TooltipButton = new TooltipButton(data.x, data.y, {defaultImage: "gfx/hardpoint.png"});

		result.setTooltipText(data.name);
		result.addListener(MouseEvent.CLICK, onLevelSelect);

		return result;
	}

	private function onBack(e:MouseEvent)
	{
		em.dispatchEvent(new MenuEvent(MenuEvent.SHOW_MENU));
	}

	private function onLevelSelect(e:MouseEvent)
	{
		em.dispatchEvent(new MenuEvent(MenuEvent.NEW_GAME));
	}
}