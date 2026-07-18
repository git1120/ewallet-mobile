# Motion and haptics

Use `IbaMotion` durations and restrained transitions that clarify hierarchy or
state. Respect `MediaQuery.disableAnimationsOf(context)` and ensure the final
state is understandable with zero animation. Avoid looping motion except
purposeful loading/skeleton feedback, and stop controllers when disabled or
disposed.

Haptics may acknowledge a tap or reinforce a server-confirmed result. They must
not communicate the only error/success signal or imply that a pending/unknown
financial operation succeeded. Introduce platform haptics through a testable
abstraction when business UI requires them.
