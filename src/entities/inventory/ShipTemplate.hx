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
import nme.geom.Point;
import nme.geom.Rectangle;

class ShipTemplate extends Entity
{
	private var hardpoints:Array<Hardpoint>;
	private var data:Dynamic;

	public function new(x:Float, y:Float, data:Dynamic)
	{
		super(x, y);

		this.data = data;
	}

	override public function added()
	{
		init();
	}

	public function saveTemplate()
	{
		var hpData:Array<HardpointDTO> = [];

		for(i in 0...hardpoints.length)
			hpData.push(hardpoints[i].getData());

		PlayerProxy.cloneInstance().playerData.shipTemplate.hardpoints = hpData; // direct reference
	}

	public function hasAvailableHardpoint(type:String)
	{
		for(i in 0...hardpoints.length)
			if(hardpoints[i].isAvailable() && hardpoints[i].supports(type))
				return true;

		return false;
	}

	public function equipItem(item:ItemDTO)
	{
		var hardpoint:Hardpoint = getAvailableHardpoint(item.type);

		if(hardpoint == null)
			return;

		hardpoint.mountItem(item);

		updateTemplate();
	}

	public function unequipItem(item:ItemDTO)
	{
		updateTemplate();
	}

	private function updateTemplate()
	{
		var base:BitmapData = Assets.getBitmapData(data.assetPath).clone();

		for(hardpoint in hardpoints)
			if(!hardpoint.isAvailable())
			{
				var hardpointData:HardpointDTO = hardpoint.getData();
				var layerAsset:BitmapData = Assets.getBitmapData(hardpoint.getLayerAsset()).clone();
				var offset:Point = new Point(hardpointData.x / 3 + 15 - layerAsset.width, hardpointData.y / 3 + 15 - layerAsset.height);
				var rect:Rectangle = new Rectangle(0, 0, layerAsset.width, layerAsset.height);

				base.copyPixels(layerAsset, rect , offset, null, null, true);
			}

		var resultImage:Image = new Image(base);

		resultImage.scaleX = resultImage.scaleY = 3;

		graphic = resultImage;
	}

	private function init()
	{
		hardpoints = [];

		drawShipTemplate();
	}

	private function drawShipTemplate()
	{
		var hpData:Array<HardpointDTO> = PlayerProxy.cloneInstance().playerData.shipTemplate.hardpoints;
		var base:BitmapData = Assets.getBitmapData(data.assetPath).clone();

		for(hardpoint in hpData)
			if(hardpoint.item != null)
			{
				var layerAsset:BitmapData = Assets.getBitmapData(hardpoint.item.layerAsset).clone();
				var offset:Point = new Point(hardpoint.x / 3 + 15 - layerAsset.width, hardpoint.y / 3 + 15 - layerAsset.height);
				var rect:Rectangle = new Rectangle(0, 0, layerAsset.width, layerAsset.height);

				base.copyPixels(layerAsset, rect , offset, null, null, true);
			}

		var baseImage:Image = new Image(base);

		baseImage.scaleX = baseImage.scaleY = 3;

		graphic = baseImage;

		drawHardpoints(hpData); // direct reference
	}

	private function drawHardpoints(hardpointsData:Array<HardpointDTO>)
	{
		for(i in 0...hardpointsData.length)
			drawHardpoint(x + hardpointsData[i].x, y + hardpointsData[i].y, hardpointsData[i]);
	}

	private function drawHardpoint(x:Float, y:Float, data:HardpointDTO)
	{
		var hp:Hardpoint = new Hardpoint(x, y, data);

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