package org.actors;

import com.haxepunk.Entity;

import flash.events.Event;

import org.events.EventManager;

class SimpleMessageEntity extends Entity
{
	private var eventManager:EventManager;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		eventManager = EventManager.cloneInstance();
	}

	// in plus ??
	private function addListener(message:String, handler:Dynamic)
	{
		eventManager.addEventListener(message, handler, false, 0, true);
	}

	private function sendMessage(e:Event)
	{
		eventManager.dispatchEvent(e);
	}
}