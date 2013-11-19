package entities.game.ships;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;

import entities.game.misc.Projectile;

import model.consts.EntityTypeConsts;
import model.consts.ItemTypeConsts;
import model.consts.LayerConsts;
import model.dto.HardpointDTO;
import model.dto.ItemDTO;
import model.dto.WeaponDTO;

import nme.Assets;
import nme.display.BitmapData;
import nme.geom.Point;
import nme.geom.Rectangle;

import org.actors.SimpleMessageEntity;

class ShipEntity extends SimpleMessageEntity
{
	private var weapons:Array<Weapon>;
	private var data:Dynamic;
	private var flipped:Bool;

	public function new(x:Float, y:Float, data:Dynamic, flipped:Bool = false)
	{
		super(x, y);

		this.data = Reflect.copy(data);
		layer = LayerConsts.MIDDLE;

		this.flipped = flipped;
	}

	override public function added()
	{
		graphic = new Image(getEntityBitmapData(data.assetPath, data.hardpoints)); //getEntityGraphic(data.assetPath, data.hardpoints);

		setHitbox(data.width, data.height);
		initWeapons(data.hardpoints);
	}

	override public function update()
	{
		if(weapons != null)
			for(weapon in weapons)
				weapon.update();
	}

	public function takeDamage(damage:Float)
	{
		data.health -= damage;
	}

	public function fire(targetTypes:Array<String>, drainEnergy:Bool = false)
	{
		if(weapons == null || weapons.length == 0)
			return;

		for(weapon in weapons)
			weapon.fire(x, y, scene, flipped, targetTypes, drainEnergy);
	}

	// might have to remove this later
	private function getEntityBitmapData(baseAsset:String, hardpoints:Array<HardpointDTO>):BitmapData
	{
		var base:BitmapData = Assets.getBitmapData(baseAsset, false);

		for(hardpoint in hardpoints)
			equipHardpointItem(base, hardpoint);

		return base;
	}

	/*private function getEntityGraphic(baseAsset:String, hardpoints:Array<HardpointDTO>):Image
	{
		return new Image(getEntityBitmapData(baseAsset, hardpoints));
	}*/

	private function equipHardpointItem(base:BitmapData, hardpoint:HardpointDTO)
	{
		if(hardpoint.item == null)
			return;

		var layerAsset:BitmapData = Assets.getBitmapData(hardpoint.item.layerAsset);
		var offset:Point = new Point(hardpoint.x, hardpoint.y - layerAsset.height + 15);
		var rect:Rectangle = new Rectangle(0, 0, layerAsset.width, layerAsset.height);

		base.copyPixels(layerAsset, rect , offset, null, null, true);
	}

	private function initWeapons(hardpointsInfo:Array<HardpointDTO>)
	{
		if(hardpointsInfo.length == 0 || hardpointsInfo == null)
			return;

		weapons = [];

		for(hardpoint in hardpointsInfo)
			if(hardpoint.item != null && hardpoint.item.type == ItemTypeConsts.ITEM_WEAPON)
				weapons.push(initNewWeapon(hardpoint));
	}

	private function initNewWeapon(hardpoint:HardpointDTO):Weapon
	{
		var weaponData:WeaponDTO = cast(hardpoint.item, WeaponDTO);
		var projectileBitmapData:BitmapData = Assets.getBitmapData(weaponData.projectile.assetPath);
		var weaponAsset:BitmapData = Assets.getBitmapData(hardpoint.item.layerAsset);
		var xOffset:Float = hardpoint.x + (weaponAsset.width - projectileBitmapData.width) / 2;
		var yOffset:Float = hardpoint.y - weaponAsset.height;

		if(flipped)
		{
			xOffset = width - (xOffset + projectileBitmapData.width / 2);
			yOffset = height - (yOffset + projectileBitmapData.height);
		}

		return new Weapon(weaponData, xOffset, yOffset, flipped);
	}
}