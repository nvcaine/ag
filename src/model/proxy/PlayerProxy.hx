package model.proxy;

class PlayerProxy
{
	public var level:Int = 1;
	public var balance:Int = 0;
	public var experience:Int = 0;
	public var levelLimit:Int = 100;

	private static var instance:PlayerProxy;

	private function new()
	{
		reset();
	}

	public static function cloneInstance():PlayerProxy
	{
		if(instance == null)
			instance = new PlayerProxy();

		return instance;
	}

	public function increaseExperience(amount:Int)
	{
		experience += amount;

		if(experience >= levelLimit)
			levelUp();
	}

	public function increaseBalance(amount:Int)
	{
		balance += amount;
	}

	public function reset()
	{
		level = 1;
		balance = 0;
		experience = 0;
		levelLimit = 100;
	}

	private function levelUp()
	{
		level++;
		levelLimit = level * 100;
		experience = 0;
	}
}