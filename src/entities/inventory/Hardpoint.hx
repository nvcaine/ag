package entities.inventory;

import model.dto.ItemDTO;
import model.dto.HardpointDTO;
import model.events.InventoryEvent;

import nme.events.MouseEvent;

import org.events.EventManager;
import org.ui.TooltipButton;

class Hardpoint extends TooltipButton
{
	private var data:HardpointDTO;

	public function new(x:Float, y:Float, data:HardpointDTO)
	{
		super(x, y, {defaultImage:data.assetPath});

		this.data = data;
	}

	override public function added()
	{
		addListener(MouseEvent.CLICK, onClick);

		if(data.item == null)
		{
			setTooltipText(data.name);
			return;			
		}

		mount(data.item);
	}

	public function mountItem(item:ItemDTO)
	{
		if(!isAvailable() || !supports(item.type))
			return;

		data.item = item;
		mount(item);
	}

	public function getData():HardpointDTO
	{
		var copy:HardpointDTO = data;

		return copy;
	}

	public function getLayerAsset():String
	{
		return data.item.layerAsset;
	}

	public function supports(itemType:String):Bool
	{
		return (data.type == itemType);
	}

	public function isAvailable():Bool
	{
		return (data.item == null);
	}

	private function mount(item:ItemDTO)
	{
		initImage(item.assetPath, 3, 3);
		setTooltipText(data.name + "\n" + item.getTooltipLabel());
	}

	private function onClick(e:MouseEvent)
	{
		if(isAvailable())
			return;

		initImage(data.assetPath);
		setTooltipText(data.name);
		
		var itemDataCopy:ItemDTO = data.item;
		data.item = null;

		EventManager.cloneInstance().dispatchEvent(new InventoryEvent(InventoryEvent.UNEQUIP_ITEM, itemDataCopy));
	}
}