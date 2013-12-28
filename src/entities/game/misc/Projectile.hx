package entities.game.misc;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

import entities.game.ships.ShipEntity;

import model.consts.EntityTypeConsts;
import model.consts.LayerConsts;
import model.dto.ProjectileDTO;

import nme.Assets;
import nme.media.SoundTransform;

import org.actors.MessageEntity;
//import org.actors.GravityField;

class Projectile extends MessageEntity
{
	//public var gravityField:GravityField;

	private var data:ProjectileDTO;

	private var flipped:Bool;

	private var entityTypes:Array<String>;

	public function new(x:Float, y:Float, data:ProjectileDTO, isFlipped:Bool = false, entityTypes:Array<String> = null)
	{
		super(x, y);

		this.data = data;
		layer = LayerConsts.MIDDLE;
		this.flipped = isFlipped;

		this.entityTypes = entityTypes;

		//gravityField = new GravityField();
	}

	override public function added()
	{
		init(data);

		if(flipped)
			flipGraphic();
	}

	override public function update()
	{
		moveBy(0, getSpeed());

		//gravityField.positionX = x;
		//gravityField.positionY = y;

		if(this.y < 0 || this.y > HXP.height)
			scene.remove(this);

		checkCollisionTargets(entityTypes);
	}

	private function init(data:Dynamic)
	{
		initGraphic(data);
		
		type = EntityTypeConsts.PROJECTILE;

		//Assets.getSound(data.sound).play(0, 1, new SoundTransform(0.15));
	}

	private function getSpeed():Float
	{
		if(flipped == true)
			return data.speed;

		return -data.speed;
	}

	private function checkCollisionTargets(entityTypes:Array<String>, removeFromScene:Bool = true)
	{
		for(type in entityTypes)
			checkCollision(type, removeFromScene);
	}

	private function checkCollision(entityType:String, removeFromScene:Bool = true)
	{
		onEnemyCollision(collide(entityType, this.x, this.y));
	}

	private function onEnemyCollision(enemy:Entity, removeFromScene:Bool = false)
	{
		if(enemy == null)
			return;
	
		var entity:ShipEntity = cast(enemy, ShipEntity); // this will potentially exclude "ground" elements - collideTypes might work better

		entity.takeDamage(data.damage);

		if(removeFromScene)
			scene.remove(this);
	}
}