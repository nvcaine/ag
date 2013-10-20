package entities.game.ships;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;

import model.dto.HardpointDTO;
import model.dto.ItemDTO;

import nme.Assets;

import nme.display.BitmapData;

import nme.geom.Point;
import nme.geom.Rectangle;

import org.actors.SimpleMessageEntity;

class ShipEntity extends SimpleMessageEntity
{
	private var data:Dynamic;

	public function new(x:Float, y:Float, data:Dynamic)
	{
		super(x, y);

		this.data = Reflect.copy(data);
	}

	override public function added()
	{
		graphic = getEntityGraphic(data.assetPath, data.hardpoints);

		setHitbox(data.width, data.height);
	}

	private function getEntityGraphic(baseAsset:String, hardpoints:Array<HardpointDTO>):Image
	{
		var base:BitmapData = Assets.getBitmapData(baseAsset, false);

		for(hardpoint in hardpoints)
			equipHardpointItem(base, hardpoint);

		return new Image(base);
	}

	private function equipHardpointItem(base:BitmapData, hardpoint:HardpointDTO)
	{
		if(hardpoint.item == null)
			return;

		var layerAsset:BitmapData = Assets.getBitmapData(hardpoint.item.layerAsset);
		var offset:Point = new Point(hardpoint.x, hardpoint.y - layerAsset.height + 15);
		var rect:Rectangle = new Rectangle(0, 0, layerAsset.width, layerAsset.height);

		base.copyPixels(layerAsset, rect , offset, null, null, true);
	}
}