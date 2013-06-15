package model.dto;

// will extend an abstract dto
class EnemyDTO
{
	public var type:String;
	public var health:Int;
	public var damage:Int;
	public var score:Int;

	public function new(data:Dynamic = null)
	{
		if(data)
			parse(data);
	}

	// abstract method
	private function parse(data:Dynamic)
	{
		var fields:Array<String> = Reflect.fields(data);

		for(i in 0...fields.length)
			if(Reflect.hasField(this, fields[i]))
				Reflect.setField(this, fields[i], Reflect.field(data, fields[i]));

//		trace(this.type + " " + this.damage + " " + this.health);
	}
}