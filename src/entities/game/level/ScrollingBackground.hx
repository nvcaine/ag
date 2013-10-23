package entities.game.level;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

import model.consts.LayerConsts;

class ScrollingBackground extends Entity
{
	private var bgImages:Array<Entity>;
	private var currentPass:Int = 0;
	private var speed:Float;

	public function new(speed:Float = 0)
	{
		super(0, 0);

		this.speed = speed;
		bgImages = [];
	}

	override public function added()
	{
		super.added();

		initImages(["gfx/bg2.jpg", "gfx/bg2.jpg"]);
	}

	override public function update()
	{
		super.update();

		translateImages();
	}

	private function initImages(images:Array<String>)
	{
		var currentImageY:Int = HXP.height - 512; // initial offset, should be computed

		for(imageAsset in images)
			currentImageY -= addBackgroundImage(imageAsset, currentImageY);
	}

	private function addBackgroundImage(imageAsset:String, yOffset:Int):Int
	{
		var image:Image = new Image(imageAsset);
		var e:Entity = new Entity(0, yOffset, image);

		e.layer = LayerConsts.BOTTOM;

		bgImages.push(e);
		scene.add(e);

		return image.height;
	}

	private function translateImages()
	{
		for(i in 0...bgImages.length)
		{
			var e:Entity = bgImages[getRelativeIndex(i, currentPass, bgImages.length)];

			e.moveBy(0, this.speed);
		}

		updateBottomImage();
	}

	private function updateBottomImage()
	{
		var e:Entity = bgImages[getRelativeIndex(0, currentPass, bgImages.length)];

		if(e.y < HXP.height)
			return;

		e.y = bgImages[getTopIndex(currentPass)].y - cast(e.graphic, Image).height;

		updatePass();
	}

	private function getTopIndex(pass:Int):Int
	{
		return getRelativeIndex(bgImages.length - 1, pass, bgImages.length);
	}

	private function updatePass()
	{
		currentPass++;

		if(currentPass >= bgImages.length)
			currentPass = 0;
	}

	private function getRelativeIndex(relative:Int, pass:Int, length:Int)
	{
		if(relative + pass >= length)
			return relative + pass - length;

		return relative + pass;
	}
}