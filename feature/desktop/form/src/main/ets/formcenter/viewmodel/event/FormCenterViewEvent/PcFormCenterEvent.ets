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

import { Position } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { FormCenterViewParam } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { AppItemInfo, CardItemInfo, FormCenterLocation, FormCenterViewManager } from '@ohos/launchercommon';
import { LazyDataSource } from '@ohos/launchercommon/Index';
import { FormCenterViewEvent } from './FormCenterViewEvent';
import { PcFormCenterContentWrapper } from '../../../view/formcenterview/PcFormCenterContentView';
import { FormCenterContentBuilderInterface } from '../../../interfaces/FormCenterContentBuilderInterface';
import StyleManager from '../../../../default/manager/StyleManager';
import { FormCenterEventInterface } from '../../../interfaces/FormCenterEventInterface';
import { BindSheetStateData } from '../../data/BindSheetStateData';
import { ViewCallback } from '@ohos/frameworkwrapper';
import { ViewData } from '../../../../default/viewmodel/FormCenterObservedData';

const TAG = 'PcFormCenterEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class PcFormCenterEvent extends FormCenterViewEvent implements FormCenterEventInterface {
  private static entrancePosition: FormCenterLocation | undefined = FormCenterLocation.DESKTOP;

  constructor(mAppInfoList: LazyDataSource<AppItemInfo>,
    mRecommendedCardList: CardItemInfo[],
    bindSheetStateData: BindSheetStateData,
    mViewData: ViewData,
    mViewStateChangeCallback?: ViewCallback) {
      super(mAppInfoList, mRecommendedCardList, bindSheetStateData, mViewData, mViewStateChangeCallback);
      this.bindSheetStateData.sheetOffset = StyleManager.getSheetFormStyle().sheetOffset;
      FormCenterViewManager.getInstance().setSheetOffsetCallback(() => {
        this.bindSheetStateData.sheetOffset = FormCenterViewManager.getInstance().calculateFormCenterPosition(
          PcFormCenterEvent.entrancePosition) ?? StyleManager.getSheetFormStyle().sheetOffset;
      });
  }

  public showView(param: FormCenterViewParam): void {
    super.showView(param);
    PcFormCenterEvent.entrancePosition = param.entrancePosition ?? PcFormCenterEvent.entrancePosition;
    this.bindSheetStateData.sheetOffset = FormCenterViewManager.getInstance().calculateFormCenterPosition(
      PcFormCenterEvent.entrancePosition) ?? StyleManager.getSheetFormStyle().sheetOffset;
  }

  public getContentBuilder(): FormCenterContentBuilderInterface {
    return new PcFormCenterContentWrapper();
  }
}