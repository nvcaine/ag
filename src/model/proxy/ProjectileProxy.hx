package model.proxy;

import model.dto.ProjectileDTO;

class ProjectileProxy
{
	public var projectileTemplates:Array<ProjectileDTO>;

	private static var instance:ProjectileProxy;

	private function new()
	{
		projectileTemplates = [
			new ProjectileDTO({
				assetPath: "gfx/glontz.png", sound: "sfx/laser.mp3",
				width: 6, height: 12, speed: 10
			}),

			new ProjectileDTO({
				assetPath: "gfx/glontz2.png", sound: "sfx/laser1.mp3",
				width: 6, height: 15, speed: 10
			}),
		];
	}

	public static function cloneInstance():ProjectileProxy
	{
		if(instance == null)
			instance = new ProjectileProxy();

		return instance;
	}
}