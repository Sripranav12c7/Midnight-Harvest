--!strict
--[[
	MiningProgressGui.luau
	Mining hit progress indicator (new in rebuild).
	MILESTONE 7: Full implementation. MILESTONE 1: Stub.
]]

--[[
Expected MiningProgressGui Structure:

MiningProgressGui (ScreenGui)
└── ProgressFrame (Frame)
    ├── OreName (TextLabel) - "Silver Ore"
    ├── ProgressBar (Frame)
    │   └── Fill (Frame) - Scales with progress
    └── HitsText (TextLabel) - "3/6 Hits"
]]

return {}