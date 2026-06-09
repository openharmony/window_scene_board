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
import { image } from '@kit.ImageKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ViewType, ViewManagerPolicy } from '@ohos/frameworkwrapper';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { DropAnimationScene } from '@ohos/componentanimator';
import { DragExtraInfo, DragDataType } from '@ohos/componentdrag';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import {
  CardItemInfo,
  CommonConstants,
  editModeManager,
  EditModeUtils,
  FormCenterViewManager,
  FormModel,
  PageDesktopModel,
} from '@ohos/launchercommon';
import { FormStyleConfig } from '../common/FormStyleConfig';
import { RecommendFormsAnimate } from './FormCenterAnimate';
import { NavDestinationViewData, RecommendFormItemData } from './FormCenterObservedData';
import { FormCenterViewModel } from './FormCenterViewModel';
import { FormCenterViewParam } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import FormStyleConstants from '../common/constants/FormStyleConstants';

const TAG: string = 'RecommendFormsViewEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

// 延迟350ms触发所有窗口出现,避免加桌卡片直接被窗口遮挡
const RECOVERY_WINDOWS_DELAY_TIME: number = 350;

export class RecommendFormsViewEvent {
  private mRecommendFormsAnimate: RecommendFormsAnimate = new RecommendFormsAnimate();
  private mViewData: NavDestinationViewData = new NavDestinationViewData();
  private recommendFormScale: number = 1;

  public initData(formList: CardItemInfo[],
    animateData: RecommendFormItemData[],
    viewData: NavDestinationViewData, recommendFormScale?: number): void {
    this.mViewData = viewData;
    this.recommendFormScale = recommendFormScale ? recommendFormScale : 1;
    this.mRecommendFormsAnimate.initData(formList, animateData);
  }

  public onTouch(event: TouchEvent, index: number): void {
    if (event?.type === TouchType.Down) {
      log.showInfo('on touch down');
      this.mRecommendFormsAnimate.scaleAnimate(true, index, this.recommendFormScale);
    }
    if (event?.type === TouchType.Up) {
      log.showInfo('on touch up');
      this.mRecommendFormsAnimate.scaleAnimate(false, index, this.recommendFormScale, true);
    }
  }

  public onClick(item: CardItemInfo, snapShotId: string, clickable: boolean): void {
    log.showInfo('onclick');
    if (!clickable) {
      log.showWarn('need not deal onclick');
      return;
    }
    let formCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
    formCenterViewManager.hideFormCenterView(FormStyleConstants.FORM_MANAGER_VIEW_HEIGHT);
    let param: FormCenterViewParam = new FormCenterViewParam();
    param.bundleName = item.bundleName;
    param.formInfo = item;
    formCenterViewManager.openFormManagerView(param);
  }

  public onClickByNegativeScreen(item: CardItemInfo, snapShotId: string, clickable: boolean): void {
    log.showInfo('onClickByNegativeScreen');
    if (!clickable) {
      log.showWarn('onClickByNegativeScreen need not deal onclick');
      return;
    }
    let formCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
    formCenterViewManager.hideFormCenterView();
    let param: FormCenterViewParam = new FormCenterViewParam();
    param.bundleName = item.bundleName;
    param.formInfo = item;
    formCenterViewManager.openFormManagerViewByNegativeScreen(param);
    return;
  }

  public longPressHandler(index: number): void {
    log.showInfo('longPressHandler');
    this.mRecommendFormsAnimate.scaleAnimate(false, index, this.recommendFormScale);
  }

  /**
   * 计算拖拽开始时按压位置与控件中心位置的偏移
   *
   * @returns 按压位置与控件中心位置的偏移
   */
  public getDragStartPositionOffset(snapShotId: string, event: DragEvent): Position {
    return { x: 0, y: 0 };
  }

  public onDragStart(cardId: string, formInfo: CardItemInfo, offset: Position, pixelMap?: image.PixelMap,
    dropImageFit?: ImageFit): DragItemInfo {
    let dragItemInfo: DragItemInfo = {
      pixelMap: pixelMap,
      // 传-1可以绕过底座老接口走新接口（老接口有问题）、新接口会读取dragPreviewOptions中设置的值
      extraInfo: new DragExtraInfo(DragDataType.FORM).setRadius(-1).toString(),
    };
    let formItem: CardItemInfo = new CardItemInfo();
    ObjectCopyUtil.deepClone<CardItemInfo>(formInfo, formItem);
    formItem.cardId = cardId;
    formItem.id = cardId;
    formItem.dimension = formInfo.cardDimension;
    formItem.name = formItem.cardName;
    log.showWarn(`drag form: ${formItem.cardId}`);
    let formStyleConfig: FormStyleConfig = FormStyleConfig.getInstance();
    let formWidth: number = Number(formStyleConfig.mFormWidth.get(String(formItem.cardDimension)));
    let formHeight: number = Number(formStyleConfig.mFormHeight.get(String(formItem.cardDimension)));

    let radius: number =
      Number(FormStyleConfig.getInstance().getRadius(true, formItem.cardDimension)) * this.recommendFormScale;
    // 由于卡片设置了marginTop值，落位点Y轴需设置偏差，这个值会随设备变化
    let isPad = CommonConstants.PAD_DEVICE_TYPE === AppStorage.get('device');
    let offsetY = isPad ? PageDesktopModel.getInstance().getPageDesktopStyleConfig().mIconMarginVertical : 0;
    const formKey: string = `${formItem.typeId}${formItem.cardId}`;
    const endScale: number = this.mViewData.formRate * this.recommendFormScale ?
      this.mViewData.formRate * this.recommendFormScale : 1;
    dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, formKey)
      ?.setWidth(formWidth * this.mViewData.formRate * this.recommendFormScale)
      .setHeight(formHeight * this.mViewData.formRate * this.recommendFormScale)
      .setEndScale(EditModeUtils.getDesktopScale() / endScale)
      .setRadius(radius)
      .setOffset(0, offsetY);
    if (dropImageFit) {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, formKey)
        ?.setImageFit(dropImageFit);
    }

    FormCenterViewManager.getInstance().closeFormCenterView();
    AppStorage.setOrCreate('isDrag', true);
    AppStorage.setOrCreate('dragItemType', CommonConstants.DRAG_FROM_FORM_SERVICE);
    AppStorage.setOrCreate('dragItemInfo', formItem);
    FormCenterViewModel.getInstance().dealUndoDragFormVisible();
    return dragItemInfo;
  }

  public onDragEnd(recoveryWindows: boolean = true): void {
    if (recoveryWindows) {
      setTimeout(() => {
        FormCenterViewModel.getInstance().recoveryAllWindows();
      }, RECOVERY_WINDOWS_DELAY_TIME);
    }
    AppStorage.setOrCreate('undoDragFormVisible', false);
    if (!editModeManager.isInEditMode()) {
      ViewManagerPolicy.showView(ViewType.STATUS_BAR);
    }
    AppStorage.setOrCreate<boolean>('isDrag', false);
    AppStorage.setOrCreate<Object>('dragItemInfo', {});
  }
}