package org.actors;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import entities.game.ships.PlayerShip;

import model.events.HUDEvent;

import model.proxy.PlayerProxy;
import model.proxy.ProjectileProxy;

import nme.events.TimerEvent;
import nme.utils.Timer;

import org.events.EventManager;

import scenes.GameScene;

class Player
{
	private var entity:PlayerShip;
	private var scene:GameScene;

	private var shootTimer:Float = 0.25;

	private var em:EventManager;

	public function new(data:Dynamic, scene:GameScene)
	{
		this.scene = scene;

		initEntity(data);
		defineInput();

		em = EventManager.cloneInstance();
	}

	public function handleInput()
	{
		var xAcc:Int = 0, yAcc:Int = 0;

		if(Input.check("up"))
			yAcc = -1;			

		if(Input.check("down"))
			yAcc = 1;

		if(Input.check("left"))
			xAcc = -1;

		if(Input.check("right"))
			xAcc = 1;

		if(Input.check("shoot") && shootTimer < 0)
			shoot();

		entity.setAcceleration(xAcc, yAcc);
		shootTimer -= HXP.elapsed;
	}

	private function initEntity(data:Dynamic)
	{
		entity = new PlayerShip(data.x, data.y, PlayerProxy.cloneInstance().playerData.shipTemplate);
		entity.layer = 0;

		this.scene.add(entity);
	}

	private function defineInput()
	{
		Input.define("up", [Key.UP, Key.W]);
		Input.define("down", [Key.DOWN, Key.S]);
		Input.define("shoot", [Key.X]);
		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("regen", [Key.Z]);
	}

	private function shoot()
	{
		entity.shoot(ProjectileProxy.cloneInstance().projectileTemplate, PlayerProxy.cloneInstance().getAvailableEnergy(), 10);

		shootTimer = 0.25;
	}
}