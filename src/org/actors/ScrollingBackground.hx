package org.actors;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

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
		var previousImageHeight:Int = HXP.height - 512;

		for(imageAsset in images)
		{
			var image:Image = new Image(imageAsset);

			bgImages.push(scene.add(new Entity(0, previousImageHeight, image)));

			previousImageHeight -= image.height;
		}
	}

	private function translateImages()
	{
		var e:Entity;

		for(i in 0...bgImages.length)
		{
			e = bgImages[getRelativeIndex(i, currentPass, bgImages.length)];

			e.moveBy(0, this.speed);
		}

		e = bgImages[getRelativeIndex(0, currentPass, bgImages.length)];
		if(e.y >= HXP.height)
		{
			var topTileIndex:Int = getRelativeIndex(bgImages.length - 1, currentPass, bgImages.length);

			e.y = bgImages[topTileIndex].y - cast(e.graphic, Image).height;
			currentPass++;
		}

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