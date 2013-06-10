package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Ease;
import nme.display.Bitmap;
import nme.Assets;

class Explosion extends Entity
{
	private var e:Emitter;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		initEmitter();
		graphic = e;
	}

	public function explode()
	{
		var i:Int;

		for(i in 0...500)
		{
			e.emit("exp", 32, 32);
		}
			//e.emitInCircle("exp", this.x, this.y, 50);

		var sound = Assets.getSound("sfx/explode.mp3");
		sound.play();
	}

	private function initEmitter()
	{
		//e = new Emitter(new Bitmap(Assets.getBitmapData("gfx/particle.png")), 5, 5);//new BitmapData(5, 5, false, 0xFFFFFF), 5, 5);
		e = new Emitter("gfx/particle.png", 31, 31);

		e.newType("exp", [0]);
		e.setMotion("exp", 0, 100, 0.5, 360, 100, 0.25, Ease.quadOut);
		e.setAlpha("exp", 2, 0.5);
		e.setColor("exp", 0xFFFF77, 0xFF0000, Ease.quadOut);
	}
}