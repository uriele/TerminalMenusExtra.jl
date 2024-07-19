
"""
HistoryStyle(::Type{T})
HistoryStyle(menu)

A trait which indicates I keep track of the history of the menu for the cursor 
that allows for backtracking (`HasHistory`) or not (`NoHistory`).

Menus for which `HistoryStyle` returns `HasHistory` must implement [`history`]@(ref), [`undo`](@ref), and [`redo`](@ref) methods.

"""
abstract type HistoryStyle end


"""
       HasHistory <: HistoryStyle

Indicates that the menu keep track of the history of the cursor. 

## Required methods
- [`history`](@ref)
- [`undo`](@ref)
- [`redo`](@ref)
"""
struct HasHistory <: HistoryStyle end

"""
         NoHistory <: HistoryStyle

Indicates that the menu does not keep track of the history of the cursor. This is the default behavior of a menu.
"""

struct NoHistory <: HistoryStyle end

HistoryStyle(::Type) = NoHistory()
HistoryStyle(menu) = HistoryStyle(typeof(menu))