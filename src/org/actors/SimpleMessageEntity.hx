package org.actors;

import com.haxepunk.Entity;

import flash.events.Event;

import org.events.EventManager;

class SimpleMessageEntity extends Entity
{
	private var eventManager:EventManager;
	private var eventHandlers:Array<Dynamic>;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		eventManager = EventManager.cloneInstance();
	}

	override public function added()
	{
		parseEventHandlerPairs(eventHandlers);
	}

	override public function removed()
	{
		parseEventHandlerPairs(eventHandlers, true);
	}

	private function parseEventHandlerPairs(eventHandlerPairs:Array<Dynamic>, remove:Bool = false)
	{
		if(eventHandlerPairs == null || eventHandlerPairs.length == 0)
			return;

		var parser:Dynamic = addListener;

		if(remove)
			parser = clearListener;

		for(pair in eventHandlerPairs)
			parser(pair.event, pair.handler);
	}

	private function addListener(message:String, handler:Dynamic->Void)
	{
		eventManager.addEventListener(message, handler, false, 0, true);
	}

	private function clearListener(message:String, handler:Dynamic)
	{
		eventManager.removeEventListener(message, handler);
	}

	private function sendMessage(e:Event)
	{
		eventManager.dispatchEvent(e);
	}
}