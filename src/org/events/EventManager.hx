package org.events;

import flash.events.EventDispatcher;

class EventManager extends EventDispatcher
{
	private static var instance:EventManager;

	private function new()
	{
		super();
	}

	public static function cloneInstance():EventManager
	{
		if(instance == null)
			instance = new EventManager();

		return instance;
	}
}