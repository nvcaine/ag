package entities.game.level;

import com.haxepunk.Entity;
import com.haxepunk.HXP;

import entities.game.ships.EnemyShip;

import model.events.LevelEvent;
import model.proxy.EnemyProxy;

import org.actors.MessageEntity;
//import org.actors.ParticleBackground;

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

		scene.add(new GroundEntity(350, -100, {assetPath: "gfx/meteor2.png", speed: 1}));
		scene.add(new GroundEntity(300, -100, {assetPath: "gfx/meteor2.png", speed: 1}));
		scene.add(new GroundEntity(250, -100, {assetPath: "gfx/meteor2.png", speed: 1}));

		/*scene.add(new GroundEntity(200, 100, {assetPath: "gfx/meteor2.png", speed: 0}));
		scene.add(new GroundEntity(200, 150, {assetPath: "gfx/meteor2.png", speed: 0}));
		scene.add(new GroundEntity(200, 200, {assetPath: "gfx/meteor2.png", speed: 0}));
		scene.add(new GroundEntity(200, 250, {assetPath: "gfx/meteor2.png", speed: 0}));*/

		/*scene.add(new ParticleBackground(0.3, 6, 5, 0.75));
		scene.add(new ParticleBackground(0.1, 3.5, 3, 0.75));
		scene.add(new ParticleBackground(0.075, 2, 2, 1, false));*/
	}

	private function initWave(waveData:Dynamic)
	{
		var enemies:Array<Dynamic> = waveData.enemies;

		for(t in enemies)
			scene.add(new EnemyShip(t.startX, t.startY, t.template, t.waypoints));

		spawnTimer = waveData.duration;
		currentWave++;
	}
}