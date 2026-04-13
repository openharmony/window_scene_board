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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { EvtBus, PackageCommonEvent, SettingsUtil } from '@ohos/frameworkwrapper';
import { settings } from '@kit.BasicServicesKit';
import { bundleManager } from '@kit.AbilityKit';

const TAG: string = 'VisionGlassListener';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const VISION_GLASS_BUNDLE_NAME: string = 'com.ohos.visionglass';
const PRIVACY_AGREEMENT_VALUE_NAME: string = 'visionglass.data.space_mode_prerequisites';
const PRIVACY_AGREEMENT_VALUE_FALSE: string = '0';

class VisionGlassListener {
  public isVisionGlassAppExist: boolean = false;
  private onPackageChangeEvent = (event: PackageCommonEvent): void => {
    if (!event) {
      log.showError(`onPackageChangeEvent cancel,event is invalid`);
      return;
    }
    log.showInfo(`onPackageChangeEvent,event type is ${event.event}`);
    switch (event.event) {
      case PackageCommonEvent.EVENT_PACKAGE_ADD:
        this.handlePackageAddEvent(event);
        break;
      case PackageCommonEvent.EVENT_PACKAGE_REMOVED:
      case PackageCommonEvent.EVENT_PACKAGE_FULL_REMOVED:
        this.handlePackageRemoveEvent(event);
        break;
      default:
        break;
    }
  }

  public async initPolicy(): Promise<void> {
    EvtBus.on(PackageCommonEvent, this.onPackageChangeEvent);
    this.initVisionGlassStatus();
  }

  public unInit(): void {
    EvtBus.off(PackageCommonEvent, this.onPackageChangeEvent);
  }

  private handlePackageAddEvent(event: PackageCommonEvent): void {
    if (event.bundleName !== VISION_GLASS_BUNDLE_NAME) {
      return;
    }
    log.showInfo(`handlePackageAddEvent,start`);
    this.isVisionGlassAppExist = true;
  }

  private handlePackageRemoveEvent(event: PackageCommonEvent): void {
    if (event.bundleName !== VISION_GLASS_BUNDLE_NAME) {
      return;
    }
    log.showInfo(`handlePackageRemoveEvent,start`);
    this.isVisionGlassAppExist = false;
    SettingsUtil.setValueEx(settings.domainName.USER_PROPERTY, PRIVACY_AGREEMENT_VALUE_NAME,
      PRIVACY_AGREEMENT_VALUE_FALSE);
  }

  private async initVisionGlassStatus(): Promise<void> {
    try {
      let info: bundleManager.ApplicationInfo =
        await bundleManager.getApplicationInfo(VISION_GLASS_BUNDLE_NAME,
          bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT);
      if (info) {
        this.isVisionGlassAppExist = true;
      }
    } catch (err) {
      log.showError(`initVisionGlassStatus fail ,error is ${err.code}`);
    }
  }
}

export const visionGlassListener: VisionGlassListener = SingletonHelper.getInstance(VisionGlassListener, TAG);