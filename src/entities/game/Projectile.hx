package entities.game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;

import flash.events.EventDispatcher;

import model.events.HUDEvent;
import model.consts.EntityTypeConsts;

import nme.Assets;
import nme.media.SoundTransform;

import org.actors.MessageEntity;

class Projectile extends MessageEntity
{
	public var damage(get, null):Int;

	private var data:Dynamic;

	public function new(x:Float, y:Float, data:Dynamic) // a dto will come in handy here
	{
		super(x, y);

		this.data = data;
	}

	public function get():Int
	{
		return damage;
	}

	override public function added()
	{
		super.added();

		init(data);

		sendMessage(new HUDEvent(HUDEvent.UPDATE_ENERGY, 0, 0, 0, -Std.int(data.energy)));
	}

	override public function moveCollideY(e:Entity):Bool
	{
		scene.remove(this);

		return true;
	}

	override public function update()
	{
		moveBy(0, -10, EntityTypeConsts.ENEMY);

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

		Assets.getSound(data.sound).play(0, 1, new SoundTransform(0.15));
	}
}