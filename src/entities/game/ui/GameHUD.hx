package entities.game.ui;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;

import nme.geom.Rectangle;

class GameHUD extends Graphiclist
{
	private var healthBar:Image;
	private var energyBar:Image;

	private var data:Dynamic;

	public function new(data:Dynamic)
	{
		super();

		this.data = data;
		init(this.data);
	}

	private function init(data:Dynamic)
	{
		add(new Image(data.background));

		healthBar = createBar(data.healthBar, 13, 4);
		energyBar = createBar(data.energyBar, 348, 4);
	}

	private function createBar(asset:String, xOffset:Int, yOffset:Int):Image
	{
		var bar:Image = cast(add(new Image(asset)), Image);

		bar.x = xOffset;
		bar.y = yOffset;

		return bar;
	}

	public function drawEnergy(value:Int, maxValue:Int)
	{
		remove(energyBar);

		energyBar = getBarImage(data.energyBar, 348, 4, 239, 26, value, maxValue, true);

		add(energyBar);
	}

	public function drawHealth(value:Int, maxValue:Int)
	{
		remove(healthBar);

		healthBar = getBarImage(data.healthBar, 13, 4, 239, 26, value, maxValue);

		add(healthBar);
	}

	private function getBarImage(asset:String, xOffset:Int, yOffset:Int, width:Int, height:Int, value:Int, max:Int, reversed:Bool = false):Image
	{
		var length:Int = getBarLength(value, max, width);
		var startOffset:Int = 0;
		var endOffset:Int = length;

		if(reversed)
		{
			startOffset = width - length;
			endOffset = width;
		}

		var bar:Image = new Image(asset, new Rectangle(startOffset, 0, endOffset, height));

		bar.x = xOffset + startOffset;
		bar.y = yOffset;

		return bar;
	}

	private function getBarLength(health:Float, maxHealth:Float, maxLength:Float):Int
	{
		return Std.int(health * maxLength / maxHealth);
	}
}