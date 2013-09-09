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
	private var velY:Float = 5.5;

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

		if(Math.isNaN(velX) || Math.isNaN(velY) || y > HXP.height || y < 0 || x < 0 || x > HXP.width)
		{
			scene.remove(this);
			return;
		}

		moveBy(velX, velY);

		//initGraphic();
	}

	private function initGraphic()
	{
		graphic = new Graphiclist([/*new Text(Std.string(y) + ": " + Std.string(velY)),*/ Image.createCircle(2, 0xFFFFFF)]);
	}

	private function getAcceleration():Point
	{
		var totalAccX:Float = 0;
		var totalAccY:Float = 0;

		for (field in fields)
		{
			var vectorX:Float = field.positionX - x;
			var vectorY:Float = field.positionY - y;

			var force:Float = field.mass / Math.pow((vectorX * vectorX + field.mass / 2 + vectorY * vectorY + field.mass / 2), 1.5); 

			//if(Math.isNaN(force))
				//trace("(" + field.positionX + " - " + x + ")" + "(" + field.positionY + " - " + y + ")");

			totalAccX += vectorX * force;
			totalAccY += vectorY * force;
		}

		return new Point(totalAccX, totalAccY);
	}
}