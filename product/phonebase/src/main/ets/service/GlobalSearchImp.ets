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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EventType, scbEventExclusiveManager } from '@ohos/windowscene';

import { IExecutor } from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  GlobalSearchLocationHandler
} from '@ohos/pagedesktop/src/main/ets/default/common/viewmodel/GlobalSearchLocationHander';
import { GSResponse } from './GlobalSearchLocationService';
import { sOutSideWindowMgr, GlobalSearchConstants } from '@ohos/frameworkwrapper';

const TAG = 'GlobalSearchImp';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * 全搜接口
 */
export class GlobalSearchImp implements IExecutor {
  async execute(extra: object): Promise<string> {
    log.showInfo('%{public}s execute', TAG);
    sOutSideWindowMgr.hideGlobalSearch(true);
    scbEventExclusiveManager.setEventExclusive(EventType.GLOBALSEARCH_LOCATIONAPPSHOW, true);
    AppStorage.setOrCreate('globalSearchAnimation', true);
    setTimeout(() => {
      const searchParms: SearchParam = extra as SearchParam;
      GlobalSearchLocationHandler.getInstance().beginLocationAnimation(searchParms.bundleName,
        searchParms.abilityName, searchParms.moduleName, searchParms.typeId, searchParms.entityId);
    }, GlobalSearchConstants.DURATION_AUTO_DISAPPEAR);
    return GSResponse.success;
  }
}

interface SearchParam {
  bundleName: string;
  abilityName: string;
  moduleName: string;
  typeId: number;
  entityId: string;
}