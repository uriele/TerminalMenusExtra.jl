import REPL.TerminalMenus: _ConfiguredMenu, Config, request, printmenu, options, cancel, pick , keypress, writeline 
using Crayons.Box
import DataStructures: CircularDeque
import Base.show 
import Base: push!,pop!

include("utilities.jl")
include("traits.jl")    
include("interfaces.jl")

const RESET = "\e[m"
const MAXPAGESIZE=Ref{UInt}(20);

set_maxpagesize(max::UInt=20)=MAXPAGESIZE[]=max;
set_maxpagesize(max)=set_maxpagesize(UInt(max));

mutable struct MenuHistory{S}
    undo_queue ::CircularDeque{S}
    redo_queue ::CircularDeque{S}
    current::S
end

MenuHistory(;length_queue=10)=MenuHistory(CircularDeque{String}(length_queue),CircularDeque{String}(length_queue),"")

function undo!(history::MenuHistory)
    if isempty(history.undo_queue)
        return history.current
    end
    push!(history.redo_queue,history.current)
    history.current=pop!(history.undo_queue)

    return history.current
end

function redo!(history::MenuHistory)
    if isempty(history.redo_queue)
        return history.current
    end
    push!(history.undo_queue,history.current)
    history.current=pop!(history.redo_queue)
    return history.current
end

function Base.push!(history::MenuHistory, new::String)
    !isempty(history.current) && push!(history.undo_queue,history.current)
    history.current=new
end

function Base.pop!(history::MenuHistory)
    if !isempty(history.current) 
        push!(history.redo_queue,history.current)
        history.current=pop!(history.undo_queue)
    end
    return history.current
end




abstract type AbstractNavMenu{C} <: _ConfiguredMenu{C} end
struct SimpleNavMenu{S,I,U,C} <: AbstractNavMenu{C}
    currentdir:: S
    keybinding:: Vector{Char}
    pagesize:: I
    maxpagesize:: Base.RefValue{U}
    pageoffset:: I
    options:: Vector{S}
    selected:: Union{S,Nothing}
    history:: MenuHistory{S}
    config:: C
end

HistoryStyle(::Type{SimpleNavMenu})=HasHistory()
MenuStyle(::Type{SimpleNavMenu})=HasSubMenu()

function SimpleNavMenu(; currentdir::String=pwd(), pagesize::Integer=10, 
    pageoffset::Integer=0, 
    warn::Bool=true, 
    confirm_key::Char='d', quit_key::Char='q', undo_key::Char='u',redo_key::Char='r', 
    history_buffer::Int=10,kwargs...)
    isdir(currentdir) || error("$(currentdir) is not a directory")

    keybinding= [confirm_key, undo_key,redo_key, quit_key]
    pagesize=Int(min(max(0,pagesize),MAXPAGESIZE[]))

    selected=abspath(currentdir)
    history=MenuHistory(length_queue=history_buffer)
    push!(history,currentdir)
    return SimpleNavMenu(currentdir,keybinding,pagesize,MAXPAGESIZE,pageoffset,String[], selected,history, Config(; kwargs...))
    
end


# AbstractMenu implementation functions
# See AbstractMenu.jl
#######################################

options(m::AbstractNavMenu) = _ordered_dirvector(m.currentdir)

cancel(m::AbstractNavMenu) = m.selected = ""




function pick(menu::AbstractNavMenu, cursor::Int)
    menu.selected = abspath(joinpath(menu.currentdir,_ordered_dirvector(menu.currentdir)[cursor]))
    return true #break out of the menu
end




function keypress(m::AbstractNavMenu, i::UInt32)
    if i in m.keybinding[1]
        pick(m, m.pageoffset+1)
        return true
    elseif i in m.keybinding[2] && !isempty(m.history)
        m.currentdir=pop!(m.history)
        return false
    elseif i in m.keybinding[3] && !isempty(m.history)
    end
    
    return true
end


function writeline(buf::IOBuffer, menu::AbstractNavMenu, idx::Int, iscursor::Bool)
    element_submenu=options(menu)[idx] 
    fullpath=joinpath(menu.currentdir,element_submenu)   
    _islinkdir(fullpath) && return print(buf, BOLD,BLUE_FG, element_submenu, RESET)
    _isdir(fullpath) && return print(buf,BOLD, element_submenu, RESET)
    _islinkfile(fullpath) && return print(buf, BLUE_FG, element_submenu, RESET)
    return print(buf, element_submenu)
end


history(menu::AbstractNavMenu)=menu.history

undo!(menu::AbstractNavMenu)=undo!(menu.history)
redo!(menu::AbstractNavMenu)=redo!(menu.history)    
Base.push!(menu::AbstractNavMenu, new::String)=push!(menu.history,new)


function Base.show(io::IO,::MIME"text/plain", hist::MenuHistory) 
    println(io, "undo_queue: $([hist.undo_queue ...])")
    println(io, "current: $(hist.current)")
    println(io, "redo_queue: $(reverse([hist.redo_queue ...]))")
end
