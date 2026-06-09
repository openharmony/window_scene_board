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

import { sEventManager } from '@ohos/frameworkwrapper/src/main/ets/utils/EventManager';
import slClockOneShotToDesktopService from '@ohos/screenlockcommon/src/main/ets/base/SlClockOneShotToDesktopService';
import { Logger } from '@ohos/basicutils/src/main/ets/utils/Logger';
import { LogDomain } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import {
  ScreenOnOffListener,
  ScreenOnOffService
} from '@ohos/screenlockcommon/src/main/ets/services/ScreenOnOffService';
import { SlClockStaticState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockStaticState';
import { BatteryLayout } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import { slStateHelper } from '../../common/helper/SlStateHelper';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';

const TAG = 'OneMirrorAodStateMonitor';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

/**
 * 一镜到底需要依赖AOD状态，AOD状态发生变化需要通知到锁屏
 */
export class OneMirrorAodStateMonitor {
  private static ins: OneMirrorAodStateMonitor;
  private isConsumerAod: boolean = false;
  private isPowerSleep = false;
  private readonly powerStateListener: ScreenOnOffListener = {
    onBeginSleep: () => {
      this.isPowerSleep = true;
    },
    onEndDisplayOn: () => {
      this.isPowerSleep = false;
    }
  }

  private constructor() {
    ScreenOnOffService.getInstance().registerObserver(this.powerStateListener);
  }

  public static getIns(): OneMirrorAodStateMonitor {
    if (!OneMirrorAodStateMonitor.ins) {
      OneMirrorAodStateMonitor.ins = new OneMirrorAodStateMonitor();
    }
    return OneMirrorAodStateMonitor.ins;
  }

  public doInit(): void {
    ScreenOnOffService.getInstance().registerObserver(this.powerStateListener);
  }

  public doRelease(): void {
    ScreenOnOffService.getInstance().unRegisterObserver(this.powerStateListener);
  }

  private readonly aodStateChange: () => void = () => {
    this.handleConsumerClockAnim();
  }

  private handleConsumerClockAnim(): void {
    const newVal: boolean = false;
      const slBindState: SlClockBindState | undefined = slStateHelper.getSlClockBindState();
      if (newVal != this.isConsumerAod && this.isConsumerAod) {
        log.showInfo(TAG, 'change consumer aod to other');
        // 灭屏状态下从自定义AOD变成其他，需要恢复锁屏时钟
        if (this.isPowerSleep) {
          slClockOneShotToDesktopService.doNoMirrorPartAodToSl();
        }
        const slClockStaticState: SlClockStaticState | undefined = slStateHelper.getSlClockStaticState();
        slClockStaticState.setClockExpandOnAod(false);
      slBindState?.setClockExpandOnAodAnim(false);
      slBindState?.setClockViewOffset({ x: undefined, y: undefined });
    }
    this.isConsumerAod = newVal;
    // 刷新电量
    slBindState?.setBatteryLayout(this.isConsumerAod ? BatteryLayout.DEFAULT_LAYOUT :
    BatteryLayout.DEFAULT_LAYOUT);
  }
}
