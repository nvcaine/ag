package org.actors;

import com.haxepunk.graphics.Image;

class MessageEntity extends SimpleMessageEntity
{
	private function initGraphic(data:Dynamic)
	{
		setGraphic(data);
		setGraphicHitbox(data);
	}

	private function setGraphic(data:Dynamic)
	{
		if(!data.assetPath || data.assetPath == "")
		{
			trace("MessageEntity.setGraphic: Invalid asset data");

			return;
		}

		graphic = new Image(data.assetPath);
	}

	private function setGraphicHitbox(data:Dynamic)
	{
		if(!data.width || !data.height)
		{
			trace("MessageEntity.setGraphicHitbox: Invalid width/height");

			return;
		}

		setHitbox(data.width, data.height);
	}
}