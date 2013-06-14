package hud;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;

class Guidelines extends Graphiclist
{
	public function new()
	{
	}

	public function addGuideline(x:Int = 0, y:Int = 0)
	{
		if(x == 0)
			add(Image.drawRect(HXP.width, y))
	}
}