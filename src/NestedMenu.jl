import REPL.TerminalMenus: AbstractMenu, RadioMenu, MultiSelectMenu
using AbstractTrees
import Base: show
import DataStructures: CircularDeque

export AbstractNavMenu, SimpleNavMenu
export history, undo!, redo!
export HistoryStyle, HasHistory, NoHistory
export AbstractMenuComponent, MenuNodeComponent, MenuLeafComponent

abstract type AbstractMenuComponent  end

"""
    SimpleNavMenu{C} <:_ ConfiguredMenu{C}

A menu that allows the navigation of a file system and to choose a particulat directory, file, or link. It has the trait [`HasHistory`](@ref).

"""
struct NavMenu{C,S} <: _ConfiguredMenu{C}  where S
    currentdir::S
    selected:: Union{S,Nothing}
    history::CircularDeque{S}
    config::C

    NavMenu(currentdir=pwd(),selecting=nothing, history=CircularDeque{S}(undef,10), config=Configure()) where {C,S} = new{C,S}(currentdir,selecting,history,config)
end

function NavMenu(; currentdir=pwd(),history_length=10, kwargs...)
    NavMenu(currentdir,currendir,CircularDeque{String}(history_length),Configure(;kwargs...))
end


#=
struct MenuNodeComponent <: AbstractMenuComponent
    name::String
    parent:: Union{MenuNodeComponent, Nothing}
    children:: Vector{AbstractMenuComponent}
end
struct MenuLeafComponent{M} <: AbstractMenuComponent where M 
    name::String
    parent:: Union{MenuNodeComponent,Nothing}
    menu :: M
end

AbstractTrees.children(node::AbstractMenuComponent) = []
AbstractTrees.children(node::MenuNodeComponent) = node.children
AbstractTrees.parent(node::AbstractMenuComponent) = node.parent
AbstractTrees.children(node::AbstractMenu)= node.options
AbstractTrees.children(node::NavMenu)= node.currentdir
isleaf(node::AbstractMenuComponent)= false
isleaf(node::MenuLeafComponent)= true
AbstractTrees.nodevalue(node::AbstractMenuComponent)= node.name
AbstractTrees.nodevalue(node::MenuLeafComponent)= (node.name," ")
AbstractTrees.nodevalue(node::MenuLeafComponent{M}) where M<:AbstractMenu = (node.name,node.menu.options)
AbstractTrees.nodevalue(node::MenuLeafComponent{NavMenu}) = (node.name,node.menu.currentdir)


function show(io::IO,::MIME"text/plain", node::AbstractMenu; level::Int=0) 
    #@assert(level>=0, "level must be non-negative")
    if level==0
        println(io, split(string(typeof(node)),"{")[1]*":")
        parent_shift= "  "*"⤷ " ;
    else
        parent_shift= "  "^level*"⤷ ";
    end

    for option in node.options
        println(io, parent_shift*option)
    end
end


function create_variables()
mm=MultiSelectMenu(["a","b","c"])
mm2=MultiSelectMenu(["d","e","f"])
ml1=MenuLeafComponent("leaf",nothing,mm)
ml2=MenuLeafComponent("leaf",nothing,mm2)
mc=MenuNodeComponent("node",nothing,[ml1])
mc1a=MenuNodeComponent("node1",mc,[ml2])
mc1b=MenuLeafComponent("node1",mc,NavMenu())
mc1=MenuNodeComponent("node1",mc,[mc1a, mc1b])

root=MenuNodeComponent("root",nothing,[mc,mc1])

crs=TrivialCursor(root)
end
=#