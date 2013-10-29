package model.events;

import flash.events.Event;

class MenuEvent extends Event
{
	public static inline var NEW_GAME:String = "newGame";
	public static inline var SHOW_INVENTORY:String = "showInventory";
	public static inline var SHOW_MENU:String = "showMenu";
	public static inline var SHOW_STAGES:String = "showStages";

	public var index:Int;

	public function new(type:String, levelIndex:Int = 0, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);

		this.index = levelIndex;
	}
}