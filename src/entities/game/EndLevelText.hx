package entities.game;

import com.haxepunk.Entity;
import com.haxepunk.Tween;

import com.haxepunk.graphics.Image;

import com.haxepunk.tweens.motion.LinearPath;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Ease;

import com.haxepunk.tweens.TweenEvent;

import model.events.MenuEvent;

import nme.events.TimerEvent;
import nme.utils.Timer;


import org.events.EventManager;

class EndLevelText extends Entity
{
	private var tween:LinearPath;
	private var alphaTween:VarTween;
	private var timer:Timer;
	private var done:Bool = false;

	public function new(x:Float, y:Float)
	{
		super(x, y);
	}

	override public function added()
	{
		super.added();

		initGraphic();
		initMotion([{x: 0, y: 0}, {x: -70, y: 100}, {x: 70, y: 100}, {x: 0, y: 0}], 3);
		initAlphaTween(cast(graphic, Image), 3);
		initTimer();
	}

	private function initGraphic()
	{
		var image:Image = new Image("gfx/welldone.png");

		image.alpha = 0.1;

		this.graphic = image;
	}

	private function initMotion(waypoints:Array<Dynamic>, duration:Float)
	{
		tween = new LinearPath();

		for(waypoint in waypoints)
			tween.addPoint(waypoint.x + this.x, waypoint.y + this.y);

		tween.setMotion(3);

		this.addTween(tween);
		tween.start();
	}

	private function initAlphaTween(target:Image, duration:Float)
	{
		alphaTween = new VarTween();

		alphaTween.tween(target, "alpha", 1, duration);
		alphaTween.addEventListener(TweenEvent.FINISH, onFinishTween);
		alphaTween.start();
	}

	private function initTimer()
	{
		if(timer == null)
			timer = new Timer(5000, 1);

		timer.addEventListener(TimerEvent.TIMER_COMPLETE, onLevelDoneTimer, false, 0, true);
		timer.start();
	}

	override public function update()
	{
		super.update();

		if(!done)
		{
			this.x = tween.x;
			this.y = tween.y;

			alphaTween.update();

			var g:Image = cast(graphic, Image);

			if(g.alpha == 1)
				alphaTween.dispatchEvent(new TweenEvent(TweenEvent.FINISH));
		}
	}

	private function onLevelDoneTimer(e:TimerEvent)
	{
		timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onLevelDoneTimer);

		EventManager.cloneInstance().dispatchEvent(new MenuEvent(MenuEvent.SHOW_INVENTORY));
	}

	private function onFinishTween(e:TweenEvent)
	{
		done = true;
		alphaTween.removeEventListener(TweenEvent.FINISH, onFinishTween);

		tween.cancel();
		alphaTween.cancel();
	}
}