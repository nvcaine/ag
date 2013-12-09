package entities.game.misc;

import com.haxepunk.graphics.Image;//Graphic;
import com.haxepunk.HXP;

import nme.Assets;

import nme.display.BitmapData;

import nme.geom.Point;
import nme.geom.Rectangle;

class Plasma extends Projectile
{
	private var graphicBitmapData:BitmapData;
	private var delay:Float = 0.05;

	override public function added()
	{
		graphicBitmapData = Assets.getBitmapData(data.assetPath);

		graphic = new Image(graphicBitmapData);//new Graphic();

		setHitbox(graphicBitmapData.width, graphicBitmapData.height);
	}

	override public function update()
	{
		if(delay < 0)
		{
			fire();
			delay = 0.05;
			moveBy(0, -12);
			return;
		}

		delay -= HXP.elapsed;
	}

	private function fire()
	{
		var prevHeight:Int = graphicBitmapData.height;

		var prevBMData:BitmapData = graphicBitmapData.clone();
		var bd:BitmapData = Assets.getBitmapData(data.assetPath);

		graphicBitmapData = new BitmapData(prevBMData.width,  prevHeight + bd.height, true, 0x000000);

		graphicBitmapData.copyPixels(prevBMData, new Rectangle(0, 0, prevBMData.width, prevHeight) , new Point(0, 0), null, null, true);
		graphicBitmapData.copyPixels(bd, new Rectangle(0, 0, bd.width, bd.height) , new Point(0, prevHeight), null, null, true);

		graphic = new Image(graphicBitmapData);

		setHitbox(graphicBitmapData.width, graphicBitmapData.height);
	}
}