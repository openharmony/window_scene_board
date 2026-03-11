/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import hilog from '@ohos.hilog';
import { LogDomain } from '@ohos/basicutils';

const DOMAIN = LogDomain.RECENT;

type FSMStateType = string | number;
type FSMEventType = string | number;
export type FSMCallbackArgsType = any;
export type FSMCallbackType = ((...args: FSMCallbackArgsType[]) => boolean) | undefined;

/*
 *
 *  FSM: Finite State Machine, manages all FSM states.
 *  FSMState: states of FSM.
 *  FSMTransition: transition from stateA to stateB.
 *  FSMEvent: event invokes stateA transfer to StateB.
 *  the relationship between FSM, FSMState, FSMTransition and FSMEvent:
 *
 *         Aggregation                 Aggregation                     Dependency
 *  FSM <>-------------> FSMState <>----------------> FSMTransition ---------------> FSMEvent
 *   ^                    |   ^                            |
 *   ^     Dependency     |   ^        Dependency          |
 *   ^<<<<<<<<<<<<<<<<<<<<|   ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<|
 *
 *
 *  the FSMState Model:
 *                      when: FSMEvent come in. by FSM.transfer(FSMEvent, args) or FSMState.transfer(FSMEvent, args)..
 *                      condition: FSMTransition[i].judge return true.
 *                      action: 1. invoke FSMEvent.onBefore/FSMEvent.on/FSMEvent.onAfter.
 *                              2. invoke StateA.onLeave.
 *                              3. invoke StateB.onEnter.
 *   ___________                4. set FSM.currentState from StateA to StateB.         ___________
 *  |  StateA   |  ================================================================>  |   StateB  |
 *  |___________|                                                                     |___________|
 *
 */
export class FSM {
  private readonly MAX_STATES_NUM = 128;
  private readonly name: string;
  private states: FSMState[] = [];
  private currentState_: FSMState;

  constructor(name: string) {
    this.name = name;
  }

  public toString(): string {
    return this.name;
  }

  public get currentState(): FSMState {
    return this.currentState_;
  }

  public set currentState(state: FSMState) {
    if (!this.hasState(state)) {
      hilog.error(DOMAIN, this.toString(), 'set currentState to %{public}s error, fsm does not has this state',
        state.toString());
      return;
    }
    this.currentState_ = state;
  }

  public allStates(): FSMState[] {
    return this.states;
  }

  public addState(state: FSMState): FSM {
    if (this.states.length > this.MAX_STATES_NUM) {
      hilog.error(DOMAIN, this.toString(), 'add state %{public}s to fsm failed, the capability is out of count',
        state.toString());
      return this;
    }
    if (!this.hasState(state)) {
      this.states.push(state);
      state.attachToFsm(this);
    }
    return this;
  }

  private hasState(state: FSMStateType | FSMState): boolean {
    let found = this.states.find((item) => {
      return item.equalTo(state);
    });
    if (found) {
      return true;
    }
    return false;
  }

  public getState(state: FSMStateType | FSMState): FSMState | null {
    let found = this.states.find((item) => {
      return item.equalTo(state);
    });
    if (found) {
      return found;
    }
    return null;
  }

  public transfer(event: FSMEventType | FSMEvent, ...args: any[]): FSMState | null {
    if (!this.currentState_.isAttachToFsm(this)) {
      hilog.error(DOMAIN, this.toString(), 'transfer failed, state %{public}s is not attached to this fsm',
        this.currentState_.toString());
      return null;
    }
    return this.currentState_.transfer(event, ...args);
  }

  public can(event: FSMEventType | FSMEvent, ...args: any[]): boolean {
    if (!this.currentState_.isAttachToFsm(this)) {
      hilog.error(DOMAIN, this.toString(), 'can not transfer, state %{public}s is not attached to this fsm, ',
        this.currentState_.toString());
      return false;
    }
    return this.currentState_.can(event, ...args);
  }

  public printDetails(): string {
    let result = '';
    this.states.forEach((item, i) => {
      result += 'State' + i.toString() + ': ' + item.toString() + '\r\n';
      result += item.printTransitions();
      result += '\r\n';
      result += '\r\n';
    });
    return result;
  }

  static builder(name: string, initState?: FSMState): FSM {
    let fsm = new FSM(name);
    if (fsm && initState) {
      fsm.addState(initState);
      fsm.currentState = initState;
    }
    return fsm;
  }
}
export abstract class FSMState {
  private readonly MAX_TRANSITIONS_NUM = 128;
  private readonly name: FSMStateType;
  private fsm: FSM;
  private transitions: FSMTransition[] = [];
  private newState: FSMState;

  constructor(name: FSMStateType) {
    this.name = name;
  }

  public abstract init(): void;

  public get myFsm(): FSM {
    return this.fsm;
  }

  public attachToFsm(fsm: FSM): void {
    this.fsm = fsm;
  }

  public isAttachToFsm(fsm: FSM): boolean {
    if (this.fsm && this.fsm === fsm) {
      return true;
    }
    return false;
  }

  public printTransitions(): string {
    let result = '';
    this.transitions.forEach((item, i) => {
      result += '    transition' + i.toString() + ': ' + item.toString() + '\r\n';
    });
    return result;
  }

  public addTransition(transition: FSMTransition): FSMState {
    if (this.transitions.length > this.MAX_TRANSITIONS_NUM) {
      hilog.error(DOMAIN, this.toString(),
        'add transition %{public}s to this state failed, the capability is out of count', transition.toString());
      return this;
    }

    if (!this.hasTransition(transition)) {
      this.transitions.push(transition);
      return this;
    }
    hilog.warn(DOMAIN, this.toString(), 'add transition %{public}s to this state failed, it is already exist.',
      transition.toString());
    return this;
  }

  public deleteTransition(transition: FSMTransition): boolean {
    let index = this.transitions.findIndex((item) => {
      return item.equalTo(transition);
    });
    if (index === -1) {
      hilog.warn(DOMAIN, this.toString(), 'delete transition %{public}s from this state failed, it is not exist.',
        transition.toString());
      return false;
    }
    this.transitions.splice(index, 1);
    return true;
  }

  private hasTransition(transition: FSMTransition): boolean {
    let ret = this.transitions.find((item) => {
      return item.equalTo(transition);
    });
    if (ret) {
      return true;
    }
    return false;
  }

  public equalTo(state: FSMStateType | FSMState): boolean {
    let ret = false;
    if (typeof state === 'object') {
      ret = (this === state);
    } else {
      ret = (this.name === state);
    }
    return ret;
  }

  public onEnter(from: FSMState, event: FSMEvent, ...args: FSMCallbackArgsType[]): boolean {
    if (!this.equalTo(from)) {
      hilog.info(DOMAIN, this.toString(),
        'enter this state %{public}s from state %{public}s because of event %{public}s.',
        this.toString(), from.toString(), event.toString());
    }
    return true;
  }

  public onLeave(to: FSMState, event: FSMEvent, ...args: FSMCallbackArgsType[]): boolean {
    if (!this.equalTo(to)) {
      hilog.info(DOMAIN, this.toString(),
        'leave this state %{public}s to state %{public}s because of event %{public}s.',
        this.toString(), to.toString(), event.toString());
    }
    return true;
  }

  public toString(): string {
    if (typeof this.name === 'string') {
      return this.name;
    }
    return this.name.toString();
  }

  private doEvent(event: FSMEvent, ...args: any[]): boolean {
    if (!event.checkOn()) {
      return false;
    }
    event.doOnBefore(...args);
    let ret = event.doOn(...args);
    event.doOnAfter(...args);
    return ret;
  }

  private doTransfer(event: FSMEvent, nextState: FSMState, ...args: any[]): FSMState {
    // if event callback failed, do not transfer to next state
    if (!this.doEvent(event, ...args)) {
      if (!this.equalTo(nextState)) {
        hilog.warn(DOMAIN, this.toString(), 'transfer do not occur. because event %{public}s action return false',
          event.toString());
      }
      return this;
    }
    this.onLeave(nextState, event, ...args);
    // if fsm exist, set fsm current state to next state
    if (this.fsm && this.fsm.currentState !== nextState) {
      this.fsm.currentState = nextState;
      hilog.info(DOMAIN, this.fsm.toString(), 'transfer from %{public}s to %{public}s by event %{public}s success.',
        this.toString(), nextState.toString(), event.toString());
    }
    nextState.onEnter(this, event, ...args);
    return nextState;
  }

  private autoTransfer(event: FSMEvent, nextState: FSMState, ...args: any[]): FSMState {
    if (!this.equalTo(nextState)) {
      hilog.info(DOMAIN, this.toString(), 'start transfer from %{public}s to %{public}s by event %{public}s',
        this.toString(), nextState.toString(), event.toString());
    }
    this.newState = this.doTransfer(event, nextState, ...args);
    while (true) {
      this.newState = nextState.transfer(FSMEvent.NULL, ...args);
      if (this.newState.equalTo(nextState)) {
        break;
      }
      nextState = this.newState;
    }
    this.newState = null;
    return nextState;
  }

  public transfer(event: FSMEventType | FSMEvent, ...args: any[]): FSMState {
    if (!this.checkFsm()) {
      hilog.error(DOMAIN, this.toString(),
        'fsm current state %{public}s is not equal to this state %{public}s, fsm can not transfer.',
        this.fsm.currentState.toString(), this.toString());
      return this;
    }
    let length = this.transitions.length;
    for (let i = 0; i < length; i++) {
      if (!this.transitions[i].getEvent().equalTo(event)) {
        continue;
      }
      if (this.transitions[i].doJudge(...args)) {
        if (!this.transitions[i].getNextState()) {
          continue;
        }
        return this.autoTransfer(this.transitions[i].getEvent(), this.transitions[i].getNextState(), ...args);
      }
    }
    if (event.toString() !== FSMEvent.NULL) {
      hilog.warn(DOMAIN, this.toString(),
        'this state can not response to event %{public}s, this transitions length %{public}d, this currentState %{public}s',
        event.toString(), this.transitions.length, this.fsm.currentState.toString());
    }
    return this;
  }

  private checkFsm(): boolean {
    if (this.fsm && !this.equalTo(this.fsm.currentState)) {
      return false;
    }
    return true;
  }

  public can(event: FSMEventType | FSMEvent, ...args: any[]): boolean {
    let length = this.transitions.length;
    for (let i = 0; i < length; i++) {
      let item = this.transitions[i];
      let fsmEvent = item.getEvent();
      if (fsmEvent.equalTo(event) && item.doJudge(...args)) {
        return true;
      }
    }
    return false;
  }
}

/**
 * Transition class of Finite State Machine.
 */
export class FSMTransition {
  private event: FSMEvent;
  private judge: FSMCallbackType;
  private nextState: FSMState;

  constructor(event: FSMEvent, nextState: FSMState, judge?: FSMCallbackType) {
    this.event = event;
    if (judge) {
      this.judge = judge;
    } else {
      this.judge = this.defaultJudge;
    }
    this.nextState = nextState;
  }

  private defaultJudge(): boolean {
    return true;
  }

  public getEvent(): FSMEvent {
    return this.event;
  }

  public doJudge(...args: any[]): boolean {
    if (this.judge) {
      return this.judge(...args);
    }
    return false;
  }

  public getNextState(): FSMState {
    return this.nextState;
  }

  public equalTo(transition: FSMTransition): boolean {
    if (this.event.equalTo(transition.event) && this.judge === transition.judge) {
      return true;
    }
    return false;
  }

  public toString(): string {
    return 'judge: ' + this.judge.name + ', ' +
      'event: ' + this.event.toString() + ', ' +
      'nextState: ' + this.nextState.toString();
  }

  public static builder(event: FSMEvent,
                        nextState: FSMState,
                        judge?: FSMCallbackType): FSMTransition {
    return new FSMTransition(event, nextState, judge);
  }
}

export class FSMEvent {
  public static readonly NULL = 'NULL';
  private readonly name: FSMEventType;
  private onBefore: FSMCallbackType;
  private onAfter: FSMCallbackType;
  private on: FSMCallbackType;

  constructor(name: FSMEventType) {
    this.name = name;
    this.on = this.defaultOn;
  }

  private defaultOn(): boolean {
    return true;
  }

  public doOnBefore(...args: any[]): boolean {
    if (this.onBefore) {
      return this.onBefore(...args);
    }
    return false;
  }

  public doOnAfter(...args: any[]): boolean {
    if (this.onAfter) {
      return this.onAfter(...args);
    }
    return false;
  }

  public checkOn(): boolean {
    if (this.on) {
      return true;
    }
    return false;
  }

  public doOn(...args: any[]): boolean {
    if (this.on) {
      return this.on(...args);
    }
    return false;
  }

  public equalTo(event: FSMEventType | FSMEvent): boolean {
    let ret = false;
    if (typeof event === 'object') {
      ret = (this === event);
    } else {
      ret = (this.toString() === event.toString());
    }
    return ret;
  }

  public toString(): string {
    if (typeof this.name === 'string') {
      return this.name;
    }
    return this.name.toString();
  }

  public isNULL(): boolean {
    return this.name === FSMEvent.NULL;
  }

  public static builder(name: FSMEventType,
                        on?: FSMCallbackType,
                        onBefore?: FSMCallbackType,
                        onAfter?: FSMCallbackType): FSMEvent {
    let event = new FSMEvent(name);
    if (on) {
      event.on = on;
    }
    if (onBefore) {
      event.onBefore = onBefore;
    }
    if (onAfter) {
      event.onAfter = onAfter;
    }
    return event;
  }
}