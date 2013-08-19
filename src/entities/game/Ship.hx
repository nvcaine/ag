package entities.game;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;

import model.consts.EntityTypeConsts;
import model.consts.PlayerConsts;
import model.events.HUDEvent;

import nme.geom.Point;

import org.actors.MessageEntity;

class Ship extends MessageEntity
{
	private var velocity:Point;
	private var yAcceleration:Int;
	private var xAcceleration:Int;

	public function new(x:Float, y:Float, data:Dynamic)
	{
		super(x, y);

		init(data);
	}

	override public function update()
	{
		super.update();

		moveVertically();
		moveHorizontally();

		moveBy(velocity.x, -PlayerConsts.DEFAULT_SPEED - velocity.y, EntityTypeConsts.LEVEL);
	}

	override public function moveCollideX(e:Entity):Bool
	{
		onLevelCollision();

		return true;
	}

	override public function moveCollideY(e:Entity):Bool
	{
		onLevelCollision();

		return true;
	}

	public function setAcceleration(xAcc:Int, yAcc:Int)
	{
		xAcceleration = xAcc;
		yAcceleration = yAcc;
	}

	public function shoot()
	{
		scene.add(createNewProjectile(x + width / 2 - 40, y + 10));
		scene.add(createNewProjectile(x + width / 2 + 40, y + 10));
	}

	public function applyBuff(data:Dynamic)
	{
		sendMessage(new HUDEvent(HUDEvent.UPDATE_HEALTH, 1, 10));
	}

	private function createNewProjectile(x:Float, y:Float):Projectile
	{
		var data:Dynamic = {assetPath: "gfx/glontz.png", sound: "sfx/laser.mp3", width: 20, height: 5, damage: 50};

		return new Projectile(x, y, data);
	}

	override private function initGraphic(data:Dynamic)
	{
		var layers:Array<Image> = [];
		var g:Graphiclist = new Graphiclist();

		if(data.addedStuff != null)
			for(i in 0...data.addedStuff.length)
				layers.push(new Image(data.addedStuff[i].assetPath));

		layers.push(new Image(data.assetPath));

		graphic = new Graphiclist(layers);

		setGraphicHitbox(data);
	}

	private function init(data:Dynamic)
	{
		type = EntityTypeConsts.PLAYER;

		initGraphic(data);

		velocity = new Point(0, 0);
	}

	private function onLevelCollision()
	{
		//sendMessage(new HUDEvent(HUDEvent.ENEMY_COLLISION));
	}

	// DO NOT manipulate x/y directly
	private function moveVertically()
	{
		y += yAcceleration;

		if(y < scene.camera.y)
			y = scene.camera.y;

		if(y > scene.camera.y + HXP.height - height)
			y = scene.camera.y + HXP.height - height;
	}

	private function moveHorizontally()
	{
		x += xAcceleration;

		if(x < 0)
			x = 0;

		if(x > HXP.width - width)
			x = HXP.width - width;
	}
}