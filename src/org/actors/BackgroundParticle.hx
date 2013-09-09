package org.actors;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;

import nme.geom.Point;

class BackgroundParticle extends Entity
{
	private var fields:Array<GravityField>;

	private var velX:Float = 0;
	private var velY:Float = 5;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		this.fields = [];
	}

	public function updateFields(fields:Array<GravityField>)
	{
		this.fields = fields;
	}

	override public function added()
	{
		initGraphic();
	}

	override public function update()
	{
		var acceleration:Point = getAcceleration();

		velX += acceleration.x;
		velY += acceleration.y;

		moveBy(velX, velY);

		if(velY < 0.5 && velY > -0.5)
			velY = 5;

		if(y > HXP.height)
			scene.remove(this);

		initGraphic();
	}

	private function initGraphic()
	{
		graphic = new Graphiclist([new Text(Std.string(y) + ": " + Std.string(velY)), Image.createCircle(2, 0xFFFFFF, 0.5)]);
	}

	private function getAcceleration()
	{
		var totalAccX:Float = 0;
		var totalAccY:Float = 0;

		for (field in fields)
		{
			var vectorX:Float = field.positionX - x;
			var vectorY:Float = field.positionY - y;

			var force:Float = field.mass / Math.pow((vectorX * vectorX + vectorY * vectorY + field.mass), 1.5); 

			totalAccX += vectorX * force;
			totalAccY += vectorY * force;
		}

		return new Point(totalAccX, totalAccY);
	}
}