package model.proxy;

class LevelProxy
{
	public var waves:Array<Dynamic>;

	private var enemyProxy:EnemyProxy;

	private static var instance:LevelProxy;

	private function new()
	{
		enemyProxy = EnemyProxy.cloneInstance();

		var enemy1:Dynamic = {
			template:Reflect.copy(enemyProxy.enemyTemplates[0]),
			waypoints: enemyProxy.waypoints[0].concat([])
		};

		var enemy2:Dynamic = {
			template:Reflect.copy(enemyProxy.enemyTemplates[1]),
			waypoints: enemyProxy.waypoints[1].concat([])
		};

		waves = [];

		waves[0] = [{
			duration: 7,
			enemies: [
				{template: enemy1.template, waypoints: enemy1.waypoints, startX: 50, startY: 20},
				{template: enemy1.template, waypoints: enemy1.waypoints, startX: 280, startY: 20},
				{template: enemy1.template, waypoints: enemy1.waypoints, startX: 450, startY: 20}
			]
		}, {
			duration: 7,
			enemies: [
				{template: enemy1.template, waypoints: enemy1.waypoints, startX: 50, startY: 20},
				{template: enemy1.template, waypoints: enemy1.waypoints, startX: 280, startY: 20},
				{template: enemy1.template, waypoints: enemy1.waypoints, startX: 450, startY: 20}
			]
		}, {
			duration: 7,
			enemies: [
				{template: enemy1.template, waypoints: enemy1.waypoints, startX: 50, startY: 20},
				{template: enemy1.template, waypoints: enemy1.waypoints, startX: 280, startY: 20}, 
				{template: enemy1.template, waypoints: enemy1.waypoints, startX: 450, startY: 20}
			]
		}];

		waves[1] = [{
			duration: 7,
			enemies: [
				{template: enemy2.template, waypoints: enemy2.waypoints, startX: 50, startY: 20},
				{template: enemy2.template, waypoints: enemy2.waypoints, startX: 450, startY: 20}
			]
		}, {
			duration: 7,
			enemies: [
				{template: enemy2.template, waypoints: enemy2.waypoints, startX: 300, startY: 20}
			]
		}];
	}

	public static function cloneInstance():LevelProxy
	{
		if(instance == null)
			instance = new LevelProxy();

		return instance;
	}
}