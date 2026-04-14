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
import { BaseViewModel } from '@ohos/screenlockcommon/Index';
import { ScreenLockState } from '@ohos/screenlockcommon';

const TAG = 'SCBScreenLockModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * clock widget view model
 *
 * @since 2024-03-19
 */
export class SCBScreenLockModel extends BaseViewModel {
  public onEnterHost(preState: ScreenLockState): void {
    log.showInfo('onEnterHost');
    super.onEnterHost(preState);
    this.mDisplayModeChangeListener?.onDisplayModeChange(this.currentMode);
  }

  public onEnterThemeEditor(preState: ScreenLockState): void {
    log.showInfo('onEnterThemeEditor');
    super.onEnterThemeEditor(preState);
    this.mDisplayModeChangeListener?.onDisplayModeChange(this.currentMode);
  }

  public onEnterFullEditor(preState: ScreenLockState, fullState: ScreenLockState): void {
    super.onEnterFullEditor(preState, fullState);
    this.mDisplayModeChangeListener?.onDisplayModeChange(this.currentMode);
  }

  public onEnterBouncer(preState: ScreenLockState): void {
    super.onEnterBouncer(preState);
    this.mDisplayModeChangeListener?.onDisplayModeChange(this.currentMode);
  }

  public onExitKeyguard(): void {
    super.onExitKeyguard();
    this.mDisplayModeChangeListener?.onDisplayModeChange(this.currentMode);
  }

  public onEnterOtherApp(): void {
    super.onEnterOtherApp();
    this.mDisplayModeChangeListener?.onDisplayModeChange(this.currentMode);
  }

  public onEnterOtherAppBorderShow(): void {
    super.onEnterOtherAppBorderShow();
    this.mDisplayModeChangeListener?.onDisplayModeChange(this.currentMode);
  }

  public onEnterOtherAppBorderHide(): void {
    super.onEnterOtherAppBorderHide();
    this.mDisplayModeChangeListener?.onDisplayModeChange(this.currentMode);
  }
}