package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;

import nme.events.MouseEvent;

import org.ui.Button;

class MenuScene extends Scene
{
	private var newGameB:Button;

	public function new()
	{
		super();

	}

	override public function begin()
	{
		newGameB = new Button(350, 130, "gfx/menu/newgame.png");

		//newGameB.addListener(MouseEvent.MOUSE_OVER, onMouseOver);
		newGameB.addListener(MouseEvent.MOUSE_OVER, onMouseOver);
		newGameB.addListener(MouseEvent.MOUSE_DOWN, onMouseOut);

		add(newGameB);

		//add(new Button(150, 130, "gfx/menu/quit.png"));
	}

	override public function end()
	{
	}

	private function onMouseOver(e:MouseEvent)
	{
		trace("mouse over");
	}

	private function onMouseOut(e:MouseEvent)
	{
		trace("mouse out");
	}
}
