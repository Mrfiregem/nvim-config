vim.api.nvim_create_user_command("DeleteFile", function()
    local current_file = vim.api.nvim_buf_get_name(0)
    if current_file ~= "" then
        os.remove(current_file)
        vim.cmd("bdelete!")
        print("File deleted successfully.")
    else
        print("Could not delete file.")
    end
end, { desc = "Delete the current buffer from system" })

vim.api.nvim_create_user_command("RenameFile", function(cmdarg)
    local path = vim.api.nvim_buf_get_name(0)
    local new_name = cmdarg.fargs[1]
    local new_path = vim.fs.joinpath(vim.fs.dirname(path), new_name)
    vim.fs.rm(path)
    vim.cmd.saveas(new_path)
end, { nargs = 1, desc = "Rename the current buffer's filename" })
