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

import fu from '@ohos.file.fileuri';
import { sensor } from '@kit.SensorServiceKit';
import { AsyncCallback, BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { SCBScreenProperty, scbGestureManager, GestureType } from '@ohos/windowscene';
import { LogHelper, LogDomain, FileUtils, CheckEmptyUtils } from '@ohos/basicutils';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { SCBDefaultZIndex } from '../../scenemanager/SCBScreen';
import { FlashlightTipsConstants } from '@ohos/screenlockcommon/src/main/ets/constants/FlashlightTipsConstants';
import { default as MultimodalInputPowerModule } from '@ohos/screenlockcommon/src/main/ets/manager/MultimodalInputPowerModule';
import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import {runningLock} from '@kit.BasicServicesKit';
import type { CommonEventData } from 'commonEvent/commonEventData';

const TAG = 'FlashlightTipsHelper';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class FlashlightTipsHelper {
  private subscriber?: commonEventManager.CommonEventSubscriber;
  // 亮灭屏事件列表
  private subscribeInfo:commonEventManager.CommonEventSubscribeInfo = {
    events: [commonEventManager.Support.COMMON_EVENT_SCREEN_ON, commonEventManager.Support.COMMON_EVENT_SCREEN_OFF]
  };
  // 监听power按下事件
  private mMultimodalInputPowerModule: MultimodalInputPowerModule | null = null;
  private recordLock: runningLock.RunningLock | null = null;
  // 申请常亮错误次数, 每次进入此页面给予1次重试机会
  private errorNum: number = 0;

  /**
   * 注册侧滑
   */
  public registerBackGestureEvent(callback: Function): void {
    if (CheckEmptyUtils.isEmpty(scbGestureManager) || CheckEmptyUtils.isEmpty(callback)) {
      log.showError(`registerBackGestureEvent error scbGestureManager: ${scbGestureManager} callback: ${callback}`);
      return;
    }
    scbGestureManager.registerGestureEvent(GestureType.BACK, FlashlightTipsConstants.SCENE_TYPE, callback);
  }

  /**
   * 侧滑解注册
   */
  public unRegisterBackGestureEvent(): void {
    if (CheckEmptyUtils.isEmpty(scbGestureManager)) {
      log.showError(`unRegisterBackGestureEvent error scbGestureManager is null`);
      return;
    }
    scbGestureManager.unRegisterGestureEvent(GestureType.BACK, FlashlightTipsConstants.SCENE_TYPE);
  }

  /**
   * 获取提示帧动画资源
   */
  public getFlashlightTipsResource(): ImageFrameInfo[] {
    let images: ImageFrameInfo[] = [];
    // 获取系统资源
    let fileNames: string[] = FileUtils.getFileList(FlashlightTipsConstants.RESOURCE_PATH);
    for (let i = 0; i < fileNames.length; i++) {
      let imagePath =
        fu.getUriFromPath(FlashlightTipsConstants.RESOURCE_PATH +
        FlashlightTipsConstants.FILE_SEPARATOR +
        FlashlightTipsConstants.FILE_NAME_PREFIX + i +
        FlashlightTipsConstants.FILE_NAME_SUFFIX);
      let frameInfo: ImageFrameInfo = {
        src: imagePath,
        // 最后一张停顿1秒
        duration: i == (fileNames.length - 1) ? FlashlightTipsConstants.ANIMATION_DURATION_END
          : FlashlightTipsConstants.ANIMATION_DURATION
      }
      images.push(frameInfo);
    }
    return images;
  }

  /**
   * 注册亮灭屏监听器
   */
  public registerScreenListener(callback: AsyncCallback<CommonEventData, void>): void {
    if (CheckEmptyUtils.isEmpty(callback)) {
      log.showError('registerScreenListener error callback is null');
      return;
    }
    this.subscriber = commonEventManager.createSubscriberSync(this.subscribeInfo);
    commonEventManager.subscribe(this.subscriber, callback);
  }

  /**
   * 注册亮灭屏监听器
   */
  public unRegisterScreenListener(): void {
    if (CheckEmptyUtils.isEmpty(this.subscriber)) {
      log.showError('unRegisterScreenListener error subscriber is empty');
      return;
    }
    commonEventManager.unsubscribe(this.subscriber);
  }

  /**
   * 注册屏幕切换事件
   */
  public registerScreenSessionManagerListener(callback: Function, screenProp?: SCBScreenProperty): void {
    if (CheckEmptyUtils.isEmpty(callback) || CheckEmptyUtils.isEmpty(screenProp)) {
      log.showError(`registerScreenSessionManagerListener error callback: ${callback} screenProp: ${screenProp}`);
      return;
    }
    SCBScreenSessionManager.getInstance().registerStartFoldToExpandChangeCallback(callback,
      SCBDefaultZIndex.SPECIFIC_MEDIA_CONTROL_TEMP, screenProp?.screenId);
  }

  /**
   * 注销屏幕切换事件
   */
  public unRegisterScreenSessionManagerListener(callback: Function, screenProp?: SCBScreenProperty): void {
    if (CheckEmptyUtils.isEmpty(callback) || CheckEmptyUtils.isEmpty(screenProp)) {
      log.showError(`unRegisterScreenSessionManagerListener error callback: ${callback} screenProp: ${screenProp}`);
      return;
    }
    SCBScreenSessionManager.getInstance().UnregisterStartFoldToExpandChangeCallback(callback,
      SCBDefaultZIndex.SPECIFIC_MEDIA_CONTROL_TEMP, screenProp?.screenId);
  }

  /**
   * 注册陀螺仪监听器
   */
  public registerGyroscopeListener(callback: Callback<sensor.GyroscopeResponse>): void {
    try {
      if (CheckEmptyUtils.isEmpty(callback)) {
        log.showError('registerGyroscopeListener error callback is null');
        return;
      }
      sensor.on(sensor.SensorId.GYROSCOPE, callback, { interval: FlashlightTipsConstants.GYROSCOPE_INTERVAL });
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      log.showError(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
    }
  }

  /**
   * 注销陀螺仪监听器
   */
  public unRegisterGyroscopeListener(): void {
    sensor.off(sensor.SensorId.GYROSCOPE);
  }

  /**
   * 注册power键按下事件
   */
  public registerPowerListener(callback: Callback<inputConsumer.KeyOptions>): void {
    if (CheckEmptyUtils.isEmpty(callback)) {
      log.showError('registerPowerListener error callback is null');
      return;
    }
    this.mMultimodalInputPowerModule = new MultimodalInputPowerModule(callback);
    this.mMultimodalInputPowerModule.registerPowerKeyDown();
  }

  /**
   * 注销power键按下事件
   */
  public unRegisterPowerListener(): void {
    if (CheckEmptyUtils.isEmpty(this.mMultimodalInputPowerModule)) {
      log.showError('registerPowerListener mMultimodalInputPowerModul is null');
      return;
    }
    this.mMultimodalInputPowerModule?.unRegisterPowerKeyDown();
  }

  /**
   * 保持屏幕常亮
   *
   * @param time 常亮时间 单位ms
   */
  public keepScreenOn(time: number): void {
    // 常亮,0代表亮屏锁
    runningLock.create('flashlight_tips_recordLock', 0, (error: BusinessError, lock: runningLock.RunningLock) => {
      if (error) {
        log.showError(`An unexpected error in runningLock. message: ${error}`);
        if (++this.errorNum <= 1) {
          // 失败重新尝试申请应用锁
          log.showInfo(`reload keepScreenOn this.errorNum: ${this.errorNum}`);
          this.keepScreenOn(time);
        }
        return;
      }
      this.recordLock = lock;
      try {
        this.recordLock.hold(time);
        log.showInfo('recordLock is holding');
      } catch (error) {
        log.showError(`An unexpected error in recordLock.hold. message: ${error}`);
      }
    });
  }

  /**
   * 取消屏幕常亮,释放常亮锁
   */
  public cancelKeepScreenOn(): void {
    if (!this.recordLock) {
      log.showWarn('lock is null');
      return;
    }
    if (this.recordLock.isHolding()) {
      this.recordLock.unhold();
      log.showInfo('lock is unHold');
    }
  }
}


