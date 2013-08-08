package scenes;

import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;

import model.events.MenuEvent;

import nme.events.MouseEvent;

import org.events.EventManager;
import org.ui.Button;
import org.ui.TooltipButton;

class InventoryScene extends Scene
{
	private var backB:Button;

	override public function begin()
	{
		backB = new Button(10, 10, "gfx/menu/back.png");

		backB.addListener(MouseEvent.CLICK, onBack);
		add(backB);

		drawShipTemplate();
	}

	override public function end()
	{
		backB.clearListener(MouseEvent.CLICK, onBack);
	}

	private function onBack(e:MouseEvent)
	{
		EventManager.cloneInstance().dispatchEvent(new MenuEvent(MenuEvent.SHOW_MENU));
	}

	private function drawShipTemplate()
	{
		var ship:Image = new Image("gfx/ship.png");
		var entity:Entity = new Entity(100, 150);

		ship.scaleX = ship.scaleY = 3;
		entity.graphic = ship;

		add(entity);

		var hardpoint:TooltipButton = new TooltipButton(100, 200, "gfx/hardpoint.png");

		add(hardpoint);

		var hardpoint2:TooltipButton = new TooltipButton(200, 100, "gfx/hardpoint.png");

		add(hardpoint2);
	}
}