package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;

import model.events.MenuEvent;

import nme.events.MouseEvent;

import org.events.EventManager;
import org.ui.Button;

class MenuScene extends Scene
{
	private var newGameB:Button;
	private var inventoryB:Button;

	private var em:EventManager;

	override public function begin()
	{
		if(em == null)
			em = EventManager.cloneInstance();

		if(newGameB == null)
			newGameB = new Button(10, 10, "gfx/menu/newgame.png");

		if(inventoryB == null)
			inventoryB = new Button(10, 100, "gfx/menu/newgame.png");

		newGameB.addListener(MouseEvent.CLICK, onNewGame);
		inventoryB.addListener(MouseEvent.CLICK, onInventory);

		add(newGameB);
		add(inventoryB);
	}

	override public function end()
	{
		newGameB.clearListener(MouseEvent.CLICK, onNewGame);
		inventoryB.clearListener(MouseEvent.CLICK, onInventory);
	}

	private function onNewGame(e:MouseEvent)
	{
		em.dispatchEvent(new MenuEvent(MenuEvent.NEW_GAME));
	}

	private function onInventory(e:MouseEvent)
	{
		em.dispatchEvent(new MenuEvent(MenuEvent.SHOW_INVENTORY));
	}
}
