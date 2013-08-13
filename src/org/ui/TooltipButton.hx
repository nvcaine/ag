package org.ui;

import org.consts.TooltipPositionConsts;

import nme.events.MouseEvent;
import nme.geom.Point;

class TooltipButton extends Button
{
	private var tooltip:Tooltip;

	public function new(x:Float, y:Float, data:Dynamic)
	{
		super(x, y, data);

		init();
	}

	override public function added()
	{
		super.added();

		tooltip = new Tooltip(x, y);
		tooltip.visible = false;

		scene.add(tooltip);
	}

	public function setTooltipText(text:String)
	{
		tooltip.setText(text);
	}

	public function showTooltip(position:String = TooltipPositionConsts.RIGHT)
	{
		var ttPos:Point = getTooltipPosition(position);

		tooltip.x = ttPos.x;
		tooltip.y = ttPos.y;

		tooltip.visible = true;
	}

	private function init()
	{
		this.addListener(MouseEvent.MOUSE_OVER, onMouseOver);
		this.addListener(MouseEvent.MOUSE_OUT, onMouseOut);
	}

	private function getTooltipPosition(position:String):Point
	{
		if(position == TooltipPositionConsts.TOP)
			return new Point(x + width / 2 - tooltip.width / 2, y - tooltip.height);

		if(position == TooltipPositionConsts.LEFT)
			return new Point(x - tooltip.width, y + height / 2 - tooltip.height / 2);

		if(position == TooltipPositionConsts.BOTTOM)
			return new Point(x + width / 2 - tooltip.width / 2, y + height);

		return new Point(x + width, y + height / 2 - tooltip.height / 2);
	}

	override private function onMouseOver(e:MouseEvent)
	{
		showTooltip(TooltipPositionConsts.TOP);
	}

	override private function onMouseOut(e:MouseEvent)
	{
		tooltip.visible = false;
	}
}