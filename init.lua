require("config.options")
require("config.keymapping")
require("config.autocmd")
require("config.ttconfig")
require("config.lazy")
require("config.osconfigs")

-- Experimental- tests: Only on mac
if require("config.utils").isMac then
	require("config.rocks")
end
