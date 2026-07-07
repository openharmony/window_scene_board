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

export class OhosSuperAdditionRelationModel {
  private sourcePackageNameArr: string[] = [];
  private targetBundleName: string = '';

  constructor(jsonObj: Object) {
    ObjectCopyUtil.simpleClone(jsonObj, this);
  }

  public isValid(): boolean {
    return Array.isArray(this.sourcePackageNameArr) &&
      !CheckEmptyUtils.isEmptyArr(this.sourcePackageNameArr) &&
      !CheckEmptyUtils.checkStrIsEmpty(this.targetBundleName);
  }

  /**
   * 获取sourcePackageName
   *
   * @returns string sourcePackageName
   */
  public getSourcePackageArr(): string[] {
    return this.sourcePackageNameArr;
  }

  /**
   * 获取targetBundleName
   *
   * @returns string targetBundleName
   */
  public getTargetBundleName(): string {
    return this.targetBundleName;
  }
}