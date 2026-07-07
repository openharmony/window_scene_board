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
import { CheckEmptyUtils } from '@ohos/basicutils';
import { CompatibilityDataManager } from '../../CompatibilityDataManager';
import { RestoreCompatibilityInfo } from '../model/RestoreCompatibilityInfo';
import { RestoreCompInfoProxy } from '../RestoreCompInfoProxy';

/**
 * 数据库版本高低高低兼容处理：返回当前数据库版本号
 */
export class DbRestoreCompInfo implements RestoreCompInfoProxy {
  public async getRestoreCompInfo(compInfo: RestoreCompatibilityInfo): Promise<void> {
    if (CheckEmptyUtils.isEmpty(compInfo)) {
      compInfo = new RestoreCompatibilityInfo();
    }
    let curDbVersion = await CompatibilityDataManager.getInstance().getCurDbVersion();
    compInfo.setDbVersion(curDbVersion);
  }
}