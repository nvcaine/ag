package model.proxy;

class LevelProxy
{
	public var waves:Array<Dynamic>;

	private var enemyProxy:EnemyProxy;

	private static var instance:LevelProxy;

	private function new()
	{
		enemyProxy = EnemyProxy.cloneInstance();

		waves = [{
				enemies: [{
					template: Reflect.copy(enemyProxy.enemyTemplate),
					waypoints: enemyProxy.waypoints,
					startX: 50, startY: 20
				}, {
					template: Reflect.copy(enemyProxy.enemyTemplate),
					waypoints: enemyProxy.waypoints,
					startX: 280, startY: 20
				}, {
					template: Reflect.copy(enemyProxy.enemyTemplate),
					waypoints: enemyProxy.waypoints,
					startX: 450, startY: 20
				}],

				duration: 7
			}, {
				enemies: [{
					template: Reflect.copy(enemyProxy.enemyTemplate),
					waypoints: enemyProxy.waypoints,
					startX: 50, startY: 20
				}, {
					template: Reflect.copy(enemyProxy.enemyTemplate),
					waypoints: enemyProxy.waypoints,
					startX: 280, startY: 20
				}, {
					template: Reflect.copy(enemyProxy.enemyTemplate),
					waypoints: enemyProxy.waypoints,
					startX: 450, startY: 20
				}],

				duration: 7

			}, {
				enemies: [{
					template: Reflect.copy(enemyProxy.enemyTemplate),
					waypoints: enemyProxy.waypoints,
					startX: 50, startY: 20
				}, {
					template: Reflect.copy(enemyProxy.enemyTemplate),
					waypoints: enemyProxy.waypoints,
					startX: 280, startY: 20
				}, {
					template: Reflect.copy(enemyProxy.enemyTemplate),
					waypoints: enemyProxy.waypoints,
					startX: 450, startY: 20
				}],

				duration: 7
			}];
	}

	public static function cloneInstance():LevelProxy
	{
		if(instance == null)
			instance = new LevelProxy();

		return instance;
	}
}