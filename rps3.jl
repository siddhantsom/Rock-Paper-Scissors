using Base: Float64, String, Int64
using Printf
using Statistics
using Random
using LinearAlgebra


@enum  RPS R=0 P=1 S=2

counts = zeros(Int, 3)

function vs(x::RPS, y::RPS)
    return (0, 1, -1)[1 + mod(Int(y)-Int(x),3)]
end



function winning_move(x::RPS)
    return RPS(mod(Int(x) + 1, 3))
end

function bart()
    return nothing, R
end

function bart(ignored_state, (my_last, your_last))
    return ignored_state, R # always rock...
end

function beat_your_last()
    counts = zeros(Int, 3)
    return counts, rand((R,P,S)) # return vector of move counts, play random
end




function beat_your_last(history, (my_last, your_last))
    #push!(history, (my_last, your_last)) # keep record of past moves
    history[Int(your_last)+1]+=1
    my_new = winning_move(RPS(argmax(history)-1)) # beat opponents most frequent move
    return history, my_new 
end

function keep_count()
    counts = Dict(R=>0, P=>0, S=>0)
    return counts, rand((R,P,S)) # return vector of move counts, play random
end




function keep_count(history, (my_last, your_last))
    #push!(history, (my_last, your_last)) # keep record of past moves
    history[your_last]+=1
    my_new = winning_move(findmax(history)[2]) # beat opponents most frequent move
    return history, my_new 
end

function beat_beat_your_last()
    counts = zeros(Int, 3)
    return Tuple{RPS, RPS}[], rand((R,P,S)) # play random, why not....
end

function beat_beat_your_last(history, (my_last, your_last))
    push!(history, (my_last, your_last)) # keep record of past moves
    my_new = winning_move(winning_move(my_last)) #now what???
    return history, my_new
end

function henny()
    past_moves = []
    return past_moves, rand((R,P,S))
end

function henny(history, (my_last, your_last))
    push!(history, your_last) #keep record of opponent's past moves
    my_new = winning_move(history[rand(eachindex(history))])
    return history, my_new
end

 

function game(player1, player2, rounds=500)
    state1, move1 = player1()
    state2, move2 = player2()
    points = vs(move1, move2)
    oldmove1, oldmove2 = move1, move2
    for r in 2:rounds
        state1, move1 = player1(state1, (oldmove1, oldmove2))
        state2, move2 = player2(state2, (oldmove2, oldmove1))
        points = points + vs(move1, move2)
        oldmove1, oldmove2 = move1, move2
    end
    return points
end

function tournament(players)
    n = length(players)
    games = UpperTriangular(zeros(Int, n,n))
    for i in 1:n
        for j in i+1:n
            games[i,j] = game(players[i], players[j])
        end
    end
    games
end

#print(tournament([bart, beat_your_last, henny, keep_count]))
moves = Dict{Tuple{RPS, RPS, RPS}, Int64}() 
moves[(R,S,P)] = 1

moves[(R,S,S)] = 2

moves[(R,S,R)] = 2

current = (R,S)

A = [get(moves, (current..., M), 0) for M in instances(RPS)]

#print(RPS(rand(findall(x->x == maximum(A), A).-1)))

function cons_stringer()
    moves = Dict{Tuple{RPS, RPS, RPS}, Int64}()
    return moves, (rand((R,P,S)), rand((R,P,S)))
end


function cons_stringer(moves, ((my_last, your_last), (my_last1, your_last1)))
    current = (your_last, your_last1)
    A = [get(moves, (current..., M), 0) for M in instances(RPS)]
    if maximum(A) != 0

        my_new = winning_move(RPS(rand(findall(x->x == maximum(A), A).-1)))
    else
        my_new = rand((R,P,S))
    end
end









