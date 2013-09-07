package org.actors;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

class ScrollingBackground extends Entity
{
	private var currentPass:Int = 0;
	private var speed:Int;
	private var bgImages:Array<Entity>;

	public function new(x, y, speed:Int = 0)
	{
		super(x, y);

		this.speed = speed;
		bgImages = [];
	}

	override public function added()
	{
		super.added();

		initImages(["gfx/bg.png", "gfx/bg.png", "gfx/bg.png"]);
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
		for(i in 0...bgImages.length)
		{
			var e:Entity = bgImages[getCurrentIndex(i, currentPass, bgImages.length)];

			e.moveBy(0, this.speed);

			if(e.y >= HXP.height)
			{
				var topTileIndex:Int = getCurrentIndex(i + bgImages.length - 1, currentPass, bgImages.length);

				e.y = bgImages[topTileIndex].y - cast(e.graphic, Image).height;
				currentPass++;
			}
		}

		if(currentPass >= bgImages.length)
			currentPass = 0;
	}

	private function getCurrentIndex(relative:Int, pass:Int, length:Int)
	{
		if(relative + pass >= length)
			return relative + pass - length;

		return relative + pass;
	}
}