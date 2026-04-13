/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper, ObjUtil, } from '@ohos/basicutils';
import { KeyCodeConstants, KeyState } from '@ohos/commonconstants';
import KeyEventConstants from '../constants/KeyEventConstants';
import { CommonConstants } from '../constants/CommonConstants';
import { KeyCode } from '@ohos.multimodalInput.keyCode';

const TAG = 'KeyEventManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const ANTI_SHAKE_DELAY_TIME: number = 500;

export interface KeyEventListener {
  onReceiveKeyEvent: (event: string) => void
}

class KeyEventManager {
  private isCtrlDown: boolean = false;

  private isShiftDown: boolean = false;
  private isAltKeyDown: boolean = false;

  private shiftStatus: Map<number, number> = new Map();
  private isCtrlAndVAvailable: boolean = true;
  private isVKeyPressed: boolean = false;
  /**
   * registered listeners
   */
  private mKeyEventListeners: Record<string, KeyEventListener[]> = {};

  static getInstance(): KeyEventManager {
    if (globalThis.keyEventManager == null) {
      log.showInfo('get instance init');
      globalThis.keyEventManager = new KeyEventManager();
    }
    return globalThis.keyEventManager;
  }

  public registerKeyEventListener(listener: KeyEventListener, events: string[]): void {
    log.showInfo(`registerKeyEventListener ${JSON.stringify(events)}`);
    if (ObjUtil.isInvalid(listener) || ObjUtil.isInvalid(events)) {
      return;
    }
    for (let idx = 0; idx < events.length; idx++) {
      const event: string = events[idx];
      if (this.mKeyEventListeners[event] === undefined) {
        this.mKeyEventListeners[event] = [];
      }
      if (this.mKeyEventListeners[event].indexOf(listener) === CommonConstants.INVALID_VALUE) {
        this.mKeyEventListeners[event].push(listener);
      }
    }
  }

  public unRegisterKeyEventListener(listener: KeyEventListener): void {
    log.showInfo('unRegisterKeyEventListener');
    Object.keys(this.mKeyEventListeners).forEach(eventKey => {
      const listeners = this.mKeyEventListeners[eventKey];
      const index: number = listeners.indexOf(listener);
      if (index !== CommonConstants.INVALID_VALUE) {
        this.mKeyEventListeners[eventKey].splice(index, 1);
      }
    });
  }

  /**
   * reset ctrl and shift key state to false
   */
  public async resetCombKeyState(): Promise<void> {
    this.isCtrlDown = false;
    this.isShiftDown = false;
    this.isAltKeyDown = false;
    AppStorage.setOrCreate<boolean>('isCtrlKeyDown', this.isCtrlDown);
    AppStorage.setOrCreate<boolean>('isShiftKeyDown', this.isShiftDown);
    AppStorage.setOrCreate<boolean>('isAltKeyDown', this.isAltKeyDown);
  }

  public getIsAltKeyDown(): boolean {
    return this.isAltKeyDown;
  }

  /**
   * 处理 alt 键盘事件
   * @param keyEvent
   * @returns 是否处理altKey事件
   */
  public handleAltKey(keyEvent: IKeyEvent): boolean {
    if (keyEvent.keyCode !== KeyCode.KEYCODE_ALT_LEFT && keyEvent.keyCode !== KeyCode.KEYCODE_ALT_RIGHT) {
      return false;
    }
    if (this.isAltKeyDown !== (keyEvent.type === 0)) {
      this.isAltKeyDown = !this.isAltKeyDown;
      AppStorage.setOrCreate<boolean>('isAltKeyDown', this.isAltKeyDown);
      log.showInfo(`AltKey change to: ${this.isAltKeyDown}`);
    }
    return true;
  }

  public async dispatchKeyEvent(event: IKeyEvent, isFromRightMenu: boolean = false): Promise<void> {
    log.showInfo(`dispatchKeyEvent: ${event.keyCode} ${event.type}`);
    if (event.keyCode === KeyCodeConstants.KEYCODE_CTRL || event.keyCode === KeyCodeConstants.KEYCODE_CTRL_RIGHT) {
      let currCtrlDown = event.type === 0 ? true : false;
      if (this.isCtrlDown !== currCtrlDown) {
        log.showInfo(`ctrl key state changed: ${currCtrlDown}`);
        this.isCtrlDown = currCtrlDown;
        AppStorage.setOrCreate<boolean>('isCtrlKeyDown', this.isCtrlDown);
      }
      return;
    }
    if (event.keyCode === KeyCodeConstants.KEYCODE_SHIFT_LEFT ||
    event.keyCode === KeyCodeConstants.KEYCODE_SHIFT_RIGHT) {
      this.shiftStatus.set(event.keyCode, event.type);
      const currShiftDown: boolean = this.getShiftStatus();
      if (this.isShiftDown !== currShiftDown) {
        this.isShiftDown = currShiftDown;
        log.showInfo(`shift key state changed: ${currShiftDown}`);
        AppStorage.setOrCreate('isShiftKeyDown', this.isShiftDown);
      }
      return;
    }

    if (this.handleAltKey(event)) {
      return;
    }
    if (event.type === 1) {
      if (event.keyCode === KeyCodeConstants.KEYCODE_V) {
        this.isVKeyPressed = false;
      }
      return;
    }
    // filter key up event
    this.doKeyEvent(event.keyCode, isFromRightMenu);
  }

  private getShiftStatus(): boolean {
    const leftShiftStatus: number | undefined = this.shiftStatus.get(KeyCodeConstants.KEYCODE_SHIFT_LEFT);
    const rightShiftStatus: number | undefined = this.shiftStatus.get(KeyCodeConstants.KEYCODE_SHIFT_RIGHT);
    if (leftShiftStatus === KeyState.DOWN || rightShiftStatus === KeyState.DOWN) {
      return true;
    }
    return false;
  }

  private doKeyEvent(keyCode: number, isFromRightMenu: boolean): void {
    switch (keyCode) {
      case KeyCodeConstants.KEYCODE_ENTER:
        this.doEnterEvent();
        break;
      case KeyCodeConstants.KEYCODE_DELETE:
        this.doDeleteEvent();
        break;
      case KeyCodeConstants.KEYCODE_F2:
        this.doF2Event();
        break;
      case KeyCodeConstants.KEYCODE_C:
        this.doCtrlCEvent();
        break;
      case KeyCodeConstants.KEYCODE_V:
        this.doCtrlVEvent();
        break;
      case KeyCodeConstants.KEYCODE_X:
        this.doCtrlXEvent();
        break;
      case KeyCodeConstants.KEYCODE_A:
        this.doCtrlAEvent();
        break;
      case KeyCodeConstants.KEYCODE_D:
        this.doCtrlDEvent();
        break;
      case KeyCodeConstants.KEYCODE_Z:
        this.doCtrlZEvent();
        break;
      case KeyCodeConstants.KEYCODE_Y:
        this.doCtrlYEvent();
        break;
      case KeyCodeConstants.KEYCODE_U:
        this.doUEvent(isFromRightMenu);
        break;
      case KeyCodeConstants.KEYCODE_R:
        this.doREvent(isFromRightMenu);
        break;
      case KeyCodeConstants.KEYCODE_N:
        this.doCtrlShiftNEvent();
        break;
      case KeyCodeConstants.KEYCODE_DPAD_UP:
      case KeyCodeConstants.KEYCODE_DPAD_DOWN:
      case KeyCodeConstants.KEYCODE_DPAD_RIGHT:
      case KeyCodeConstants.KEYCODE_DPAD_LEFT:
        this.doDirectionsEvent();
        break;
      case KeyCode.KEYCODE_SPACE:
        this.sendKeyEvent(KeyEventConstants.EVENT_SPACE);
        break;
      case KeyCode.KEYCODE_ESCAPE:
        this.sendKeyEvent(KeyCode.KEYCODE_ESCAPE.toString());
      default:
        break;
    }
  }

  private doCtrlZEvent(): void {
    if (this.isCtrlDown) {
      log.showInfo('ctrl z event coming');
      this.sendKeyEvent(KeyEventConstants.EVENT_CTRL_Z);
    }
  }

  private doCtrlYEvent(): void {
    if (this.isCtrlDown) {
      log.showInfo('ctrl y event coming');
      this.sendKeyEvent(KeyEventConstants.EVENT_CTRL_Y);
    }
  }

  private doEnterEvent(): void {
    log.showInfo(`enter event coming, isAltKeyDown:${this.isAltKeyDown}`);
    if (this.isAltKeyDown) {
      this.sendKeyEvent(KeyEventConstants.EVENT_ALT_ENTER);
       return;
    }
    this.sendKeyEvent(KeyEventConstants.EVENT_ENTER);
  }

  private doDeleteEvent(): void {
    log.showInfo('delete event coming');
    this.sendKeyEvent(this.isShiftDown ? KeyEventConstants.EVENT_FORCE_DELETE : KeyEventConstants.EVENT_DELETE);
  }

  private doF2Event(): void {
    log.showInfo('f2 event coming');
    this.sendKeyEvent(KeyEventConstants.EVENT_F2);
  }

  private doCtrlCEvent(): void {
    if (this.isCtrlDown) {
      log.showInfo('ctrl c event coming');
      this.sendKeyEvent(KeyEventConstants.EVENT_CTRL_C);
    }
  }

  private doCtrlVEvent(): void {
    if (!this.isCtrlAndVAvailable || this.isVKeyPressed) {
      // 仅ctrl+V从抬起到按下时触发，每两次触发之间添加防抖逻辑，此处防止日志堆积省略打印
      return;
    }
    this.isCtrlAndVAvailable = false;
    this.isVKeyPressed = true;
    const timeBox = setTimeout(() => {
      this.isCtrlAndVAvailable = true;
      clearTimeout(timeBox);
    }, ANTI_SHAKE_DELAY_TIME);
    if (this.isCtrlDown) {
      log.showInfo('ctrl v event coming');
      this.sendKeyEvent(KeyEventConstants.EVENT_CTRL_V);
    }
  }

  private doCtrlAEvent(): void {
    if (this.isCtrlDown) {
      log.showInfo('ctrl A event coming');
      this.sendKeyEvent(KeyEventConstants.EVENT_CTRL_A);
    }
  }

  private doCtrlXEvent(): void {
    if (this.isCtrlDown) {
      log.showInfo('ctrl x event coming');
      this.sendKeyEvent(KeyEventConstants.EVENT_CTRL_X);
    }
  }

  private doCtrlDEvent(): void {
    if (this.isCtrlDown) {
      log.showInfo('ctrl d event coming');
      this.sendKeyEvent(KeyEventConstants.EVENT_CTRL_D);
    }
  }

  private doUEvent(isFromRightMenu: boolean): void {
    log.showInfo(`right menu U event coming, isFromRightMenu: ${isFromRightMenu}`);
    if (isFromRightMenu) {
      this.sendKeyEvent(KeyEventConstants.EVENT_U);
    }
  }

  private doREvent(isFromRightMenu: boolean): void {
    log.showInfo(`right menu R event coming, isFromRightMenu: ${isFromRightMenu}`);
    if (isFromRightMenu) {
      this.sendKeyEvent(KeyEventConstants.EVENT_R);
    }
  }

  private doCtrlShiftNEvent(): void {
    if (this.isCtrlDown && this.isShiftDown) {
      log.showInfo('ctrl shift n event coming');
      this.sendKeyEvent(KeyEventConstants.EVENT_CTRL_SHIFT_N);
    }
  }

  private doDirectionsEvent(): void {
    log.showInfo('doDirectionsEvent event coming');
    this.sendKeyEvent(KeyEventConstants.EVENT_DPAD_UP);
  }

  public sendKeyEvent(event: string): void {
    log.showInfo('sendKeyEvent with : ' + event);
    let listeners = this.mKeyEventListeners[event];
    if (!ObjUtil.isInvalid(listeners)) {
      log.showInfo(`sendKeyEvent ok: ${JSON.stringify(listeners)}}`);
      for (const listener of listeners) {
        listener.onReceiveKeyEvent(event);
      }
    } else {
      log.showInfo('sendKeyEvent failed, no listeners');
    }
  }

  public async sendAsyncEvent(event: string): Promise<void> {
    log.showInfo('sendAsyncKeyEvent with : ' + event);
    this.sendKeyEvent(event);
  }
}

const keyEventManager = KeyEventManager.getInstance();

export default keyEventManager;

export interface IKeyEvent {
  keyCode: number;
  type: number;
}