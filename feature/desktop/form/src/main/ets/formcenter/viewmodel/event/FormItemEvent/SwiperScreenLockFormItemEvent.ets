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
import {
  CardItemInfo,
  CommonConstants,
  FormCenterViewManager,
  vibratorMgr,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { FormItemData } from '../../data/FormItemVm';
import { SwiperLayoutFormEvent } from './SwiperLayoutFormEvent';
import { AttributeUpdater } from '@kit.ArkUI';
import ScreenLockFormModel from '../../../../default/viewmodel/ScreenLockFormModel';
import { ScreenLockParentUpdater } from '../../modifier/SwiperFormModifier';
import {
  clockLayoutHelper
} from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutHelper';
import PerformanceMonitorUtil, { CardItemUEInfo } from '@ohos/screenlockcommon/src/main/ets/record/report/PerformanceMonitorUtil';
import { SCREEN_LOCK_EDIT_CARD_ADD_DRAG } from '../../../../default/common/constants/FormReportConstants';

const TAG = 'SwiperScreenLockFormItemEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const FORM_PADDING: number = 12;

export class SwiperScreenLockFormItemEvent extends SwiperLayoutFormEvent {
  private formModel: ScreenLockFormModel = new ScreenLockFormModel();
  private viewManager: FormCenterViewManager = FormCenterViewManager.getInstance();

  public initFormUIConfig(formItemUIConfig: FormItemData, formScale?: number | undefined): void {
    formItemUIConfig.index = this.index;
    let isScreenVertical: boolean = SCBScreenSessionManager.getInstance().isScreenVertical();
    let gridWidth: number = clockLayoutHelper.getLayoutGridWidth(isScreenVertical);

    formItemUIConfig.formDisplayHeight = gridWidth - FORM_PADDING;
    formItemUIConfig.formDisplayWidth = this.formItem.cardDimension === CommonConstants.CARD_DIMENSION_1x2 ?
      gridWidth * 2 - FORM_PADDING / 2 : (gridWidth - FORM_PADDING);
    formItemUIConfig.hiddenStrokes = true;
    this.swiperFormAnimate.setFormWidth(this.index, formItemUIConfig.formDisplayWidth);

    formItemUIConfig.parentUpdater = new ScreenLockParentUpdater(formItemUIConfig, this.swiperFormAnimate);
    this.parentUpdater = formItemUIConfig.parentUpdater;
    formItemUIConfig.formUpdater = new AttributeUpdater();
    this.formUpdater = formItemUIConfig.formUpdater;
    this.setParentUpdater?.(this.index, this.parentUpdater, this.formUpdater);
  }

  public onDragStart(event?: DragEvent, extraParams?: string): DragItemInfo {
    log.showWarn('onDragStart');
    AppStorage.setOrCreate<boolean>('isScreenLockFormDrag', true);
    let formItem: CardItemInfo = this.copyCard();

    //上报拖拽添加卡片
    let cardUEItem: CardItemUEInfo = {
      formId: formItem.cardId.toString(),
      packageName: formItem.bundleName,
      cardDimension: formItem.cardDimension.toString(),
      moduleName: formItem.moduleName,
      formName: formItem.description,
    };
    PerformanceMonitorUtil.reportLockscreenEditCardDrag(cardUEItem, SCREEN_LOCK_EDIT_CARD_ADD_DRAG);

    let dragItemInfo: DragItemInfo = this.formModel.onDragStart(formItem, this.formItemAnimData.dragSnapshot);
    this.viewManager.closeFormManagerView(true);
    this.viewManager.recoveryFormCenterHeight();
    return dragItemInfo;
  }

  public onDragEnd() {
    AppStorage.setOrCreate<boolean>('isScreenLockFormDrag', false);
    this.formModel.onDragEnd();
    log.showWarn('onDragEnd');
  }

  public isDragable(): boolean {
    return true;
  }

  public onVibratorLongPress(event: GestureEvent): void {
    vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
      CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
  }
}