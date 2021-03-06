nick,chan,message = ...
local serialization = require "serialization"
lnick = config.nick
--print(lnick,nick,chan,message)
if string.find(message,lnick) ~= nil and nick ~= "Shocky" then
-- print("Message addressed to AI!")
 local f = io.open("./ai.lua","rb")
 if f ~= nil then
  local content = f:read("*a")
  f:close()
--  print(content)
--  print("Loaded AI file.")
--  print(type(serialization.unserialize))
  w,aitab = pcall(serialization.unserialize,content)
--  print(w,aitab)
--  print("Decoded AI file.")
  message = message:lower()
  local selection = 0
  local hscore = 0
--  print("Starting interpretation.")
  for k,v in ipairs(aitab) do
   local count = 0
   for l,w in ipairs(v[2]) do
    if message:find(w) then count = count + 1 end
   end
   if config.debug then print(k.. " = " ..count) end
   if count > hscore then
    selection = k
    hscore = count
--    print(selection,hscore)
   end
  end
  if hscore == 0 then
--   print("No high score, selecting a random response.")
   local rtab = {}
   for k,v in pairs(aitab) do
    if v[3] == true then
     table.insert(rtab,k)
    end
   end
   selectrand = math.random(1,#rtab)
   selection = rtab[selectrand]
  end
--  print(selection)
  seltab = aitab[selection][1]
  selstring = seltab[math.random(1,#seltab)]
  selstring = selstring:format(nick)
  if type(selstring) == "table" then
   for k,v in pairs(selstring) do
    --print(k.."="..v)
   end
  end
  print("Selected response: " .. selstring)
  sendchan(chan,selstring)
 end
end
