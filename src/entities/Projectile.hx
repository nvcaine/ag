package entities;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

import flash.events.EventDispatcher;

import events.ExplosionEvent;
import events.HUDEvent;

import model.consts.EntityTypeConsts;

class Projectile extends Entity
{
	public var damage(get, null):Int;

	private var dispatcher:EventDispatcher;

	public function new(x:Float, y:Float, d:EventDispatcher, g:Image, damageValue:Int) // a dto will come in handy here
	{
		super(x, y);

		graphic = g;
		setHitbox(16, 4);

		dispatcher = d;

		type = EntityTypeConsts.PROJECTILE;
		damage = damageValue;
	}

	public function get():Int
	{
		return damage;
	}

	override public function moveCollideX(e:Entity):Bool
	{
		scene.remove(this);

		return true;
	}

	override public function update()
	{
		moveBy(10, 0, EntityTypeConsts.ENEMY);

		if(x - scene.camera.x > HXP.width)
		{
			scene.remove(this);
			return;
		}

		super.update();
	}
}