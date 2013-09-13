package model.proxy;

import model.consts.ItemTypeConsts;

import model.dto.ItemDTO;
import model.dto.HardpointDTO;

class EnemyProxy
{
	public var enemyTemplate:Dynamic;
	public var waypoints:Array<Dynamic>;

	private static var instance:EnemyProxy;

	private function new()
	{
		enemyTemplate = {

			assetPath: "gfx/enemy_01.png",
			energyRegen: 1,
			type: "enemy",
			health: 100, damage: 25, speed: 3,
			width: 98, height: 98,
			score: 5, xp: 10,

			hardpoints: [
				/*new HardpointDTO({
					name:"Hardpoint 1",
					assetPath:"gfx/hardpoint.png",
					type: ItemTypeConsts.ITEM_WEAPON,
					x:100, y:100,
					
					item: new ItemDTO({
						assetPath: "gfx/arma_3_icon.png",
						name:"Weapon 3",
						type: ItemTypeConsts.ITEM_WEAPON,
						layerAsset: "gfx/arma_3.png"})
					}),

				new HardpointDTO({
					name:"Hardpoint 2",
					assetPath:"gfx/hardpoint.png",
					type: ItemTypeConsts.ITEM_UTILITY,
					x:200, y:200})*/
			]
		};

		waypoints = [
			{x: 0, y: 0},
			{x: -100, y: 200},
			{x: 100, y: 200},
			{x: 0, y: 0}
		];
	}

	public static function cloneInstance():EnemyProxy
	{
		if(instance == null)
			instance = new EnemyProxy();

		return instance;
	}
}