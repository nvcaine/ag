package org.actors;

import com.haxepunk.Entity;

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
		eventManager.addEventListener(message, handler);
	}

	private function sendMessage(e:Event)
	{
		eventManager.dispatchEvent(e);
	}
}