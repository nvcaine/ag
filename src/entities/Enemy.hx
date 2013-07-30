package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.graphics.Image;

import entities.Projectile;

import model.consts.EntityTypeConsts;
import model.dto.EnemyDTO;
import model.events.EntityEvent;
import model.events.HUDEvent;

import nme.Assets;

import org.actors.MessageEntity;

class Enemy extends MessageEntity
{
	private var data:EnemyDTO;

	public function new(x:Float, y:Float, data:EnemyDTO)
	{
		super(x, y);

		this.data = data;

		type = EntityTypeConsts.ENEMY; // don't confuse with data.type (which refers to the type of enemy)

		initGraphic(data);
	}

	override public function moveCollideX(e:Entity):Bool
	{
		sendMessage(new HUDEvent(HUDEvent.ENEMY_COLLISION, 0, data.damage));

		die();

		return true;
	}

	override public function moveCollideY(e:Entity):Bool
	{
		sendMessage(new HUDEvent(HUDEvent.ENEMY_COLLISION, 0, data.damage));

		die();

		return true;
	}

	override public function update()
	{
		if(!visible)
			return;

		super.update();

		moveBy(0, data.speed, EntityTypeConsts.PLAYER);

		checkProjectileCollision([EntityTypeConsts.PROJECTILE]);

		if(data.health <= 0)
		{
			die(true, true);

			dropPickup(100);
		}

		if(x < scene.camera.x - width)
			die(false);
	}

	private function initGraphic(data:EnemyDTO)
	{
		/*var g:Canvas = new Canvas(data.width, data.height);

		g.draw(0, 0, Assets.getBitmapData(data.asset));*/

		var g:Image = new Image(data.asset);

		graphic = g;

		setHitbox(data.width, data.height);
	}

	private function checkProjectileCollision(projectileEntityTypes:Array<String>)
	{
		var entity:Projectile = cast(collideTypes(projectileEntityTypes, x, y), Projectile);

		if(entity != null)
		{
			data.health -= entity.damage;

			return;			
		}
	}

	private function die(explode:Bool = true, score:Bool = false)
	{
		if(explode)
			sendMessage(new EntityEvent(EntityEvent.ENTITY_EXPLOSION, this.x + width / 2, this.y + height / 2));

		if(score)
			sendMessage(new HUDEvent(HUDEvent.KILL_SCORE, data.score));

		graphic = null;

		scene.remove(this);
	}

	private function dropPickup(chance:Float)
	{
		sendMessage(new EntityEvent(EntityEvent.DROP_PICKUP, this.x + width / 2, this.y + height / 2));
	}
}