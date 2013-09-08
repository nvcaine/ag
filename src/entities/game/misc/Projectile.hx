package entities.game.misc;

import model.consts.EntityTypeConsts;
import model.dto.ProjectileDTO;

import nme.Assets;
import nme.media.SoundTransform;

import org.actors.MessageEntity;

class Projectile extends MessageEntity
{
	public var damage(get, null):Int;

	private var data:ProjectileDTO;

	public function new(x:Float, y:Float, data:ProjectileDTO)
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
		init(data);
	}

	override public function update()
	{
		moveBy(0, -data.speed);

		if(this.y < 0)
			scene.remove(this);
	}

	private function init(data:Dynamic)
	{
		initGraphic(data);

		type = EntityTypeConsts.PROJECTILE;

		damage = data.damage;

		Assets.getSound(data.sound).play(0, 1, new SoundTransform(0.15));
	}
}