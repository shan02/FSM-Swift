# FSM-Swift

Here is my inital attempt to create a generic implementation of simple Finite State Machine.

Here is a sample initialization of a TurnsTile state machine

    fsm.From(State.Locked)
            .GoTo(State.UnLocked, on: Action.InsertCoin)
            .GoTo(State.Locked, on: Action.Push)
        .From(State.UnLocked)
            .GoTo(State.Locked, on: Action.Push)
            .GoTo(State.UnLocked, on: Action.InsertCoin)
