-- wraps full-line comments that run past the formatter's line length.
-- ruff/stylua/prettier wrap code but leave comments alone, so this fills the gap.
local M = {}

-- where each language's formatter keeps its line length, and the formatter's default
local settings = {
	python = {
		files = { "ruff.toml", ".ruff.toml", "pyproject.toml" },
		key = "line%-length",
		section = { ["pyproject.toml"] = "tool.ruff" },
		default = 88,
	},
	lua = {
		files = { "stylua.toml", ".stylua.toml" },
		key = "column_width",
		section = {},
		default = 120,
	},
	javascript = {
		files = {},
		section = {},
		default = 80,
	},
}

M.filetypes = vim.tbl_keys(settings)

-- shebangs, python pragmas, and lua block comments must stay on one line
local skip_patterns = {
	"^#!",
	"^#%s*noqa",
	"^#%s*type:",
	"^#%s*fmt:",
	"^#%s*pyright:",
	"^#%s*ruff:",
	"^%-%-%[=*%[",
}

local function read_setting(path, key, section)
	local in_section = section == nil
	for line in io.lines(path) do
		local header = line:match("^%s*%[([^%]]+)%]")
		if header then
			in_section = section == nil or header == section
		elseif in_section then
			local value = line:match("^%s*" .. key .. "%s*=%s*(%d+)")
			if value then
				return tonumber(value)
			end
		end
	end
end

-- closest config file wins, same as ruff/stylua
function M.line_length(buf)
	local ft = vim.bo[buf].filetype
	local s = settings[ft]
	if not s then
		return 80
	end
	local found = vim.fs.find(s.files, {
		upward = true,
		path = vim.fs.dirname(vim.api.nvim_buf_get_name(buf)),
		limit = math.huge,
	})
	for _, path in ipairs(found) do
		local value = read_setting(path, s.key, s.section[vim.fs.basename(path)])
		if value then
			return value
		end
	end
	return s.default
end

-- rows (0-indexed) that hold a single-line comment with nothing before it but indentation
local function comment_rows(lines, lang)
	local ok, parser = pcall(vim.treesitter.get_string_parser, table.concat(lines, "\n"), lang)
	if not ok then
		return {}
	end
	local ok_query, query = pcall(vim.treesitter.query.parse, lang, "(comment) @comment")
	if not ok_query then
		return {}
	end
	local rows = {}
	local root = parser:parse()[1]:root()
	for _, node in query:iter_captures(root, table.concat(lines, "\n")) do
		local start_row, start_col, end_row = node:range()
		if start_row == end_row and start_col == #lines[start_row + 1]:match("^%s*") then
			rows[start_row] = true
		end
	end
	return rows
end

-- greedy word wrap; returns nil if the line can't be broken (e.g. one long URL)
local function wrap_line(line, prefix, width)
	local indent = line:match("^%s*")
	local rest = line:sub(#indent + 1)
	if rest:sub(1, #prefix) ~= prefix then
		return nil
	end
	for _, pattern in ipairs(skip_patterns) do
		if rest:match(pattern) then
			return nil
		end
	end
	-- keep doubled markers like "##" or "---" and any extra spacing on every wrapped line
	local marker = rest:match("^" .. vim.pesc(prefix) .. vim.pesc(prefix:sub(-1)) .. "*")
	local body = rest:sub(#marker + 1)
	local spacing = body:match("^%s*")
	local lead = indent .. marker .. (spacing == "" and " " or spacing)

	local out, current = {}, nil
	for word in body:gmatch("%S+") do
		if current == nil then
			current = lead .. word
		elseif vim.fn.strdisplaywidth(current .. " " .. word) <= width then
			current = current .. " " .. word
		else
			table.insert(out, current)
			current = lead .. word
		end
	end
	table.insert(out, current)
	return #out > 1 and out or nil
end

function M.wrap(buf, lines)
	local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
	local prefix = vim.trim((vim.bo[buf].commentstring:match("^(.-)%%s") or ""))
	if not lang or prefix == "" then
		return lines
	end
	local width = M.line_length(buf)
	local rows = comment_rows(lines, lang)

	local out = {}
	for i, line in ipairs(lines) do
		local wrapped = rows[i - 1] and vim.fn.strdisplaywidth(line) > width and wrap_line(line, prefix, width)
		vim.list_extend(out, wrapped or { line })
	end
	return out
end

return M
