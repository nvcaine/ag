package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

import entities.Ship;

import model.consts.EntityTypeConsts;

class Pickup extends Entity
{
	private var data:Dynamic;

	public function new(x:Float, y:Float, data:Dynamic)
	{
		super(x, y);

		type = EntityTypeConsts.PICKUP;

		initGraphic(data);

		this.data = data;
	}

	private function initGraphic(data:Dynamic)
	{
		var g:Image = new Image(data.assetPath);

		graphic = g;

		setHitbox(data.width, data.height);
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