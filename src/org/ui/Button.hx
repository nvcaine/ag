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
	private var mouseWasDown:Bool = false;
	private var mouseEntered:Bool = false;

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
			if(!mouseEntered)
			{
				eventType = MouseEvent.MOUSE_OVER;				
				mouseEntered = true;
			}

			if(Input.mousePressed)
			{
				eventType = MouseEvent.MOUSE_DOWN;
				mouseWasDown = true;
			}

			if(Input.mouseReleased)
			{
				eventType = MouseEvent.CLICK;
				mouseWasDown = false;
			}
		}
		else
		{
			if(mouseEntered)
			{
				eventType = MouseEvent.MOUSE_OUT;
				mouseEntered = false;
			}

			if(Input.mouseReleased && mouseWasDown)
			{
				eventType = MouseEvent.MOUSE_UP;
				mouseWasDown = false;
			}
		}

		if(eventType != "" && prevEventType != eventType)
		{
			prevEventType = eventType;
			dispatcher.dispatchEvent(new MouseEvent(eventType));

			//trace(eventType);
		}
	}

	private function initImage(image:Dynamic)
	{
		_image = new Image(image);

		graphic = _image;

		setHitbox(_image.width, _image.height);
	}
}