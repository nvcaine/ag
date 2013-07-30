package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

import model.consts.EntityTypeConsts;

class Pickup extends Entity
{
	public function new(x:Float, y:Float, data:Dynamic)
	{
		super(x, y);

		type = EntityTypeConsts.PICKUP;

		initGraphic(data);
	}

	private function initGraphic(data:Dynamic)
	{
		var g:Image = new Image(data.assetPath);

		graphic = g;

		setHitbox(data.width, data.height);
	}
}