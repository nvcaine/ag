package entities.game;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

import model.consts.EntityTypeConsts;
import model.consts.PlayerConsts;
import model.events.HUDEvent;

import nme.geom.Point;

class BossEnemy extends Enemy
{
	private var dir:Int = 1;

	override public function update()
	{
		super.update();

		//moveBy(0, dir);
		x += dir;

		if(x > HXP.width - 128 && dir == 1)
			dir = -1;
		else
			if(x < 0)
				dir = 1;
	}
}