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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  BaseViewModel,
  EDIT_GUIDE_MODE,
  NONE_EDIT_MODE } from '@ohos/screenlockcommon';
import { ScreenLockState } from '@ohos/screenlockcommon';

const TAG = 'LockIconModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * clock widget view model
 *
 * @since 2024-03-19
 */
export class LockIconModel extends BaseViewModel {

  public onEnterHost(preState: ScreenLockState): void {
    log.showInfo('onEnterHost');
    this.mDisplayModeChangeListener?.onDisplayModeChange(NONE_EDIT_MODE);
  }

  public onEnterThemeEditor(preState: ScreenLockState): void {
    log.showInfo('onEnterThemeEditor');
    this.mDisplayModeChangeListener?.onDisplayModeChange(EDIT_GUIDE_MODE);
  }
}