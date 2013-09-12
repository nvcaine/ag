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
	private var velY:Float = 8.5;
	private var alpha:Float;
	public var size(get_size, null):Float;

	public function new(x:Float, y:Float, velocity:Float, size:Float, alpha:Float)
	{
		super(x, y);

		this.fields = [];
		this.velY = velocity;
		this.size = size;
		this.alpha = alpha;
	}

	private function get_size():Float
	{
		return this.size;
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
		if(y > HXP.height || y < 0 || x < 0 || x > HXP.width)
		{
			scene.remove(this);
			return;
		}

		if(fields.length > 0)
		{
			if(size == 1)
				trace(fields.length);

			var acceleration:Point = getAcceleration();

			if(!Math.isNaN(acceleration.x) && !Math.isNaN(acceleration.y))
			{
				velX += acceleration.x;
				velY += acceleration.y;
			}
		}

		moveBy(velX, velY);
	}

	private function initGraphic()
	{
		var g:Image = Image.createRect(1, 1, 0xFFFFFF, alpha);

		g.scale = size;

		graphic = g;
	}

	private function getAcceleration():Point
	{
		var totalAccX:Float = 0;
		var totalAccY:Float = 0;

		for (field in fields)
		{
			var vectorX:Float = field.positionX - x;
			var vectorY:Float = field.positionY - y;
			var force:Float = field.mass / Math.pow(((vectorX * vectorX) + (vectorY * vectorY) + (field.mass * size)), 1.5); 

			totalAccX += vectorX * force;
			totalAccY += vectorY * force;
		}

		return new Point(totalAccX, totalAccY);
	}
}