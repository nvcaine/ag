package org.actors;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Scene;

import com.haxepunk.graphics.Image;

import org.actors.InventoryItem;

class EntityGrid
{
	private var _scene:Scene;
	private var _numRows:Int = 0;
	private var _numCols:Int = 0;
	private var _cellWidth:Int = 0;
	private var _cellHeight:Int = 0;

	public function new(scene:Scene, numRows:Int, numCols:Int, cellWidth:Int, cellHeight:Int)
	{
		_scene = scene;

		_numRows = numRows;
		_numCols = numCols;

		_cellWidth = cellWidth;
		_cellHeight = cellHeight;

		drawBackground(0, 450);
		addEntities(["a", "b", "c", "d", "e", "a", "b"]);
	}

	public function addEntities(items:Array<Dynamic>)
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

			drawEntity(currentRow, currentColumn);

			currentColumn++;
		}
	}

	public function drawEntity(row:Int, col:Int)
	{
		var icon:InventoryItem = new InventoryItem(row, col, _cellWidth, _cellHeight, {defaultImage: "gfx/arma.png"});

		/*icon.scaleX = 0.5;
		icon.scaleY = 0.5;*/

		_scene.add(icon);
	}

	private function drawBackground(startX:Int, startY:Int)
	{
		for(i in 0..._numRows)
			_scene.addGraphic(Image.createRect(HXP.width, 1, 0x00FF00), 0, 0, startY + i * _cellHeight);

		for(i in 0..._numCols)
			_scene.addGraphic(Image.createRect(1, HXP.height - startY, 0x00FF00), 0, startX + i * _cellWidth, startY);
	}
}