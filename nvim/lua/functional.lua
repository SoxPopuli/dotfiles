local M = {}

---Map x[] -> fn(x)[]
---@generic K
---@generic V
---@generic O
---@param lst { [K]: V }
---@param fn fun(x: V): O
---@return { [K]: O }
function M.map(lst, fn)
    local new = {}
    for k, v in pairs(lst) do
        new[k] = fn(v)
    end

    return new
end

---Map x[] -> fn(x)[]
---@generic K
---@generic V
---@generic O
---@param lst { [K]: V }
---@param fn fun(k: K, v: V): O
---@return O[]
function M.map_pairs(lst, fn)
    local new = {}
    for k, v in pairs(lst) do
        table.insert(new, fn(k, v))
    end

    return new
end

---Map x[] -> fn(x)[]
---@generic I
---@generic O
---@param lst I[]
---@param fn fun(x: I): O
---@return O[]
function M.mapi(lst, fn)
    local new = {}
    for i = 1, #lst do
        new[i] = fn(lst[i])
    end

    return new
end

---Iter x[] -> fn(x)[]
---@generic K
---@generic V
---@generic O
---@param lst { [K]: V }
---@param fn fun(x: V)
function M.iter(lst, fn)
    for _, v in pairs(lst) do
        fn(v)
    end
end

---Iter x[] -> fn(x)[]
---@generic K
---@generic V
---@generic O
---@param lst { [K]: V }
---@param fn fun(k: K, v: V)
function M.iter_pairs(lst, fn)
    for k, v in pairs(lst) do
        fn(k, v)
    end
end

---Iter x[] -> fn(x)[]
---@generic I
---@generic O
---@param lst I[]
---@param fn fun(x: I)
function M.iteri(lst, fn)
    for i = 1, #lst do
        fn(lst[i])
    end
end

---Filter lst where fn(x) == true
---@generic I
---@generic O
---@param lst I[]
---@param fn fun(x: I): O
---@return O[]
function M.filter(lst, fn)
    local new = {}
    for i = 1, #lst do
        if fn(lst[i]) then
            new[i] = lst[i]
        end
    end

    return new
end

---Fold fn over lst
---@generic I
---@generic O
---@param lst I[]
---@param init O
---@param fn fun(acc: O, x: I): O
---@return O
function M.fold(lst, init, fn)
    local state = init
    for i = 1, #lst do
        state = fn(state, lst[i])
    end

    return state
end

return M
