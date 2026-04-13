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

import { FormCenterEventInterface } from '../../../interfaces/FormCenterEventInterface';
import { FormCenterViewParam, } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { FormCenterViewEvent } from './FormCenterViewEvent';
import { CenterTitleBuilderInterface } from '../../../interfaces/FormCenterTitleBuildeInterface';

const TAG = 'ScreenLockFormCenterEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class ScreenLockFormCenterEvent extends FormCenterViewEvent implements FormCenterEventInterface {
  public hideView(height?: number): void {
    log.showDebug('form manage show, recover height');
    this.bindSheetStateData.changeDetents = !this.bindSheetStateData.changeDetents;
  }

  public getTitleBuilder(): CenterTitleBuilderInterface {
    return {};
  }

  onBindSheetDetentsDidChange(height: number): void {
    log.showInfo('onDetentsDidChange height change: ' + height.toString());
    this.mViewStateChangeCallback?.onHeightChange?.(this.viewTag, height);
    this.mFormCenterViewData.setCurrentViewHeight(height);
  }

  protected async firstShowView(param: FormCenterViewParam): Promise<void> {
    this.mViewStateChangeCallback?.onShow?.(this.viewTag);
    this.destroyViewData();
    await this.updateViewData();
    this.mViewStateChangeCallback?.onHeightChange?.(this.viewTag, 0);
    this.updateViewHeight(param.viewHeight, param.viewMaxHeight);
    this.getShowInfo(param.bundleName);
    this.bindSheetStateData.changeDetents = false;
    this.bindSheetStateData.isShow = true;
  }

  protected updateViewHeight(viewHeight?: number, viewMaxHeight?: number): void {
    super.updateViewHeight(viewHeight, viewMaxHeight);
  }
}