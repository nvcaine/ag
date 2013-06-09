package level;

import flash.events.EventDispatcher;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.masks.Grid;
import com.haxepunk.graphics.Image;

import events.LevelEvent;

class Level extends Entity
{
	private var checkpoints:Array<Int>;
	private var checkPointsPassed:Int = 0;

	private var dispatcher:EventDispatcher;

	public function new(d:EventDispatcher)
	{
		super(0, 0);

		checkpoints = [500, 1000];

		dispatcher = d;
	}

	public function init()
	{
		drawBackground();
		initGrid(40);
	}

	override public function update()
	{
		checkIfReachedCheckpoint();

		super.update();
	}

	private function initGrid(gridCellSize:Int)
	{
		var mask:Grid = new Grid(1000, 500, gridCellSize, gridCellSize); // app W/H
		var maskEntity = new Entity(0, 0, null, mask);

		//mask.setRect(20, 20, 1, 1);

		maskEntity.type = "solid";

		scene.add(maskEntity);

		addLevelEntity(400, 100, 40, mask, gridCellSize);
		addLevelEntity(400, 220, 40, mask, gridCellSize);
	}

	private function drawBackground()
	{
		var b:Backdrop = new Backdrop("gfx/bg.png", true, true);

		b.scrollX = 0.5;
		b.scrollY = 0.5;

		graphic = b;
	}

	private function addEntity(x:Float, y:Float, size:Int)
	{
		var a:Entity = new Entity(x, y);

		a.graphic = Image.createRect(size, size, 0xDDEEFF);

		scene.add(a);
	}

	private function addLevelEntity(x:Float, y:Float, entitySize:Int, gridMask:Grid, gridCellSize:Int)
	{
		gridMask.setRect(Std.int(x / gridCellSize), Std.int(y / gridCellSize), 1, 1);

		addEntity(x, y, entitySize);
	}

	private function checkIfReachedCheckpoint()
	{
		if(checkpoints.length == 0)
			return;

		if(scene.camera.x > checkpoints[0])
		{
			checkpoints.splice(0, 1);

			dispatcher.dispatchEvent(new LevelEvent(LevelEvent.PASSED_CHECKPOINT, ++checkPointsPassed));
		}
	}
}