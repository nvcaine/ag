package level;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Grid;

import entities.game.BossEnemy;
import entities.game.Enemy;

import model.consts.EntityTypeConsts;
import model.consts.PlayerConsts;

class Level extends Entity
{
	private var checkpoints:Array<Int>;
	private var checkPointsPassed:Int = 0;

	private var enemyImages:Hash<String>;

	private var spawnTimer:Float = 0;
	private var cameraSpeed:Float = 0;
	private var bossReached:Bool = false;

	private var b:Backdrop;

	public function new(enemyAssets:Hash<String>)
	{
		super(0, 0);

		checkpoints = [-500, -750, -2500];

		enemyImages = enemyAssets;
	}

	override public function added()
	{
		super.added();

		init();
	}

	override public function update()
	{
		super.update();

		checkIfReachedCheckpoint();

		spawnTimer -= HXP.elapsed;
		
		scene.camera.y -= cameraSpeed;

		if(spawnTimer < 0 && !bossReached)
			spawn();
	}

	private function init()
	{
		drawBackground();

		initGrid(50);

		cameraSpeed = PlayerConsts.DEFAULT_SPEED;
	}

	private function initGrid(gridCellSize:Int)
	{
		var mask:Grid = new Grid(500, 700, gridCellSize, gridCellSize); // level W/H
		var maskEntity = new Entity(0, 0, null, mask);

		maskEntity.type = EntityTypeConsts.LEVEL;

		addLevelEntity(200, 0, mask, gridCellSize);
		addLevelEntity(200, 50, mask, gridCellSize);
		addLevelEntity(200, 100, mask, gridCellSize);
		addLevelEntity(200, 150, mask, gridCellSize);
		addLevelEntity(200, 200, mask, gridCellSize);
		addLevelEntity(200, 250, mask, gridCellSize);

		scene.add(maskEntity);
	}

	private function addEntity(x:Float, y:Float, size:Int)
	{
		var a:Entity = new Entity(x, y);

		a.graphic = Image.createRect(size, size, 0xDDEEFF);

		scene.add(a);
	}

	private function addLevelEntity(x:Float, y:Float, gridMask:Grid, gridCellSize:Int)
	{
		var row:Int = Std.int(x / gridCellSize);
		var col:Int = Std.int(y / gridCellSize);

		gridMask.setTile(row, col, true);

		addEntity(row * gridCellSize, col * gridCellSize, gridCellSize);
	}

	private function drawBackground()
	{
		b = new Backdrop("gfx/bg.png", true, true);

		b.scrollX = 0.5;
		b.scrollY = 0.5;

		graphic = b;
	}

	private function spawn()
	{
		var enemyIndex:Int = Std.random(2);
		var enemyAsset:String = (enemyIndex % 2 == 0) ? enemyImages.get("enemy1") : enemyImages.get("enemy2");
		var enemyXP:Int = (enemyIndex % 2 == 0) ? 10 : 5;
		var enemyData:Dynamic = {type: "asd", health: 100, damage: 25, score: 5, speed: 3, assetPath: enemyAsset, width: 32, height: 32, xp: enemyXP};
		var x:Float = Math.random() * (HXP.width - 32);

		scene.add(new Enemy(x, scene.camera.y, enemyData));

		spawnTimer = 1;
	}

	private function checkIfReachedCheckpoint()
	{
		if(checkpoints.length == 0)
			return;

		if(scene.camera.y < checkpoints[0])
		{
			checkpoints.splice(0, 1);

			//dispatcher.dispatchEvent(new LevelEvent(LevelEvent.PASSED_CHECKPOINT, ++checkPointsPassed));
			if(checkpoints.length == 0)
				spawnBoss();
		}
	}

	private function spawnBoss()
	{
		bossReached = true;
		cameraSpeed = 0;

		var y:Float = scene.camera.y + 128;
		var enemyData:Dynamic = {type: "boss", health: 300, damage: 25, score: 100, speed: 0.5, assetPath: "gfx/boss.png", width: 128, height: 128, xp: 100};

		scene.add(new BossEnemy(HXP.width / 2, y, enemyData));
	}
}