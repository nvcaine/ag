package org.actors;

import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import flash.events.TimerEvent;
import flash.utils.Timer;

import entities.Ship;

import nme.events.TimerEvent;
import nme.utils.Timer;

import scenes.GameScene;

class Player
{
	private var entity:Ship;
	private var scene:GameScene;
	private var canShoot:Bool;
	private var t:Timer;

	public function new(data:Dynamic, scene:GameScene)
	{
		this.scene = scene;

		initEntity(data);
		initTimer();
		defineInput();
	}

	public function handleInput()
	{
		var xAcc:Int = 0, yAcc:Int = 0;

		if(Input.check("up"))
			yAcc = -5;			

		if(Input.check("down"))
			yAcc = 5;

		if(Input.check("left"))
			xAcc = -5;

		if(Input.check("right"))
			xAcc = 5;

		if(Input.check("shoot") && canShoot)
			shoot();

		entity.setAcceleration(xAcc, yAcc);
	}

	private function initTimer()
	{
		t = new Timer(200);

		t.addEventListener("timer", onTimer);

		canShoot = true;
	}

	private function initEntity(data:Dynamic)
	{
		entity = new Ship(data.x, data.y, data);

		this.scene.add(entity);
	}

	private function defineInput()
	{
		Input.define("up", [Key.UP, Key.W]);
		Input.define("down", [Key.DOWN, Key.S]);
		Input.define("shoot", [Key.X]);
		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
	}

	private function shoot()
	{
		t.start();

		entity.shoot();

		canShoot = false;
	}

	private function onTimer(e:TimerEvent)
	{
		//t.removeEventListener("timer", onTimer); - // should remove the listener, so as not to prevent garbage collection

		canShoot = true;
	}
}