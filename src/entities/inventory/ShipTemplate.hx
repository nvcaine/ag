package entities.inventory;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;

import model.consts.ItemTypeConsts;
import model.dto.ItemDTO;
import model.dto.HardpointDTO;
import model.proxy.PlayerProxy;

import nme.Assets;
import nme.display.BitmapData;
import nme.filters.GlowFilter;
import nme.geom.Point;
import nme.geom.Rectangle;

class ShipTemplate extends Entity
{
	private var hardpoints:Array<Hardpoint>;
	private var data:Dynamic;

	private var playerProxy:PlayerProxy;

	public function new(x:Float, y:Float, data:Dynamic)
	{
		super(x, y);

		this.data = data;
	}

	override public function added()
	{
		playerProxy = PlayerProxy.cloneInstance();

		drawShipTemplate(playerProxy.getHardpoints(), 3);
		drawHardpoints(playerProxy.getHardpoints(), 3);
	}

	public function saveTemplate()
	{
		var hpData:Array<HardpointDTO> = [];

		for(hardpoint in hardpoints)
			hpData.push(hardpoint.getData());

		playerProxy.saveHardpointData(hpData);
	}

	public function hasAvailableHardpoint(type:String)
	{
		for(hardpoint in hardpoints)
			if(hardpoint.isAvailable() && hardpoint.supports(type))
				return true;

		return false;
	}

	public function equipItem(item:ItemDTO)
	{
		var hardpoint:Hardpoint = getAvailableHardpoint(item.type);

		if(hardpoint == null)
			return;

		hardpoint.mountItem(item);

		drawShipTemplate(getUsedHardpointsData(hardpoints), 3);
	}

	public function unequipItem(item:ItemDTO)
	{
		drawShipTemplate(getUsedHardpointsData(hardpoints), 3);
	}

	private function drawShipTemplate(hpData:Array<HardpointDTO>, scale:Int)
	{
		var base:BitmapData = Assets.getBitmapData(data.assetPath).clone();
		var baseImage:Image = new Image(getTemplateBitmapData(base, hpData));

		baseImage.scaleX = baseImage.scaleY = scale;

		graphic = baseImage;
	}

	private function getUsedHardpointsData(hardpoints:Array<Hardpoint>)
	{
		var result:Array<HardpointDTO> = [];

		for(hardpoint in hardpoints)
			if(!hardpoint.isAvailable())
				result.push(hardpoint.getData());

		return result;
	}

	private function getTemplateBitmapData(base:BitmapData, hpData:Array<HardpointDTO>):BitmapData
	{
		var result:BitmapData = base.clone();

		for(hardpoint in hpData)
			if(hardpoint.item != null)
			{
				var layerAsset:BitmapData = Assets.getBitmapData(hardpoint.item.layerAsset).clone();
				var offset:Point = new Point(hardpoint.x, hardpoint.y - layerAsset.height + 15);
				var rect:Rectangle = new Rectangle(0, 0, layerAsset.width, layerAsset.height);

				result.copyPixels(layerAsset, rect, offset, null, null, true);
			}

		result.applyFilter(result, new Rectangle(0, 0, result.width, result.height), new Point(0, 0), new GlowFilter(0x00FF00, 1, 5, 5));

		return result;
	}

	private function drawHardpoints(hardpointsData:Array<HardpointDTO>, scale:Int)
	{
		hardpoints = [];

		for(i in 0...hardpointsData.length)
			drawHardpoint(hardpointsData[i].x, hardpointsData[i].y, hardpointsData[i], scale);
	}

	private function drawHardpoint(xOffset:Float, yOffset:Float, data:HardpointDTO, scale:Int)
	{
		var hp:Hardpoint = new Hardpoint(x + xOffset * scale, y + yOffset * scale, data);

		hardpoints.push(hp);

		scene.add(hp);
	}

	private function getAvailableHardpoint(type:String):Hardpoint
	{
		for(i in 0...hardpoints.length)
			if(hardpoints[i].isAvailable() && hardpoints[i].supports(type))
				return hardpoints[i];

		return null;
	}
}