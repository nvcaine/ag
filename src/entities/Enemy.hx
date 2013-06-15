package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

import entities.Projectile;

import model.consts.EntityTypeConsts;
import model.dto.EnemyDTO;
import model.events.ExplosionEvent;
import model.events.HUDEvent;

import org.actors.MessageEntity;


class Enemy extends MessageEntity
{
	private var data:EnemyDTO;

	public function new(g:Image, x:Float, y:Float)
	{
		super(x, y);

		graphic = g;
		setHitbox(32, 32);

		data = new EnemyDTO({type: "asd", health: 200, damage: 5, score: 5});

		type = EntityTypeConsts.ENEMY;
	}

	override public function moveCollideX(e:Entity):Bool
	{
		sendMessage(new HUDEvent(HUDEvent.ENEMY_COLLISION, 0, data.damage));

		die();

		return true;
	}

	public override function update()
	{
		moveBy(-2, 0, EntityTypeConsts.PLAYER);

		super.update();

		checkProjectileCollision([EntityTypeConsts.PROJECTILE]);

		if(data.health <= 0)
			die(true, true);

		if(x < scene.camera.x - width)
			die(false);
	}

	private function checkProjectileCollision(projectileEntityTypes:Array<String>)
	{
		var bullet:Projectile = cast(collideTypes(projectileEntityTypes, x, y), Projectile);

		if(bullet != null)
			data.health -= bullet.damage;
	}

	private function die(explode:Bool = true, score:Bool = false)
	{
		if(explode)
			sendMessage(new ExplosionEvent("explode", this.x - 16, this.y - 16));

		if(score)
			sendMessage(new HUDEvent(HUDEvent.KILL_SCORE, data.score));

		scene.remove(this);
	}
}