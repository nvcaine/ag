package entities.game.level;

import com.haxepunk.Scene;

import entities.game.ships.EnemyShip;

import model.proxy.EnemyProxy;

class Wave
{
	private var data:Dynamic;
	private var scene:Scene;

	public function new(scene:Scene)
	{
		data = {
			enemies: [{
				template: EnemyProxy.cloneInstance().enemyTemplate,
				waypoints: EnemyProxy.cloneInstance().waypoints,
				startX: 50, startY: 20
			}, {
				template: EnemyProxy.cloneInstance().enemyTemplate,
				waypoints: EnemyProxy.cloneInstance().waypoints,
				startX: 300, startY: 20
			}, {
				template: EnemyProxy.cloneInstance().enemyTemplate,
				waypoints: EnemyProxy.cloneInstance().waypoints,
				startX: 450, startY: 20
			}]
		};

		this.scene = scene;

		init();
	}

	private function init()
	{
		var enemies:Array<Dynamic> = data.enemies;

		for(t in enemies)
		{
			var enemy:EnemyShip = new EnemyShip(t.startX, t.startY, t.template, t.waypoints);

			scene.add(enemy);
		}
	}
}