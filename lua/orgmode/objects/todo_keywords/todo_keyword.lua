---@alias OrgTodoKeywordType 'TODO' | 'DONE'

---@class OrgTodoKeyword
---@field keyword string
---@field index number
---@field type OrgTodoKeywordType
---@field value string
---@field shortcut string
---@field hl string
---@field has_fast_access boolean
---@field log_state_entry string
---@field log_state_exit string
local TodoKeyword = {}
TodoKeyword.__index = TodoKeyword

---@param opts { type: OrgTodoKeywordType, keyword: string, index: number }
---@return OrgTodoKeyword
function TodoKeyword:new(opts)
  local this = setmetatable({
    keyword = opts.keyword,
    type = opts.type,
    index = opts.index,
    has_fast_access = false,
  }, self)
  this:parse()
  return this
end

function TodoKeyword:empty()
  return setmetatable({
    keyword = '',
    value = '',
    type = '',
    index = 1,
    has_fast_access = false,
    hl = '',
  }, self)
end

function TodoKeyword:is_empty()
  return self.keyword == ''
end

function TodoKeyword:parse()
  self.value = self.keyword
  self.shortcut = self.keyword:sub(1, 1):lower()

  local value, shortcut, inside = self.keyword:match('(.*)%((.)([^%)]*)%)$')
  if inside then
    local special1, special2 = inside:match("([!@])%/([!@])")
    if special1 then
      self.log_state_entry = special1
    else
      self.log_state_entry = nil
    end
    if special2 then
      self.log_state_exit = special2
    else
      self.log_state_exit = nil
    end
    if special1 == nil and special2 == nil then
      local special = inside:match("[!@]")  -- check if ! or @ inside
      if special then
        self.log_state_entry = special
      end
    end
  end
  if value and shortcut then
    self.value = value
    if shortcut ~= "!" and shortcut ~= "@" then
      self.shortcut = shortcut
      self.has_fast_access = true
    else
      self.log_state_entry = shortcut
    end
  end
end

return TodoKeyword
