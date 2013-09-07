package model.proxy;

class ProjectileProxy
{
	public var projectileTemplate:Dynamic;

	private static var instance:ProjectileProxy;

	private function new()
	{
		projectileTemplate = {
			assetPath: "gfx/glontz.png",
			sound: "sfx/laser.mp3",
			width: 20, height: 5,
			damage: 10, energy: 2
		};
	}

	public static function cloneInstance():ProjectileProxy
	{
		if(instance == null)
			instance = new ProjectileProxy();

		return instance;
	}
}