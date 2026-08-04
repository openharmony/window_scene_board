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
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { AppReserveType } from './TransformAppInfoManager';

// 第三位非空，表示该应用为尝鲜应用
const APP_TASTE_FRESH = 1 << 2;
// 第四位非空，表示该应用在应用的分发清单内
const APP_IN_APP_LIST = 1 << 3;
// 第五位非空，表示该应用在克隆应用的分发清单内
const APP_IN_DELIVER_TONG_LIST = 1 << 4;
// 第六位非空，表示该应用不在分发清单，但是兜底允许
const APP_NOT_IN_LIST = 1 << 5;
// 第七位非空，表示该应用为企业应用
const APP_ENTERPRISE = 1 << 6;

/**
 *  系统迁移三方应用、企业应用和应用市场尝鲜应用本地映射信息
 *    从 third_dev_module_migrate_policy.json和enterprise_module_migrate_policy.json和ag_module_migrate_policy.json解析
 */
export class LocalHapMigrateInfo {
  public sourceModule: string = '';

  public sourceModules: string[] = [];

  public targetModule: string = '';

  public migrateData: string = '';

  public sourceModuleSignature: string = '';

  // 0 三方应用  1 企业应用  2  应用市场尝鲜应用  3 克隆应用应用 4 兜底入克隆应用应用 5 应用应用
  public type: number = 0;

  // 企业应用URL
  public targetModuleUrl: string = '';

  constructor(jsonObj: Object) {
    ObjectCopyUtil.simpleClone(jsonObj, this);
    if (this.type !== undefined) {
      if (this.type & APP_TASTE_FRESH) {
        this.type = AppReserveType.TASTE_FRESH;
        return;
      } else if (this.type & APP_IN_DELIVER_TONG_LIST) {
        this.type = AppReserveType.DELIVER_TONG;
        return;
      } else if (this.type & APP_NOT_IN_LIST) {
        this.type = AppReserveType.OTHER_DELIVER;
        return;
      } else if (this.type & APP_IN_APP_LIST) {
        this.type = AppReserveType.APP;
        return;
      } else if (this.type & APP_ENTERPRISE) {
        this.type = AppReserveType.ENTERPRISE;
        return;
      }
    }
  }

  public get source(): string {
    return this.sourceModule;
  }

  public get sources(): string[] {
    return this.sourceModules;
  }

  public get target(): string {
    return this.targetModule;
  }

  public isValid(): boolean {
    if ((CheckEmptyUtils.checkStrIsEmpty(this.sourceModule) && CheckEmptyUtils.isEmptyArr(this.sourceModules)) ||
    CheckEmptyUtils.checkStrIsEmpty(this.targetModule)) {
      return false;
    }
    return true;
  }
}
