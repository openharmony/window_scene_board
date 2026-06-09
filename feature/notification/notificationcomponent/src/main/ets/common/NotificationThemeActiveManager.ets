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

import {
  LogDomain,
  LogHelper,
  SingletonHelper
} from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import commonEventManager from '@ohos.commonEventManager';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { VisualEffectConstants } from '@ohos/commonconstants';

const TAG: string = 'SysUI-NotificationThemeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 主题使能公共事件
 */
const ACTIVE_EVENT: string = 'com.ohos.ActivateTheme';
/**
 * 使能主题权限
 */
const PERMISSION_ACTIVATE_THEME: string = 'ohos.permission.ACTIVATE_THEME_PACKAGE';


export class NotificationThemeActiveManager {
  private activeThemeCallbacks: Set<NotificationThemeActiveCallback> = new Set();

  private brightnessEffectChangeCallbacks: Set<BrightnessEffectChangeCallback> = new Set();

  private subscriber?: commonEventManager.CommonEventSubscriber;

  private ntfBrightnessEffectResources: Array<Resource> = [$r('app.color.theme_ntf_color_text_primary')
    , $r('app.color.theme_ntf_color_text_secondary'), $r('app.color.theme_ntf_color_text_tertiary')
    , $r('app.color.ntf_blur_style_bg'), $r('app.color.ntf_phone_all_clear_bg_color')];

  private ntfBrightnessResourceDefault: Array<Resource> = [$r('sys.color.ohos_id_color_text_primary')
    , $r('sys.color.ohos_id_color_text_secondary'), $r('sys.color.ohos_id_color_text_tertiary'),
    $r('app.color.ntf_bg_color_default'), $r('app.color.ntf_all_clear_bg_color_default')];

  private ntfBrightnessResourceDark: Array<Resource> = [$r('sys.color.ohos_id_color_text_primary')
    , $r('sys.color.ohos_id_color_text_secondary'), $r('sys.color.ohos_id_color_text_tertiary'),
    $r('app.color.ntf_bg_color_dark'), $r('app.color.ntf_all_clear_bg_color_dark')];

  private ntfBrightnessResourceOverlayDefault: Array<Resource> = [$r('app.color.theme_ntf_color_text_primary')
    , $r('app.color.theme_ntf_color_text_no_brightness_secondary'),
    $r('app.color.theme_ntf_color_text_no_brightness_tertiary'),
    $r('app.color.ntf_blur_style_no_brightness_bg'), $r('app.color.ntf_phone_all_clear_no_brightness_bg_color')];

  private isNtfBrightnessUseEffect: boolean = true;

  private isNtfBrightnessDisable: boolean = false;

  constructor() {
    if (DeviceHelper.isPC()) {
      this.subscriberThemeActive();
      this.updateNtfBrightnessUseEffect();
    }
  }

  registerNotificationThemeActive(callback: NotificationThemeActiveCallback): void {
    this.activeThemeCallbacks.add(callback);
  }

  unregisterNotificationThemeActive(callback: NotificationThemeActiveCallback): void {
    this.activeThemeCallbacks.delete(callback);
  }

  registerBrightnessEffectChange(callback: BrightnessEffectChangeCallback): void {
    this.brightnessEffectChangeCallbacks.add(callback);
    this.updateNtfBrightnessUseEffect();
  }

  unregisterBrightnessEffectChange(callback: BrightnessEffectChangeCallback): void {
    this.brightnessEffectChangeCallbacks.delete(callback);
  }

  isNtfBrightnessEffectUse(): boolean {
    return this.isNtfBrightnessUseEffect;
  }

  deinit(): void {
    if (this.subscriber) {
      commonEventManager.unsubscribe(this.subscriber);
      this.subscriber = undefined;
    }
  }

  private subscriberThemeActive(): void {
    const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [ACTIVE_EVENT],
      publisherPermission: PERMISSION_ACTIVATE_THEME
    };
    commonEventManager.createSubscriber(subscribeInfo).then((res) => {
      this.subscriber = res;
      try {
        commonEventManager.subscribe(this.subscriber, (err) => {
          log.showInfo(`receive active theme event, err: ${err?.code}, ${err?.message}`);
          this.onThemeActive();
        });
      } catch (err) {
        log.error('subscribe err:', err);
      }
    });
  }

  public onThemeActive(): void {
    this.activeThemeCallbacks.forEach((callback) => callback.updateOnThemeActive());
    this.updateNtfBrightnessUseEffect();
  }

  private isNtfBrightnessEqual(index: number): boolean {
    this.isNtfBrightnessDisable =
      SCBVisualEffectMgr.getFeatureParam(VisualEffectConstants.NTF_BRIGHTENS_DISABLE) === 'true';
    if (this.isNtfBrightnessDisable && ResUtils.getColor(this.ntfBrightnessEffectResources[index]) ===
    ResUtils.getColor(this.ntfBrightnessResourceOverlayDefault[index])) {
      return false;
    }
    return true;
  }

  private updateNtfBrightnessUseEffect(): void {
    for (let index = 0; index < this.ntfBrightnessEffectResources.length; index++) {
      log.showInfo(`updateNtfBrightnessUseEffect, ${ResUtils.getColor(this.ntfBrightnessEffectResources[index]) ??
        0}, ${ResUtils.getColor(this.ntfBrightnessResourceDefault[index])}, ${ResUtils
        .getColor(this.ntfBrightnessResourceDark[index])}`);
      if (ResUtils.getColor(this.ntfBrightnessEffectResources[index]) !==
      ResUtils.getColor(this.ntfBrightnessResourceDefault[index]) &&
        ResUtils.getColor(this.ntfBrightnessEffectResources[index]) !==
        ResUtils.getColor(this.ntfBrightnessResourceDark[index]) && this.isNtfBrightnessEqual(index)) {
        log.showInfo(`updateNtfBrightnessEffect use.`);
        this.isNtfBrightnessUseEffect = false;
        this.brightnessEffectChangeCallbacks.forEach((callback) => callback
          .updateOnBrightnessEffectChange(this.isNtfBrightnessUseEffect));
        return;
      }
    }
    if (!this.isNtfBrightnessUseEffect) {
      log.showInfo(`updateNtfBrightnessEffect not use.`);
      this.isNtfBrightnessUseEffect = true;
      this.brightnessEffectChangeCallbacks.forEach((callback) => callback
        .updateOnBrightnessEffectChange(this.isNtfBrightnessUseEffect));
    }
  }
}

export interface NotificationThemeActiveCallback {
  updateOnThemeActive: () => void;
}

export interface BrightnessEffectChangeCallback {
  updateOnBrightnessEffectChange: (isEffect: boolean) => void;
}

export let ntfThemeActiveMgr: NotificationThemeActiveManager = SingletonHelper
  .getInstance(NotificationThemeActiveManager, TAG);