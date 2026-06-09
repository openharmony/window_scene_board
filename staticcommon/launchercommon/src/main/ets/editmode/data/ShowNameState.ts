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

const TAG = 'ShowNameState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 是否显示名称类
 */
@Observed
export class ShowNameState {
  /**
   * 是否显示名称
   */
  private isNameShow: boolean = true;

  /**
   * 设置是否显示名称
   *
   * @param isEditMode
   */
  public setIsShowName(isNameShow: boolean): void {
    log.showInfo('setIsShowName: %{public}s', isNameShow);
    this.isNameShow = isNameShow;
  }

  /**
   * 判断是否显示名称
   *
   * @returns boolean
   */
  public isShowName(): boolean {
    return this.isNameShow;
  }
}