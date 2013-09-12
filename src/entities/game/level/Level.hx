package entities.game.level;

import com.haxepunk.Entity;
import com.haxepunk.HXP;

import entities.game.ships.EnemyShip;

import model.proxy.EnemyProxy;

import org.actors.ScrollingBackground;
import org.actors.ParticleBackground;

class Level extends Entity
{
	private var spawnTimer:Float = 0;

	public function new()
	{
		super(0, 0);
	}

	override public function added()
	{
		init();
	}

	override public function update()
	{
		spawnTimer -= HXP.elapsed;
		
		/*if(spawnTimer < 0)
			spawn();*/

		//updateWaves();
	}

	/*private function updateWaves()
	{
		currentWave = getCurrentWave();

		currentWave.update();
	}*/

	private function init()
	{
		scene.add(new ScrollingBackground(2.33));
		scene.add(new ParticleBackground(0.3, 6, 5, 0.75));
		scene.add(new ParticleBackground(0.1, 3.5, 3, 0.75));
		scene.add(new ParticleBackground(0.075, 2, 2, 1, false));
	}

	/*private function spawn()
	{
		var enemyData:Dynamic = Reflect.copy(EnemyProxy.cloneInstance().enemyTemplate);

		scene.add(new EnemyShip(HXP.width / 2, 10, enemyData));

		spawnTimer = 2.66;
	}*/
}