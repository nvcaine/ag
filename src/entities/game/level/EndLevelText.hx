package entities.game.level;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.motion.LinearPath;
import com.haxepunk.tweens.misc.VarTween;

import model.consts.LayerConsts;

class EndLevelText extends Entity
{
	private var tween:LinearPath;
	private var alphaTween:VarTween;
	private var done:Bool = false;
	private var data:Dynamic;

	public function new(x:Float, y:Float, data:Dynamic)
	{
		super(x, y);

		layer = cast((LayerConsts.TOP + data.layer), Int);

		this.data = data;
	}

	override public function added()
	{
		initGraphic();
		initMotion(data.path, data.duration);
		initAlphaTween(graphic, data.duration);
	}

	override public function update()
	{
		if(done)
			return;

		this.x = tween.x;
		this.y = tween.y;

		tween.update();
		alphaTween.update();
	}

	private function initGraphic()
	{
		var image:Image = new Image(data.assetPath);

		image.alpha = 0.1;

		this.graphic = image;
	}

	private function initMotion(waypoints:Array<Dynamic>, duration:Float)
	{
		tween = new LinearPath();

		for(waypoint in waypoints)
			tween.addPoint(waypoint.x + this.x, waypoint.y + this.y);

		tween.setMotion(duration);

		this.addTween(tween);
		tween.start();
	}

	private function initAlphaTween(target:Dynamic, duration:Float)
	{
		alphaTween = new VarTween(onFinishTween);

		alphaTween.tween(target, "alpha", 1, duration + 3);
		alphaTween.start();
	}

	private function onFinishTween(_):Void
	{
		done = true;

		tween.cancel();
		alphaTween.cancel();
	}
}