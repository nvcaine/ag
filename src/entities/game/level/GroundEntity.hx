package entities.game.level;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Pixelmask;

import model.consts.EntityTypeConsts;
import model.consts.LayerConsts;

class GroundEntity extends Entity
{
	private var data:Dynamic;

	public function new(x:Float, y:Float, data:Dynamic)
	{
		super(x, y);

		this.data = data;

		type = EntityTypeConsts.LEVEL;
		layer = LayerConsts.MIDDLE;
	}

	override public function added()
	{
		init(data.assetPath);
	}

	override public function update()
	{
		updatePosition();
		checkPlayerCollision();

		if(y > HXP.height)
			scene.remove(this);
	}

	private function init(assetPath:String)
	{
		mask = new Pixelmask(assetPath);
		graphic = new Image(assetPath);
	}

	private function updatePosition()
	{
		moveBy(0, data.speed);
	}

	private function checkPlayerCollision()
	{
	}
}