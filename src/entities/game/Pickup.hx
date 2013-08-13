package entities.game;

//import com.haxepunk.Entity;
//import com.haxepunk.graphics.Image;

import entities.game.Ship;

import model.consts.EntityTypeConsts;

import org.actors.MessageEntity;

class Pickup extends MessageEntity
{
	private var data:Dynamic;

	public function new(x:Float, y:Float, data:Dynamic)
	{
		super(x, y);

		type = EntityTypeConsts.PICKUP;

		initGraphic(data);

		this.data = data;
	}

	override public function update()
	{
		super.update();

		checkPlayerCollision();
	}

	private function checkPlayerCollision()
	{
		var playerEntity:Ship = cast(collideTypes([EntityTypeConsts.PLAYER], x, y), Ship);

		if(playerEntity == null)
			return;

		playerEntity.applyBuff(this.data);
		scene.remove(this);
	}
}