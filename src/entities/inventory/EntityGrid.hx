package entities.inventory;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Scene;

import com.haxepunk.graphics.Image;

import model.dto.ItemDTO;

class EntityGrid
{
	private var _scene:Scene;
	private var _numRows:Int = 0;
	private var _numCols:Int = 0;
	private var _cellWidth:Int = 0;
	private var _cellHeight:Int = 0;

	private var inventoryItems:Array<InventoryItem>;

	public function new(scene:Scene, numRows:Int, numCols:Int, cellWidth:Int, cellHeight:Int)
	{
		_scene = scene;

		_numRows = numRows;
		_numCols = numCols;

		_cellWidth = cellWidth;
		_cellHeight = cellHeight;

		inventoryItems = [];

		drawBackground(0, 450);
	}

	public function removeItem(item:ItemDTO)
	{
		for(i in 0...inventoryItems.length)
			if(inventoryItems[i].matches(item))
				_scene.remove(inventoryItems[i]);
	}

	public function addItem(item:ItemDTO)
	{
		var row:Int = Std.int(inventoryItems.length / _numRows);
		var col:Int = Std.int(inventoryItems.length % _numCols);

		drawEntity(row, col, item);
	}

	public function clearItems()
	{
		for(i in 0...inventoryItems.length)
			_scene.remove(inventoryItems[i]);

		inventoryItems = [];
	}

	private function addEntities(items:Array<Dynamic>)
	{
		var currentRow:Int = 0;
		var currentColumn:Int = 0;

		for(i in 0...items.length)
		{
			if(currentColumn == _numCols)
			{
				currentRow++;
				currentColumn = 0;
			}

			drawEntity(currentRow, currentColumn, items[i]);

			currentColumn++;
		}
	}

	private function drawEntity(row:Int, col:Int, data:Dynamic)
	{
		var itemEntity:InventoryItem = new InventoryItem(row, col, _cellWidth, _cellHeight, data);

		inventoryItems.push(itemEntity);

		_scene.add(itemEntity);
	}

	private function drawBackground(startX:Int, startY:Int)
	{
		for(i in 0..._numRows)
			_scene.addGraphic(Image.createRect(HXP.width, 1, 0x00FF00), 0, 0, startY + i * _cellHeight);

		for(i in 0..._numCols)
			_scene.addGraphic(Image.createRect(1, HXP.height - startY, 0x00FF00), 0, startX + i * _cellWidth, startY);
	}
}