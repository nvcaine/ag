package entities.game.misc;

import model.consts.EntityTypeConsts;
import model.consts.LayerConsts;
import model.events.HUDEvent;

import org.actors.MessageEntity;

class Pickup extends MessageEntity
{
	private var data:Dynamic;

	public function new(x:Float, y:Float, data:Dynamic)
	{
		super(x, y);

		type = EntityTypeConsts.PICKUP;

		layer = LayerConsts.MIDDLE;

		initGraphic(data);

		this.data = data;
	}

	override public function update()
	{
		moveBy(0, 3);

		checkPlayerCollision();
	}

	private function checkPlayerCollision()
	{
		if(collideTypes([EntityTypeConsts.PLAYER], x, y) == null)
			return;

		sendMessage(new HUDEvent(HUDEvent.UPDATE_HEALTH, 0, 10));

		scene.remove(this);
	}
}