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
	private var prevEventType:String = "";

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

		var eventType:String = "";
		var mouseCollides:Bool = collidePoint(x, y, scene.mouseX, scene.mouseY);

		if(mouseCollides)
		{
			eventType = MouseEvent.MOUSE_OVER;

			if(Input.mousePressed)
				eventType = MouseEvent.MOUSE_DOWN;
			else
				if(prevEventType == MouseEvent.MOUSE_DOWN)
					eventType = MouseEvent.MOUSE_UP;
		}

		if(prevEventType == MouseEvent.MOUSE_OVER && !mouseCollides)
			eventType = MouseEvent.MOUSE_OUT;

		if(prevEventType == MouseEvent.MOUSE_DOWN && eventType == MouseEvent.MOUSE_UP)
			eventType = MouseEvent.CLICK;

		if(eventType != "" && prevEventType != eventType)
		{
			prevEventType = eventType;

			trace(eventType);
			dispatcher.dispatchEvent(new MouseEvent(eventType));
		}
	}

	private function initImage(image:Dynamic)
	{
		_image = new Image(image);

		graphic = _image;

		setHitbox(_image.width, _image.height);
	}
}