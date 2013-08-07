package org.ui;

class TooltipButton extends Button
{
	private var tooltip:Tooltip;

	public function new(x:Float, y:Float, image:Dynamic)
	{
		super(x, y, image);
	}

	public function showTooltip()
	{
		tooltip.visible = true;
	}

	private function init()
	{
		tooltip = new Tooltip();

		tooltip.visible = false;
	}
}