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
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { CardItemInfo, FormCenterViewManager } from '@ohos/launchercommon';
import { FormCenterViewData } from '../../../../default/viewmodel/FormCenterViewData';
import ScreenLockFormModel from '../../../../default/viewmodel/ScreenLockFormModel';
import { FormItemEventInterface } from '../../../interfaces/FormItemEventInterface';
import { SwiperScreenLockFormItemEvent } from '../FormItemEvent/SwiperScreenLockFormItemEvent';
import { SwiperLayoutEvent } from './SwiperLayoutEvent';
import { AttributeUpdater } from '@kit.ArkUI';
import { CloseReason, FormCenterViewModel } from '../../FormCenterViewModel';
import FormStyleConstants from '../../../../default/common/constants/FormStyleConstants';
import { FormCenterFormCommonUtil } from '../FormCenterFormCommonUtil';

const TAG: string = 'SwiperScreenLockViewEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class SwiperScreenLockViewEvent extends SwiperLayoutEvent {
  private formModel: ScreenLockFormModel = new ScreenLockFormModel();
  private viewManager: FormCenterViewManager = FormCenterViewManager.getInstance();

  public getFormItemEvent(index: number): FormItemEventInterface {
    let event: FormItemEventInterface = new SwiperScreenLockFormItemEvent(
      this.swiperLayoutViewData.appFormList[index], index, this.mAppInfo,
      (index: number) => {
        return index === this.swiperLayoutViewData.swipeTargetIndex
      },
      (index: number, cardId: string) => {
        this.setCardId(index, cardId);
      },
      this.swiperFormAnimate,
      (index: number, parentUpdater: AttributeUpdater<CommonAttribute>,
        formModifier: AttributeUpdater<CommonAttribute>) => {
        this.parentAnimateModifierList[index] = parentUpdater;
        this.formModifierList[index] = formModifier;
      });
    return event;
  }

  public onButtonTouch(event: TouchEvent) {
    this.isSnapshotDone = true;
  }

  onButtonClick(event: ClickEvent) {
    FormCenterViewModel.getInstance().setCloseReason(CloseReason.CLOSE_BY_ADD_FORM);
    this.addFormToDeskTop();
  }

  protected addFormToDeskTop(): void {
    log.showWarn('form add to desktop click');
    let formItem: CardItemInfo = this.copyCard();
    let isScreenVertical: boolean = SCBScreenSessionManager.getInstance().isScreenVertical();
    let height: number =
      FormCenterViewData.getInstance().getViewData(isScreenVertical).navDestinationViewData.bindSheetHeight;
    let bundleName: string = FormCenterViewModel.getInstance().isCurrentSuggestion ?
      FormStyleConstants.FORM_CENTER_DEFAULT_ITEM : this.swiperLayoutViewData.appFormList[0].bundleName;
    this.formModel.onClick(formItem, height,
      FormCenterFormCommonUtil.getFormItemId(bundleName, this.swiperLayoutViewData.swipeTargetIndex));
    this.viewManager.closeFormManagerView(true);
    this.viewManager.recoveryFormCenterHeight();
  }
}