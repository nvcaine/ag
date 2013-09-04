package entities.game;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;

import model.dto.HardpointDTO;

import org.actors.MessageEntity;

class GameEntity extends MessageEntity
{
	private var data:Dynamic;

	public function new(x:Float, y:Float, data:Dynamic)
	{
		super(x, y);

		this.data = data;
	}

	override public function added()
	{
		super.added();

		graphic = getEntityGraphic(data.assetPath, getLayerAssets(data.hardpoints));
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