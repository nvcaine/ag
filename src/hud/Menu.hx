package hud;

import com.haxepunk.graphics.Canvas;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.prototype.Rect;

import nme.events.MouseEvent;

class Menu extends Graphiclist
{
	static inline var NEW_GAME_TEMPLATE = "New Game";
	static inline var QUIT_TEMPLATE = "Quit";

	private var newGameT:Text;
	private var quitT:Text;

	public function new()
	{
		super();

		init();
	}

	private function init()
	{
		newGameT = new Text(NEW_GAME_TEMPLATE, 10, 10, 0, 0);
		quitT = new Text(QUIT_TEMPLATE, 10, 30, 0, 0);

		//add(newGameT);
		//add(quitT);
	}
}