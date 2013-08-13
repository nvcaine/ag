package model.events;

import model.dto.ItemDTO;
import nme.events.Event;

class InventoryEvent extends Event
{
	public static inline var EQUIP_ITEM:String = "equipItem";

	public var data:ItemDTO;

	public function new(type:String, data:ItemDTO, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);

		this.data = data;
	}
}