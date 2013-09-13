package entities.game.level;

import com.haxepunk.Entity;
import com.haxepunk.HXP;

import entities.game.ships.EnemyShip;

import model.events.LevelEvent;
import model.proxy.EnemyProxy;
import model.proxy.LevelProxy;

import org.actors.MessageEntity;
import org.actors.ScrollingBackground;
import org.actors.ParticleBackground;

class Level extends MessageEntity
{
	private var spawnTimer:Float = 0;
	private var currentWave:Int = 0;

	private var enemyProxy:EnemyProxy;

	private var waves:Array<Dynamic>;

	public function new()
	{
		super(0, 0);

		enemyProxy = EnemyProxy.cloneInstance();
		waves = LevelProxy.cloneInstance().waves;
	}

	override public function added()
	{
		init();

		initWave(waves[currentWave]);
	}

	override public function update()
	{
		spawnTimer -= HXP.elapsed;
		
		if(spawnTimer < 0)
		{
			if(currentWave < waves.length)
				initWave(waves[currentWave]);
			else
			{
				sendMessage(new LevelEvent(LevelEvent.FINISHED_LEVEL));
				scene.remove(this);
			}
		}
	}

	private function init()
	{
		scene.add(new ScrollingBackground(1));

		scene.add(new ParticleBackground(0.3, 6, 5, 0.75));
		scene.add(new ParticleBackground(0.1, 3.5, 3, 0.75));
		scene.add(new ParticleBackground(0.075, 2, 2, 1, false));
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