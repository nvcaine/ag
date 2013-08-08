package org.ui;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;


class Tooltip extends Entity
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		init();
	}

	private function init()
	{
		var textOptions:TextOptions = {font: "font/xoloniumregular.ttf", color: 0x00FF00};
		var tf:Text = new Text("Awesome-est weapon ever", 0, 0, 0, 0, textOptions);
		var w:Int = cast(tf.x, Int) + tf.width;
		var h:Int = cast(tf.y, Int) + tf.height;

		var bg = Image.createRect(w, h, 0x0090c2);
		var g:Graphiclist = new Graphiclist([bg, tf]);
		
		graphic = g;

		setHitbox(w, h);
	}
}