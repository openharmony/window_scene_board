/**
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved. 2024-2025. All rights reserved.
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

const TAG = 'TransferRelationModel';

export class TransferRelationModel {
  private sourcePackageName: string = '';
  private sourceClassName: string = '';
  private sourceShortcutId: string = '';
  private targetBundleName: string = '';
  private targetModuleName: string = '';
  private targetAbilityName: string = '';
  private appIndex: string = '';
  private shortCutId: string = '';

  constructor(jsonObj: Object) {
    Object.assign(this, jsonObj);
  }

  public isValid(): boolean {
    return !CheckEmptyUtils.checkStrIsEmpty(this.sourcePackageName) &&
      !CheckEmptyUtils.checkStrIsEmpty(this.sourceClassName) &&
      !CheckEmptyUtils.checkStrIsEmpty(this.targetBundleName) &&
      !CheckEmptyUtils.checkStrIsEmpty(this.targetModuleName) &&
      !CheckEmptyUtils.checkStrIsEmpty(this.targetAbilityName);
  }

  /**
   * 获取sourcePackageName
   *
   * @returns string sourcePackageName
   */
  public getSourcePackageName(): string {
    return this.sourcePackageName;
  }

  /**
   * 获取sourceClassName
   *
   * @returns string sourceClassName
   */
  public getSourceClassName(): string {
    return this.sourceClassName;
  }

  /**
   * 获取targetBundleName
   *
   * @returns string targetBundleName
   */
  public getTargetBundleName(): string {
    return this.targetBundleName;
  }

  /**
   * 获取targetModuleName
   *
   * @returns string targetModuleName
   */
  public getTargetModuleName(): string {
    return this.targetModuleName;
  }

  /**
   * 获取targetAbilityName
   *
   * @returns string targetAbilityName
   */
  public getTargetAbilityName(): string {
    return this.targetAbilityName;
  }

  /**
   * 获取targetAbilityName
   *
   * @returns string targetAbilityName
   */
  public getAppIndex(): string {
    return this.appIndex;
  }

  /**
   * 获取targetAbilityName
   *
   * @returns string targetAbilityName
   */
  public getSourceShortcutId(): string {
    return this.sourceShortcutId;
  }

  /**
   * 获取targetAbilityName
   *
   * @returns string targetAbilityName
   */
  public getTargetShortcutId(): string {
    return this.shortCutId;
  }
}