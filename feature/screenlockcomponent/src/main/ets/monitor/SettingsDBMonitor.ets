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

import DataShareManager from '@ohos/screenlockcommon/src/main/ets/base/DataShareManager';
import { BaseStatusMonitor } from '@ohos/screenlockcommon/Index';
import { ObserverStageEnum } from '@ohos/screenlockcommon';


export class SettingsDBMonitor extends BaseStatusMonitor<boolean> {
  private static instance: SettingsDBMonitor;

  protected constructor() {
    super();
  }


  public static getInstance(): SettingsDBMonitor {
    if (!SettingsDBMonitor.instance) {
      SettingsDBMonitor.instance = new SettingsDBMonitor();
    }
    return SettingsDBMonitor.instance;
  }

  public initStatus(): void {
    this.publishAtStage(ObserverStageEnum.INITIAL);
  }

  public register(): void {
    setTimeout(() => {
      for (let key of this.getSubscriberNames()) {
        this.infoLog(`start register db key:${key},size=${this.getSubscriberSize(key)}`);
        this.startDataListener(key);
        this.infoLog(`end register db key:${key}`);
      }
    }, 500);
  }

  protected startDataListener(key: string | null) {
    if (key === null || key === undefined) {
      return;
    }
    let keySplitArr: string[] = key.split('|');
    if (keySplitArr.length > 1) {
      DataShareManager.getInstance().registerSecureDataShareListener(keySplitArr[0], () => {
        this.handleStatusChange(true, () => {
          this.infoLog(`db key:${key} changed`);
          this.publishAtStage(key, true);
        });
      });
      return;
    }
    DataShareManager.getInstance().registerDataShareListener(key, () => {
      this.handleStatusChange(true, () => {
        this.infoLog(`db key:${key} changed`);
        this.publishAtStage(key, true);
      });
    });
  }

  public unregister(): void {
    for (let key of this.getSubscriberNames()) {
      this.infoLog(`start unregister db key:${key},size=${this.getSubscriberSize(key)}`);
      if (key === null || key === undefined) {
        continue;
      }
      let keySplitArr: string[] = key.split('|');
      if (keySplitArr.length > 1) {
        DataShareManager.getInstance().unregisterSecureDataShareListener(keySplitArr[0]);
      } else {
        DataShareManager.getInstance().unregisterDataShareListener(key);
      }
      this.infoLog(`end unregister db key:${key},size=${this.getSubscriberSize(key)}`);
    }
  }
}
