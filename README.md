# WigglyAppendage2D
A node for adding long dynamic appendages like tails, loose ropes and antennas to characters and other moving objects.

These appendages don't use realistic physics, instead they use a simplified approximation of physics that's designed to look good visually and naturally handle a lot of types of movement, including discontinuous movement. They also support being scaled and flipped.

# Parameter descriptions
## `Segment Count`
**How many physically simulated segments the appendage should have.**

**🔴Keep this number as low as possible🔴**, if you need the appendage to be longer or look smoother, use the `Segment Length` and `Subdivision` parameters instead of increasing this number.

## `Segment Length`
**How long each physically simulated segment should be.**

Increase this number to increase the overall length of the tail.

## `Curvature`
**How much the entire appendage should curve.**

Positive numbers will make the appendage curve clockwise.

Negative numbers will make the appendage curve counter-clockwise.

## `Curvature Exponent`
**How much the end of the appendage should curl.**

Positive numbers will curl the end of the appendage.

Negative numbers will straighten the end of the appendage.

A value of 0 will have no effect.

Unless `Curvature` is close to zero, this value should be itself close to zero (you'd rarely want it to be above 1, sometimes even 1 is too big).

## `Max Angle Degrees`
**The maximum angle each physically simulated segment can bend.**

A value of 180 or more will remove any restrictions on much segments can bend.

## `Comeback Speed`
**How big of an impulse should be applied to segments when they reach the maximum bend angle to push them back towards being straight.**

A value of 0 won't apply any impulses.

If `Max Angle Degrees` is set to 180 or more, this parameter will do nothing.

Increase this number if you want the appendage to react faster to sudden changes.

## `Stiffness`
**How stiff the appendage should be.**

This controls how fast the appendage will bend in the way specified by `Curvature` and `Curvature Exponent`

If this value is set to zero, the appendage won't try to bend in the aforementioned way at all (but `Curvature` and `Curvature Exponent` won't be ignored, as they affect `Max Angle Degrees`).

## `Stiffness Decay`
**How much the stiffness should be reduced towards the end of the appendage.**

This value shouldn't be higher than `Stiffness`, it shouldn't even be close.

Negative numbers will make the end of the appendage more stiff.

If `Stiffness` is 0, this parameter will do nothing, unless it's set to a negative number.

## `Stiffness Decay Exponent`
**A parameter to further control the stiffness decay.**

Values above 1 will make the decay more sudden and noticeable.

A value of 1 will do nothing.

Values below 1 will make the decay more gradual and subtle.

A value of 0 will (almost) negate the effects of `Stiffness Decay`.

Values below 0 will reverse the effects of `Stiffness Decay`.

(Values at or below 0 are not recommended)

## `Gravity`
**A vector to determine the direction and strength of gravity.**

## `Damping`
**How fast the appendage stops wiggling.**

Increase this value if the appendage is wiggling too much.

## `Max Angular Momentum`
**How fast the appendage is allowed to spin.**

The default value is good for most cases, you shouldn't need to change it.

## `Subdivision`
**Hou much the physically simulated segments should be subdivided before rendering to achieve a smoother look.**

A value of 0 will disable subdividing.

Don't set this parameter to 1, it looks worse than having it at 0 while still having a performance cost.

## `Additional Start Segment`
**If true, adds a small segment at the start of the appendage to bridge any gaps between it and the object it's supposed to look connected to.**

## `Additional Start Segment Length`
**The length of the segment added by `Additional Start Segment`.**

## `Subdivide Additional Start Segment`
**Whether or not to apply `Subdivision` to the segment added by `Additional Start Segment`.**