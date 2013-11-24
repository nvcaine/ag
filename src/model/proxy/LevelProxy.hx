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
			waypoints: {duration: 3, path: enemyProxy.waypoints[0].concat([])}
		};

		var enemy2:Dynamic = {
			template:Reflect.copy(enemyProxy.enemyTemplates[1]),
			waypoints: {duration: 3, path: enemyProxy.waypoints[1].concat([])}
		};

		var storyPoints1:Dynamic = {duration: 10, path: enemyProxy.waypoints[2].concat([])};
		var storyPoints2:Dynamic = {duration: 7, path: enemyProxy.waypoints[3].concat([])};

		waves = [];

		waves[0] = [{
			duration: 7,
			enemies: [
				{template: enemy1.template, waypoints: enemy1.waypoints, startX: 50, startY: 20},
				{template: enemy1.template, waypoints: enemy1.waypoints, startX: 280, startY: 20},
				{template: enemy1.template, waypoints: enemy1.waypoints, startX: 450, startY: 20}
			],
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
				{template: enemy2.template, waypoints: enemy2.waypoints, startX: 450, startY: 20},
			],
			groundElements: [
				{x: 350, y: -100, assetPath: "gfx/meteor2.png", speed: 1},
				{x: 300, y: -100, assetPath: "gfx/meteor2.png", speed: 1},
				{x: 250, y: -100, assetPath: "gfx/meteor2.png", speed: 1}
			]
		}, {
			duration: 5,
			groundElements: [
				{x: 300, y: -300, assetPath: "gfx/meteor2.png", speed: 1},
				{x: 300, y: -200, assetPath: "gfx/meteor2.png", speed: 1},
				{x: 300, y: -100, assetPath: "gfx/meteor2.png", speed: 1},
			]			
		}, {
			duration: 70,
			enemies: [
				{template: enemy2.template, startX: 100, startY: 20},
				{template: enemy2.template, startX: 200, startY: 20},
				{template: enemy2.template, startX: 150, startY: 120},
			],
			groundElements: [
				{x: 300, y: -900, assetPath: "gfx/meteor2.png", speed: 1},
				{x: 300, y: -800, assetPath: "gfx/meteor2.png", speed: 1},
				{x: 300, y: -700, assetPath: "gfx/meteor2.png", speed: 1},
				{x: 300, y: -600, assetPath: "gfx/meteor2.png", speed: 1},
				{x: 300, y: -500, assetPath: "gfx/meteor2.png", speed: 1},
				{x: 300, y: -400, assetPath: "gfx/meteor2.png", speed: 1},
				{x: 300, y: -300, assetPath: "gfx/meteor2.png", speed: 1},
				{x: 300, y: -200, assetPath: "gfx/meteor2.png", speed: 1},
				{x: 300, y: -100, assetPath: "gfx/meteor2.png", speed: 1},
			]
		}];

		waves[2] = [{
			duration: 5,
			enemies: [
				{template: enemy1.template, startX: 100, startY: 20},
				{template: enemy1.template, startX: 200, startY: 20},
				{template: enemy1.template, startX: 300, startY: 20},
				{template: enemy1.template, startX: 400, startY: 20},
				{template: enemy1.template, startX: 150, startY: 120},
				{template: enemy1.template, startX: 250, startY: 120},
				{template: enemy1.template, startX: 350, startY: 120},
			]
		}, {
			duration: 5,
			enemies: [
				{template: enemy1.template, startX: 50, startY: 20, waypoints: storyPoints1},
				{template: enemy1.template, startX: 150, startY: 20, waypoints: storyPoints1},
				{template: enemy1.template, startX: 100, startY: 120, waypoints: storyPoints1},
				{template: enemy1.template, startX: 400, startY: 20, waypoints: storyPoints2},
				{template: enemy1.template, startX: 500, startY: 20, waypoints: storyPoints2},
				{template: enemy1.template, startX: 450, startY: 120, waypoints: storyPoints2}
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