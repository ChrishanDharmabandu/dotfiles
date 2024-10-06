-- Function to toggle or add a checkbox in markdown files
local function toggle_or_add_checkbox()
    -- Get the file type of the current buffer
    local filetype = vim.bo.filetype

    -- Only proceed if the file is a markdown file
    if filetype ~= "markdown" then
        return
    end

    -- Get the current line
    local line = vim.api.nvim_get_current_line()

    -- Check if the line contains '[ ]' (unchecked) or '[x]' (checked)
    if line:match("%[ %]") then
        -- If it's unchecked, replace '[ ]' with '[x]'
        line = line:gsub("%[ %]", "[x]")
    elseif line:match("%[x%]") then
        -- If it's checked, replace '[x]' with '[ ]'
        line = line:gsub("%[x%]", "[ ]")
    else
        -- If there's no checkbox, add an unchecked one '[ ]' at the start
        line = "- [ ] " .. line
    end

    -- Set the modified line back to the buffer
    vim.api.nvim_set_current_line(line)
end

-- Map Ctrl-l to the toggle_or_add_checkbox function in normal mode for markdown files
vim.keymap.set("n", "<C-l>", toggle_or_add_checkbox, { desc = "Toggle or add checkbox in markdown files" })

