/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

// import swingability from '@ohos.swingability';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SingletonHelper } from '@ohos/basicutils';
import { UserSwitchListener, UserSwitchService } from '../services/UserSwitchService';
import { AccountHelper, AuthType, SwitchEventData } from '../utils/AccountHelper';

const TAG = 'EyeGazeSwingEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const DOMAIN_ID: number = 19;

export class EyeGazeSwingEvent {
  private isCurrentThemeSupport: boolean = false;

  // private eventList: swingability.SwingEventType[] = [
  // // 亮屏屏下人脸注视检测事件
  //   { eventType: 'EYE_GAZE_SCREEN_ON', params: { 'domainId': DOMAIN_ID, 'openEyeGaze': 1 } }
  // ];

  // private callback: swingability.ISubscribeCallback | undefined = undefined;

  private accountSwitchCallback: UserSwitchListener = {
    onSwitched: (switchEventData: SwitchEventData): void => {
      log.showInfo('user switched');
      if (AccountHelper.getInstance().currentLocalId === switchEventData.fromAccountId) {
        this.unSubscribe();
      }
    }
  }

  setCurrentThemeSupport(isSupport: boolean): void {
    if (this.isCurrentThemeSupport === isSupport) {
      return;
    }
    this.isCurrentThemeSupport = isSupport;
    if (isSupport) {
      this.registerAccountSwitch();
    } else {
      this.unRegisterAccountSwitch();
    }
  }

  private registerAccountSwitch(): void {
    log.showInfo('registerAccountSwitch');
    UserSwitchService.getInstance().registerObserver(this.accountSwitchCallback);
  }

  private unRegisterAccountSwitch(): void {
    log.showInfo('unRegisterAccountSwitch');
    UserSwitchService.getInstance().unRegisterObserver(this.accountSwitchCallback);
  }

  /**
   * 通知Swing事件开启时机：进入锁屏主页时，且主页可见
   */
  subscribe(): void {
    if (!this.isCurrentThemeSupport) {
      return;
    }
    // if (this.callback) {
    //   return;
    // }
    // const callback: swingability.ISubscribeCallback = {
    //   onSwingEvent(data: Record<string, object>) {
    //     let result = '';
    //     if (typeof data === 'object') {
    //       Object.keys(data).forEach(key => {
    //         result = `${result} ${key.substring(0, key.length - 1)} : ${data[key]} ;`;
    //       });
    //     } else if (typeof data === 'string') {
    //       result = data;
    //     }
    //     log.showInfo(`onSwingEvent, result: ${result}`);
    //   }
    // };
    log.showInfo(`subscribe EYE GAZE event`);
    // this.callback = callback;
    try {
      // swingability?.on(this.eventList, callback);
    } catch (e) {
      log.showError(`swingability error: ${e?.message}`);
    }
  }

  /**
   * 通知Swing事件关闭时机：
   * 退出锁屏主页（包含进入密码页、SIM卡PIN页、解锁）、灭屏、进入覆盖模式、控制中心拉下
   * 充电动效（覆盖模式可以覆盖）、皮套模式（暂不考虑）
   */
  unSubscribe(): void {
    // if (this.callback) {
    //   log.showInfo(`unsubscribe EYE GAZE event`);
    //   try {
    //     swingability?.off(this.eventList, this.callback).then(() => {
    //       this.callback = undefined;
    //     });
    //   } catch (e) {
    //     log.showError(`swingability error: ${e?.message}`);
    //   }
    // }
  }
}

export const eyeGazeSwingEvent: EyeGazeSwingEvent = SingletonHelper.getInstance(EyeGazeSwingEvent, TAG);