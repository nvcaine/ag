package model.proxy;

import model.consts.ItemTypeConsts;
import model.dto.ItemDTO;
import model.dto.WeaponDTO;

class ItemsProxy
{
	private static var instance:ItemsProxy;

	public var itemTemplates:Array<ItemDTO>;

	private function new()
	{
		// weapons should have a hardpoint asset too

		itemTemplates = [
			new WeaponDTO({
				name:"Weapon 3", type: ItemTypeConsts.ITEM_WEAPON,
				assetPath: "gfx/arma_3_icon.png", layerAsset: "gfx/arma_3.png",
				fireDelay: 1, damage: 30, energy: 10,
				projectile: ProjectileProxy.cloneInstance().projectileTemplates[0]
			}),

			new WeaponDTO({
				name:"Weapon 2", type: ItemTypeConsts.ITEM_WEAPON,
				assetPath: "gfx/arma_2_icon.png", layerAsset: "gfx/arma_2.png",
				fireDelay: 0.15, damage: 5, energy: 1,
				projectile: ProjectileProxy.cloneInstance().projectileTemplates[1]
			}),

			new WeaponDTO({
				name:"Weapon 1", type: ItemTypeConsts.ITEM_WEAPON,
				assetPath: "gfx/arma_1_icon.png", layerAsset: "gfx/arma_1.png",
				fireDelay: 0.75, damage: 15, energy: 4,
				projectile: ProjectileProxy.cloneInstance().projectileTemplates[0]
			}),

			new ItemDTO({
				name:"Utility 1", type: ItemTypeConsts.ITEM_UTILITY,
				assetPath: "gfx/shield_icon.png", layerAsset: "gfx/shield.png"
			}),

			new WeaponDTO({
				name:"Weapon 4", type: ItemTypeConsts.ITEM_WEAPON,
				assetPath: "gfx/arma_3_icon.png", layerAsset: "gfx/arma_4.png",
				fireDelay: 0.15, damage: 5, energy: 1,
				projectile: ProjectileProxy.cloneInstance().projectileTemplates[0]
			}),

			new WeaponDTO({
				name:"Weapon 5", type: ItemTypeConsts.ITEM_WEAPON,
				assetPath: "gfx/arma_3_icon.png", layerAsset: "gfx/arma_5.png",
				fireDelay: 0.15, damage: 5, energy: 1,
				projectile: ProjectileProxy.cloneInstance().projectileTemplates[0]
			})
	];
	}

	public static function cloneInstance():ItemsProxy
	{
		if(instance == null)
			instance = new ItemsProxy();

		return instance;
	}
}