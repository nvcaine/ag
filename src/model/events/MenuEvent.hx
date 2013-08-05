package model.events;

import flash.events.Event;

class MenuEvent extends Event
{
	public static inline var NEW_GAME:String = "newGame";
	public static inline var SHOW_INVENTORY:String = "showInventory";
	public static inline var SHOW_MENU:String = "showMenu";

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);
	}
}