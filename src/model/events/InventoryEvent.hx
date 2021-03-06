package model.events;

import model.dto.ItemDTO;
import nme.events.Event;

class InventoryEvent extends Event
{
	public static inline var EQUIP_ITEM:String = "equipItem";
	public static inline var UNEQUIP_ITEM:String = "unequipItem";
	public static inline var FILTER_ITEMS:String = "filterItems";

	public var data:ItemDTO;
	public var category:String;

	public function new(type:String, data:ItemDTO, ?itemCategory:String, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);

		this.data = data;

		if(itemCategory != null)
			category = itemCategory;
	}
}