# FSM-Swift

Here is my inital attempt to create a generic implementation of simple Finite State Machine.

Here is a sample initialization of a TurnsTile state machine

    fsm.from(State.Locked)
            .goTo(State.UnLocked, on: Action.InsertCoin)
            .goTo(State.Locked, on: Action.Push)
        .from(State.UnLocked)
            .goTo(State.Locked, on: Action.Push)
            .goTo(State.UnLocked, on: Action.InsertCoin)
