package entities.inventory;

import model.consts.ItemTypeConsts;
import model.events.InventoryEvent;

import nme.events.MouseEvent;

import org.actors.SimpleMessageEntity;
import org.ui.Button;

class InventoryHeader extends SimpleMessageEntity
{
	private var buttons:Array<Dynamic>;

	override public function added()
	{
		buttons = [{
				x: 5, y: 0,
				defaultImage: "inv/weapons.png",
				overImage: "inv/weapons_hover.png",
				downImage: "inv/weapons_down.png",
				clickHandler: onWeaponsClick
			}, {
				x: 170, y: 0,
				defaultImage: "inv/engines.png",
				overImage: "inv/engines_hover.png",
				downImage: "inv/engines_down.png",
				clickHandler: onEnginesClick
			}, {
				x: 335, y: 0,
				defaultImage: "inv/utility.png",
				overImage: "inv/utility_hover.png",
				downImage: "inv/utility_down.png",
				clickHandler: onUtilityClick
		}];

		for(buttonInfo in buttons)
			initButton(buttonInfo);
	}

	override public function removed()
	{
		for(buttonInfo in buttons)
			cast(buttonInfo.entity, Button).clearListener(MouseEvent.CLICK, buttonInfo.clickHandler);
	}

	// adds a button to the stage then saves the refference to the entity in the initial info object
	private function initButton(data:Dynamic)
	{
		var button:Button = new Button(this.x + data.x, this.y + data.y, data);

		button.addListener(MouseEvent.CLICK, data.clickHandler);
		scene.add(button);
		data.entity = button; // critical
	}

	private function onWeaponsClick(e:MouseEvent)
	{
		sendMessage(new InventoryEvent(InventoryEvent.FILTER_ITEMS, null, ItemTypeConsts.ITEM_WEAPON));
	}

	private function onEnginesClick(e:MouseEvent)
	{
		sendMessage(new InventoryEvent(InventoryEvent.FILTER_ITEMS, null, ItemTypeConsts.ITEM_ENGINE));
	}

	private function onUtilityClick(e:MouseEvent)
	{
		sendMessage(new InventoryEvent(InventoryEvent.FILTER_ITEMS, null, ItemTypeConsts.ITEM_UTILITY));
	}
}