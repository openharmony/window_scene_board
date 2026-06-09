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
import { launcherStatusUtil } from '@ohos/windowscene';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DropAnimationScene } from '@ohos/componentanimator';
import { DragDataType, DragExtraInfo } from '@ohos/componentdrag';
import { ViewType, ViewManagerPolicy, GlobalContext } from '@ohos/frameworkwrapper';
import {
  ResourceManager,
  DeviceHelper,
  FormLocationType,
  ErrorCardResultType,
} from '@ohos/frameworkwrapper';
import { SnapshotType, dragSnapshotHelper } from '@ohos/componenthelper';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import { FormDFXUtil } from '@ohos/launchercommon/Index';
import {
  CardItemInfo,
  CommonConstants,
  editModeManager,
  EditModeUtils,
  FormCenterViewManager,
  FormCommonUtil,
  FormLocation,
  FormManager,
  FormModel,
  PageDesktopModel,
  vibratorMgr,
} from '@ohos/launchercommon';
import { FormCenterViewParam } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { FormItemEventInterface } from '../../../interfaces/FormItemEventInterface';
import { FormItemAnimData, FormItemData } from '../../data/FormItemVm';
import { NavDestinationViewData } from '../../../../default/viewmodel/FormCenterObservedData';
import { CardAnimParams, FormCenterAnimateUtil } from '../../FormCenterAnimate';
import { FormStyleConfig } from '../../../../default/common/FormStyleConfig';
import { CloseReason, FormCenterViewModel } from '../../FormCenterViewModel';
import { AttributeUpdater } from '@kit.ArkUI';
import FormStyleConstants from '../../../../default/common/constants/FormStyleConstants';
import { FormCenterFormCommonUtil } from '../FormCenterFormCommonUtil';
import { FormUtil } from '../../../../default/util/FormUtil';
import { NavDestinationLayout } from '../../../viewstyles/manager/NavConfig';

const TAG: string = 'TileFormItemEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class ParentUpdater extends AttributeUpdater<CommonAttribute> {
  public isNeedShadow?: boolean = true;

  constructor(isNeedShadow?: boolean) {
    super();
    this.isNeedShadow = isNeedShadow;
  }

initializeModifier(instance: CommonAttribute): void {
    instance
      .shadow(this.isNeedShadow ? {
        radius: $r('app.float.normal_form_center_radius'),
        color: $r('app.color.normal_form_center_shadow_color'),
        offsetY: $r('app.float.normal_form_center_offset')
      } : null)
  }
}

class FormUpdater extends AttributeUpdater<CommonAttribute> {
  private formItemUIConfig?: FormItemData;
  private dragable: boolean = true;

  constructor(formItemUIConfig: FormItemData, dragable: boolean) {
    super();
    this.formItemUIConfig = formItemUIConfig;
    this.dragable = dragable;
  }

  initializeModifier(instance: CommonAttribute): void {
    instance.width(Math.floor(vp2px(this.formItemUIConfig?.formDisplayWidth)) + 'px')
      .height(Math.floor(vp2px(this.formItemUIConfig?.formDisplayHeight)) + 'px')
      .borderRadius(this.formItemUIConfig?.formRadius)
  }
}

export class TileFormItemEvent implements FormItemEventInterface {
  protected static mViewData: NavDestinationViewData = new NavDestinationViewData();
  protected formItemAnimData: FormItemAnimData = new FormItemAnimData();
  protected index: number = 0;
  protected formItem: CardItemInfo = new CardItemInfo();
  protected isClickable: boolean = !FormModel.getInstance().isSupportFormCenterSplit();
  protected cardId: string = '';
  protected isDragForm: boolean = false;
  protected dropImageFit?: number;
  protected formItemUIConfig: FormItemData = new FormItemData();

  constructor(
    viewData: NavDestinationViewData,
    formItem: CardItemInfo,
    index: number,
  ) {
    this.formItem = formItem;
    this.index = index;
    TileFormItemEvent.mViewData = viewData;
  }

  public initAnimateData(formItemAnimData: FormItemAnimData, index?: number): void {
    this.formItemAnimData = formItemAnimData;
  }

  public initFormUIConfig(formItemUIConfig: FormItemData, formScale?: number) {
    let formConfig: FormStyleConfig = FormStyleConfig.getInstance();
    let scale: number = formScale ?? 1;
    let dimensionString: string = String(this.formItem.cardDimension);
    if (!formConfig.mFormWidth.has(dimensionString) || !formConfig.mFormHeight.has(dimensionString)) {
      log.showError(`invalid cardDimension: ${this.formItem.bundleName}, ${this.formItem.cardDimension}`);
      return;
    }
    let card4x4HeightInner: number = FormUtil.get4x4CardHeight(scale);
    formItemUIConfig.formDisplayWidth = Number(formConfig.mFormWidth.get(dimensionString)) * scale;
    formItemUIConfig.formDisplayHeight = this.formItem.cardDimension === CommonConstants.CARD_DIMENSION_4x4 ?
      card4x4HeightInner : Number(formConfig.mFormHeight.get(dimensionString)) * scale;
    formItemUIConfig.formScale = scale;
    formItemUIConfig.layoutType = NavDestinationLayout.TILE;

    let formStyleConfig: FormStyleConfig = FormStyleConfig.getInstance();
    formItemUIConfig.formRadius = formStyleConfig.getRadius(false, this.formItem.cardDimension);
    formItemUIConfig.parentUpdater = new ParentUpdater(true);
    formItemUIConfig.formUpdater = new FormUpdater(formItemUIConfig, this.isDragable());
    formItemUIConfig.formHeight = formItemUIConfig.formDisplayHeight / scale;
    formItemUIConfig.hasFadeInAnimation = true;
    this.formItemUIConfig = formItemUIConfig;
    if (!FormModel.getInstance().isSupportFormCenterSplit()) {
      this.formItemUIConfig.dragScale = FormStyleConstants.RECOMMEND_FORM_SCALE;
    }
  }

  public onTouch(event: TouchEvent): void {
    let itemKey: string = `${this.formItem.typeId}${this.cardId}`;
    if (event.type === TouchType.Down && this.formItemAnimData.dragSnapshot?.getBytesNumberPerRow() === undefined) {
      dragSnapshotHelper.snapshotFromId(this.getFormItemSnapId(), SnapshotType.DROP, itemKey,
        (value: image.PixelMap) => {
          this.formItemAnimData.dragSnapshot = value;
          const cacheKey: string = `${this.cardId}${this.formItem.bundleName}${this.formItem.moduleName}`;
          ResourceManager.getInstance().setAppResourceCache(cacheKey, 'cardSnapshot', value);
        }, this.formItemUIConfig.dragScale, this.formItemUIConfig.dragScale);
    }
    if (event?.type === TouchType.Down) {
      log.showInfo('on touch down');
      this.scaleAnimate(true);
      return;
    }
    if (event?.type === TouchType.Up) {
      log.showInfo('on touch up');
      this.scaleAnimate(false);
    }
  }

  public onClick(event?: ClickEvent): void {
    log.showInfo('onclick');
    if (!this.isClickable) {
      log.showWarn('need not deal onclick');
      return;
    }
    let formCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
    formCenterViewManager.hideFormCenterView(FormStyleConstants.FORM_MANAGER_VIEW_HEIGHT);
    let param: FormCenterViewParam = new FormCenterViewParam();
    param.bundleName = this.formItem.bundleName;
    param.formInfo = this.formItem;
    if (FormCenterViewModel.getInstance().isNegativeScreenOpen) {
      formCenterViewManager.openFormManagerViewByNegativeScreen(param);
    } else {
      formCenterViewManager.openFormManagerView(param);
    }
  }

  public onZoomInLongPress(event: GestureEvent): void {
    log.showInfo('longPressHandler');
    this.scaleAnimate(false);
  }

  public onVibratorLongPress(event: GestureEvent): void {
    vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
      CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
  }

  public onDragStart(event?: DragEvent, extraParams?: string): DragItemInfo {
    FormCenterViewModel.getInstance().setCloseReason(CloseReason.CLOSE_BY_ADD_FORM);
    this.isDragForm = true;

    // 如果从大文件夹打开，需要关闭大文件夹
    AppStorage.setOrCreate('openFolderStatus', CommonConstants.FOLDER_STATUS_REQUEST_CLOSE);
    let dragItemInfo: DragItemInfo = {
      pixelMap: this.formItemAnimData.dragSnapshot,
      // 传-1可以绕过底座老接口走新接口（老接口有问题）、新接口会读取dragPreviewOptions中设置的值
      extraInfo: new DragExtraInfo(DragDataType.FORM).setRadius(-1).toString(),
    };
    let formItem: CardItemInfo = new CardItemInfo();
    ObjectCopyUtil.deepClone<CardItemInfo>(this.formItem, formItem);
    formItem.cardId = this.cardId;
    formItem.id = this.cardId;
    formItem.dimension = this.formItem.cardDimension;
    formItem.name = formItem.cardName;
    log.showWarn(`drag form: ${formItem.cardId}`);
    let formStyleConfig: FormStyleConfig = FormStyleConfig.getInstance();
    let formWidth: number = Number(formStyleConfig.mFormWidth.get(String(formItem.cardDimension))) *
      TileFormItemEvent.mViewData.formRate;
    let formHeight: number = Number(formStyleConfig.mFormHeight.get(String(formItem.cardDimension))) *
    TileFormItemEvent.mViewData.formRate;
    if (formItem.cardDimension === CommonConstants.CARD_DIMENSION_4x4 &&
      !launcherStatusUtil.getShowOutLauncherStatus()) {
      let card4x4HeightInner: number = FormUtil.get4x4CardHeight(TileFormItemEvent.mViewData.formRate);
      formHeight = card4x4HeightInner;
      this.dropImageFit = ImageFit.Cover;
    }
    let radius: number =
      Number(FormStyleConfig.getInstance().getRadius(false, formItem.cardDimension)) *
        TileFormItemEvent.mViewData.formRate;
    // 由于卡片设置了marginTop值，落位点Y轴需设置偏差，这个值会随设备变化
    let isPad = CommonConstants.PAD_DEVICE_TYPE === AppStorage.get('device');
    let offsetY = isPad ? PageDesktopModel.getInstance().getPageDesktopStyleConfig().mIconMarginVertical : 0;
    const formKey: string = `${formItem.typeId}${formItem.cardId}`;
    dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, formKey)
      ?.setWidth(formWidth)
      .setHeight(formHeight)
      .setEndScale(EditModeUtils.getDesktopScale() / TileFormItemEvent.mViewData.formRate)
      .setRadius(radius)
      .setOffset(0, offsetY);
    if (this.dropImageFit) {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, formKey)
        ?.setImageFit(this.dropImageFit);
    }

    FormCenterViewManager.getInstance().closeFormCenterView();
    AppStorage.setOrCreate('isDrag', true);
    AppStorage.setOrCreate('dragItemType', CommonConstants.DRAG_FROM_FORM_SERVICE);
    AppStorage.setOrCreate('dragItemInfo', formItem);
    // 通知SCBFormCenter零层窗口取消焦点并重新设置热区，避免Drag事件无法透传到底层窗口导致拖拽异常
    GlobalContext.getContext().eventHub.emit(CommonConstants.UNFOCUS_SCB_FORM_CENTER);
    FormCenterViewModel.getInstance().dealUndoDragFormVisible();
    return dragItemInfo;
  }

  public onDragEnd(event?: DragEvent): void {
    AppStorage.setOrCreate('undoDragFormVisible', false);
    if (!editModeManager.isInEditMode()) {
      ViewManagerPolicy.showView(ViewType.STATUS_BAR);
    }
    AppStorage.setOrCreate<boolean>('isDrag', false);
    AppStorage.setOrCreate<Object>('dragItemInfo', {});
  }

  public onCardAcquired(cardId: string): void {
    this.cardId = cardId;
    FormDFXUtil.reportBuildCard(this.formItem, cardId, FormLocationType.FORMCENTER);
  }

  public onCardError(errorMsg: string): void {
    FormDFXUtil.reportBuildCardError(this.formItem, FormLocationType.FORMCENTER, ErrorCardResultType.ONERROR, errorMsg);
  }

  public getFormWant(formItem: CardItemInfo): Want | undefined {
    return FormCommonUtil.getCommonWant({
      isTransparent: formItem.isTransparent,
      formLocation: FormLocation.FORM_CENTER,
    });
  }

  public onDisAppear(): void {
    if (!this.isDragForm) {
      ResourceManager.getInstance().deleteAppResourceCache(`${this.cardId}${this.formItem.bundleName}`, 'cardSnapshot');
      FormManager.getInstance().deleteCard(this.cardId);
      this.formItemAnimData.dragSnapshot?.release();
    }
  }

  public isDragable(): boolean {
    return FormCenterViewModel.getInstance().getIsSupportDrag();
  }

  public getFormItemSnapId(): string {
    let bundleName: string = FormCenterViewModel.getInstance().isCurrentSuggestion ?
      FormStyleConstants.FORM_CENTER_DEFAULT_ITEM : this.formItem.bundleName;
    return FormCenterFormCommonUtil.getFormItemId(bundleName, this.index);
  }

  protected scaleAnimate(isZoomOut: boolean): void {
    let animateUtil = FormCenterAnimateUtil.getInstance();
    let params: CardAnimParams = animateUtil.getPressAnimParams(isZoomOut, this.formItem.cardDimension);
    animateTo(params.params, () => {
      this.formItemAnimData.animateScale = params.scale;
    });
  }
}