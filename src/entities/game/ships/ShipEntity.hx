package entities.game.ships;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;

import model.dto.HardpointDTO;

import org.actors.MessageEntity;

// MessageEntity contains graphic logic - unnecessary graphic logic
class ShipEntity extends MessageEntity
{
	private var data:Dynamic;

	public function new(x:Float, y:Float, data:Dynamic)
	{
		super(x, y);

		this.data = Reflect.copy(data);
	}

	override public function added()
	{
		graphic = getEntityGraphic(data.assetPath, getLayerAssets(data.hardpoints));

		setHitbox(data.width, data.height);
	}

	private function getLayerAssets(hardpointsData:Array<HardpointDTO>):Array<String>
	{
		var assets:Array<String> = [];

		for(hardpoint in hardpointsData)
			if(hardpoint.item != null)
				assets.push(hardpoint.item.layerAsset);

		return assets;
	}

	private function getEntityGraphic(baseAsset:String, assets:Array<String>):Graphiclist
	{
		var images:Array<Image> = [];

		for(asset in assets)
			images.push(new Image(asset));

		images.push(new Image(baseAsset));

		return new Graphiclist(images);
	}
}