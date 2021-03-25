-- synlog.moon
-- SFZILabs 2021

Service = setmetatable {}, __index: (K) => game\GetService K

map = (List, Fn) -> [Fn V, I, List for I, V in pairs List]
defaults = (dest, source) ->
	dest[k] = v for k, v in pairs source when dest[k] == nil

Color3 or= fromRGB: (...) -> {...}

RGB = Color3.fromRGB

Enums =
	YAlignment:
		TOP: 0
		BOTTOM: 1

	XAlignment:
		LEFT: 0
		RIGHT: 1

	Colors:
		Red: RGB 255
		Green: RGB 0, 255
		Blue: RGB 0, 0, 255

		Yellow: RGB 255, 255
		Teal: RGB 0, 255, 255
		Magenta: RGB 255, 0, 255
		Orange: RGB 255, 150

		BabyBlue: RGB 100, 143, 200
		InfoBlue: RGB 52, 152, 219
		Mint: RGB 103, 211, 157
		Sublime: RGB 72, 75, 79

		LightRed: RGB 255, 63, 63
		LightGreen: RGB 82, 255, 107
		LightPurple: RGB 128, 101, 201

		Black: RGB!
		White: RGB 255, 255, 255
		Grey: RGB 107, 107, 107
		GreyGrey: RGB 70, 70, 70

isClass = (Class, Value) ->
	if C = Value.__class
		return true if C == Class
		
		if P = Value.__parent
			return isClass Class, P

	false

class Block -- a drawn element
	@isBlock: (T) -> isClass Block, T.__class

	setHeight: (@Height) =>
	setWidth: (@Width) =>

	move: (X, Y) => error 'move not implemented!'

	setObject: (@Object) =>

	make: =>
	destroy: =>
		if @Object
			@Object\Remove!
			@Object = nil

class TextBlock extends Block
	new: (@Text) =>

	make: =>
		@setObject with Drawing.new 'Text'
			.Visible = false
		@setTransparency 1
		@setText @Text
		super!

	setText: (@Text = '') =>
		return unless @Object
		with @Object
			.Text = @Text
			.Color = Color3.new 1, 1, 1
			.Size = 21
			.Font = Drawing.Fonts.Monospace
			.Center = false
			.Outline = true
			@Width = .TextBounds.X
			@Height = .TextBounds.Y

	move: (X, Y) =>
		assert @Object, 'setText called but no object exists!'
		@Object.Position = Vector2.new X, Y

	setSize: (Size) =>
		assert tonumber(Size), 'setSize expects a number!'

	setTransparency: (T) =>
		return unless @Object
		@Object.Visible = T ~= 1
		@Object.Transparency = 1 - T

	__tostring: => @Text

class ColorBlock extends TextBlock
	new: (Text, @Color) =>
		super Text
	
	make: =>
		super!
		@setColor @Color

	setColor: (@Color = Color3.new 1, 1, 1) =>
		@Object.Color = @Color

chalk = (Text, Opts = {}) ->
	setmetatable {}, __index: (K) =>
		assert 'string' == type(K), 'chalk expects a string key!'
		switch K\lower!
			when 'reset'
				return chalk Text, {}
			when 'light'
				Opts.lerp = Enums.Colors.White
				return chalk Text, Opts
			when 'dark'
				Opts.lerp = Enums.Colors.Black
				return chalk Text, Opts
			-- TODO: underline, background, etc

		Color = Enums.Colors[K] or Enums.Colors[K\lower!]
		unless Color
			K = K\lower!
			for C, V in pairs Enums.Colors
				if C\lower! == K
					Color = V
					break
		
		assert Color, 'chalk expects a valid color!'
		if game
			if Opts.lerp
				Color = Color\lerp Opts.lerp, .5
			ColorBlock Text, Color

class Line extends Block -- contains horizontal blocks
	@isLine: (T) -> isClass Line, T
	new: (Blocks = {}, @Options = {}) =>
		defaults @Options,
			Time: 3
			Position: nil

		@Alive = true
		@Blocks = map Blocks, (V) ->
			switch type V
				when 'string', 'number', 'boolean', 'nil', 'function'
					return TextBlock tostring V
				when 'table'
					if Block.isBlock V
						return V

			error 'Line: invalid block type ' .. type V

	getHeight: => -- max of y
		with N = 0
			N = math.max N, B.Height for B in *@Blocks

	getWidth: => -- total
		with N = 0
			N += B.Width for B in *@Blocks

	move: (X, Y) =>
		for B in *@Blocks
			B\move X, Y
			X += B.Width

	make: =>
		B\make! for B in *@Blocks
		@update!

	destroy: =>
		@Alive = false
		B\destroy! for B in *@Blocks
		@Blocks = {}

	setTransparency: (T) =>
		B\setTransparency T for B in *@Blocks

	update: =>
		@Height = @getHeight!
		@Width = @getWidth!

	show: =>
		@Alive = math.random 1, 100
		N = @Alive
		@setTransparency 0
		Updated = [B for B in *@Blocks when B.updater]
		if #Updated > 0
			spawn ->
				while @Alive == N
					B\updater! for B in *Updated
					wait!

	fadeOut: =>
		for i = 1, 3
			t = i/4
			@setTransparency t
			wait!

	__tostring: => table.concat [tostring b for b in *@Blocks], ''

mergestrings = (args) ->
	switch type args
		when 'string'
			args = {args}
		when 'table'
			if Line.isLine args
				args = {args}

	k = #args
	i = 0
	result = {}
	current = ''
	done = ->
		if current
			table.insert result, current
			current = ''

	shift = ->
		i += 1
		T = args[i]
		if 'table' == type T
			if Block.isBlock T
				if current
					current ..= ' '
					done!

				table.insert result, T
				return

		current or= ''
		current ..= ' ' .. tostring T

	while i < k
		shift!
	
	done!

	result

justtext = (result) -> #result == 1 and 'string' == type result[1]

Mouse = nil
if game
	Mouse = Service.Players.LocalPlayer\GetMouse!

class Logger
	:chalk
	YAlignment: Enums.YAlignment
	XAlignment: Enums.XAlignment

	new: (@Options = {}) =>
		defaults @Options,
			YAlignment: @YAlignment.BOTTOM -- setYAlignment
			XAlignment: @XAlignment.LEFT -- setXAlignment
			-- Offset: Vector2.new 8, 8
			MaxLines: 9 -- setMaxLines

			Size: 11
			Font: 'Monospace'

		@Lines = {}
		@Queue = {}
		@Offset = 0

	setMaxLines: (Amount) =>
		assert tonumber(Amount), 'setMaxLines expects a number!'
		@Options.MaxLines = tonumber Amount

	setYAlignment: (Value) =>
		assert Value, 'setYAlignment expects a YAlignment!'
		@Options.YAlignment = Value
		@update!

	setXAlignment: (Value) =>
		assert Value, 'setXAlignment expects a XAlignment!'
		@Options.XAlignment = Value
		@update!

	update: => -- move all lines
		sizeY = Mouse.ViewSizeY
		sizeX = Mouse.ViewSizeX

		height = 0
		-- offset = @Offset
		count = #@Lines
		for i , L in pairs @Lines -- count, 1, -1
			L = @Lines[i]
			L\move 8, 50 + sizeY - 8 - height
			height += L.Height

	addLine: (L) =>
		assert Line.isLine(L), 'addLine expects a Line!'
		table.insert @Queue, L
		@runQueue!

	remove: (L) =>
		for i, v in pairs @Lines
			if v == L
				table.remove @Lines, i
				return

	removeLine: (Next) =>
		if #@Lines + #@Queue < @Options.MaxLines
			Next\fadeOut!

		Next\destroy!
		@remove Next

	showLine: (Next) =>
		assert Line.isLine(Next), 'showLine expects a Line!'

		if Next.Options.Position
			P = math.max 1, Next.Options.Position
			Pos = P -- 1 + #@Lines - P
			table.insert @Lines, Pos, Next
		else table.insert @Lines, 1, Next

		with Next
			\make!
			\show!

		if Next.Options.Time != 0
			spawn ->
				wait Next.Options.Time
				@removeLine Next
				@runQueue!

		@update!
	
	runQueue: =>
		return if @runningQueue
		return if #@Lines >= @Options.MaxLines
		return if @Queue[1] == nil
		@runningQueue = true
		@showLine table.remove @Queue, 1
		@runQueue!
		@runningQueue = false

	startRendering: =>
		return if @rendering
		if game
			Service.RunService\BindToRenderStep 'synlog', 300 + 1, -> @update!
			@rendering = true

	stopRendering: =>
		return unless @rendering
		if game
			Service.RunService\UnbindFromRenderStep 'synlog'
			@rendering = false

	makeLine: (A, ...) => Line mergestrings(A), ...

	print: (...) =>
		args = {...}
		spawn -> @addLine @makeLine args
		wait!

	destroy: =>
		L\destroy! for L in *@Queue
		@Queue = {}

		L\destroy! for L in *@Lines
		@Lines = {}

		@stopRendering!
		@addLine = ->

	error: (...) => @print chalk('  ERROR').LightRed, ...
	warn: (...) => @print chalk('WARNING').Orange, ...
	info: (...) => @print chalk('   INFO').InfoBlue, ...
	success: (...) => @print chalk('SUCCESS').Mint, ...

	logger: =>
		(level, tag, ...) ->
			s = '[' .. tag .. ']'
			fn = switch level
				when 'ERROR' then @error
				when 'WARN' then @warn
				when 'INFO' then @info
				else @print

			fn @, s, ...

class SplitText extends Line
	new: (Text) =>
		super [ColorBlock Text\sub i, i for i = 1, #Text]

	make: =>
		super!
		@Height = @getHeight!
		@Width = @getWidth!

class Rainbow extends SplitText
	new: (Text, @Speed = 1, @Saturation = 255, @Value = 255, @Length = 25) =>
		super Text

	updater: =>
		for i, B in pairs @Blocks
			h = i/@Length + tick!*-@Speed
			B\setColor Color3.fromHSV h % 1, @Saturation/255, @Value/255

Frames = {'/','-','\\','|'}
class Spinner extends ColorBlock
	new: (...) =>
		super ' ', ...
		@Last = 1

	updater: =>
		F = 1 + (math.floor(7*tick!)-1)%4
		if F != @Last
			@Last = F
			@setText Frames[F]

class Metasploit extends ColorBlock
	new: (T, ...) =>
		super T\lower!, ...
		@Last = tick!
		@Len = #T
		@Start = tick!

	updater: =>
		F = 1 + (math.floor(7*(tick!-@Start))-1)%@Len
		if F != @Last
			@Last = F
			T = @Text\sub(0,F-1)\lower! .. @Text\sub(F,F)\upper! .. @Text\sub(F+1)\lower!
			@setText T

if game
	pcall -> SYNLOG\destroy!
	getgenv!.SYNLOG = Logger!
	return SYNLOG
