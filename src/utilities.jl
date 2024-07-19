
"""
    isrootdir(dir::String)
Return `true` if the directory is the root of the filesystem, `false` otherwise.

"""
isrootdir(dir::String)= _isdir(dir) && splitpath(abspath(dir))==1  # I am at the root of the filesystem


"""
    _isdir(dir::String)
Wrapper around `isdir` that returns `false` if the directory does not exist or cannot be read.
"""
function _isdir(dir::String)
    try
        return isdir(dir)
    catch err
        return false  # If for any reason I cannot read the file and stat returns ERROR
    end
end

"""
    _isfile(file::String)
Wrapper around `isfile` that returns `false` if the file does not exist or cannot be read.
"""

function _isfile(file::String)
    try
        return isfile(file)
    catch err
        return false  # If for any reason I cannot read the file and stat returns ERROR
    end
end

"""
    _islinkfile(file::String)
Return `true` if the file is a symbolic link to a file, `false` otherwise.
"""

_islinkfile(file::String)=islink(file) && _isfile(file)
    
"""
    _islinkdir(dir::String) 
Return `true` if the directory is a symbolic link to a directory, `false` otherwise.
"""

_islinkdir(dir::String)=islink(dir) && _isdir(dir)

"""
    _readdir(dir::String)
Wrapper around `readdir` that returns the contents of the directory if it is a symbolic link to a directory or the directory itself.


"""
 _readdir(dir::String)= readdir(dir)


"""
    _ordered_dirvector(currentdir::String)
"""
function _ordered_dirvector(currentdir::String)
    head= isrootdir(currentdir) ? ["."] : [".",".."];
    @show(head)
    @show(currentdir)
    @show(isrootdir(currentdir))

    _isdir(currentdir) || error("$(currentdir) is not a directory")
    listdir=_readdir(currentdir);
    dirs= sort(filter(x-> _isdir(joinpath(currentdir,x)), listdir))
    files=sort(filter(x-> _isfile(joinpath(currentdir,x)), listdir))
    return [head...,dirs..., files...]
end
