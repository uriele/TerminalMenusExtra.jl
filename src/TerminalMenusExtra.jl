module TerminalMenusExtra
    import REPL.TerminalMenus: AbstractMenu
    import AbstractTrees: AbstractNode

    abstract type AbstractTree{N} where N<:AbstractNode end

    mutable struct MenuTree{N} <: AbstractTree{N}
        root:: N
        info:: Dict
    end

    mutable struct MenuNode <: AbstractNode
        name:: String
        parent:: Union{MenuNode, Nothing}
        children:: Vector{MenuNode}
        action:: Union{Function, Nothing}
        isleaf:: Bool
        level:: Int
    end

    children(node::MenuNode) = node.children
    parent(node::MenuNode) = isnothing(node.parent) ? nothing : node.parent
    

   # include("NavMenu.jl")
   # include("NestedMenu.jl")
    include("utilities.jl")

    history(menu) = nothing
    undo(menu) = error("undo not implementer for $(typeof(menu))")
    redo(menu) = error("redo not implementer for $(typeof(menu))")

    
    

end
