package model.proxy;

import model.consts.ItemTypeConsts;
import model.dto.ItemDTO;
import model.dto.HardpointDTO;
import model.dto.WeaponDTO;

class PlayerProxy
{
	private static var instance:PlayerProxy;

	public var level:Int = 1;
	public var balance:Int = 0;
	public var experience:Int = 0;
	public var levelLimit:Int = 100;
	public var playerData:Dynamic;

	private var availableEnergy:Int;

	private function new()
	{
		reset();

		// loaded from server
		playerData = {
			shipTemplate: {

				assetPath: "gfx/nava_1.png",
				hp: 100, energy: 100, energyRegen: 1,
				width:98, height: 98, speed: 5,

				hardpoints: [
					new HardpointDTO({
						name:"Hardpoint 1",
						assetPath:"gfx/hardpoint.png",
						type: ItemTypeConsts.ITEM_WEAPON,
						x:30, y:80,
						
						item: ItemsProxy.cloneInstance().itemTemplates[5]
					}),

					new HardpointDTO({
						name:"Hardpoint 1",
						assetPath:"gfx/hardpoint.png",
						type: ItemTypeConsts.ITEM_WEAPON,
						x:215, y:80,

						item: ItemsProxy.cloneInstance().itemTemplates[4]
					}),


					new HardpointDTO({
						name:"Hardpoint 2",
						assetPath:"gfx/hardpoint.png",
						type: ItemTypeConsts.ITEM_UTILITY,
						x:200, y:200
					})
				]
			},

			items: [
				ItemsProxy.cloneInstance().itemTemplates[2],
				ItemsProxy.cloneInstance().itemTemplates[3],
				ItemsProxy.cloneInstance().itemTemplates[1]
			]
		};
	}

	public static function cloneInstance():PlayerProxy
	{
		if(instance == null)
			instance = new PlayerProxy();

		return instance;
	}

	public function getMaxHealth():Int
	{
		return playerData.shipTemplate.hp;
	}

	public function getMaxEnergy():Int
	{
		return playerData.shipTemplate.energy;
	}

	public function updateEnergy(value:Int)
	{
		availableEnergy = value;
	}

	public function getAvailableEnergy()
	{
		return availableEnergy;
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