package entities.game.misc;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;//Graphic;

import entities.game.ships.ShipEntity;

import nme.Assets;

import nme.display.BitmapData;

import nme.geom.Point;
import nme.geom.Rectangle;

class Plasma extends Projectile
{
	private var checked:Bool = false;

	override public function update()
	{
		if(!checked)
		{
			checkCollisionTargets(entityTypes, false);
			checked = true;
		}

		fade();
	}

	private function fade()
	{
		var g:Image = cast(graphic, Image);

		g.alpha -= data.fadeRate;

		if(g.alpha <= 0)
			scene.remove(this);
	}

	override private function checkCollision(entityType:String, removeFromScene:Bool = true)
	{
		var targetEntities:Array<ShipEntity> = [];

		collideInto(entityType, this.x, this.y, targetEntities);

		for(ship in targetEntities)
			ship.takeDamage(data.damage);
	}
}