package entities.game.level;

import com.haxepunk.Entity;
import com.haxepunk.HXP;

import entities.game.ships.EnemyShip;

import model.events.LevelEvent;
import model.proxy.EnemyProxy;

import org.actors.MessageEntity;

class Level extends MessageEntity
{
	private var waves:Array<Dynamic>;
	private var spawnTimer:Float = 0;
	private var currentWave:Int = 0;
	private var endLevel:Bool = false;

	private var enemyProxy:EnemyProxy;
	private var background:ScrollingBackground;

	public function new(wavesData:Array<Dynamic>)
	{
		super(0, 0);

		enemyProxy = EnemyProxy.cloneInstance();
		waves = wavesData;
	}

	override public function added()
	{
		init();

		initWave(waves[currentWave]);
	}

	override public function update()
	{
		if(endLevel)
			return;

		spawnTimer -= HXP.elapsed;
		
		updateWaves();
	}

	private function updateWaves()
	{
		if(spawnTimer > 0)
			return;

		if(currentWave >= waves.length)
		{
			sendMessage(new LevelEvent(LevelEvent.FINISHED_LEVEL));
			endLevel = true;

			background.warpBackground();

			return;
		}

		initWave(waves[currentWave]);
	}

	private function init(backgroundSpeed:Float = 1)
	{
		background = new ScrollingBackground(backgroundSpeed);

		scene.add(background);

		endLevel = false;
	}

	private function initWave(waveData:Dynamic)
	{
		if(Reflect.hasField(waveData, "groundElements"))
		{
			var groundElements:Array<Dynamic> = waveData.groundElements;

			for(ge in groundElements)
				scene.add(new GroundEntity(ge));
		}

		if(Reflect.hasField(waveData, "enemies"))
		{
			var enemies:Array<Dynamic> = waveData.enemies;

			for(t in enemies)
				scene.add(new EnemyShip(t.startX, t.startY, t.template, t.waypoints));
		}

		spawnTimer = waveData.duration;

		currentWave++;
	}
}