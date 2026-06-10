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

const TAG = 'EditModeState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Observed
export class EditModeState {
  /**
   * 是否编辑模式
   */
  private isEditMode: boolean = false;

  /**
   * 设置是否编辑模式
   *
   * @param isEditMode
   */
  public setIsInEditMode(isEditMode: boolean): void {
    log.showInfo('setIsInEditMode: %{public}s', isEditMode);
    this.isEditMode = isEditMode;
  }

  /**
   * 判断是否编辑模式
   *
   * @returns boolean
   */
  public isInEditMode(): boolean {
    return this.isEditMode;
  }
}