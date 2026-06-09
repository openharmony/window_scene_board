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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { bundleResourceManager } from '@kit.AbilityKit';
import { obtainLocalEvent, sEventManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

const TAG: string = 'GlassAppWhiteListManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

export class GlassAppWhiteListManager {
  public static instance: GlassAppWhiteListManager | undefined = undefined;
  private appWhiteList: Want[] = [];

  constructor() {
  }

  public static getInstance(): GlassAppWhiteListManager {
    if (GlassAppWhiteListManager.instance === undefined) {
      log.showInfo(`getInstance new instance`);
      GlassAppWhiteListManager.instance = new GlassAppWhiteListManager();
    }
    return GlassAppWhiteListManager.instance;
  }

  public static destroyInstance(): void {
    log.showInfo(`destroyInstance`);
    GlassAppWhiteListManager.instance = undefined;
  }

  public updateWhiteList(list: Want[]): void {
    log.showInfo(`updateWhiteList,list num is ${list.length}`);
    this.appWhiteList = list;
    sEventManager.publish(obtainLocalEvent('updateGlassWhiteList', true));
  }

  public getWhiteList(): Want[] {
    return this.appWhiteList;
  }

  public isWhiteListApp(bundleName: string): boolean {
    let isWhiteListApp: boolean = this.appWhiteList.find((item: Want) => item.bundleName === bundleName) !== undefined;
    log.showInfo(`isWhiteListApp ${isWhiteListApp}，bundleName is ${bundleName}`);
    return isWhiteListApp;
  }

  public getWhiteListAppWant(bundleName: string): Want | undefined {
    let theWant: Want | undefined = this.appWhiteList.find((item: Want) => item.bundleName === bundleName);
    return theWant;
  }

  public getAppName(bundleName: string): string {
    return bundleResourceManager.getBundleResourceInfo(bundleName,
      bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_LABEL).label;
  }
}