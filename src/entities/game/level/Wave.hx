package entities.game.level;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Scene;

import entities.game.ships.EnemyShip;

import model.proxy.EnemyProxy;

class Wave extends Entity
{
	private var waves:Array<Dynamic>;

	public function new()
	{
		super(0, 0);

	}

	override public function added()
	{
		initWave(waves[0]);
	}

	override public function update()
	{
		if(waveTimer < 0)
			initWave(waves[currentWave]);

		waveTimer -= HXP.elapsed;
	}

	private function initWave(waveData:Dynamic)
	{
		var enemies:Array<Dynamic> = waveData.enemies;

		for(t in enemies)
		{
			var enemy:EnemyShip = new EnemyShip(t.startX, t.startY, t.template, t.waypoints);

			scene.add(enemy);
		}

		waveTimer = waveData.duration;
		currentWave++;
	}
}