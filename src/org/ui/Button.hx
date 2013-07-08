package org.ui;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;

import nme.events.EventDispatcher;
import nme.events.MouseEvent;

class Button extends Entity
{
	private var _image:Image;
	private var dispatcher:EventDispatcher;

	public function new(x:Float, y:Float, image:Dynamic)
	{
		super(x, y);

		initImage(image);

		dispatcher = new EventDispatcher();
	}

	public function addListener(type:String, handler:Dynamic->Void)
	{
		dispatcher.addEventListener(type, handler);
	}

	public function clearListener(type:String, handler:Dynamic->Void)
	{
		dispatcher.removeEventListener(type, handler);
	}

	override public function update()
	{
		super.update();

		if(Input.mousePressed)
			if(collidePoint(x, y, scene.mouseX, scene.mouseY))
				dispatcher.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
	}

	private function initImage(image:Dynamic)
	{
		_image = new Image(image);

		graphic = _image;

		setHitbox(_image.width, _image.height);
	}
}