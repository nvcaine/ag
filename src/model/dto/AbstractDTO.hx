package model.dto;

class AbstractDTO
{
	public function new(data:Dynamic = null)
	{
		if(data)
			parse(data);
	}

	private function parse(data:Dynamic)
	{
		var fields:Array<String> = Reflect.fields(data);

		for(i in 0...fields.length)
			if(Reflect.hasField(this, fields[i]))
				Reflect.setField(this, fields[i], Reflect.field(data, fields[i]));
	}
}