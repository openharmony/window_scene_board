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

import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import { SingletonHelper, LogDomain, LogHelper } from '@ohos/basicutils';
import { HiSysEventUtil, TargetPanel } from '@ohos/frameworkwrapper';
import { PowerStatus } from '@ohos/commonconstants';
import keyCode from '@ohos.multimodalInput.keyCode';
import type { EventManager } from '@ohos/frameworkwrapper';
import { OobeAdapter } from '../adapter/OobeAdapter';
import { statusBarMaskManager } from '../statusbar/mask/statusBarMaskManager';

const TAG = 'MultimodalInputManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export type MultiCallback = (keyOptions: inputConsumer.KeyOptions) => void;

export enum MultiKeyCode {
  BACK = 2,
  DPAD_UP = 2012,
  DPAD_DOWN = 2013,
  DPAD_LEFT = 2014,
  DPAD_RIGHT = 2015,
  NUMPAD_ENTER = 2119,
  A = 2017,
  C = 2019,
  D = 2020,
  F = 2022,
  I = 2025,
  N = 2030,
  S = 2035,
  ALT_LEFT = 2045,
  ALT_RIGHT = 2046,
  SHIFT_LEFT = 2047,
  SHIFT_RIGHT = 2048,
  TAB = 2049,
  ENTER = 2054,
  SLASH = 2064,
  FORWARD_DEL = 2071,
  CTRL_LEFT = 2072,
  CTRL_RIGHT = 2073,
  CAPS_LOCK = 2074,
  WIN = 2076,
  WIN_RIGHT = 2077,
  ESC = 2070,
  L = 2028,
  NUMPAD_DOT = 2117
}

class MultimodalInputManager {
  public dealWithShortcutKeyInFA: boolean = false;

  //win + N
  notificationKeyOptions: any = {
    preKeys: [MultiKeyCode.WIN],
    finalKey: MultiKeyCode.N,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
    isRepeat: false
  };

  //win + C
  controlKeyOptions: any = {
    preKeys: [MultiKeyCode.WIN],
    finalKey: MultiKeyCode.C,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
    isRepeat: false
  };

  // BRIGHTNESS_UP 调亮
  brightnessUpOptions: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: keyCode.KeyCode.KEYCODE_BRIGHTNESS_UP,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
  };

  // BRIGHTNESS_DOWN 调暗
  brightnessDownOptions: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: keyCode.KeyCode.KEYCODE_BRIGHTNESS_DOWN,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
  };

  subscribeCombinationKey(keys: MultiKeyCode[], isKeyDown: boolean, cb: MultiCallback): () => void {
    if (keys.length <= 0) {
      log.showError('Invalid keys, can not subscribe.');
      return () => {
      };
    }
    let keyOptions = {
      preKeys: keys.slice(0, keys.length - 1),
      finalKey: keys[keys.length - 1],
      isFinalKeyDown: isKeyDown,
      finalKeyDownDuration: 0,
    };

    try {
      let callback: (options) => void = (options) => {
        // Do not respond combine key event when shutting down
        if (AppStorage.get('powerStatus') === PowerStatus.SHUTDOWN ||
          AppStorage.get('powerStatus') === PowerStatus.REBOOT) {
          log.showDebug('subscribeCombinationKey shutting down or reboot, do not respond.');
          return;
        }
        log.showInfo('on CombinationKey, options');
        cb(options);
        return;
      };
      inputConsumer.on('key', keyOptions, callback);
      log.showInfo('subscribe CombinationKey, keys');
      return () => {
        inputConsumer.off('key', keyOptions, callback);
      };
    } catch (error) {
      log.error('inputConsumer error', error);
    }
    return () => {};
  }

  private controlListenerCallback: () => void = () => {}

  registerControlListener(callback): void {
    log.showDebug('registerListener control');
    try {
      this.controlListenerCallback = (): void => {
        log.showInfo('controlRegisterCallBack data');
        if (OobeAdapter.isOobe) {
          log.showInfo(`OOBE states: ${OobeAdapter.isOobe}`);
          return;
        }
        HiSysEventUtil.reportKey('usual.event.WIN_C');
        callback.onPanelStateChange(TargetPanel.CONTROL_CENTER_PANEL);
        statusBarMaskManager.setStatusBarMaskState(false);
      }
      inputConsumer.on('key', this.controlKeyOptions, this.controlListenerCallback);
    } catch (error) {
      log.error('registerControlListener error', error);
    }
    log.showDebug('registerListener end');
  }

  private notificationListenerCallback: () => void = () => {}

  registerNotificationListener(callback): void {
    log.showDebug('registerListener notification');
    try {
      this.notificationListenerCallback = (): void => {
        log.showInfo('notificationRegisterCallBack data');
        if (OobeAdapter.isOobe) {
          log.showInfo(`OOBE states: ${OobeAdapter.isOobe}`);
          return;
        }
        HiSysEventUtil.reportKey('usual.event.WIN_N');
        callback.onPanelStateChange(TargetPanel.NOTIFICATION_PANEL);
        statusBarMaskManager.setStatusBarMaskState(false);
      };
      inputConsumer.on('key', this.notificationKeyOptions, this.notificationListenerCallback);
    } catch (error) {
      log.error('registerNotificationListener error', error);
    }
    log.showDebug('registerListener end');
  }

  registerBrightnessUpListener(callback): () => void {
    log.showDebug('registerListener brightness up');
    try {
      let onBrightnessUp: (data) => void = (data) => {
        log.showInfo('brightnessUpCallBack data');
        callback.onBrightnessUpChange();
      };
      inputConsumer.on('key', this.brightnessUpOptions, onBrightnessUp);
      return () => {
        log.info('unregisterBrightnessUpListener');
        inputConsumer.off('key', this.brightnessUpOptions, onBrightnessUp);
      };
    } catch (error) {
      log.error('registerBrightnessUpListener error', error);
    }
    log.showDebug('registerListener end');
    return () => {};
  }

  registerBrightnessDownListener(callback): () => void {
    log.showDebug('registerListener brightness down');
    try {
      let onBrightnessDown: (data) => void = (data) => {
        log.showInfo('brightnessDownCallBack data');
        callback.onBrightnessDownChange();
      };
      inputConsumer.on('key', this.brightnessDownOptions, onBrightnessDown);
      return () => {
        log.info('unregisterBrightnessDownListener');
        inputConsumer.off('key', this.brightnessDownOptions, onBrightnessDown);
      };
    } catch (error) {
      log.error('registerBrightnessDownListener error', error);
    }
    log.showDebug('registerListener end');
    return () => {};
  }

  unregisterListener(): void {
    log.showDebug('unregisterListener start');

    try {
      inputConsumer.off('key', this.notificationKeyOptions, this.notificationListenerCallback);
    } catch (error) {
      log.error('notificationUnregisterCallBack error', error);
    }

    try {
      inputConsumer.off('key', this.controlKeyOptions, this.controlListenerCallback);
    } catch (error) {
      log.error('controlUnregisterCallBack error', error);
    }

    log.showDebug('unregisterListener end');
  }

  /**
   * status bar level-2 panel hide/show event listening and extract public methods.
   *
   * @param eventMgr 多事件管理器
   * @param hideWindow 窗口隐藏事件
   * @param onWindowEvent 窗口show/hide事件
   * @param onScreenOnOffEvent 亮灭屏事件
   * @param onRequestWindowEvent 请求窗口show/hide事件
   */
  initCombinationKey(eventMgr: EventManager, hideWindow): void {
    if (eventMgr === undefined) {
      log.showError('Invalid eventMgr, can not init.');
    }
    eventMgr.addOff(this.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.D], true, (data) => {
      log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
      hideWindow();
    }))
      .addOff(this.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.DPAD_UP], true, (data) => {
        log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        hideWindow();
      }))
      .addOff(this.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.A], true, (data) => {
        log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        hideWindow();
      }))
      .addOff(this.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.SLASH], true, (data) => {
        log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        hideWindow();
      }))
      .addOff(this.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.S], true, (data) => {
        log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        hideWindow();
      }))
      .addOff(this.subscribeCombinationKey([MultiKeyCode.ALT_LEFT, MultiKeyCode.TAB], true, (data) => {
        log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        hideWindow();
      }))
      .addOff(this.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.TAB], true, (data) => {
        log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        hideWindow();
      }));
  }
}
let sMultimodalInputManager = SingletonHelper.getInstance(MultimodalInputManager, TAG);

export default sMultimodalInputManager as MultimodalInputManager;
