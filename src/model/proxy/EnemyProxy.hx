package model.proxy;

import model.consts.ItemTypeConsts;

import model.dto.ItemDTO;
import model.dto.HardpointDTO;

class EnemyProxy
{
	public var enemyTemplates:Array<Dynamic>;
	public var waypoints:Array<Dynamic>;

	private static var instance:EnemyProxy;

	private function new()
	{
		// ship templates proxy

		enemyTemplates = [{
			assetPath: "gfx/enemy_01.png",
			energyRegen: 1,
			type: "enemy",
			health: 100, damage: 25, speed: 3,
			width: 98, height: 98,
			score: 5, xp: 10,
			hardpoints: [
				new HardpointDTO({
					name:"Hardpoint 1",
					assetPath:"gfx/hardpoint.png",
					type: ItemTypeConsts.ITEM_WEAPON,
					x:10, y:26,
					
					item: ItemsProxy.cloneInstance().itemTemplates[5]
				})
			]
		}, {
			assetPath: "gfx/nava_1.png",
			energyRegen: 1,
			type: "enemy",
			health: 100, damage: 25, speed: 3,
			width: 98, height: 98,
			score: 5, xp: 10,
			hardpoints: []		
		}];

		waypoints = [[
			{x: 0, y: 0},
			{x: -100, y: 200},
			{x: 100, y: 200},
			{x: 0, y: 0}
		], [
			{x: 0, y: 0},
			{x: -100, y: 300},
			{x: 100, y: 300},
			{x: 0, y: 0}
		], [
			{x:0, y:0},
			{x:500, y:500}
		], [
			{x:0, y:0},
			{x:-500, y:500}
		]];
	}

	public static function cloneInstance():EnemyProxy
	{
		if(instance == null)
			instance = new EnemyProxy();

		return instance;
	}
}