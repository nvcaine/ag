package scenes;

import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;

import model.events.MenuEvent;

import nme.events.MouseEvent;

import org.events.EventManager;
import org.ui.Button;

class InventoryScene extends Scene
{
	private var backB:Button;

	override public function begin()
	{
		backB = new Button(10, 10, "gfx/menu/back.png");

		backB.addListener(MouseEvent.MOUSE_DOWN, onBack);
		add(backB);

		drawShipTemplate();
	}

	private function onBack(e:MouseEvent)
	{
		EventManager.cloneInstance().dispatchEvent(new MenuEvent(MenuEvent.SHOW_MENU));
	}

	private function drawShipTemplate()
	{
		var ship:Image = new Image("gfx/ship.png");
		var entity:Entity = new Entity(100, 50);

		entity.graphic = ship;

		add(entity);
	}
}