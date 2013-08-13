package entities.game;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.graphics.Image;

import entities.game.Projectile;

import model.consts.EntityTypeConsts;
import model.dto.EnemyDTO;
import model.events.EntityEvent;
import model.events.HUDEvent;

import nme.Assets;

import org.actors.MessageEntity;

class Enemy extends MessageEntity
{
	private var data:EnemyDTO;

	public function new(x:Float, y:Float, data:Dynamic)
	{
		super(x, y);

		this.data = new EnemyDTO(data);

		type = EntityTypeConsts.ENEMY; // don't confuse with data.type (which refers to the type of enemy)

		initGraphic(data);
	}

	override public function moveCollideX(e:Entity):Bool
	{
		collideWithPlayer();

		return true;
	}

	override public function moveCollideY(e:Entity):Bool
	{
		collideWithPlayer();

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

	private function checkProjectileCollision(projectileEntityTypes:Array<String>)
	{
		var entity:Projectile = cast(collideTypes(projectileEntityTypes, x, y), Projectile);

		if(entity != null)
		{
			data.health -= entity.damage;

			return;			
		}
	}

	private function collideWithPlayer()
	{
		sendMessage(new HUDEvent(HUDEvent.UPDATE_HEALTH, 0, -data.damage));

		die();
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