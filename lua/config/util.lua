vim.api.nvim_create_user_command('DeleteFile', function()
    local current_file = vim.api.nvim_buf_get_name(0)
    if current_file ~= "" then
        os.remove(current_file)
        vim.cmd('bdelete!')
        print('File deleted successfully.')
    else
        print('Could not delete file.')
    end
end, {})
