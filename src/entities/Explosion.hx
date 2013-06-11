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

		for(i in 0...200)
			e.emit("exp", 32, 32);

		for(i in 0...200)
			e.emit("exp2", 32, 32);

		for(i in 0...100)
			e.emit("exp3", 32, 32);
		
			//e.emitInCircle("exp", this.x, this.y, 50);

		var sound = Assets.getSound("sfx/explode.mp3");
		sound.play();
	}

	private function initEmitter()
	{
		//e = new Emitter(new Bitmap(Assets.getBitmapData("gfx/particle.png")), 5, 5);//new BitmapData(5, 5, false, 0xFFFFFF), 5, 5);
		e = new Emitter("gfx/particle.png", 31, 31);

		// outter ring
		e.newType("exp", [0]);
		e.setMotion("exp", 0, 200, 0.5, 360, 10, 0.5, Ease.quadOut);
		e.setAlpha("exp", 1, 0.15);
		e.setColor("exp", 0x40ECF5, 0x2AA6DB, Ease.quadOut);

		// mid-flame
		e.newType("exp2", [0]);
		e.setMotion("exp2", 0, 50, 0.5, 360, 100, 0.5, Ease.quadOut);
		e.setAlpha("exp2", 2, 0.5);
		e.setColor("exp2", 0xFFFB7D, 0xFF5917, Ease.quadOut);

		// inner sparks
		e.newType("exp3", [0]);
		e.setMotion("exp3", 0, 25, 1, 360, 50, 1, Ease.quadOut);
		e.setAlpha("exp3", 2, 0.05);
		e.setColor("exp3", 0xFFFF77, 0xFF0000, Ease.quadOut);
	}
}