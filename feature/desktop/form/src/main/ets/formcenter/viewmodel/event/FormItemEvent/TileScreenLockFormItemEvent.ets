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
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { CardItemInfo, CommonConstants, FormCenterViewManager, vibratorMgr } from '@ohos/launchercommon';
import display from '@ohos.display';
import { componentUtils, AttributeUpdater } from '@kit.ArkUI';
import PerformanceMonitorUtil, { CardItemUEInfo } from '@ohos/screenlockcommon/src/main/ets/record/report/PerformanceMonitorUtil';
import { TileFormItemEvent } from './TileFormItemEvent';
import { FormItemData } from '../../data/FormItemVm';
import ScreenLockFormModel from '../../../../default/viewmodel/ScreenLockFormModel';
import { FormCenterViewData } from '../../../../default/viewmodel/FormCenterViewData';
import { SCREEN_LOCK_EDIT_CARD_ADD_DRAG } from '../../../../default/common/constants/FormReportConstants';
import {
  clockLayoutHelper
} from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutHelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { FormUtil } from '../../../../default/util/FormUtil';

const TAG: string = 'TileScreenLockFormItemEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const FORM_PADDING: number = 12;
const SCREEN_GRIDWIDTH: number = 80;

class FormUpdater extends AttributeUpdater<CommonAttribute> {
  private formItemUIConfig: FormItemData = new FormItemData();
  constructor(formItemUIConfig: FormItemData) {
    super();
    this.formItemUIConfig = formItemUIConfig;
  }

  initializeModifier(instance: CommonAttribute): void {
    instance.width(Math.floor(vp2px(this.formItemUIConfig.formDisplayWidth)) + 'px')
      .height(Math.floor(vp2px(this.formItemUIConfig.formDisplayHeight)) + 'px')
  }
}

export class TileScreenLockFormItemEvent extends TileFormItemEvent {
  protected isClickable: boolean = false;
  private formModel: ScreenLockFormModel = new ScreenLockFormModel();
  protected formItemUIConfig: FormItemData = new FormItemData();

  public onClick(event?: ClickEvent): void {
    let isScreenLockFormDrag: boolean | undefined = AppStorage.get<boolean>('isScreenLockFormDrag');
    if (isScreenLockFormDrag) {
      log.showInfo('screenLock card is drag');
      return;
    }
    let height: number = px2vp(FormCenterViewData.getInstance().mCurrentHeight);
    FormCenterViewManager.getInstance().recoveryFormCenterHeight();
    this.formModel.onClick(this.formItem, height, this.getFormItemSnapId());
  }

  private getDragStartPositionOffset(snapShotId: string, event: DragEvent): Position {
    if (!event) {
      log.showError('DragEvent is undefined');
      return { x: 0, y: 0 };
    }

    let touchX = event.getWindowX();
    let touchY = event.getWindowY();
    try {
      let displayHeight: number = display.getDefaultDisplaySync().height;
      let info = componentUtils.getRectangleById(snapShotId) as componentUtils.ComponentInfo;
      let offsetX = px2vp(info.windowOffset.x + info.size.width / 2) - touchX;
      let offsetY = px2vp(info.windowOffset.y + info.size.height / 2 + displayHeight) -
        touchY - px2vp(FormCenterViewData.getInstance().mCurrentHeight);
      return { x: offsetX, y: offsetY };
    } catch (err) {
      log.showError('failed to get screenHeight');
    }
    return { x: 0, y: 0 };
  }

  public onDragStart(event?: DragEvent, extraParams?: string): DragItemInfo {
    log.showWarn('onDragStart');
    let formItem: CardItemInfo = new CardItemInfo();
    AppStorage.setOrCreate<boolean>('isScreenLockFormDrag', true);
    ObjectCopyUtil.deepClone<CardItemInfo>(this.formItem, formItem);
    formItem.cardId = this.cardId as string;
    formItem.id = this.cardId as string;
    formItem.dimension = this.formItem.cardDimension;
    formItem.name = formItem.cardName;

    //上报拖拽添加卡片
    let cardUEItem: CardItemUEInfo = {
      formId: formItem.cardId.toString(),
      packageName: formItem.bundleName,
      cardDimension: formItem.cardDimension.toString(),
      moduleName: formItem.moduleName,
      formName: formItem.description,
    };
    PerformanceMonitorUtil.reportLockscreenEditCardDrag(cardUEItem, SCREEN_LOCK_EDIT_CARD_ADD_DRAG);

    FormCenterViewManager.getInstance().recoveryFormCenterHeight();
    let dragItemInfo: DragItemInfo = this.formModel.onDragStart(this.formItem,
      this.formItemAnimData.dragSnapshot,
      this.getDragStartPositionOffset(this.getFormItemSnapId(), event as DragEvent));
    return dragItemInfo;
  }

  public initFormUIConfig(formItemUIConfig: FormItemData, formScale?: number): void {
    let gridWidth: number = FormUtil.getGridWidth();
    formItemUIConfig.formDisplayHeight = gridWidth - FORM_PADDING;
    formItemUIConfig.formDisplayWidth = this.formItem.cardDimension === CommonConstants.CARD_DIMENSION_1x2 ?
      gridWidth * 2 - FORM_PADDING / 2 : (gridWidth - FORM_PADDING);
    formItemUIConfig.hiddenStrokes = true;
    formItemUIConfig.hasFadeInAnimation = true;

    if (formItemUIConfig.formDisplayHeight && formItemUIConfig.formDisplayWidth) {
      formItemUIConfig.formUpdater = new FormUpdater(formItemUIConfig);
    }

    formItemUIConfig.isSupportBrightness = true;
  }

  public onDragEnd(): void {
    log.showWarn('onDragEnd');
    AppStorage.setOrCreate<boolean>('isScreenLockFormDrag', false);
    this.formModel.onDragEnd();
  }

  public isDragable(): boolean {
    return true;
  }

  public onVibratorLongPress(event: GestureEvent): void {
    vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
      CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
  }

  public getFormWant(formItem: CardItemInfo): Want | undefined {
    return undefined;
  }
}