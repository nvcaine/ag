package entities.inventory;

import model.dto.ItemDTO;
import model.events.InventoryEvent;

import nme.events.MouseEvent;
import nme.geom.Point;

import org.events.EventManager;

import org.ui.TooltipButton;

class InventoryItem extends TooltipButton
{
	private var em:EventManager;
	private var data:ItemDTO;

	public function new(row:Int, col:Int, cellWidth:Int, cellHeight:Int, data:Dynamic)
	{
		var pos:Point = getCoords(row, col, cellWidth, cellHeight);

		super(pos.x, pos.y, data);

		this.data = new ItemDTO(data);

		setHitbox(cellWidth, cellHeight);

		em = EventManager.cloneInstance();
	}

	override public function added()
	{
		super.added();

		addListener(MouseEvent.CLICK, onClick);
	}
	private function getCoords(row:Int, col:Int, cellWidth:Int, cellHeight:Int):Point
	{
		var result:Point = new Point(col * cellWidth + 2, 450 + row * cellHeight + 2);

		return result;
	}

	private function onClick(e:MouseEvent)
	{
		// should be a message entity
		em.dispatchEvent(new InventoryEvent(InventoryEvent.EQUIP_ITEM, data));
	}
}