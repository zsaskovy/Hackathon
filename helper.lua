function print_r (tbl, indent)
  if not indent then indent = 0 end
  if (tbl == nil) then
	print("NIL")
	return
  end
  
  --[[if (#tbl == 0) then
  	print("EMPTY")
  	return
  end]]--
  print("table:[")
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      print_r(v, indent+1)
    else
      print(formatting .. tostring(v))
    end
  end
  print("]")
end

function string_starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function TableConcat(t1,t2)
	if (t2 == nil) then return t1 end
	if (t1 == nil) then return t2 end
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

function TableFirstNElements(t, n)
	local ret = {}
	for i=1,math.min(n,#t) do
		ret[#ret+1] = t[i]
	end
	return ret
end

--matches all health types
function isTypeHealth(t)
	return (string.match(t, "medikit") or string.match(t, "heal"))
end

--matches all goodie types except keys
function isPowerup(t)
	return (string.match(t, "i_") and not string.match(t, "key"))
end

--matches all goodie types that should be picked up along the way
function isPickupItem(t)
	return (
		(string.match(t, "w_") or
		string.match(t, "i_") or
		string.match(t, "a_") or
		isTypeHealth(t)) and
		not string.match(t, "chainsaw")
	)
end