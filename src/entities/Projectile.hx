package entities;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.graphics.Image;

import flash.events.EventDispatcher;

import model.events.ExplosionEvent;
import model.events.HUDEvent;
import model.consts.EntityTypeConsts;

import nme.Assets;

class Projectile extends Entity
{
	public var damage(get, null):Int;

	public function new(x:Float, y:Float, data:Dynamic) // a dto will come in handy here
	{
		super(x, y);

		init(data);
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

	private function init(data:Dynamic)
	{
		initGraphic(data);

		type = EntityTypeConsts.PROJECTILE;

		damage = data.damage;

		Assets.getSound(data.sound).play();
	}

	private function initGraphic(data:Dynamic)
	{
		var g:Canvas = new Canvas(data.width, data.height); //g;

		g.draw(0, 0, Assets.getBitmapData(data.assetPath));

		graphic = g;

		setHitbox(data.width, data.height);
	}
}