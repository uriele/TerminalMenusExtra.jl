mutable struct TestNode
    value::Int
    next::Set{TestNode}
    prev::Union{TestNode, Nothing}
end
import Base: show

SubTree=Union{Set{TestNode},Array{TestNode,1}}
SubTreeOrNode=Union{TestNode,SubTree}
TestNode(value::Int; subtree::SubTreeOrNode=TestNode[], supertree::Union{TestNode,nothing})=TestNode(value, Set{TestNode}(subtree...),supretree)

function pushsubtree!(node::TestNode, subtree::SubTreeOrNode)
    push!(node.next, tree...)
    pushsupertree!(subtree, node)   
end

function pushsupertree!(node::TestNode, supertree::TestNode)
    node.prev=supertree
    node in supertree.next || push!(supertree.next, node)
end
   
function pushsupertree!(nodes::SubTree, supertree::TestNode)
    for node in nodes
        pushsupertree!(node, supertree)
    end
end

popsupertee

function popsubtreenode!(node::TestNode) 
    next=pop!(node.next)
    next.prev=nothing
    return next
end
function popfirstsubtree!(node::TestNode)=popfirst!(node.next)   
popatsubtree!(node::TestNode, subtree::SubTreeOrNode)=popat!(node.next, subtree)
popsubtree!(node::TestNode, subtree::SubTreeOrNode)= setdiff!(node.next, subtree)   



root=TestNode(0)
first=TestNode(1)
second=TestNode(2)
firsta=TestNode(3)
firstb=TestNode(4)

root.next=Set([first,second])
first.prev=root
second.prev=root
first.next=Set([firsta,firstb])
firsta.prev=first
firstb.prev=first

function show(io::IO, node::TestNode) 
    println(io, `value: $(node.value)`)
    if !isnothing(node.next)
        println(io, `next: $([n.value for n in node.next])`)
    end
    if !isnothing(node.prev)
        println(io, `prev: $(node.prev.value)`)
    end
end

isroot(node::TestNode)=isnothing(node.prev) 
isleaf(node::TestNode)=isempty(node.next)
function subtree!(node::TestNode)
    isroot(node) && return nothing
    filter!(n-> n.next!=node, node.prev);