package org.actors;

import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import flash.events.TimerEvent;
import flash.utils.Timer;

import entities.game.Ship;

import model.proxy.PlayerProxy;

import nme.events.TimerEvent;
import nme.utils.Timer;

import scenes.GameScene;

class Player
{
	private var entity:Ship;
	private var scene:GameScene;
	private var canShoot:Bool;
	private var regenerateEnergy:Bool;
	private var t:Timer;
	private var et:Timer;

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
			yAcc = -1;			

		if(Input.check("down"))
			yAcc = 1;

		if(Input.check("left"))
			xAcc = -1;

		if(Input.check("right"))
			xAcc = 1;

		if(Input.check("shoot") && canShoot)
			shoot();

		if(regenerateEnergy)
			updateEnergy();

		entity.setAcceleration(xAcc, yAcc);
	}

	private function initTimer()
	{
		t = new Timer(200);

		t.addEventListener("timer", onTimer, false, 0, true);

		canShoot = true;

		et = new Timer(100);
		et.addEventListener("timer", onEnergyTimer, false, 0 , true);
		regenerateEnergy = true;
	}

	private function initEntity(data:Dynamic)
	{
		var newData:Dynamic = data;

		newData.addedStuff = [];

		var hpData:Array<Dynamic> = PlayerProxy.cloneInstance().playerData.shipTemplate.hardpoints;

		for(i in 0...hpData.length)
			if(hpData[i].item != null)
				newData.addedStuff.push({assetPath: hpData[i].item.layerAsset});

		newData.speed = 5;

		entity = new Ship(data.x, data.y, newData);

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
		t.start();

		entity.shoot();

		canShoot = false;
	}

	private function onTimer(e:TimerEvent)
	{
		//t.removeEventListener("timer", onTimer); - // should remove the listener, so as not to prevent garbage collection

		canShoot = true;
	}

	private function updateEnergy()
	{
		// this should be handled by the hud directly

		et.start();

		entity.updateEnergy(PlayerProxy.cloneInstance().playerData.shipTemplate.energyRegen);

		regenerateEnergy = false;
	}

	private function onEnergyTimer(e:TimerEvent)
	{
		regenerateEnergy = true;
	}
}