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

import lazy { AsyncCallback, BusinessError } from '@ohos.base';
import lazy commonEventManager from '@ohos.commonEventManager';
import { WallpaperViewController } from '../pages/WallpaperViewController';
import { Constants } from '../utils/Constants';
import { DeviceUtil } from '../utils/DeviceUtil';
import { Log } from '../utils/Log';

const TAG: string = 'ThemeLoadPublisher';
const FINISH_LOADING_DELAY: number = 150;

/**
 * Unified class to handle all theme load events
 *
 * @since 2024-07-24
 */
export class ThemeLoadPublisher {
  private static instance: ThemeLoadPublisher;

  private themeLoadFence: number = 0;

  private registeredLoadCount: number = 0;

  private hasPublished: boolean = false;

  private constructor() {
  }

  /**
   * Get the publisher's singleton instance
   *
   * @returns ThemeLoadPublisher instance
   */
  public static getInstance(): ThemeLoadPublisher {
    if (!ThemeLoadPublisher.instance) {
      ThemeLoadPublisher.instance = new ThemeLoadPublisher();
    }

    return ThemeLoadPublisher.instance;
  }

  /**
   * Set the fence for load count
   *
   * @param fence Load fence
   */
  public setLoadFence(fence: number): void {
    Log.info(TAG, `Registering load fence ${fence}`);
    this.themeLoadFence = fence;
  }

  /**
   * Report the theme load event on finish
   * Once the count reaches the fence, actual common event will be published
   */
  public reportThemeLoad(): void {
    if (this.hasPublished) {
      Log.info(TAG, 'hasPublished is true.');
      return;
    }
    this.registeredLoadCount++;
    Log.info(TAG, `Received theme load report, current count ${this.registeredLoadCount}`);
    if (this.registeredLoadCount < this.themeLoadFence) {
      return;
    }

    // 延时发布ThemeFinishLoading事件，尽可能保证首帧渲染完成
    let timeOutId: number = setTimeout(this.publishThemeLoaded, FINISH_LOADING_DELAY, this.onPublish);
    if (timeOutId === Constants.NUM_ZERO) {
      Log.info(TAG, 'timeOutId is 0, reset the timeout task.');
      clearTimeout(timeOutId);
      setTimeout(this.publishThemeLoaded, FINISH_LOADING_DELAY, this.onPublish);
    }
    this.hasPublished = true;
  }

  private publishThemeLoaded(publishCallback: AsyncCallback<void>): void {
    try {

      Log.info(TAG, 'On publish ThemeFinishLoading event');
      WallpaperViewController.getInstance().hideUnseenWallpaper();
      WallpaperViewController.getInstance().notifyThemeFinishLoading();
      if (DeviceUtil.isDoubleDisplayPocketProduct()) {
        Log.info(TAG, `DoubleDisplayPocketDevice wait for both engine finish to publish ThemeFinishLoading.`);
        return;
      } else {
        commonEventManager.publish('ThemeFinishLoading', publishCallback);
      }
    } catch (err) {
      Log.error(TAG, `Error on publishing ThemeFinishLoading event, ${err?.code} - ${err?.message}`);
    }
  }

  private onPublish(err: BusinessError): void {
    if (err) {
      Log.error(TAG, `publishThemeLoaded failed, code is ${err?.code}, message is ${err?.message}`);
      return;
    }
    Log.info(TAG, 'Succeeded publish event: ThemeFinishLoading');
  }
}