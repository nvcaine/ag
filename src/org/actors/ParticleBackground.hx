package org.actors;

import com.haxepunk.Entity;
import com.haxepunk.HXP;

import entities.game.misc.Projectile;

class ParticleBackground extends Entity
{
	private var spawnDelay:Float;
	private var spawnTimer:Float = 0;
	private var velocity:Float;
	private var size:Int;

	public function new(spawnDelay:Float, velocity:Float, size:Int)
	{
		super(0, 0);

		this.spawnDelay = spawnDelay;
		this.velocity = velocity;
		this.size = size;
	}

	override public function update()
	{
		spawnTimer -= HXP.elapsed;

		updateFields(getUpdateFields());

		if(spawnTimer < 0)
		{
			spawnTimer = spawnDelay;
			spawn();
		}
	}

	private function spawn()
	{
		var randX:Int = Std.random(HXP.width - 3) + 3;

		scene.add(new BackgroundParticle(randX, 0, velocity, size));
	}

	private function getUpdateFields():Array<GravityField>
	{
		var entities:Array<Projectile> = [];
		var fields:Array<GravityField> = [];

		scene.getClass(Projectile, entities);

		for(e in entities)
			fields.push(e.gravityField);

		return fields;
	}

	private function updateFields(fields:Array<GravityField>)
	{
		var particles:Array<BackgroundParticle> = [];

		scene.getClass(BackgroundParticle, particles);

		for(particle in particles)
			particle.updateFields(fields);
	}
}