package org.ui;

import com.haxepunk.graphics.Graphiclist;

import nme.text.TextField;

class Tooltip extends Graphiclist
{
	public function new()
	{
		super();

		init();
	}

	private function init()
	{
		var tf:TextField = new TextField();

		tf.text = "The tooltip with the text that will be displayed";

		add(tf);
	}
}