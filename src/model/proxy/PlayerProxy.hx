package model.proxy;

import model.consts.ItemTypeConsts;
import model.dto.ItemDTO;
import model.dto.HardpointDTO;

class PlayerProxy
{
	public var level:Int = 1;
	public var balance:Int = 0;
	public var experience:Int = 0;
	public var levelLimit:Int = 100;

	public var playerData:Dynamic;

	private static var instance:PlayerProxy;

	private function new()
	{
		reset();

		// loaded from server
		playerData = {
			shipTemplate: {
				assetPath: "gfx/nava_1.png",
				energyRegen: 1,
				hardpoints: [
					new HardpointDTO({
						name:"Hardpoint 1", assetPath:"gfx/hardpoint.png", type: ItemTypeConsts.ITEM_WEAPON, x:100, y:100,
						item: new ItemDTO({assetPath: "gfx/arma_3_icon.png", name:"Weapon 3", type: ItemTypeConsts.ITEM_WEAPON, layerAsset: "gfx/arma_3.png"})
						}),
					new HardpointDTO({name:"Hardpoint 2", assetPath:"gfx/hardpoint.png", type: ItemTypeConsts.ITEM_UTILITY, x:200, y:200})
				]
			},
			items: [
				new ItemDTO({assetPath: "gfx/arma_1_icon.png", name:"Weapon 1", type: ItemTypeConsts.ITEM_WEAPON, layerAsset: "gfx/arma_1.png"}),
				new ItemDTO({assetPath: "gfx/arma_2_icon.png", name:"Weapon 2", type: ItemTypeConsts.ITEM_WEAPON, layerAsset: "gfx/arma_2.png"}),
				new ItemDTO({assetPath: "gfx/shield_icon.png", name:"Utility 1", type: ItemTypeConsts.ITEM_UTILITY, layerAsset: "gfx/shield.png"})
			]
		};
	}

	public static function cloneInstance():PlayerProxy
	{
		if(instance == null)
			instance = new PlayerProxy();

		return instance;
	}

	public function increaseExperience(amount:Int)
	{
		experience += amount;

		if(experience >= levelLimit)
			levelUp();
	}

	public function increaseBalance(amount:Int)
	{
		balance += amount;
	}

	public function reset()
	{
		level = 1;
		balance = 0;
		experience = 0;
		levelLimit = 100;
	}

	private function levelUp()
	{
		level++;
		levelLimit = level * 100;
		experience = 0;
	}
}