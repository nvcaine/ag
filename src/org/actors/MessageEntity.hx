package org.actors;

import com.haxepunk.Entity;

import com.haxepunk.graphics.Image;

import flash.events.Event;

import org.events.EventManager;

class MessageEntity extends Entity
{
	private var eventManager:EventManager;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		eventManager = EventManager.cloneInstance();
	}

	private function addListener(message:String, handler:Dynamic)
	{
		eventManager.addEventListener(message, handler, false, 0, true);
	}

	private function sendMessage(e:Event)
	{
		eventManager.dispatchEvent(e);
	}

	private function initGraphic(data:Dynamic)
	{
		setGraphic(data);
		setGraphicHitbox(data);
	}

	private function setGraphic(data:Dynamic)
	{
		if(!data.assetPath || data.assetPath == "")
		{
			trace("MessageEntity.setGraphic: Invalid asset data");

			return;
		}

		graphic = new Image(data.assetPath);
	}

	private function setGraphicHitbox(data:Dynamic)
	{
		if(!data.width || !data.height)
		{
			trace("MessageEntity.setGraphicHitbox: Invalid width/height");

			return;
		}

		setHitbox(data.width, data.height);
	}
}