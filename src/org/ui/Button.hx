package org.ui;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;

import nme.events.EventDispatcher;
import nme.events.MouseEvent;

class Button extends Entity
{
	private var skin:Dynamic;
	private var dispatcher:EventDispatcher;
	private var prevEventType:String = "";
	private var mouseWasDown:Bool = false;
	private var mouseEntered:Bool = false;

	public function new(x:Float, y:Float, skinInfo:Dynamic)
	{
		super(x, y);

		dispatcher = new EventDispatcher();

		initImage(skinInfo.defaultImage);

		skin = skinInfo;

		initStates();
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
		}
	}

	private function initStates()
	{
		if(skin.overImage != null)
			addListener(MouseEvent.MOUSE_OVER, onMouseOver);

		if(skin.downImage != null)
			addListener(MouseEvent.MOUSE_DOWN, onMouseDown);

		if(skin.defaultImage != null && skin.overImage != null)
			addListener(MouseEvent.MOUSE_OUT, onMouseOut);

		if(skin.defaultImage != null && skin.overImage != null)
			addListener(MouseEvent.CLICK, onMouseOut);
	}

	private function initImage(imageAsset:Dynamic, scaleX:Int = 1, scaleY:Int = 1)
	{
		var image:Image = new Image(imageAsset);

		image.scaleX = scaleX;
		image.scaleY = scaleY;

		graphic = image;

		setHitbox(image.width * scaleX, image.height * scaleY);
	}

	// -----------------------------------------------------------------------------

	private function onMouseOver(e:MouseEvent)
	{
		graphic = new Image(skin.overImage);
	}

	private function onMouseOut(e:MouseEvent)
	{
		graphic = new Image(skin.defaultImage);
	}

	private function onMouseDown(e:MouseEvent)
	{
		graphic = new Image(skin.downImage);
	}
}