package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;

import hud.Menu;

class MenuScene extends Scene
{
	public function new()
	{
		super();

		addGraphic(new Menu());
	}
}
