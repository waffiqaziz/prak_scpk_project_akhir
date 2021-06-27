function formatHasil = UbahFormat(format,data)
    fun = @(x) sprintf(format, x);
    formatHasil = cellfun(fun, data, 'UniformOutput',0);  
end