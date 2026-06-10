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

import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { FormViewModel } from '@ohos/form';
import {
  FormModel,
  CardItemInfo,
  editModeManager,
  FormHiSysEventReporter,
  GridLayoutItemInfo,
  FormLayoutCacheManager,
  CommonConstants,
  EditModeUtils,
  FormCommonUtil,
} from '@ohos/launchercommon';
import { DragFormToChangeSizeEvent } from '@ohos/launchercommon/src/main/ets/utils/FormHiSysEventReporter';
import {
  ZoomType,
  ZoomOffset,
  CheckZoomResult,
  FormZoomTargetArea,
} from '../common/FormZoomCommonType';
import { FormZoomManager } from '../common/FormZoomManager';
import { FormZoomUtil } from '../common/FormZoomUtil';
import { FormZoomVm } from './FormZoomVm';
import curves from '@ohos.curves';
import systemparameter from '@ohos.systemParameterEnhance';
import { FormZoomViewManager } from '@ohos/launchercommon/src/main/ets/manager/FormZoomViewManager';
import { formZoomController } from '../viewModel/FormZoomController';

const TAG = 'FormZoomEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const REBOUND_THRESHOLD: number = 12;
const ZOOM_OUT_RATIO: number = 0.6;
const ZOOM_IN_RATIO: number = 0.5;

export class FormZoomEvent {
  private mFormZoomVm: FormZoomVm;
  private mFormItem: CardItemInfo = new CardItemInfo();
  private mFormItemWidth: number;
  private mFormItemHeight: number;
  private checkZoomResult?: CheckZoomResult;
  private cardInfos: CardItemInfo[] = [];
  private switchCardSnapshot: (key: string) => void;
  private currentDimension?: number;

  constructor(zoomVm: FormZoomVm, width: number, height: number, switchCardSnapshot: (key: string) => void) {
    this.mFormZoomVm = zoomVm;
    this.mFormItemWidth = width;
    this.mFormItemHeight = height;
    this.switchCardSnapshot = switchCardSnapshot;
  }

  private reset(size: Size): void {
    animateTo({
      duration: 250,
    }, () => {
      this.setFormZoomSize({
        width: size.width,
        height: size.height,
      })
    });
  }

  private refreshLayout(targetArea: FormZoomTargetArea | undefined): void {
    if (!targetArea) {
      log.showError('invalid target area');
      return;
    }
    log.showInfo('refresh form size and position, old row: %{public}d, old col: %{public}d, old area: %{public}s, old cardDimension: %{public}s, new row: %{public}d, new col: %{public}d, new area: %{public}s, new cardDimension: %{public}s',
      this.mFormItem.row,
      this.mFormItem.column,
      String(this.mFormItem.area),
      String(this.mFormItem.cardDimension),
      targetArea.row,
      targetArea.column,
      String(targetArea.area),
      String(targetArea.cardDimension),
    );

    // 更新卡片的尺寸和位置信息
    this.updateCardInfo(targetArea);

    let targetWidth: number = FormViewModel.getInstance().getFormStyleConfig()
      .mFormWidth.get(String(targetArea.cardDimension)) as number;
    let targetHeight: number = FormViewModel.getInstance().getFormStyleConfig()
      .mFormHeight.get(String(targetArea.cardDimension)) as number;

    if (editModeManager.isInEditMode()) {
      targetWidth = EditModeUtils.convertWithDesktopScale(targetWidth);
      targetHeight = EditModeUtils.convertWithDesktopScale(targetHeight);
    }
    this.mFormItemWidth = targetWidth;
    this.mFormItemHeight = targetHeight;

    animateTo({
      duration: 250,
      onFinish: () => {
        // 更新桌面卡片布局信息:尺寸和位置
        let cardId: string = this.mFormItem.cardId;
        FormZoomManager.getInstance().setOldCardId(cardId);
        FormModel.getInstance().updateFormSizeAndPosition(this.mFormItem);
      }
    }, () => {
      this.setFormZoomSize({
        width: targetWidth,
        height: targetHeight,
      })
    });
  }

  private updateCardInfo(targetArea: FormZoomTargetArea): void {
    this.mFormItem.row = targetArea.row;
    this.mFormItem.column = targetArea.column;
    this.mFormItem.area = targetArea.area;
    this.mFormItem.cardDimension = targetArea.cardDimension;
    let cardItem: CardItemInfo | undefined = this.cardInfos.find((item: CardItemInfo) => {
      return item.cardDimension === targetArea.cardDimension;
    });
    if (cardItem) {
      this.mFormItem.cardName = cardItem.cardName;
    }
  }

  private reportDragFormToChangeSizeEvent(targetArea: FormZoomTargetArea, result: boolean): void {
    let event: DragFormToChangeSizeEvent = {
      packageName: this.mFormItem.bundleName,
      currentPage: Number(this.mFormItem.page),
      formId: this.mFormItem.cardId,
      formName: this.mFormItem.cardName,
      dragResult: result,
      oldSize: `${this.mFormItem.area?.[1]}*${this.mFormItem.area?.[0]}`,
      newSize: `${targetArea.area[1]}*${targetArea.area[0]}`,
      oldRow: Number(this.mFormItem.row),
      oldColumn: Number(this.mFormItem.column),
      newRow: Number(targetArea.row),
      newColumn: Number(targetArea.column),
      isEditMode: editModeManager.isInEditMode(),
    }
    FormHiSysEventReporter.reportDragFormToChangeSize(event);
  }

  public setFormZoomSize(size: Size): void {
    this.mFormZoomVm.width = size.width;
    this.mFormZoomVm.height = size.height;
  }

  public initCardInfo(cardItem: CardItemInfo, cardInfos: CardItemInfo[]): void {
    log.showWarn(`init card info, cardId: ${cardItem.cardId}`);
    this.mFormItem = cardItem;
    // 平板旋转场景,formItem中的row,column和布局缓存中的不一致,以布局缓存中的信息为主
    let gridItemInfo: GridLayoutItemInfo | undefined =
      FormLayoutCacheManager.getInstance().selectGridLayoutItemByCardId(this.mFormItem.cardId);
    this.mFormItem.row = gridItemInfo?.row;
    this.mFormItem.column = gridItemInfo?.column;
    this.cardInfos = cardInfos;
    this.currentDimension = this.mFormItem.cardDimension;
  }

  public getFormItem(): CardItemInfo {
    return this.mFormItem;
  }

  public onDragZoomMove = (result: CheckZoomResult, zoomOffset: ZoomOffset, defaultAlignContent: Alignment) => {
    let filterList: FormZoomTargetArea[] = result.targetAreaList.filter(targetArea => {
      let index = this.cardInfos.findIndex((item) => item.cardDimension === targetArea.cardDimension);
      return index >= 0;
    })

    this.checkZoomResult = {
      zoomType: result.zoomType,
      targetAreaList: filterList
    };

    let dimensions: number[] = this.checkZoomResult.targetAreaList.map(item => item.cardDimension);
    dimensions.push(this.mFormItem.cardDimension);
    let targetDimension: number = FormZoomUtil.getTargetCardDimension(
      this.mFormZoomVm.width,
      this.mFormZoomVm.height,
      dimensions
    );
    if (this.currentDimension !== undefined && this.currentDimension !== targetDimension) {
      this.currentDimension = targetDimension;
      let cardItem: CardItemInfo | undefined = this.cardInfos.find((item) => item.cardDimension === targetDimension);
      let cardName = cardItem?.cardName || this.mFormItem.cardName;
      let key: string = `formZoom_${this.mFormItem.bundleName}_${cardName}_${targetDimension}`;
      this.switchCardSnapshot(key);
    }

    let minWidth: number;
    let minHeight: number;
    let maxWidth: number;
    let maxHeight: number;
    if (filterList.length <= 0) {
      this.mFormZoomVm.alignContent = defaultAlignContent;
      minWidth = this.mFormItemWidth;
      minHeight = this.mFormItemHeight;
      maxWidth = this.mFormItemWidth;
      maxHeight = this.mFormItemHeight;
    } else {
      this.mFormZoomVm.alignContent = filterList[0].alignContent;
      let cardDimension: number = filterList[filterList.length - 1].cardDimension;
      let width: number = FormViewModel.getInstance().getFormStyleConfig()
        .mFormWidth.get(String(cardDimension)) as number;
      let height: number = FormViewModel.getInstance().getFormStyleConfig()
        .mFormHeight.get(String(cardDimension)) as number;
      if (editModeManager.isInEditMode()) {
        width = EditModeUtils.convertWithDesktopScale(width);
        height = EditModeUtils.convertWithDesktopScale(height);
      }

      minWidth = Math.min(this.mFormItemWidth, width);
      minHeight = Math.min(this.mFormItemHeight, height);
      maxWidth = Math.max(this.mFormItemWidth, width);
      maxHeight = Math.max(this.mFormItemHeight, height);
    }

    let newWidth: number;
    let newHeight: number;
    newWidth = this.mFormItemWidth + zoomOffset.offsetX;
    newHeight = this.mFormItemHeight + zoomOffset.offsetY;
    // 超过阈值回弹
    if (newWidth > maxWidth + REBOUND_THRESHOLD || newHeight > maxHeight + REBOUND_THRESHOLD) {
      this.reset({
        width: maxWidth,
        height: maxHeight
      });
    } else if (newWidth < minWidth - REBOUND_THRESHOLD || newHeight < minHeight - REBOUND_THRESHOLD) {
      this.reset({
        width: minWidth,
        height: minHeight
      });
    } else {
      let stiffness: number = Number(systemparameter.getSync('formZoomStiffness', '328'));
      let damping: number = Number(systemparameter.getSync('formZoomDamping', '35'));
      log.showInfo(`ch123 stiffness: ${stiffness}, damping: ${damping}`);
      animateToImmediately({
        curve: curves.interpolatingSpring(0, 1, stiffness, damping)
      }, () => {
        // 设置放缩组件宽高
        this.setFormZoomSize({
          width: newWidth,
          height: newHeight
        });
      })
    }
  }

  public onDragZoomEnd = () => {
    if (!FormZoomViewManager.getInstance().getFormZoomState()) {
      log.showWarn('form zoom component is invisible');
      formZoomController.setDragState(false);
      return;
    }
    if (!this.checkZoomResult || this.checkZoomResult.targetAreaList.length <= 0) {
      log.showWarn('invalid zoom result');
      this.reset({
        width: this.mFormItemWidth,
        height: this.mFormItemHeight
      });
      formZoomController.setDragState(false);
      return;
    }
    let targetArea: FormZoomTargetArea | undefined =
      this.checkZoomResult.targetAreaList.find((targetArea: FormZoomTargetArea) => {
        return targetArea.cardDimension === this.currentDimension;
      });
    if (targetArea) {
      this.reportDragFormToChangeSizeEvent(targetArea, true);
      // 刷新卡片布局信息
      this.refreshLayout(targetArea);
    } else {
      this.reset({
        width: this.mFormItemWidth,
        height: this.mFormItemHeight
      });
      formZoomController.setDragState(false);
    }
  }
}