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

	public function new(data:Dynamic)
	{
		this.data = data;

		super(data.x, data.y);

		type = EntityTypeConsts.LEVEL;
		layer = LayerConsts.MIDDLE;
	}

	// do this for all level entities
	override public function removed()
	{
		graphic.destroy();
	}

	override public function added()
	{
		init(data.assetPath);
	}

	override public function update()
	{
		if(y > HXP.height)
		{
			scene.remove(this);

			return;
		}

		updatePosition();
		checkPlayerCollision();
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