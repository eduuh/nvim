local M = { results = {} }

local function key(cell)
	assert(cell.buf, "cell.buf is missing")
	assert(cell.range, "cell.range is missing")
	return string.format("%d:%d-%d", cell.buf, cell.range.start, cell.range.stop)
end

function M.save(cell, result)
	if not cell or not cell.buf then
		return
	end
	M.results[key(cell)] = result
end

function M.get(cell)
	if not cell or not cell.buf then
		return nil
	end
	return M.results[key(cell)]
end

return M
