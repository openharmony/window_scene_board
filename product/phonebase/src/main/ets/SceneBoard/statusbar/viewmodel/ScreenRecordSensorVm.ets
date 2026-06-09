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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { RTLUtil } from '@ohos/componenthelper';
import { DeviceHelper, EventManager, EvtBus } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ScreenRecordCapsuleEvent, StatusBarStyleChangeEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { display } from '@kit.ArkUI';
import { ScreenRecordEvent } from '@ohos/systemuicommon/src/main/ets/event/StatusBarEvent';
// instrument ignore file

const TAG = 'ScreenRecordSensorVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const groupHeight = ResUtils.getNumber($r('app.float.plugin_phone_icon_height'));

@Observed
export class ScreenRecordSensorStatus {
  public paddingLeft: number = 0;
  public positionY: number = 0;
  public backgroundColor: string = '';
}

@Observed
export class ScreenRecordSensorOpacity {
  public opacity: number = 0;
}

export class ScreenRecordSensorVm {
  public static get = SingletonHelper.createFactory(() => new ScreenRecordSensorVm);

  private mScreenRecordSensorStatus: ScreenRecordSensorStatus = new ScreenRecordSensorStatus();
  private mScreenRecordSensorOpacity: ScreenRecordSensorOpacity = new ScreenRecordSensorOpacity();
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  /**
   * 是否在沉浸态
   */
  private isImmersiveType: boolean = false;
  /**
   * 是否处于屏幕录制
   */
  private isScreenRecord: boolean | undefined = false;
  /**
   * 屏幕录制指示器闪烁时间Id
   */
  private screenRecordSensorIntervalId: number | null = null;
  /**
   * 屏幕录制指示器是否处于首次闪烁
   */
  private isFirstScreenRecordSensor: boolean = true;
  /**
   * 屏幕录制指示器大小
   */
  public screenRecordSensorSize: number = 0;

  public init(): void {
    log.showInfo('init');
    // 初始化隐私指示灯大小
    this.initScreenRecordSensorSize();
    // 监听是否存在录屏胶囊
    this.eventMgr.on(ScreenRecordCapsuleEvent, this.onScreenRecordCapsuleEvent);
    // 监听是否存在录屏胶囊2.0
    this.eventMgr.on(ScreenRecordEvent, this.onScreenRecordEvent);
    // 监听状态栏padding变化
    this.eventMgr.on(StatusBarStyleChangeEvent, this.onStatusBarStyleChangeEvent);
  }

  /**
   * 去初始化状态栏背景vm
   */
  public unInit(): void {
    log.showInfo('unInit');
    this.eventMgr.offAll();
  }

  /**
   * 获取录屏指示器状态数据
   */
  public getScreenRecordSensorStatus(): ScreenRecordSensorStatus {
    return this.mScreenRecordSensorStatus;
  }

  /**
   * 获取录屏指示器透明度数据
   */
  public getScreenRecordSensorOpacity(): ScreenRecordSensorOpacity {
    return this.mScreenRecordSensorOpacity;
  }

  /**
   * 初始化录屏指示器大小
   */
  private initScreenRecordSensorSize(): void {
    if (DeviceHelper.isLargeInFoldProduct()) {
      this.screenRecordSensorSize = ResUtils.getNumber($r('app.float.screen_record_sensor_size_large_fold'));
      return;
    }
    this.screenRecordSensorSize = ResUtils.getNumber($r('app.float.screen_record_sensor_size'));
  }

  /**
   * 录屏胶囊事件回调
   */
  private onScreenRecordCapsuleEvent = (event: ScreenRecordCapsuleEvent): void => {
    if (!SystemUICcmConfig.instance.isEnabledLive2) {
      this.handleScreenRecord(event);
    }

  }

  /**
   * 录屏胶囊事件回调2.0
   */
  private onScreenRecordEvent = (event: ScreenRecordEvent): void => {
    if (SystemUICcmConfig.instance.isEnabledLive2) {
      this.handleScreenRecord(event);
    }
  }

  private handleScreenRecord = (event: ScreenRecordCapsuleEvent | ScreenRecordEvent): void => {
    let isScreenRecord = event.status;
    let screenRecordSensorColor = event.color;
    log.showInfo(`onScreenRecordCapsuleEvent: isScreenRecord: ${isScreenRecord} color: ${screenRecordSensorColor}`);
    if (screenRecordSensorColor !== this.mScreenRecordSensorStatus.backgroundColor) {
      this.mScreenRecordSensorStatus.backgroundColor = screenRecordSensorColor;
    }
    if (isScreenRecord !== this.isScreenRecord) {
      this.isScreenRecord = isScreenRecord;
      this.animScreenRecordSensor();
    }
  }

  /**
   * 状态栏padding变化回调
   */
  private onStatusBarStyleChangeEvent = (event: StatusBarStyleChangeEvent): void => {
    try {
      const displayClass = display.getDefaultDisplaySync();
      const paddingLeft =
      ResUtils.getNumberFromLength(event.statusBarPaddingLeft);
      this.mScreenRecordSensorStatus.paddingLeft = RTLUtil.isRTL() ? px2vp(displayClass.width) -
        paddingLeft - this.screenRecordSensorSize : paddingLeft;
      log.showInfo(`width is ${displayClass.width}, paddingLeft is ${this.mScreenRecordSensorStatus.paddingLeft}`);
    } catch (err) {
      log.showError('getDefaultDisplaySync failed, reason: ' + err.message);
    }
    let statusbarHeight = ResUtils.getNumberFromLength($r('app.float.status_bar_phone_height'));
    const paddingTop = ResUtils.getNumberFromLength(event.statusBarPaddingTop);
    let positionY = 0;
    if (SystemUICcmConfig.instance.isEnabledLive2) {
      positionY = paddingTop + groupHeight / 2 - this.screenRecordSensorSize / 2;
    } else {
      positionY = paddingTop + groupHeight / 2 + (statusbarHeight - groupHeight) / 2 - this.screenRecordSensorSize / 2;
    }
    log.showInfo(`paddingTop: ${paddingTop}, statusbarHeight: ${statusbarHeight}, groupHeight: ${groupHeight}, ` +
      `screenRecordSensorSize: ${this.screenRecordSensorSize}, positionY: ${positionY}`);
    this.mScreenRecordSensorStatus.positionY = positionY;
  }

  /**
   * topbar显隐变化回调
   */
  public onViewChange(isShowing: boolean): void {
    this.isImmersiveType = isShowing;
    this.animScreenRecordSensor();
  }

  /**
   *  录屏在沉浸态下指示灯闪烁动效
   */
  public animScreenRecordSensor(): void {
    if (this.isScreenRecord && this.isImmersiveType) {
      this.startAnimScreenRecordSensor();
      return;
    }
    this.stopAnimScreenRecordSensor();
  }

  private startAnimScreenRecordSensor(): void {
    if (!this.screenRecordSensorIntervalId) {
      log.showInfo(`start screenRecordSensor anim`)
      this.screenRecordSensorIntervalId = setInterval(() => {
        this.mScreenRecordSensorOpacity.opacity = this.mScreenRecordSensorOpacity.opacity === 0 ? 1 : 0;
      }, 500);
    }
  }

  private stopAnimScreenRecordSensor(): void {
    this.isFirstScreenRecordSensor = true;
    if (this.screenRecordSensorIntervalId) {
      log.showInfo(`end screenRecordSensor anim`)
      clearInterval(this.screenRecordSensorIntervalId);
      this.screenRecordSensorIntervalId = null;
      this.mScreenRecordSensorOpacity.opacity = 0;
    }
  }
}