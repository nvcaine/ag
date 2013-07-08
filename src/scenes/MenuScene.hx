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
	private var em:EventManager;

	public function new()
	{
		super();
	}

	override public function begin()
	{
		if(newGameB == null)
			newGameB = new Button(10, 10, "gfx/menu/newgame.png");

		newGameB.addListener(MouseEvent.MOUSE_DOWN, onMouseOut);

		add(newGameB);
	}

	override public function end()
	{
		newGameB.clearListener(MouseEvent.MOUSE_DOWN, onMouseOut);
	}

	private function onMouseOut(e:MouseEvent)
	{
		if(em == null)
			em = EventManager.cloneInstance();

		em.dispatchEvent(new MenuEvent(MenuEvent.NEW_GAME));
	}
}
