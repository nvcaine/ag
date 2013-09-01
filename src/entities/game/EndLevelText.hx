package entities.game;

import com.haxepunk.Entity;
import com.haxepunk.Tween;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.motion.LinearPath;
import com.haxepunk.utils.Ease;

import model.events.MenuEvent;
import nme.events.TimerEvent;
import nme.utils.Timer;

import org.events.EventManager;

class EndLevelText extends Entity
{
	private var tween:LinearPath;
	private var timer:Timer;
	private var started:Bool = true;

	public function new(x:Float, y:Float)
	{
		super(x, y);
	}

	override public function added()
	{
		super.added();

		var image:Image = new Image("gfx/welldone.png");

		tween = new LinearPath();

		tween.addPoint(this.x, this.y);
		tween.addPoint(this.x, this.y + 100);
		tween.addPoint(this.x, this.y);
		tween.setMotion(2);

		this.addTween(tween);

		this.graphic = image;

		if(timer == null)
			timer = new Timer(2000, 1);

		timer.addEventListener(TimerEvent.TIMER_COMPLETE, onLevelDoneTimer);
		timer.start();
	}

	override public function update()
	{
		super.update();

		if(started)
		{
			started = false;
			tween.start();
		}
		else
		{
			this.x = tween.x;
			this.y = tween.y;
		}
	}

	private function onLevelDoneTimer(e:TimerEvent)
	{
		timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onLevelDoneTimer);

		EventManager.cloneInstance().dispatchEvent(new MenuEvent(MenuEvent.SHOW_INVENTORY));
	}
}