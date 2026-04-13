/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import keyCodeConstants from './constants/KeyCodeConstants';
import inputConsumer from '@ohos.multimodalInput.inputConsumer'
import inputMonitor from '@ohos.multimodalInput.inputMonitor';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, localEventManager } from '@ohos/frameworkwrapper';
import { scbGestureManager, SCBSceneSessionManager } from '@ohos/windowscene';
import EventConstants from './constants/EventConstants'
import commonEventManager from '@ohos.commonEventManager';
import Constants from './constants/Constants';
import { KeyCode } from '@kit.InputKit';
import KeyCodeConstants from './constants/KeyCodeConstants';
import { KeyEvent } from '@ohos.multimodalInput.keyEvent';
import { Action } from '@ohos.multimodalInput.keyEvent';
import { ModeChangeUtils } from '@ohos/frameworkwrapper/src/main/ets/utils/ModeChangeUtils';
import CommonEventManager from '@ohos.commonEventManager';
import { MouseEvent } from '@ohos.multimodalInput.mouseEvent';

const TAG = 'MultiInputManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

class MultiInputManager {

  private fnBrightnessDownOption: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCode.KEYCODE_BRIGHTNESS_DOWN,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  private fnBrightnessUpOption: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCode.KEYCODE_BRIGHTNESS_UP,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  private fnSysrqOption: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCode.KEYCODE_SYSRQ,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  private altLeftUpOption: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCode.KEYCODE_ALT_LEFT,
    isFinalKeyDown: false,
    finalKeyDownDuration: 0
  };

  private altRightUpOption: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCode.KEYCODE_ALT_RIGHT,
    isFinalKeyDown: false,
    finalKeyDownDuration: 0
  };

  private tabUpOption: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCode.KEYCODE_TAB,
    isFinalKeyDown: false,
    finalKeyDownDuration: 0
  };

  // left WIN + left CTRL + DOWN
  private leftWinLeftCtrlDownOption: inputConsumer.KeyOptions = {
    preKeys: [KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_CTRL_LEFT],
    finalKey: KeyCode.KEYCODE_DPAD_DOWN,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
    isRepeat: false
  };

  // left WIN + right CTRL + DOWN
  private leftWinRightCtrlDownOption: inputConsumer.KeyOptions = {
    preKeys: [KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_CTRL_RIGHT],
    finalKey: KeyCode.KEYCODE_DPAD_DOWN,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
    isRepeat: false
  };

  // right WIN + left CTRL + DOWN
  private rightWinLeftCtrlDownOption: inputConsumer.KeyOptions = {
    preKeys: [KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_CTRL_LEFT],
    finalKey: KeyCode.KEYCODE_DPAD_DOWN,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
    isRepeat: false
  };

  // right WIN + right CTRL + DOWN
  private rightWinRightCtrlDownOption: inputConsumer.KeyOptions = {
    preKeys: [KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_CTRL_RIGHT],
    finalKey: KeyCode.KEYCODE_DPAD_DOWN,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
    isRepeat: false
  };

  // left WIN + left CTRL + UP
  private leftWinLeftCtrlUPOption: inputConsumer.KeyOptions = {
    preKeys: [KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_CTRL_LEFT],
    finalKey: KeyCode.KEYCODE_DPAD_UP,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
    isRepeat: false
  };

  // left WIN + right CTRL + UP
  private leftWinRightCtrlUPOption: inputConsumer.KeyOptions = {
    preKeys: [KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_CTRL_RIGHT],
    finalKey: KeyCode.KEYCODE_DPAD_UP,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
    isRepeat: false
  };

  // right WIN + left CTRL + UP
  private rightWinLeftCtrlUPOption: inputConsumer.KeyOptions = {
    preKeys: [KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_CTRL_LEFT],
    finalKey: KeyCode.KEYCODE_DPAD_UP,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
    isRepeat: false
  };

  // right WIN + right CTRL + UP
  private rightWinRightCtrlUPOption: inputConsumer.KeyOptions = {
    preKeys: [KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_CTRL_RIGHT],
    finalKey: KeyCode.KEYCODE_DPAD_UP,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
    isRepeat: false
  };

  private isRegisteredInputEvent: boolean = false;
  private multiInputSubscriber: commonEventManager.CommonEventSubscriber[] = [];

  /**
   * 获取多模输入事件管理类对象
   *
   * @return 多模输入事件管理类对象单一实例
   */
  static getInstance(): MultiInputManager {
    if (globalThis.multiInputManager == null) {
      log.showInfo('getInstance');
      globalThis.multiInputManager = new MultiInputManager();
    }
    return globalThis.multiInputManager;
  }

  /**
   * 创建快捷键帮助页面公共事件动态订阅, 键盘设置发布此事件
   * @returns
   */
  public createMultiInputSubscriber(bundleName: string, eventName: string): void {
    let subscribeInfo: CommonEventManager.CommonEventSubscribeInfo = {
      events: [eventName],
      publisherPermission: Constants.PCSETTING_SYSTEM_BASIC_PERMISSION,
      publisherBundleName: bundleName
    };
    commonEventManager.createSubscriber(subscribeInfo, (err, commonEventSubscriber) => {
      if (err) {
        log.showError(`Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
        return;
      }
      this.multiInputSubscriber.push(commonEventSubscriber);
      this.subscribeMultiInputEvent(eventName, commonEventSubscriber);
      log.showInfo('Succeeded in creating subscriber.');
    });
  }

  private subscribeMultiInputEvent(eventStr: string, commonEventInfo: commonEventManager.CommonEventSubscriber): void {
    commonEventManager.subscribe(commonEventInfo, (err, data) => {
      log.showInfo(`event subscribe --- ${data?.event}`);
      if (err) {
        log.showError(`Failed to subscribe common event. Code is ${err.code}, message is ${err.message}`);
        return;
      }
      if (data.event === eventStr) {
        AppStorage.setOrCreate('isShortcutKeyPanelShow', true);
      }
    });
  }

  private miSendLocalEventSticky(eventName: string, param: MouseEvent | null = null): void {
    try {
      localEventManager.sendLocalEventSticky(eventName, param);
    } catch(error) {
      log.showError(`[ERROR]sendLocalEventSticky: ${error}`);
    }
  }

  public registerFnF1Event(brightDownCallback: () => void): void {
    try {
      inputConsumer.on('key', this.fnBrightnessDownOption, callback => {
        log.showInfo(`register singleKey, keyCode: [${KeyCode.KEYCODE_BRIGHTNESS_DOWN}], keyAction Down: true,
        inputEvent: ${EventConstants.EVENT_FN_BRIGHTNESS_DOWN}`);
        brightDownCallback();
        log.showInfo('brightnessDownCallback');
        this.miSendLocalEventSticky(EventConstants.EVENT_FN_BRIGHTNESS_DOWN, null);
      });
    } catch (error) {
      log.showError(`[inputConsumer] ERROR: ${error}, register KC: [${KeyCode.KEYCODE_BRIGHTNESS_DOWN}]`);
    }
  }

  public unregisterFnF1Event(): void {
    try {
      inputConsumer.off('key', this.fnBrightnessDownOption);
      log.showInfo(`unRegister combinationKey: [${KeyCode.KEYCODE_BRIGHTNESS_DOWN}], keyAction Down: true,
        inputEvent: ${EventConstants.EVENT_FN_BRIGHTNESS_DOWN}`);
    } catch (error) {
      log.showError(`[inputConsumer] ERROR: ${error}, unRegister KC: [${KeyCode.KEYCODE_BRIGHTNESS_DOWN}]`);
    }
  }

  public registerFnSysrqEvent(): void {
    try {
      inputConsumer.on('key', this.fnSysrqOption, () => {
        log.showInfo(`register singleKey, keyCode: [${KeyCode.KEYCODE_SYSRQ}], keyAction Down: true,
          inputEvent: ${EventConstants.EVENT_FN_SYSRQ}`);
        this.miSendLocalEventSticky(EventConstants.EVENT_FN_SYSRQ, null);
      });
    } catch (error) {
      log.showError(`[inputConsumer] ERROR: ${error}, register KC: [${KeyCode.KEYCODE_SYSRQ}]`);
    }
  }

  public unRegisterFnSysrqEvent(): void {
    try {
      inputConsumer.off('key', this.fnSysrqOption);
      log.showInfo(`unRegister combinationKey: [${KeyCode.KEYCODE_SYSRQ}], keyAction Down: true,
        inputEvent: ${EventConstants.EVENT_FN_SYSRQ}`);
    } catch (error) {
      log.showError(`[inputConsumer] ERROR: ${error}, unRegister KC: [${KeyCode.KEYCODE_SYSRQ}]`);
    }
  }

  public registerFnF2Event(brightUpCallback: () => void): void {
    try {
      inputConsumer.on('key', this.fnBrightnessUpOption, callback => {
        log.showInfo(`register singleKey, keyCode: [${KeyCode.KEYCODE_BRIGHTNESS_UP}], keyAction Down: true,
          inputEvent: ${EventConstants.EVENT_FN_BRIGHTNESS_UP}`);
        brightUpCallback();
        log.showInfo('brightnessUpCallback');
        this.miSendLocalEventSticky(EventConstants.EVENT_FN_BRIGHTNESS_UP, null);
      });
    } catch (error) {
      log.showError(`[inputConsumer] ERROR: ${error}, register KC: [${KeyCode.KEYCODE_BRIGHTNESS_UP}]`);
    }
  }

  public unregisterFnF2Event(): void {
    try {
      inputConsumer.off('key', this.fnBrightnessUpOption);
      log.showInfo(`unRegister combinationKey: [${KeyCode.KEYCODE_BRIGHTNESS_UP}], keyAction Down: true,
        inputEvent: ${EventConstants.EVENT_FN_BRIGHTNESS_UP}`);
    } catch (error) {
      log.showError(`[inputConsumer] ERROR: ${error}, unRegister KC: [${KeyCode.KEYCODE_BRIGHTNESS_UP}]`);
    }
  }

  public registerAltUpEvent(): void {
    try {
      inputConsumer.on('key', this.altLeftUpOption, callback => {
        log.showInfo(`register singleKey, keyCode: [${KeyCode.KEYCODE_ALT_LEFT}], keyAction Down: false, inputEvent:
        ${EventConstants.EVENT_ALT_UP}`);
        this.miSendLocalEventSticky(EventConstants.EVENT_ALT_UP, null);
      });
    } catch (error) {
      log.showError(`[inputConsumer] ERROR: ${error}, register KC: [${KeyCode.KEYCODE_ALT_LEFT}]`);
    }
    try {
      inputConsumer.on('key', this.altRightUpOption, callback => {
        log.showInfo(`register singleKey, keyCode: [${KeyCode.KEYCODE_ALT_RIGHT}], keyAction Down: false,
        inputEvent: ${EventConstants.EVENT_ALT_UP}`);
        this.miSendLocalEventSticky(EventConstants.EVENT_ALT_UP, null);
      });
    } catch (error) {
      log.showError(`[inputConsumer] ERROR: ${error}, register KC: [${KeyCode.KEYCODE_ALT_RIGHT}]`);
    }
  }

  public unRegisterAltUpEvent(): void {
    try {
      inputConsumer.off('key', this.altLeftUpOption);
      log.showInfo(`unRegister singleKey, keyCode: [${KeyCode.KEYCODE_ALT_LEFT}], keyAction Down: false,
        inputEvent: ${EventConstants.EVENT_ALT_UP}`);
    } catch (error) {
      log.showError(`[inputConsumer] ERROR: ${error}, unRegister KC: [${KeyCode.KEYCODE_ALT_LEFT}]`);
    }
    try {
      inputConsumer.off('key', this.altRightUpOption);
      log.showInfo(`unRegister singleKey, keyCode: [${KeyCode.KEYCODE_ALT_RIGHT}], keyAction Down: false,
        inputEvent: ${EventConstants.EVENT_ALT_UP}`);
    } catch (error) {
      log.showError(`[inputConsumer] ERROR: ${error}, unRegister KC: [${KeyCode.KEYCODE_ALT_RIGHT}]`);
    }
  }

  public registerTabUpEvent(): void {
    try {
      inputConsumer.on('key', this.tabUpOption, callback => {
        log.showInfo(`register singleKey, keyCode: [${KeyCode.KEYCODE_TAB}], keyAction Down: false,
        inputEvent: ${EventConstants.EVENT_TAB_UP}`);
        this.miSendLocalEventSticky(EventConstants.EVENT_TAB_UP, null);
      });
    } catch (error) {
      log.showError(`[inputConsumer] ERROR: ${error}, register KC: [${KeyCode.KEYCODE_TAB}]`);
    }
  }

  public unRegisterTabUpEvent(): void {
    try {
      inputConsumer.off('key', this.tabUpOption);
      log.showInfo(`unRegister singleKey, keyCode: [${KeyCode.KEYCODE_TAB}], keyAction Down: false,
        inputEvent: ${EventConstants.EVENT_TAB_UP}`);
    } catch (error) {
      log.showError(`[inputConsumer] ERROR: ${error}, unRegister KC: [${KeyCode.KEYCODE_TAB}]`);
    }
  }

  private registerSingleKeyEvent(finalKeyDown: number, repeatState: boolean, keyEvent: string, keyDown: boolean): void {
    try {
      let keyPressOption: inputConsumer.KeyOptions = {
        preKeys: [],
        finalKey: finalKeyDown,
        isFinalKeyDown: keyDown,
        finalKeyDownDuration: 0,
        isRepeat: repeatState
      };
      inputConsumer.on('key', keyPressOption, callback => {
        log.showInfo(`register singleKey, keyCode: [${finalKeyDown}], keyAction Down: ${keyDown},
        inputEvent: ${keyEvent}`);
        this.miSendLocalEventSticky(keyEvent, null);
      });
    } catch (error) {
      log.showError(`[inputConsumer] ERROR: ${error}, register KC: [${finalKeyDown}]`);
    }
  }

  private unRegisterSingleKeyEvent(finalKeyDown: number, repeatState: boolean, keyEvent: string, keyDown: boolean):
    void {
    try {
      let keyPressOption: inputConsumer.KeyOptions = {
        preKeys: [],
        finalKey: finalKeyDown,
        isFinalKeyDown: keyDown,
        finalKeyDownDuration: 0,
        isRepeat: repeatState
      };
      inputConsumer.off('key', keyPressOption);
      log.showInfo(`unRegister singleKey, keyCode: [${finalKeyDown}], keyAction Down: ${keyDown},
      inputEvent: ${keyEvent}`);
    } catch (error) {
      log.showError(`[inputConsumer] ERROR: ${error}, unRegister KC: [${finalKeyDown}]`);
    }
  }

  private registerDoubleCombinationKeyEvent(preKeyDown: number, finalKeyDown: number, repeatState: boolean,
    keyEvent: string, keyDown: boolean, pressState?: string): void {
    try {
      let keyPressOption: inputConsumer.KeyOptions = {
        preKeys: [preKeyDown],
        finalKey: finalKeyDown,
        isFinalKeyDown: keyDown,
        finalKeyDownDuration: 0,
        isRepeat: repeatState
      };
      inputConsumer.on('key', keyPressOption, callback => {
        log.showInfo(`register combinationKey, keyCode: [${preKeyDown}, ${finalKeyDown}], keyAction Down: ${keyDown},
      inputEvent: ${keyEvent}`);
        if (pressState) {
          log.showInfo(`pressState: ${pressState}`);
          AppStorage.setOrCreate(pressState, true);
        }
        this.miSendLocalEventSticky(keyEvent, null);
      });
    } catch (error) {
      log.showError(`[inputConsumer] ERROR: ${error}, register KC: [${preKeyDown}, ${finalKeyDown}]`);
    }
  }

  private unRegisterDoubleCombinationKeyEvent(preKeyDown: number, finalKeyDown: number, repeatState: boolean,
    keyEvent: string, keyDown: boolean): void {
    try {
      let keyPressOption: inputConsumer.KeyOptions = {
        preKeys: [preKeyDown],
        finalKey: finalKeyDown,
        isFinalKeyDown: keyDown,
        finalKeyDownDuration: 0,
        isRepeat: repeatState
      };
      inputConsumer.off('key', keyPressOption);
      log.showInfo(`unRegister combinationKey: [${preKeyDown}, ${finalKeyDown}], keyAction Down: ${keyDown}` +
        `,inputEvent: ${keyEvent}`);
    } catch (error) {
      log.showError(`[inputConsumer] ERROR: ${error}, unRegister KC: [${preKeyDown}, ${finalKeyDown}]`);
    }
  }

  private registerTripleCombinationKeyEvent(preKey1stDown: number, preKey2ndDown: number, finalKeyDown: number,
    repeatState: boolean, keyEvent: string, keyDown: boolean): void {
    try {
      let keyPressOption: inputConsumer.KeyOptions = {
        preKeys: [preKey1stDown, preKey2ndDown],
        finalKey: finalKeyDown,
        isFinalKeyDown: keyDown,
        finalKeyDownDuration: 0,
        isRepeat: repeatState
      };
      inputConsumer.on('key', keyPressOption, callback => {
        log.showInfo(`register combinationKey: [${preKey1stDown}, ${preKey2ndDown}, ${finalKeyDown}],
      keyAction Down: ${keyDown}, inputEvent: ${keyEvent}`);
        this.miSendLocalEventSticky(keyEvent, null);
      });
    } catch (error) {
      log.showError(`[inputConsumer] ERROR: ${error}, register KC: [${preKey1stDown}, ${preKey2ndDown},
      ${finalKeyDown}]`);
    }
  }

  private unRegisterTripleCombinationKeyEvent(preKey1stDown: number, preKey2ndDown: number, finalKeyDown: number,
    repeatState: boolean, keyEvent: string, keyDown: boolean): void {
    try {
      let keyPressOption: inputConsumer.KeyOptions = {
        preKeys: [preKey1stDown, preKey2ndDown],
        finalKey: finalKeyDown,
        isFinalKeyDown: keyDown,
        finalKeyDownDuration: 0,
        isRepeat: repeatState
      };
      inputConsumer.off('key', keyPressOption);
      log.showInfo(`unRegister combinationKey: [${preKey1stDown}, ${preKey2ndDown}, ${finalKeyDown}],
        keyAction Down: ${keyDown}, inputEvent: ${keyEvent}`);
    } catch (error) {
      log.showError(`[inputConsumer] ERROR: ${error}, unRegister KC: [${preKey1stDown}, ${preKey2ndDown},
      ${finalKeyDown}]`);
    }
  }

  private onDockDisplayStatusChange = (mouseEvent: MouseEvent) => {
    log.showInfo('Dock display status change');
    this.miSendLocalEventSticky(EventConstants.EVENT_DOCK_DISPLAY_STATUS_CHANGE, mouseEvent);
  }

  private onCSideTitleStatusChange = (mouseEvent: MouseEvent) => {
    log.showInfo('C side title status change');
    this.miSendLocalEventSticky(EventConstants.EVENT_C_SIDE_TITLE_STATUS_CHANGE, mouseEvent);
  }

  private registerMouseEvent(): void {
    try {
      inputMonitor.on('mouse', this.onDockDisplayStatusChange);
    } catch (error) {
      log.showError(`[inputMonitor] registerMouseEvent ERROR: ${error}`);
    }
  }

  private registerFnKeyInputEvent(): void {
    this.registerSingleKeyEvent(KeyCode.KEYCODE_MUTE, false, EventConstants.EVENT_FN_MUTE, true);
    this.registerSingleKeyEvent(KeyCode.KEYCODE_SWITCHVIDEOMODE, false, EventConstants.EVENT_FN_SWITCHVIDEOMODE, true);
    this.registerSingleKeyEvent(KeyCode.KEYCODE_MEDIA_RECORD, false, EventConstants.EVENT_FN_MEDIA_RECORD, true);
    if (DeviceHelper.isPhone()) {
      this.registerFnSysrqEvent();
    }
  }

  private registerKeyInputEventPConly(): void {
    this.registerSingleKeyEvent(KeyCode.KEYCODE_META_LEFT, false, EventConstants.EVENT_WIN_UP, false);
    this.registerSingleKeyEvent(KeyCode.KEYCODE_META_RIGHT, false, EventConstants.EVENT_WIN_UP, false);
    this.registerSingleKeyEvent(keyCodeConstants.KEYCODE_SEARCH, false, EventConstants.EVENT_FN_SEARCH, true);
    this.registerSingleKeyEvent(KeyCodeConstants.KEYCODE_HOME, false, EventConstants.EVENT_FN_BROWSER, true);
    this.registerSingleKeyEvent(KeyCodeConstants.KEYCODE_ENVELOPE, false, EventConstants.EVENT_FN_EMAIL, true);
    this.registerSingleKeyEvent(KeyCodeConstants.KEYCODE_CALC, false, EventConstants.EVENT_FN_CALCULATOR, true);
    this.registerSingleKeyEvent(KeyCodeConstants.KEYCODE_CONFIG, false, EventConstants.EVENT_FN_MUSIC, true);
    this.registerSingleKeyEvent(KeyCodeConstants.KEYCODE_FILE, false, EventConstants.EVENT_WIN_F, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_A, false,
      EventConstants.EVENT_WIN_A, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_A, false,
      EventConstants.EVENT_WIN_A, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_C, false,
      EventConstants.EVENT_WIN_C, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_C, false,
      EventConstants.EVENT_WIN_C, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_D, false,
      EventConstants.EVENT_WIN_D, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_D, false,
      EventConstants.EVENT_WIN_D, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_N, false,
      EventConstants.EVENT_WIN_N, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_N, false,
      EventConstants.EVENT_WIN_N, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_TAB, false,
      EventConstants.EVENT_WIN_TAB, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_TAB, false,
      EventConstants.EVENT_WIN_TAB, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_CTRL_LEFT, KeyCode.KEYCODE_SHIFT_LEFT,
      KeyCode.KEYCODE_ESCAPE, false, EventConstants.EVENT_CTRL_SHIFT_ESC, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_CTRL_LEFT, KeyCode.KEYCODE_SHIFT_RIGHT,
      KeyCode.KEYCODE_ESCAPE, false, EventConstants.EVENT_CTRL_SHIFT_ESC, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_CTRL_RIGHT, KeyCode.KEYCODE_SHIFT_LEFT,
      KeyCode.KEYCODE_ESCAPE, false, EventConstants.EVENT_CTRL_SHIFT_ESC, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_CTRL_RIGHT, KeyCode.KEYCODE_SHIFT_RIGHT,
      KeyCode.KEYCODE_ESCAPE, false, EventConstants.EVENT_CTRL_SHIFT_ESC, true);
  }

  private registerCombinationKeyInputEvent(): void {
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_ALT_LEFT, KeyCode.KEYCODE_F4, false,
      EventConstants.EVENT_ALT_F4, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_ALT_RIGHT, KeyCode.KEYCODE_F4, false,
      EventConstants.EVENT_ALT_F4, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_F, false,
      EventConstants.EVENT_WIN_F, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_F, false,
      EventConstants.EVENT_WIN_F, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_M, false,
      EventConstants.EVENT_WIN_M, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_M, false,
      EventConstants.EVENT_WIN_M, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_S, false,
      EventConstants.EVENT_WIN_S, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_S, false,
      EventConstants.EVENT_WIN_S, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_SLASH, false,
      EventConstants.EVENT_WIN_SLASH, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_SLASH, false,
      EventConstants.EVENT_WIN_SLASH, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_ALT_LEFT, KeyCode.KEYCODE_TAB, true,
      EventConstants.EVENT_ALT_TAB, true, 'altTab');
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_ALT_RIGHT, KeyCode.KEYCODE_TAB, true,
      EventConstants.EVENT_ALT_TAB, true, 'altTab');
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_DEL, false,
      EventConstants.EVENT_WIN_BACKSPACE, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_DEL, false,
      EventConstants.EVENT_WIN_BACKSPACE, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_SHIFT_LEFT,
      KeyCode.KEYCODE_S, false, EventConstants.EVENT_WIN_SHIFT_S, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_SHIFT_LEFT, KeyCode.KEYCODE_S,
      false, EventConstants.EVENT_WIN_SHIFT_S, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_SHIFT_RIGHT, KeyCode.KEYCODE_S,
      false, EventConstants.EVENT_WIN_SHIFT_S, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_SHIFT_RIGHT, KeyCode.KEYCODE_S,
      false, EventConstants.EVENT_WIN_SHIFT_S, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_SHIFT_LEFT, KeyCode.KEYCODE_R,
      false, EventConstants.EVENT_WIN_SHIFT_R, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_SHIFT_LEFT, KeyCode.KEYCODE_R,
      false, EventConstants.EVENT_WIN_SHIFT_R, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_SHIFT_RIGHT, KeyCode.KEYCODE_R,
      false, EventConstants.EVENT_WIN_SHIFT_R, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_SHIFT_RIGHT, KeyCode.KEYCODE_R,
      false, EventConstants.EVENT_WIN_SHIFT_R, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_ALT_LEFT, KeyCode.KEYCODE_SHIFT_LEFT, KeyCode.KEYCODE_F4,
      false, EventConstants.EVENT_ALT_SHIFT_F4, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_ALT_LEFT, KeyCode.KEYCODE_SHIFT_RIGHT, KeyCode.KEYCODE_F4,
      false, EventConstants.EVENT_ALT_SHIFT_F4, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_ALT_RIGHT, KeyCode.KEYCODE_SHIFT_LEFT, KeyCode.KEYCODE_F4,
      false, EventConstants.EVENT_ALT_SHIFT_F4, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_ALT_RIGHT, KeyCode.KEYCODE_SHIFT_RIGHT, KeyCode.KEYCODE_F4,
      false, EventConstants.EVENT_ALT_SHIFT_F4, true);
    if (DeviceHelper.is2In1DevicePcType()) {
      this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_L, false,
        EventConstants.EVENT_WIN_L, true);
    }
  }

  private unRegisterFnKeyInputEvent(): void {
    this.unRegisterSingleKeyEvent(KeyCode.KEYCODE_MUTE, false, EventConstants.EVENT_FN_MUTE, true);
    this.unRegisterSingleKeyEvent(KeyCode.KEYCODE_SWITCHVIDEOMODE, false,
      EventConstants.EVENT_FN_SWITCHVIDEOMODE, true);
    this.unRegisterSingleKeyEvent(KeyCode.KEYCODE_MEDIA_RECORD, false, EventConstants.EVENT_FN_MEDIA_RECORD, true);
    if (DeviceHelper.isPhone()) {
      this.unRegisterFnSysrqEvent();
    }
  }

  private unRegisterKeyInputEventPConly(): void {
    this.unRegisterSingleKeyEvent(KeyCode.KEYCODE_META_LEFT, false, EventConstants.EVENT_WIN_UP, false);
    this.unRegisterSingleKeyEvent(KeyCode.KEYCODE_META_RIGHT, false, EventConstants.EVENT_WIN_UP, false);
    this.unRegisterSingleKeyEvent(KeyCodeConstants.KEYCODE_SEARCH, false, EventConstants.EVENT_FN_SEARCH, true);
    this.unRegisterSingleKeyEvent(KeyCodeConstants.KEYCODE_HOME, false, EventConstants.EVENT_FN_BROWSER, true);
    this.unRegisterSingleKeyEvent(KeyCodeConstants.KEYCODE_ENVELOPE, false, EventConstants.EVENT_FN_EMAIL, true);
    this.unRegisterSingleKeyEvent(KeyCodeConstants.KEYCODE_CALC, false, EventConstants.EVENT_FN_CALCULATOR, true);
    this.unRegisterSingleKeyEvent(KeyCodeConstants.KEYCODE_CONFIG, false, EventConstants.EVENT_FN_MUSIC, true);
    this.unRegisterSingleKeyEvent(KeyCodeConstants.KEYCODE_FILE, false, EventConstants.EVENT_WIN_F, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_A, false,
      EventConstants.EVENT_WIN_A, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_A, false,
      EventConstants.EVENT_WIN_A, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_C, false,
      EventConstants.EVENT_WIN_C, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_C, false,
      EventConstants.EVENT_WIN_C, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_D, false,
      EventConstants.EVENT_WIN_D, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_D, false,
      EventConstants.EVENT_WIN_D, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_N, false,
      EventConstants.EVENT_WIN_N, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_N, false,
      EventConstants.EVENT_WIN_N, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_TAB, false,
      EventConstants.EVENT_WIN_TAB, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_TAB, false,
      EventConstants.EVENT_WIN_TAB, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_CTRL_LEFT, KeyCode.KEYCODE_SHIFT_LEFT,
      KeyCode.KEYCODE_ESCAPE, false, EventConstants.EVENT_CTRL_SHIFT_ESC, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_CTRL_LEFT, KeyCode.KEYCODE_SHIFT_RIGHT,
      KeyCode.KEYCODE_ESCAPE, false, EventConstants.EVENT_CTRL_SHIFT_ESC, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_CTRL_RIGHT, KeyCode.KEYCODE_SHIFT_LEFT,
      KeyCode.KEYCODE_ESCAPE, false, EventConstants.EVENT_CTRL_SHIFT_ESC, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_CTRL_RIGHT, KeyCode.KEYCODE_SHIFT_RIGHT,
      KeyCode.KEYCODE_ESCAPE, false, EventConstants.EVENT_CTRL_SHIFT_ESC, true);
  }

  private unRegisterCombinationKeyInputEvent(): void {
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_ALT_LEFT, KeyCode.KEYCODE_F4, false,
      EventConstants.EVENT_ALT_F4, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_ALT_RIGHT, KeyCode.KEYCODE_F4, false,
      EventConstants.EVENT_ALT_F4, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_F, false,
      EventConstants.EVENT_WIN_F, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_F, false,
      EventConstants.EVENT_WIN_F, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_M, false,
      EventConstants.EVENT_WIN_M, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_M, false,
      EventConstants.EVENT_WIN_M, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_S, false,
      EventConstants.EVENT_WIN_S, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_S, false,
      EventConstants.EVENT_WIN_S, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_SLASH, false,
      EventConstants.EVENT_WIN_SLASH, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_SLASH, false,
      EventConstants.EVENT_WIN_SLASH, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_ALT_LEFT, KeyCode.KEYCODE_TAB, false,
      EventConstants.EVENT_ALT_TAB, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_ALT_RIGHT, KeyCode.KEYCODE_TAB, false,
      EventConstants.EVENT_ALT_TAB, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_DEL, false,
      EventConstants.EVENT_WIN_BACKSPACE, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_DEL, false,
      EventConstants.EVENT_WIN_BACKSPACE, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_SHIFT_LEFT, KeyCode.KEYCODE_S,
      false, EventConstants.EVENT_WIN_SHIFT_S, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_SHIFT_LEFT, KeyCode.KEYCODE_S,
      false, EventConstants.EVENT_WIN_SHIFT_S, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_SHIFT_RIGHT, KeyCode.KEYCODE_S,
      false, EventConstants.EVENT_WIN_SHIFT_S, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_SHIFT_RIGHT, KeyCode.KEYCODE_S,
      false, EventConstants.EVENT_WIN_SHIFT_S, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_SHIFT_LEFT, KeyCode.KEYCODE_R,
      false, EventConstants.EVENT_WIN_SHIFT_R, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_SHIFT_LEFT, KeyCode.KEYCODE_R,
      false, EventConstants.EVENT_WIN_SHIFT_R, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_SHIFT_RIGHT, KeyCode.KEYCODE_R,
      false, EventConstants.EVENT_WIN_SHIFT_R, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_SHIFT_RIGHT, KeyCode.KEYCODE_R,
      false, EventConstants.EVENT_WIN_SHIFT_R, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_ALT_LEFT, KeyCode.KEYCODE_SHIFT_LEFT, KeyCode.KEYCODE_F4,
      false, EventConstants.EVENT_ALT_SHIFT_F4, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_ALT_LEFT, KeyCode.KEYCODE_SHIFT_RIGHT, KeyCode.KEYCODE_F4,
      false, EventConstants.EVENT_ALT_SHIFT_F4, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_ALT_RIGHT, KeyCode.KEYCODE_SHIFT_LEFT, KeyCode.KEYCODE_F4,
      false, EventConstants.EVENT_ALT_SHIFT_F4, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_ALT_RIGHT, KeyCode.KEYCODE_SHIFT_RIGHT, KeyCode.KEYCODE_F4,
      false, EventConstants.EVENT_ALT_SHIFT_F4, true);
    if (DeviceHelper.is2In1DevicePcType()) {
      this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_L, false,
        EventConstants.EVENT_WIN_L, true);
    }
  }

  public registerInputEvent(): void {
    if (this.isRegisteredInputEvent) {
      return;
    }
    this.isRegisteredInputEvent = true;
    this.registerFnKeyInputEvent();
    this.registerKeyInputEventPConly();
    this.registerCombinationKeyInputEvent();
    this.createMultiInputSubscriber(Constants.SETTING_BUNDLE_NAME, EventConstants.EVENT_SETTING_SHOW_SHORT_CUT_PANEL);
    this.createMultiInputSubscriber(Constants.PCSETTING_BUNDLENAME,
      EventConstants.EVENT_PCSETTING_SHOW_SHORT_CUT_PANEL);
    this.registerPreLogoKeyEvent();
    this.registerWinDpadKeyInput();
  }

  public unRegisterInputEvent(): void {
    log.showInfo('unRegisterInputEvent');
    if (!this.isRegisteredInputEvent) {
      return;
    }
    this.isRegisteredInputEvent = false;
    this.unRegisterFnKeyInputEvent();
    this.unRegisterKeyInputEventPConly();
    this.unRegisterCombinationKeyInputEvent();
    this.unRegisterPreLogoKeyEvent();
    this.unRegisterWinDpadKeyInput();
  }

  public register2in1InputEvent(): void {
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_CTRL_LEFT, KeyCode.KEYCODE_SHIFT_LEFT,
      KeyCode.KEYCODE_ESCAPE, false, EventConstants.EVENT_CTRL_SHIFT_ESC, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_CTRL_LEFT, KeyCode.KEYCODE_SHIFT_RIGHT,
      KeyCode.KEYCODE_ESCAPE, false, EventConstants.EVENT_CTRL_SHIFT_ESC, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_CTRL_RIGHT, KeyCode.KEYCODE_SHIFT_LEFT,
      KeyCode.KEYCODE_ESCAPE, false, EventConstants.EVENT_CTRL_SHIFT_ESC, true);
    this.registerTripleCombinationKeyEvent(KeyCode.KEYCODE_CTRL_RIGHT, KeyCode.KEYCODE_SHIFT_RIGHT,
      KeyCode.KEYCODE_ESCAPE, false, EventConstants.EVENT_CTRL_SHIFT_ESC, true);
  }

  public unregister2in1InputEvent(): void {
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_CTRL_LEFT, KeyCode.KEYCODE_SHIFT_LEFT,
      KeyCode.KEYCODE_ESCAPE, false, EventConstants.EVENT_CTRL_SHIFT_ESC, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_CTRL_LEFT, KeyCode.KEYCODE_SHIFT_RIGHT,
      KeyCode.KEYCODE_ESCAPE, false, EventConstants.EVENT_CTRL_SHIFT_ESC, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_CTRL_RIGHT, KeyCode.KEYCODE_SHIFT_LEFT,
      KeyCode.KEYCODE_ESCAPE, false, EventConstants.EVENT_CTRL_SHIFT_ESC, true);
    this.unRegisterTripleCombinationKeyEvent(KeyCode.KEYCODE_CTRL_RIGHT, KeyCode.KEYCODE_SHIFT_RIGHT,
      KeyCode.KEYCODE_ESCAPE, false, EventConstants.EVENT_CTRL_SHIFT_ESC, true);
  }

  public registerPadInputEvent(): void {
    if (this.isRegisteredInputEvent) {
      return;
    }
    this.isRegisteredInputEvent = true;
    this.registerAltUpEvent();
    this.registerFnKeyInputEvent();
    this.registerCombinationKeyInputEvent();
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_L, false,
      EventConstants.EVENT_WIN_L, true);
    this.createMultiInputSubscriber(Constants.SETTING_BUNDLE_NAME, EventConstants.EVENT_SETTING_SHOW_SHORT_CUT_PANEL);
    this.registerPreLogoKeyEvent();
    if (SCBSceneSessionManager.getInstance().isPcMode()) {
      this.register2in1InputEvent();
    }
  }

  public unRegisterPadInputEvent(): void {
    if (!this.isRegisteredInputEvent) {
      return;
    }
    this.isRegisteredInputEvent = false;
    this.unRegisterAltUpEvent();
    this.unRegisterFnKeyInputEvent();
    this.unRegisterCombinationKeyInputEvent();
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_L, false,
      EventConstants.EVENT_WIN_L, true);
    this.unRegisterPreLogoKeyEvent();
    if (SCBSceneSessionManager.getInstance().isPcMode()) {
      this.unregister2in1InputEvent();
    }
  }

  public registerPcMouseEvent(): void {
    try {
      this.unregisterMouseEvent();
      inputMonitor.on('mouse', this.onDockDisplayStatusChange);
    } catch (error) {
      log.showError(`[inputMonitor] registerPcMouseEvent ERROR: ${error}`);
    }
  }

  public registerCSideTitleMouseEvent(): void {
    this.unregisterMouseEvent();
    inputMonitor.on('mouse', this.onCSideTitleStatusChange);
  }

  public recoverMouseEvent(): void {
    this.unregisterMouseEvent();
  }

  private unregisterMouseEvent(): void {
    inputMonitor.off('mouse');
  }

  public registerTempInput(inputOption: inputConsumer.KeyOptions, callback: Callback<inputConsumer.KeyOptions>): void {
    try {
      log.showInfo('registerTempInput in other modules');
      inputConsumer.on('key', inputOption, callback);
    } catch (err) {
      log.error('[registerTempInput] failed, error -> ', err);
    }
  }

  public unRegisterTempInput(inputOption: inputConsumer.KeyOptions): void {
    try {
      log.showInfo('unregisterTempInput in other modules');
      inputConsumer.off('key', inputOption);
    } catch (err) {
      log.error('[unRegisterTempInput] failed, error -> ', err);
    }
  }

  public registerPcModeKeyInput(): void {
    scbGestureManager.unRegisterPublicPcKey();
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_TAB, false,
      EventConstants.EVENT_WIN_TAB, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_D, false,
      EventConstants.EVENT_WIN_D, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_TAB, false,
      EventConstants.EVENT_WIN_TAB, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_D, false,
      EventConstants.EVENT_WIN_D, true);
    this.registerWinDpadKeyInput();
  }

  public unregisterPcModeKeyInput(): void {
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_TAB, false,
      EventConstants.EVENT_WIN_TAB, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_D, false,
      EventConstants.EVENT_WIN_D, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_TAB, false,
      EventConstants.EVENT_WIN_TAB, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_D, false,
      EventConstants.EVENT_WIN_D, true);
    this.unRegisterWinDpadKeyInput();
    scbGestureManager.registerPublicKey();
  }

  public registerPcModeMouseEvent(): void {
    this.registerMouseEvent();
  }

  public unregisterPcModeMouseEvent(): void {
    this.unregisterMouseEvent();
  }

  private registerPreLogoKeyEvent(): void {
    const keys: KeyCode[] = [KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_META_RIGHT];
    let keyDownMap = new Map<number, number>();
    try {
      inputMonitor.on('keyPressed', keys, (keyEvent: KeyEvent) => {
        log.showInfo(`[inputMonitor] PreLogoKeyEvent invoke action: ${keyEvent.action}`);
        if (keyEvent.action === Action.DOWN) {
          keyDownMap.set(keyEvent.key.code, 1);
        }
        if (keyEvent.action === Action.UP) {
          keyDownMap.delete(keyEvent.key.code);
          if (!keyDownMap.size) {
            AppStorage.delete('focusedSessionId');
          }
        }
      });
    } catch (e) {
      log.showError(`[inputMonitor] failed monitor key event, e: ${e}`);
    }
  }

  private unRegisterPreLogoKeyEvent(): void {
    inputMonitor.off('keyPressed', (keyEvent: KeyEvent) => {
      if (keyEvent.key.code === KeyCode.KEYCODE_META_LEFT ||
        keyEvent.key.code === KeyCode.KEYCODE_META_RIGHT) {
        AppStorage.delete('focusedSessionId');
      }
    });
  }

  public unRegisterSwitchPageEvent(): void {
    log.showInfo('unRegisterSwitchDesktopEvent');
    try {
      inputConsumer.off('key', this.leftWinLeftCtrlDownOption);
      inputConsumer.off('key', this.leftWinRightCtrlDownOption);
      inputConsumer.off('key', this.rightWinLeftCtrlDownOption);
      inputConsumer.off('key', this.rightWinRightCtrlDownOption);
      inputConsumer.off('key', this.leftWinLeftCtrlUPOption);
      inputConsumer.off('key', this.leftWinRightCtrlUPOption);
      inputConsumer.off('key', this.rightWinLeftCtrlUPOption);
      inputConsumer.off('key', this.rightWinRightCtrlUPOption);
    } catch (err) {
      log.showError(`unRegisterSwitchPageEvent, code ${err?.code}, msg ${err?.msg}`);
    }
  }

  public registerSwitchPageEvent(callBack: Function): void {
    log.showInfo('registerSwitchDesktopEvent');
    try {
      inputConsumer.on('key', this.leftWinLeftCtrlDownOption, callback => {
        log.showInfo('ctrlWinDUpCallback');
        callBack?.(false);
      });
      inputConsumer.on('key', this.leftWinRightCtrlDownOption, callback => {
        log.showInfo('ctrlWinDUpCallback');
        callBack?.(false);
      });
      inputConsumer.on('key', this.rightWinLeftCtrlDownOption, callback => {
        log.showInfo('ctrlWinDUpCallback');
        callBack?.(false);
      });
      inputConsumer.on('key', this.rightWinRightCtrlDownOption, callback => {
        log.showInfo('ctrlWinDUpCallback');
        callBack?.(false);
      });
      inputConsumer.on('key', this.leftWinLeftCtrlUPOption, callback => {
        log.showInfo('ctrlWinDDownCallback');
        callBack?.(true);
      });
      inputConsumer.on('key', this.leftWinRightCtrlUPOption, callback => {
        log.showInfo('ctrlWinDDownCallback');
        callBack?.(true);
      });
      inputConsumer.on('key', this.rightWinLeftCtrlUPOption, callback => {
        log.showInfo('ctrlWinDDownCallback');
        callBack?.(true);
      });
      inputConsumer.on('key', this.rightWinRightCtrlUPOption, callback => {
        log.showInfo('ctrlWinDDownCallback');
        callBack?.(true);
      });
    } catch (err) {
      log.showError(`registerSwitchDesktopEvent, code ${err?.code}, msg ${err?.msg}`);
    }
  }

  public registerWinDpadKeyInput(): void {
    this.unRegisterWinDpadKeyInput();
    log.showInfo('registerWinDpadKeyInput');
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_DPAD_UP, false,
      EventConstants.EVENT_WIN_DPAD_UP, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_DPAD_UP, false,
      EventConstants.EVENT_WIN_DPAD_UP, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_DPAD_DOWN, false,
      EventConstants.EVENT_WIN_DPAD_DOWN, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_DPAD_DOWN, false,
      EventConstants.EVENT_WIN_DPAD_DOWN, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_DPAD_LEFT, false,
      EventConstants.EVENT_WIN_DPAD_LEFT, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_DPAD_RIGHT, false,
      EventConstants.EVENT_WIN_DPAD_RIGHT, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_DPAD_LEFT, false,
      EventConstants.EVENT_WIN_DPAD_LEFT, true);
    this.registerDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_DPAD_RIGHT, false,
      EventConstants.EVENT_WIN_DPAD_RIGHT, true);
  }

  public unRegisterWinDpadKeyInput(): void {
    log.showInfo('unRegisterWinDpadKeyInput');
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_DPAD_UP, false,
      EventConstants.EVENT_WIN_DPAD_UP, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_DPAD_UP, false,
      EventConstants.EVENT_WIN_DPAD_UP, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_DPAD_DOWN, false,
      EventConstants.EVENT_WIN_DPAD_DOWN, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_DPAD_DOWN, false,
      EventConstants.EVENT_WIN_DPAD_DOWN, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_DPAD_LEFT, false,
      EventConstants.EVENT_WIN_DPAD_LEFT, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_DPAD_LEFT, false,
      EventConstants.EVENT_WIN_DPAD_LEFT, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_LEFT, KeyCode.KEYCODE_DPAD_RIGHT, false,
      EventConstants.EVENT_WIN_DPAD_RIGHT, true);
    this.unRegisterDoubleCombinationKeyEvent(KeyCode.KEYCODE_META_RIGHT, KeyCode.KEYCODE_DPAD_RIGHT, false,
      EventConstants.EVENT_WIN_DPAD_RIGHT, true);
  }


  public winCtrlLogoRightStatus: boolean = false;
  public hisearchShortcutExcuted: boolean = false;
}

export const multiInputManager = MultiInputManager.getInstance();