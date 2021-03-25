local Service = setmetatable({ }, {
  __index = function(self, K)
    return game:GetService(K)
  end
})
local map
map = function(List, Fn)
  local _accum_0 = { }
  local _len_0 = 1
  for I, V in pairs(List) do
    _accum_0[_len_0] = Fn(V, I, List)
    _len_0 = _len_0 + 1
  end
  return _accum_0
end
local defaults
defaults = function(dest, source)
  for k, v in pairs(source) do
    if dest[k] == nil then
      dest[k] = v
    end
  end
end
local Color3 = Color3 or {
  fromRGB = function(...)
    return {
      ...
    }
  end
}
local RGB = Color3.fromRGB
local Enums = {
  YAlignment = {
    TOP = 0,
    BOTTOM = 1
  },
  XAlignment = {
    LEFT = 0,
    RIGHT = 1
  },
  Colors = {
    Red = RGB(255),
    Green = RGB(0, 255),
    Blue = RGB(0, 0, 255),
    Yellow = RGB(255, 255),
    Teal = RGB(0, 255, 255),
    Magenta = RGB(255, 0, 255),
    Orange = RGB(255, 150),
    BabyBlue = RGB(100, 143, 200),
    InfoBlue = RGB(52, 152, 219),
    Mint = RGB(103, 211, 157),
    Sublime = RGB(72, 75, 79),
    LightRed = RGB(255, 63, 63),
    LightGreen = RGB(82, 255, 107),
    LightPurple = RGB(128, 101, 201),
    Black = RGB(),
    White = RGB(255, 255, 255),
    Grey = RGB(107, 107, 107),
    GreyGrey = RGB(70, 70, 70)
  }
}
local isClass
isClass = function(Class, Value)
  do
    local C = Value.__class
    if C then
      if C == Class then
        return true
      end
      do
        local P = Value.__parent
        if P then
          return isClass(Class, P)
        end
      end
    end
  end
  return false
end
local Block
do
  local _class_0
  local _base_0 = {
    setHeight = function(self, Height)
      self.Height = Height
    end,
    setWidth = function(self, Width)
      self.Width = Width
    end,
    move = function(self, X, Y)
      return error('move not implemented!')
    end,
    setObject = function(self, Object)
      self.Object = Object
    end,
    make = function(self) end,
    destroy = function(self)
      if self.Object then
        self.Object:Remove()
        self.Object = nil
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "Block"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.isBlock = function(T)
    return isClass(Block, T.__class)
  end
  Block = _class_0
end
local TextBlock
do
  local _class_0
  local _parent_0 = Block
  local _base_0 = {
    make = function(self)
      self:setObject((function()
        do
          local _with_0 = Drawing.new('Text')
          _with_0.Visible = false
          return _with_0
        end
      end)())
      self:setTransparency(1)
      self:setText(self.Text)
      return _class_0.__parent.__base.make(self)
    end,
    setText = function(self, Text)
      if Text == nil then
        Text = ''
      end
      self.Text = Text
      if not (self.Object) then
        return 
      end
      do
        local _with_0 = self.Object
        _with_0.Text = self.Text
        _with_0.Color = Color3.new(1, 1, 1)
        _with_0.Size = 21
        _with_0.Font = Drawing.Fonts.Monospace
        _with_0.Center = false
        _with_0.Outline = true
        self.Width = _with_0.TextBounds.X
        self.Height = _with_0.TextBounds.Y
        return _with_0
      end
    end,
    move = function(self, X, Y)
      assert(self.Object, 'setText called but no object exists!')
      self.Object.Position = Vector2.new(X, Y)
    end,
    setSize = function(self, Size)
      return assert(tonumber(Size), 'setSize expects a number!')
    end,
    setTransparency = function(self, T)
      if not (self.Object) then
        return 
      end
      self.Object.Visible = T ~= 1
      self.Object.Transparency = 1 - T
    end,
    __tostring = function(self)
      return self.Text
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, Text)
      self.Text = Text
    end,
    __base = _base_0,
    __name = "TextBlock",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  TextBlock = _class_0
end
local ColorBlock
do
  local _class_0
  local _parent_0 = TextBlock
  local _base_0 = {
    make = function(self)
      _class_0.__parent.__base.make(self)
      return self:setColor(self.Color)
    end,
    setColor = function(self, Color)
      if Color == nil then
        Color = Color3.new(1, 1, 1)
      end
      self.Color = Color
      self.Object.Color = self.Color
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, Text, Color)
      self.Color = Color
      return _class_0.__parent.__init(self, Text)
    end,
    __base = _base_0,
    __name = "ColorBlock",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  ColorBlock = _class_0
end
local chalk
chalk = function(Text, Opts)
  if Opts == nil then
    Opts = { }
  end
  return setmetatable({ }, {
    __index = function(self, K)
      assert('string' == type(K), 'chalk expects a string key!')
      local _exp_0 = K:lower()
      if 'reset' == _exp_0 then
        return chalk(Text, { })
      elseif 'light' == _exp_0 then
        Opts.lerp = Enums.Colors.White
        return chalk(Text, Opts)
      elseif 'dark' == _exp_0 then
        Opts.lerp = Enums.Colors.Black
        return chalk(Text, Opts)
      end
      local Color = Enums.Colors[K] or Enums.Colors[K:lower()]
      if not (Color) then
        K = K:lower()
        for C, V in pairs(Enums.Colors) do
          if C:lower() == K then
            Color = V
            break
          end
        end
      end
      assert(Color, 'chalk expects a valid color!')
      if game then
        if Opts.lerp then
          Color = Color:lerp(Opts.lerp, .5)
        end
        return ColorBlock(Text, Color)
      end
    end
  })
end
local Line
do
  local _class_0
  local _parent_0 = Block
  local _base_0 = {
    getHeight = function(self)
      do
        local N = 0
        local _list_0 = self.Blocks
        for _index_0 = 1, #_list_0 do
          local B = _list_0[_index_0]
          N = math.max(N, B.Height)
        end
        return N
      end
    end,
    getWidth = function(self)
      do
        local N = 0
        local _list_0 = self.Blocks
        for _index_0 = 1, #_list_0 do
          local B = _list_0[_index_0]
          N = N + B.Width
        end
        return N
      end
    end,
    move = function(self, X, Y)
      local _list_0 = self.Blocks
      for _index_0 = 1, #_list_0 do
        local B = _list_0[_index_0]
        B:move(X, Y)
        X = X + B.Width
      end
    end,
    make = function(self)
      local _list_0 = self.Blocks
      for _index_0 = 1, #_list_0 do
        local B = _list_0[_index_0]
        B:make()
      end
      return self:update()
    end,
    destroy = function(self)
      self.Alive = false
      local _list_0 = self.Blocks
      for _index_0 = 1, #_list_0 do
        local B = _list_0[_index_0]
        B:destroy()
      end
      self.Blocks = { }
    end,
    setTransparency = function(self, T)
      local _list_0 = self.Blocks
      for _index_0 = 1, #_list_0 do
        local B = _list_0[_index_0]
        B:setTransparency(T)
      end
    end,
    update = function(self)
      self.Height = self:getHeight()
      self.Width = self:getWidth()
    end,
    show = function(self)
      self.Alive = math.random(1, 100)
      local N = self.Alive
      self:setTransparency(0)
      local Updated
      do
        local _accum_0 = { }
        local _len_0 = 1
        local _list_0 = self.Blocks
        for _index_0 = 1, #_list_0 do
          local B = _list_0[_index_0]
          if B.updater then
            _accum_0[_len_0] = B
            _len_0 = _len_0 + 1
          end
        end
        Updated = _accum_0
      end
      if #Updated > 0 then
        return spawn(function()
          while self.Alive == N do
            for _index_0 = 1, #Updated do
              local B = Updated[_index_0]
              B:updater()
            end
            wait()
          end
        end)
      end
    end,
    fadeOut = function(self)
      for i = 1, 3 do
        local t = i / 4
        self:setTransparency(t)
        wait()
      end
    end,
    __tostring = function(self)
      return table.concat((function()
        local _accum_0 = { }
        local _len_0 = 1
        local _list_0 = self.Blocks
        for _index_0 = 1, #_list_0 do
          local b = _list_0[_index_0]
          _accum_0[_len_0] = tostring(b)
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)(), '')
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, Blocks, Options)
      if Blocks == nil then
        Blocks = { }
      end
      if Options == nil then
        Options = { }
      end
      self.Options = Options
      defaults(self.Options, {
        Time = 3,
        Position = nil
      })
      self.Alive = true
      self.Blocks = map(Blocks, function(V)
        local _exp_0 = type(V)
        if 'string' == _exp_0 or 'number' == _exp_0 or 'boolean' == _exp_0 or 'nil' == _exp_0 or 'function' == _exp_0 then
          return TextBlock(tostring(V))
        elseif 'table' == _exp_0 then
          if Block.isBlock(V) then
            return V
          end
        end
        return error('Line: invalid block type ' .. type(V))
      end)
    end,
    __base = _base_0,
    __name = "Line",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.isLine = function(T)
    return isClass(Line, T)
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Line = _class_0
end
local mergestrings
mergestrings = function(args)
  local _exp_0 = type(args)
  if 'string' == _exp_0 then
    args = {
      args
    }
  elseif 'table' == _exp_0 then
    if Line.isLine(args) then
      args = {
        args
      }
    end
  end
  local k = #args
  local i = 0
  local result = { }
  local current = ''
  local done
  done = function()
    if current then
      table.insert(result, current)
      current = ''
    end
  end
  local shift
  shift = function()
    i = i + 1
    local T = args[i]
    if 'table' == type(T) then
      if Block.isBlock(T) then
        if current then
          current = current .. ' '
          done()
        end
        table.insert(result, T)
        return 
      end
    end
    current = current or ''
    current = current .. (' ' .. tostring(T))
  end
  while i < k do
    shift()
  end
  done()
  return result
end
local justtext
justtext = function(result)
  return #result == 1 and 'string' == type(result[1])
end
local Mouse = nil
if game then
  Mouse = Service.Players.LocalPlayer:GetMouse()
end
local Logger
do
  local _class_0
  local _base_0 = {
    chalk = chalk,
    YAlignment = Enums.YAlignment,
    XAlignment = Enums.XAlignment,
    setMaxLines = function(self, Amount)
      assert(tonumber(Amount), 'setMaxLines expects a number!')
      self.Options.MaxLines = tonumber(Amount)
    end,
    setYAlignment = function(self, Value)
      assert(Value, 'setYAlignment expects a YAlignment!')
      self.Options.YAlignment = Value
      return self:update()
    end,
    setXAlignment = function(self, Value)
      assert(Value, 'setXAlignment expects a XAlignment!')
      self.Options.XAlignment = Value
      return self:update()
    end,
    update = function(self)
      local sizeY = Mouse.ViewSizeY
      local sizeX = Mouse.ViewSizeX
      local height = 0
      local count = #self.Lines
      for i, L in pairs(self.Lines) do
        L = self.Lines[i]
        L:move(8, 50 + sizeY - 8 - height)
        height = height + L.Height
      end
    end,
    addLine = function(self, L)
      assert(Line.isLine(L), 'addLine expects a Line!')
      table.insert(self.Queue, L)
      return self:runQueue()
    end,
    remove = function(self, L)
      for i, v in pairs(self.Lines) do
        if v == L then
          table.remove(self.Lines, i)
          return 
        end
      end
    end,
    removeLine = function(self, Next)
      if #self.Lines + #self.Queue < self.Options.MaxLines then
        Next:fadeOut()
      end
      Next:destroy()
      return self:remove(Next)
    end,
    showLine = function(self, Next)
      assert(Line.isLine(Next), 'showLine expects a Line!')
      if Next.Options.Position then
        local P = math.max(1, Next.Options.Position)
        local Pos = P
        table.insert(self.Lines, Pos, Next)
      else
        table.insert(self.Lines, 1, Next)
      end
      do
        Next:make()
        Next:show()
      end
      if Next.Options.Time ~= 0 then
        spawn(function()
          wait(Next.Options.Time)
          self:removeLine(Next)
          return self:runQueue()
        end)
      end
      return self:update()
    end,
    runQueue = function(self)
      if self.runningQueue then
        return 
      end
      if #self.Lines >= self.Options.MaxLines then
        return 
      end
      if self.Queue[1] == nil then
        return 
      end
      self.runningQueue = true
      self:showLine(table.remove(self.Queue, 1))
      self:runQueue()
      self.runningQueue = false
    end,
    startRendering = function(self)
      if self.rendering then
        return 
      end
      if game then
        Service.RunService:BindToRenderStep('synlog', 300 + 1, function()
          return self:update()
        end)
        self.rendering = true
      end
    end,
    stopRendering = function(self)
      if not (self.rendering) then
        return 
      end
      if game then
        Service.RunService:UnbindFromRenderStep('synlog')
        self.rendering = false
      end
    end,
    makeLine = function(self, A, ...)
      return Line(mergestrings(A), ...)
    end,
    print = function(self, ...)
      local args = {
        ...
      }
      spawn(function()
        return self:addLine(self:makeLine(args))
      end)
      return wait()
    end,
    destroy = function(self)
      local _list_0 = self.Queue
      for _index_0 = 1, #_list_0 do
        local L = _list_0[_index_0]
        L:destroy()
      end
      self.Queue = { }
      local _list_1 = self.Lines
      for _index_0 = 1, #_list_1 do
        local L = _list_1[_index_0]
        L:destroy()
      end
      self.Lines = { }
      self:stopRendering()
      self.addLine = function() end
    end,
    error = function(self, ...)
      return self:print(chalk('  ERROR').LightRed, ...)
    end,
    warn = function(self, ...)
      return self:print(chalk('WARNING').Orange, ...)
    end,
    info = function(self, ...)
      return self:print(chalk('   INFO').InfoBlue, ...)
    end,
    success = function(self, ...)
      return self:print(chalk('SUCCESS').Mint, ...)
    end,
    logger = function(self)
      return function(level, tag, ...)
        local s = '[' .. tag .. ']'
        local fn
        local _exp_0 = level
        if 'ERROR' == _exp_0 then
          fn = self.error
        elseif 'WARN' == _exp_0 then
          fn = self.warn
        elseif 'INFO' == _exp_0 then
          fn = self.info
        else
          fn = self.print
        end
        return fn(self, s, ...)
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, Options)
      if Options == nil then
        Options = { }
      end
      self.Options = Options
      defaults(self.Options, {
        YAlignment = self.YAlignment.BOTTOM,
        XAlignment = self.XAlignment.LEFT,
        MaxLines = 9,
        Size = 11,
        Font = 'Monospace'
      })
      self.Lines = { }
      self.Queue = { }
      self.Offset = 0
    end,
    __base = _base_0,
    __name = "Logger"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Logger = _class_0
end
local SplitText
do
  local _class_0
  local _parent_0 = Line
  local _base_0 = {
    make = function(self)
      _class_0.__parent.__base.make(self)
      self.Height = self:getHeight()
      self.Width = self:getWidth()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, Text)
      return _class_0.__parent.__init(self, (function()
        local _accum_0 = { }
        local _len_0 = 1
        for i = 1, #Text do
          _accum_0[_len_0] = ColorBlock(Text:sub(i, i))
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)())
    end,
    __base = _base_0,
    __name = "SplitText",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  SplitText = _class_0
end
local Rainbow
do
  local _class_0
  local _parent_0 = SplitText
  local _base_0 = {
    updater = function(self)
      for i, B in pairs(self.Blocks) do
        local h = i / self.Length + tick() * -self.Speed
        B:setColor(Color3.fromHSV(h % 1, self.Saturation / 255, self.Value / 255))
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, Text, Speed, Saturation, Value, Length)
      if Speed == nil then
        Speed = 1
      end
      if Saturation == nil then
        Saturation = 255
      end
      if Value == nil then
        Value = 255
      end
      if Length == nil then
        Length = 25
      end
      self.Speed, self.Saturation, self.Value, self.Length = Speed, Saturation, Value, Length
      return _class_0.__parent.__init(self, Text)
    end,
    __base = _base_0,
    __name = "Rainbow",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Rainbow = _class_0
end
local Frames = {
  '/',
  '-',
  '\\',
  '|'
}
local Spinner
do
  local _class_0
  local _parent_0 = ColorBlock
  local _base_0 = {
    updater = function(self)
      local F = 1 + (math.floor(7 * tick()) - 1) % 4
      if F ~= self.Last then
        self.Last = F
        return self:setText(Frames[F])
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ' ', ...)
      self.Last = 1
    end,
    __base = _base_0,
    __name = "Spinner",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Spinner = _class_0
end
local Metasploit
do
  local _class_0
  local _parent_0 = ColorBlock
  local _base_0 = {
    updater = function(self)
      local F = 1 + (math.floor(7 * (tick() - self.Start)) - 1) % self.Len
      if F ~= self.Last then
        self.Last = F
        local T = self.Text:sub(0, F - 1):lower() .. self.Text:sub(F, F):upper() .. self.Text:sub(F + 1):lower()
        return self:setText(T)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, T, ...)
      _class_0.__parent.__init(self, T:lower(), ...)
      self.Last = tick()
      self.Len = #T
      self.Start = tick()
    end,
    __base = _base_0,
    __name = "Metasploit",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Metasploit = _class_0
end
if game then
  pcall(function()
    return SYNLOG:destroy()
  end)
  getgenv().SYNLOG = Logger()
  local X = SYNLOG
  do
    local _with_0 = X
    _with_0:setMaxLines(14)
    _with_0:success('something worked!')
    _with_0:info(Spinner(), 'doing something...')
    _with_0:warn('something may go wrong')
    _with_0:error(Metasploit('something went wrong!'))
    return _with_0
  end
end
