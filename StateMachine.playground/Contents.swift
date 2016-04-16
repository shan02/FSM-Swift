import UIKit

/*
    Sample Initialization

    fsm.From(State.Locked)
            .GoTo(State.UnLocked, on: Action.InsertCoin)
            .GoTo(State.Locked, on: Action.Push)
        .From(State.UnLocked)
            .GoTo(State.Locked, on: Action.Push)
            .GoTo(State.UnLocked, on: Action.InsertCoin)
*/

public class FiniteStateMachine<S: Hashable, A: Hashable>
{
    private var currentState: S
    private var transitionMap = [S:StateTransition<S, A>]()
    
    init(cs: S){
        currentState = cs
    }
    
    public func From(fromState: S) -> StateTransition<S,A>
    {
        transitionMap[fromState] = StateTransition(sm: self)
        return transitionMap[fromState]!
    }
    
    public func Fire(action: A, delegate: ())
    {
        // Check if valid transition can happen and fire the event
        let possibleToStates = transitionMap[currentState]
        for item in (possibleToStates!.toStateMap){
            if item.1 == action
            {
                delegate
                currentState = item.0
            }
        }
    }
}

public class StateTransition<S: Hashable, A: Hashable>
{
    private var toStateMap = [S:A]()
    weak var stateMachine : FiniteStateMachine<S, A>?
    
    init(sm: FiniteStateMachine<S,A>)
    {
        stateMachine = sm
    }
    
    public func GoTo(toState: S, on: A) -> StateTransition<S,A>
    {
        toStateMap[toState] = on
        return self
    }
    
    public func From(fs: S) -> StateTransition<S,A>
    {
        return stateMachine!.From(fs)
    }
}

public class TurnsTile
{
    // Possible States
    enum State{
        case Locked
        case UnLocked
    }
  
    // Possible Actions
    enum Action{
        case InsertCoin
        case Push
    }
    
    private var fsm = FiniteStateMachine<State, Action>(cs: State.Locked)

    init(){
        fsm.From(State.Locked)
            .GoTo(State.UnLocked, on: Action.InsertCoin)
            .GoTo(State.Locked, on: Action.Push)
            .From(State.UnLocked)
            .GoTo(State.Locked, on: Action.Push)
            .GoTo(State.UnLocked, on: Action.InsertCoin)
    }
    
    func GetCurrentState() -> State{
        return fsm.currentState
    }
    
    func InsertCoin(){
        fsm.Fire(Action.InsertCoin, delegate: { print("Coin Inserted...") }())
    }
    
    func Push(){
        fsm.Fire(Action.Push, delegate: { print("Push TurnsTile...")}())
    }
    
}


var turnsTile = TurnsTile()
print(turnsTile.GetCurrentState())
turnsTile.InsertCoin()
print(turnsTile.GetCurrentState())
turnsTile.Push()
print(turnsTile.GetCurrentState())
turnsTile.Push()
print(turnsTile.GetCurrentState())
turnsTile.InsertCoin()
print(turnsTile.GetCurrentState())


