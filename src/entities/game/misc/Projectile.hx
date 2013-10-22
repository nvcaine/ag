package entities.game.misc;

import model.consts.EntityTypeConsts;
import model.consts.LayerConsts;
import model.dto.ProjectileDTO;

import nme.Assets;
import nme.media.SoundTransform;

import org.actors.MessageEntity;
import org.actors.GravityField;

class Projectile extends MessageEntity
{
	public var gravityField:GravityField;

	public var damage(get, null):Int;

	private var data:ProjectileDTO;

	public function new(x:Float, y:Float, data:ProjectileDTO)
	{
		super(x, y);

		this.data = data;

		layer = LayerConsts.MIDDLE;

		gravityField = new GravityField();
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

		gravityField.positionX = x;
		gravityField.positionY = y;

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