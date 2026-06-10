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
import { commonEventManager } from '@kit.BasicServicesKit';
import { Singleton, TsLog } from '@ohos/themeservicebase';
import { GlobalPersistCache } from '../../cache/GlobalPersistCache';
import { GlobalPersistInfo } from '../../remote/model/GlobalPersistInfo';
import { GlobalPersistServiceApi } from '../api/GlobalPersistServiceApi';

const TAG: string = 'GlobalPersistServiceImpl';

const EVENT_GLOBAL_PERSIST_CHANGED: string = 'ts.event.persist.change';

export class GlobalPersistServiceImpl implements GlobalPersistServiceApi {
  async setGlobalPersist(globalPersistInfo: GlobalPersistInfo): Promise<boolean> {
    let ret: boolean = await GlobalPersistCache.getInstance().update(globalPersistInfo);
    if (ret) {
      this.notifyPersistChanged();
    }
    return ret;
  }

  async getGlobalPersist(): Promise<Nullable<GlobalPersistInfo>> {
    return await GlobalPersistCache.getInstance().get();
  }

  async clearGlobalPersistData(): Promise<void> {
    let info: Nullable<GlobalPersistInfo> = await this.getGlobalPersist();
    if (!info) {
      TsLog.info(TAG, `no data, not need clear`);
      return;
    }
    let resetInfo: GlobalPersistInfo = {
      themeId: info.themeId,
      version: 0,
      data: {},
    };
    if (await GlobalPersistCache.getInstance().update(resetInfo)) {
      TsLog.info(TAG, `clearGlobalPersistData success`);
      this.notifyPersistChanged();
    }
  }

  private notifyPersistChanged(): void {
    const option: commonEventManager.CommonEventPublishData = {
      subscriberPermissions: ['ohos.permission.ACTIVATE_THEME_PACKAGE'],
      isOrdered: false,
      isSticky: false
    }
    try {
      TsLog.info(TAG, 'notifyPersistChanged start');
      commonEventManager.publish(EVENT_GLOBAL_PERSIST_CHANGED, option, (error) => {
        if (error) {
          TsLog.error(TAG, 'notifyPersistChanged error', error);
        } else {
          TsLog.info(TAG, 'notifyPersistChanged success');
        }
      });
    } catch (error) {
      TsLog.error(TAG, 'publish notifyPersistChanged error', error);
    }
  }
}

export const globalPersistService: Singleton<GlobalPersistServiceImpl> =
  new Singleton<GlobalPersistServiceImpl>(() => new GlobalPersistServiceImpl());
