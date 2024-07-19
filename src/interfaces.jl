"""
    history(menu)

Return the history of the menu. If the menu does have the trait [`NoHistory`](@ref) (default), return `nothing`. 
For menus with the trait `HasHistory`, return the history of the menu. By default, this falls back to the `history` field of the menu.
"""

history(menu)= history(HistoryStyle(menu),menu)

history(::HasHistory,menu)= throw(ArgumentError("history not implemented for $(typeof(menu)) even if it has the trait HasHistory"))
history(::NoHistory,menu)= nothing

"""
    undo!(menu)
Undo the last action in the menu. If the menu does not have the trait [`HasHistory`](@ref), throw an error.
"""
function undo! end
undo!(::NoHistory,menu)= nothing
undo!(::HistoryStyle,menu)= throw(ArgumentError("undo not implemented for $(typeof(menu)) even if it has the trait HasHistory"))
undo!(menu)= undo!(HistoryStyle(menu),menu)


"""
    redo!(!menu)
Redo the last action in the menu. If the menu does not have the trait [`HasHistory`](@ref), throw an error.
"""
function redo! end

redo!(::NoHistory,menu)= nothing
redo!(::HistoryStyle,menu)= throw(ArgumentError("redo not implemented for $(typeof(menu)) even if it has the trait HasHistory"))   
redo!(menu)= redo!(HistoryStyle(menu),menu)
