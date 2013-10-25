package entities.inventory;

import com.haxepunk.Graphic;
import com.haxepunk.HXP;

import com.haxepunk.graphics.Image;

import model.consts.ItemTypeConsts;
import model.events.InventoryEvent;
import model.dto.ItemDTO;

import nme.events.MouseEvent;

import org.actors.SimpleMessageEntity;
import org.ui.Button;

class InventoryGrid extends SimpleMessageEntity
{
	private var _numRows:Int = 0;
	private var _numCols:Int = 0;
	private var _cellWidth:Int = 0;
	private var _cellHeight:Int = 0;

	private var inventoryItems:Array<InventoryItem>;
	private var currentInventorySection:String;
	private var items:Array<ItemDTO>;

	public function new(x:Float, y:Float, itemsData:Array<ItemDTO>, numRows:Int, numCols:Int, cellWidth:Int, cellHeight:Int)
	{
		super(x, y);

		_numRows = numRows;
		_numCols = numCols;

		_cellWidth = cellWidth;
		_cellHeight = cellHeight;

		inventoryItems = [];
		items = itemsData;

		currentInventorySection = ItemTypeConsts.ITEM_WEAPON;
	}

	override public function added()
	{
		scene.add(new InventoryHeader(0, 425));

		drawBackground(x, y);

		refreshItems();

		addListener(InventoryEvent.FILTER_ITEMS, onFilterItems);
	}

	override public function removed()
	{
		// not removing event/message listeners prevents objects from being garbage-collected
		clearListener(InventoryEvent.FILTER_ITEMS, onFilterItems);
	}
	public function unequip(item:ItemDTO)
	{
		items.remove(item);

		if(item.type == currentInventorySection)
			refreshItems();
	}

	public function equip(item:ItemDTO)
	{
		items.push(item);

		if(item.type == currentInventorySection)
			addItem(item);
	}

	private function addItem(item:ItemDTO)
	{
		var row:Int = Std.int(inventoryItems.length / _numRows);
		var col:Int = Std.int(inventoryItems.length % _numCols);

		drawEntity(row, col, item);
	}

	private function clearItems()
	{
		if(inventoryItems.length == 0)
			return;

		for(item in inventoryItems)
			scene.remove(item);

		inventoryItems = [];
	}

	private function drawEntity(row:Int, col:Int, data:Dynamic)
	{
		var itemEntity:InventoryItem = new InventoryItem(row, col, _cellWidth, _cellHeight, data);

		inventoryItems.push(itemEntity);

		scene.add(itemEntity);
	}

	private function drawBackground(startX:Float, startY:Float)
	{
		for(i in 0..._numRows)
			scene.addGraphic(Image.createRect(HXP.width, 1, 0x00FF00), 0, 0, Std.int(startY) + i * _cellHeight);

		for(i in 0..._numCols)
			scene.addGraphic(Image.createRect(1, HXP.height - Std.int(startY), 0x00FF00), 0, Std.int(startX) + i * _cellWidth, Std.int(startY));
	}

	private function changeInventorySection(section:String)
	{
		if(currentInventorySection == section)
			return;

		currentInventorySection = section;
		refreshItems();
	}

	private function refreshItems()
	{
		var currentItems:Array<ItemDTO> = getItemsByType(currentInventorySection);

		clearItems();

		for(item in currentItems)
			addItem(item);
	}

	private function getItemsByType(type:String):Array<ItemDTO>
	{
		var result:Array<ItemDTO> = [];

		for(item in items)
			if(item.type == type)
				result.push(item);

		return result;
	}

	private function onFilterItems(e:InventoryEvent)
	{
		changeInventorySection(e.category);
	}
}