package entities.inventory;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;

import model.consts.ItemTypeConsts;
import model.dto.ItemDTO;
import model.dto.HardpointDTO;
import model.proxy.PlayerProxy;

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
		super.added();

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
		if(graphic != null)
			graphic.destroy();

		var elements:Array<Image> = [];
		var base:Image = new Image(data.assetPath);

		base.scaleX = base.scaleY = 3;

		elements.push(base);

		for(i in 0...hardpoints.length)
			if(!hardpoints[i].isAvailable())
			{
				var asset:Image = new Image(hardpoints[i].getLayerAsset());

				asset.scaleX = asset.scaleY = 3;

				elements.push(asset);
			}

		graphic = new Graphiclist(elements);
	}

	private function init()
	{
		hardpoints = [];

		drawShipTemplate();
	}

	private function drawShipTemplate()
	{
		var hpData:Array<HardpointDTO> = PlayerProxy.cloneInstance().playerData.shipTemplate.hardpoints;

		if(graphic != null)
			graphic.destroy();

		var elements:Array<Image> = [];
		var base:Image = new Image(data.assetPath);

		base.scaleX = base.scaleY = 3;

		elements.push(base);

		for(i in 0...hpData.length)
			if(hpData[i].item != null)
			{
				var asset:Image = new Image(hpData[i].item.layerAsset);

				asset.scaleX = asset.scaleY = 3;

				elements.push(asset);
			}

		graphic = new Graphiclist(elements);

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