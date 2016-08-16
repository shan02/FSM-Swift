import UIKit

/*
    Sample Initialization

    fsm.from(State.Locked)
            .goTo(State.UnLocked, on: Action.InsertCoin)
            .goTo(State.Locked, on: Action.Push)
        .from(State.UnLocked)
            .goTo(State.Locked, on: Action.Push)
            .goTo(State.UnLocked, on: Action.InsertCoin)
*/

public class FiniteStateMachine<State: Hashable, Action: Equatable> {
    private var currentState: State
    private var transitionMap = [State:StateTransition<State, Action>]()
    
    init(currentState: State) {
        self.currentState = currentState
    }
    
    public func from(fromState: State) -> StateTransition<State,Action> {
        transitionMap[fromState] = StateTransition(stateMachine: self)
        return transitionMap[fromState]!
    }
    
    public func fire(action: Action, delegate: ()->()) {
        // Check if valid transition can happen and fire the event
        let possibleToStates = transitionMap[currentState]
        for item in (possibleToStates!.toStateMap){
            if item.1 == action
            {
                delegate()
                currentState = item.0
            }
        }
    }
}

public class StateTransition<State: Hashable, Action: Equatable> {
    private var toStateMap = [State:Action]()
    weak var stateMachine : FiniteStateMachine<State, Action>?
    
    init(stateMachine: FiniteStateMachine<State,Action>) {
        self.stateMachine = stateMachine
    }
    
    public func goTo(toState: State, on: Action) -> StateTransition<State,Action> {
        toStateMap[toState] = on
        return self
    }
    
    public func from(fromState: State) -> StateTransition<State,Action> {
        return stateMachine!.from(fromState)
    }
}

public class TurnsTile {
    
    // Possible States
    enum State {
        case Locked
        case UnLocked
    }
  
    // Possible Actions
    enum Action {
        case InsertCoin
        case Push
    }
    
    private var fsm = FiniteStateMachine<State, Action>(currentState: State.Locked)

    init() {
        fsm.from(State.Locked)
                .goTo(State.UnLocked, on: Action.InsertCoin)
                .goTo(State.Locked, on: Action.Push)
            .from(State.UnLocked)
                .goTo(State.Locked, on: Action.Push)
                .goTo(State.UnLocked, on: Action.InsertCoin)
    }
    
    func getCurrentState() -> State {
        return fsm.currentState
    }
    
    func insertCoin() {
        fsm.fire(Action.InsertCoin, delegate: { print("Coin Inserted...") })
    }
    
    func push() {
        fsm.fire(Action.InsertCoin, delegate: { print("Turnstile Pushed...") })
    }
}


var turnsTile = TurnsTile()
print(turnsTile.getCurrentState())
turnsTile.insertCoin()
print(turnsTile.getCurrentState())
turnsTile.push()
print(turnsTile.getCurrentState())
turnsTile.push()
print(turnsTile.getCurrentState())
turnsTile.insertCoin()
print(turnsTile.getCurrentState())


