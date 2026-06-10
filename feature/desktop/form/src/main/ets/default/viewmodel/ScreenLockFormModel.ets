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
import { Want } from '@kit.AbilityKit';
import { componentUtils } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import componentSnapshot from '@ohos.arkui.componentSnapshot';
import display from '@ohos.display';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DragExtraInfo, DragDataType } from '@ohos/componentdrag';
import { GlobalContext, DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { CardItemInfo, CommonConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FormCenterResponseCode } from '../service/ServiceInterface';
import { screenLockAniMgr, ScreenLockAniScene } from '@ohos/screenlockwidget/src/main/ets/formAni/ScreenLockFormAniMgr';
import { systemDateTime } from '@kit.BasicServicesKit';
import {
  clockLayoutHelper
} from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutHelper';
import { FormUtil } from '../util/FormUtil';

const ADD_FORM_PADDING: number = 24;
const DRAG_FORM_PADDING: number = 12;
const NORMAL_GRID_MARGIN: number = 24;
const PAD_GRID_MARGIN: number = 99;
const NORMAL_VERTICAL_GRID_MARGIN: number = 104;
const SCREEN_LOCK_KEY: number = 6;

const PAD_PORTRAIT_GRID: GridAmount = {x: 6, y: 10};
const PAD_LANDSCAPE_GRID: GridAmount = {x: 10, y: 6};
const PHONE_GRID: GridAmount = {x: 4, y: 7};
const FOLD_EXPAND_GRID: GridAmount = {x: 8, y: 7};
const FORM_LOCATION_KEY = 'ohos.extra.param.key.form_location';
const FORM_PRIVACY_KEY = 'isPrivacyScene';

const TAG = 'ScreenLockFormModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export default class ScreenLockFormModel {
  private gridNormal: GridAmount = PHONE_GRID;
  private gridSpecial: GridAmount = PHONE_GRID;
  private verticalMargin: number = NORMAL_VERTICAL_GRID_MARGIN;
  private horizontalMargin: number = NORMAL_GRID_MARGIN;

  constructor() {
    if (DeviceHelper.isPad()) {
      this.gridNormal = PAD_LANDSCAPE_GRID;
      this.gridSpecial = PAD_PORTRAIT_GRID;
      this.verticalMargin = PAD_GRID_MARGIN;
      this.horizontalMargin = PAD_GRID_MARGIN;
    }

    if (DeviceHelper.isFoldButNotSmallFoldProduct()) {
      this.gridSpecial = FOLD_EXPAND_GRID;
    }
  }

  /**
   * 获取卡片类型
   *
   * @returns 锁屏类型卡片的want
   */
  public getScreenLockWant(): Want {
    let want: Want = {};
    want.parameters = {};
    want.parameters[FORM_LOCATION_KEY] = SCREEN_LOCK_KEY;
    want.parameters[FORM_PRIVACY_KEY] = true;
    return want;
  }

  /**
   * 计算宫格宽度
   *
   * @returns 宫格宽度
   */
  public getGridWidth(): number {
    try {
      const screenDisplay: display.Display = display.getDefaultDisplaySync();
      let layoutGridAmount: GridAmount = this.getLayoutGridAmount();
      let xGridAmount = Math.min(layoutGridAmount.x, layoutGridAmount.y);
      let yGridAmount = Math.max(layoutGridAmount.x, layoutGridAmount.y);
      let screenWidth = px2vp(screenDisplay.width);
      let screenHeight = px2vp(screenDisplay.height);
      let calcWidth = Math.min(screenWidth, screenHeight);
      let calcHeight = Math.max(screenWidth, screenHeight);
      let singleWidth = (calcWidth - this.horizontalMargin * 2) / xGridAmount;
      let singleHeight = (calcHeight - this.verticalMargin * 2) / yGridAmount;
      let singleGridWidth: number = Math.min(singleWidth, singleHeight);
      return singleGridWidth;
    } catch (err) {
      log.showError('failed to get default display');
    }
    return 0;
  }

  public onClick(formItem: CardItemInfo, height: number, snapShotId?: string): void {
    let gridWidth: number = FormUtil.getGridWidth();
    let formHeight: number = gridWidth - ADD_FORM_PADDING;
    let formWidth: number = formItem.cardDimension === CommonConstants.CARD_DIMENSION_1x2 ?
      gridWidth * 2 - ADD_FORM_PADDING : (gridWidth - ADD_FORM_PADDING);
    let info = componentUtils.getRectangleById(snapShotId) as componentUtils.ComponentInfo;
    try {
      let displayHeight = display.getDefaultDisplaySync().height;
      let x: number = px2vp(info.windowOffset.x + info.size.width / 2);
      let y: number = px2vp(info.windowOffset.y + info.size.height / 2 + displayHeight) - height;
      formItem.tempId = systemDateTime.getTime(true).toString();
      componentSnapshot.get(snapShotId).then((value: image.PixelMap) => {
        GlobalContext.getContext()?.eventHub
          .emit('waitFormCenterResponse', { code: FormCenterResponseCode.ADD_FORM, formInfo: formItem,
            startPosition: {x, y} });
        GlobalContext.getContext()?.eventHub
          .emit('waitSubFormManagerResponse', { code: FormCenterResponseCode.ADD_FORM, formInfo: formItem,
            startPosition: {x, y} });
        let key: string = `${formItem.cardName}_${formItem.tempId}`;
        screenLockAniMgr.prepareAnimation(ScreenLockAniScene.BIND_SHEET, key)?.setSnapshot(value).setHeight(formHeight).
        setRadius(formHeight / 2).setWidth(formWidth).setGridWidth(gridWidth).
        setDimensionX(formItem.cardDimension === CommonConstants.CARD_DIMENSION_1x2 ? 2 : 1);
      });
    } catch (e) {
      log.showError(`getDefaultDisplaySync code: ${e?.code}, msg: ${e?.message}`);
    }
  }

  public onDragStart(formItem: CardItemInfo, pixelMap?: image.PixelMap, offset?: Position): DragItemInfo {
    let gridWidth: number = FormUtil.getGridWidth();
    let formHeight: number = gridWidth - DRAG_FORM_PADDING;
    let formWidth: number = formItem.cardDimension === CommonConstants.CARD_DIMENSION_1x2 ?
      gridWidth * 2 - DRAG_FORM_PADDING / 2 : (gridWidth - DRAG_FORM_PADDING);

    let dragItemInfo: DragItemInfo = {
      pixelMap: pixelMap,
      extraInfo: new DragExtraInfo(DragDataType.FOLDER).setRadius(formHeight / 2).toString()
    };

    let offsetX: number = Number(offset?.x ?? 0);
    let offsetY: number = Number(offset?.y ?? 0);
    formItem.tempId = systemDateTime.getTime(true).toString();
    GlobalContext.getContext()?.eventHub.emit('waitFormCenterResponse',
      { code: FormCenterResponseCode.DRAG_FORM_START, formInfo: formItem, startPosition: { offsetX, offsetY } });

    let key: string = `${formItem.cardName}_${formItem.tempId}`;
    screenLockAniMgr.prepareAnimation(ScreenLockAniScene.BIND_SHEET, key)?.setSnapshot(pixelMap).setHeight(formHeight).
      setRadius(formHeight / 2).setWidth(formWidth).setGridWidth(gridWidth).
      setDimensionX(formItem.cardDimension === CommonConstants.CARD_DIMENSION_1x2 ? 2 : 1);
    return dragItemInfo;
  }

  public onDragEnd(): void {
    GlobalContext.getContext()?.eventHub.emit('waitFormCenterResponse',
      { code: FormCenterResponseCode.DRAG_FORM_END });
  }

  private getLayoutGridAmount(): GridAmount {
    let isScreenVertical: boolean = SCBScreenSessionManager.getInstance().isScreenVertical();
    if (DeviceHelper.isFoldExpanded() || (DeviceHelper.isPad() && isScreenVertical)) {
      return this.gridSpecial;
    }
    return this.gridNormal;
  }
}

interface GridAmount {
  x: number,
  y: number
}