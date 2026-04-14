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

import { AttributeUpdater } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import { DropAnimationScene } from '@ohos/componentanimator';
import { DragDataType, DragExtraInfo } from '@ohos/componentdrag';
import { GlobalContext, ViewType, ViewManagerPolicy, AccessibilityManager } from '@ohos/frameworkwrapper';
import {
  ResourceManager,
  FormLocationType,
  ErrorCardResultType,
} from '@ohos/frameworkwrapper';
import { SnapshotType, dragSnapshotHelper } from '@ohos/componenthelper';
import { dropAnimationManager, DropItemViewModel } from '@ohos/componentanimator/Index';
import { launcherStatusUtil } from '@ohos/windowscene';
import { FormDFXUtil } from '@ohos/launchercommon/Index';
import {
  CardItemInfo,
  CommonConstants,
  EditModeUtils,
  FormCenterViewManager,
  FormModel,
  editModeManager,
  FormCommonUtil,
  FormLocation,
  AppItemInfo,
  vibratorMgr,
  FormManager,
  PageDesktopModel,
  FormCenterLocation,
} from '@ohos/launchercommon';
import { FormCenterViewData } from '../../../../default/viewmodel/FormCenterViewData';
import { CloseReason, FormCenterViewModel } from '../../FormCenterViewModel';
import { FormStyleConfig } from '../../../../default/common/FormStyleConfig';
import Want from '@ohos.app.ability.Want';
import { FormItemEventInterface } from '../../../interfaces/FormItemEventInterface';
import { FormItemAnimData, FormItemData } from '../../data/FormItemVm';
import { CardAnimParams, FormCenterAnimateUtil } from '../../FormCenterAnimate';
import FormStyleConstants from '../../../../default/common/constants/FormStyleConstants';
import { FormUpdater, ParentUpdater } from '../../modifier/SwiperFormModifier';
import { SwiperFormAnimate } from '../swiperlayoutevent/SwiperAnimateViewModel';
import { FormCenterFormCommonUtil } from '../FormCenterFormCommonUtil';
import { FormViewModel } from '../../../../default/viewmodel/FormViewModel';

const TAG: string = 'AppFormsViewEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class SwiperLayoutFormEvent implements FormItemEventInterface {
  protected formItemAnimData: FormItemAnimData = new FormItemAnimData();
  protected static mFormCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
  protected index: number = 0;
  protected formItem: CardItemInfo = new CardItemInfo();
  protected appInfo?: AppItemInfo;
  protected cardId: string = '';
  protected parentUpdater?: AttributeUpdater<CommonAttribute>;
  protected formUpdater?: AttributeUpdater<CommonAttribute>;
  protected isCurrentIndex: (index: number) => boolean = () => false;
  protected setCardId: (index: number, cardId: string) => void = () => {};
  protected swiperFormAnimate: SwiperFormAnimate = new SwiperFormAnimate();
  protected setParentUpdater?: (index: number, parentUpdater: AttributeUpdater<CommonAttribute>,
    formModifier: AttributeUpdater<CommonAttribute>) => void;
  protected formItemUIConfig: FormItemData = new FormItemData();
  protected shortcutFormSize: number = 0;
  protected shortcutFormRadius: number = 0;

  constructor(
    formItem: CardItemInfo,
    index: number,
    appItem: AppItemInfo,
    isCurrentIndex: (index: number) => boolean,
    setCardId: (index: number, cardId: string) => void,
    swiperFormAnimate: SwiperFormAnimate,
    setParentUpdater?: (index: number, parentUpdater: AttributeUpdater<CommonAttribute>,
      formModifier: AttributeUpdater<CommonAttribute>) => void,
  ) {
    this.formItem = formItem;
    this.index = index;
    this.appInfo = appItem;
    this.isCurrentIndex = isCurrentIndex;
    this.setCardId = setCardId;
    this.swiperFormAnimate = swiperFormAnimate;
    this.setParentUpdater = setParentUpdater;
  }

  public doFadeInAnimation(start: boolean) {
    if (start) {
      if (AppStorage.get('enterFormManager') && this.isCurrentIndex(this.index)) {
        this.parentUpdater?.attribute?.opacity(1);
        this.parentUpdater?.attribute?.shadow({
          radius: $r('app.float.normal_form_manager_radius'),
          color: Color.Transparent,
          offsetY: $r('app.float.normal_form_manager_offset')
        });
      }
      this.parentUpdater?.attribute?.backgroundColor($r('app.color.gradient_transparent_form_background_color'));
    } else {
      // 卡片投影渐显
      this.parentUpdater?.attribute?.shadow({
        radius: $r('app.float.normal_form_manager_radius'),
        color: $r('app.color.normal_form_manager_shadow_color'),
        offsetY: $r('app.float.normal_form_manager_offset'),
      });
      // 透明卡片背景渐显
      if (this.formItem.isTransparent) {
        this.parentUpdater?.attribute?.backgroundColor($r('app.color.transparent_form_background_color'));
      }
    }
  }

  public onTouch(event: TouchEvent): void {
    let itemKey: string = this.getDragKeyItem();
    if (event.type === TouchType.Down && this.formItemAnimData.dragSnapshot?.getBytesNumberPerRow() === undefined) {
      dragSnapshotHelper.snapshotFromId(this.getFormItemSnapId(), SnapshotType.DROP, itemKey,
        (value: image.PixelMap) => {
          this.formItemAnimData.dragSnapshot = value;
          const cacheKey: string = CheckEmptyUtils.isEmpty(this.formItem.shortcutInfo) ?
            `${this.cardId}${this.formItem.bundleName}${this.formItem.moduleName}` :
            `shortcut_${this.formItem.bundleName}_${this.formItem.shortcutInfo?.id}`;
          ResourceManager.getInstance().setAppResourceCache(cacheKey, 'cardSnapshot', value);
        }, this.formItemUIConfig.dragScale, this.formItemUIConfig.dragScale);
    }
    if (event.type === TouchType.Down) {
      log.showInfo('on touch down');
      this.scaleAnimate(true);
    }
    if (event.type === TouchType.Up) {
      log.showInfo('on touch up');
      this.scaleAnimate(false);
    }
  }

  public onDragEnd(event?: DragEvent | undefined): void {
    log.showInfo('onDragEnd');
    // 延迟350ms触发所有窗口出现,避免加桌卡片直接被窗口遮挡
    setTimeout(() => {
      FormCenterViewModel.getInstance().recoveryAllWindows();
    }, 350);

    AppStorage.setOrCreate('undoDragFormVisible', false);
    if (!editModeManager.isInEditMode()) {
      ViewManagerPolicy.showView(ViewType.STATUS_BAR);
    }
    AppStorage.setOrCreate<boolean>('isDrag', false);
    AppStorage.setOrCreate<Object>('dragItemInfo', {});
  }

  public onZoomInLongPress(event: GestureEvent): void {
    log.showInfo('longPressHandler');
    this.scaleAnimate(false);
  }

  public onVibratorLongPress(event: GestureEvent): void {
    vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
      CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
  }

  private getDragKeyItem(): string {
    if (!CheckEmptyUtils.isEmpty(this.formItem.shortcutInfo)) {
      return `${CommonConstants.TYPE_SHORTCUT_ICON}${this.formItem.keyName}`;
    } else {
      return `${this.formItem.typeId}${this.cardId}`;
    }
  }

  public onDragStart(event?: DragEvent, extraParams?: string): DragItemInfo {
    if (this.isAccessibilityMode()) {
      let itemKey: string = `${this.formItem.typeId}${this.cardId}`;
      dragSnapshotHelper.snapshotFromIdSync(this.getFormItemSnapId(), SnapshotType.DROP, itemKey,
        (value: image.PixelMap) => {
          this.formItemAnimData.dragSnapshot = value;
          const cacheKey: string = `${this.cardId}${this.formItem.bundleName}${this.formItem.moduleName}`;
          ResourceManager.getInstance().setAppResourceCache(cacheKey, 'cardSnapshot', value);
        }, this.formItemUIConfig.dragScale, this.formItemUIConfig.dragScale);
    }
    // 如果从大文件夹打开，需要关闭大文件夹
    log.showInfo('onDragStart');
    AppStorage.setOrCreate('openFolderStatus', CommonConstants.FOLDER_STATUS_REQUEST_CLOSE);
    FormCenterViewModel.getInstance().setCloseReason(CloseReason.CLOSE_BY_ADD_FORM)

    let dragItemInfo: DragItemInfo = {
      pixelMap: this.formItemAnimData.dragSnapshot,
      // 传-1可以绕过底座老接口走新接口（老接口有问题）、新接口会读取dragPreviewOptions中设置的值
      extraInfo: new DragExtraInfo(DragDataType.FORM).setRadius(-1).toString(),
    };
    let formItem: CardItemInfo = this.copyCard();
    let scale: number = FormCenterViewData.getInstance().getFormDimensionScale(formItem.cardDimension);
    let formWidth: number = FormCenterViewModel.getInstance().getFormDisplaySize(formItem.cardDimension, true);
    let formHeight: number = FormCenterViewModel.getInstance().getFormDisplaySize(formItem.cardDimension, false);
    let radius: number = Number(FormStyleConfig.getInstance().getRadius(false, formItem.cardDimension)) * scale;
    if (!CheckEmptyUtils.isEmpty(this.formItem.shortcutInfo)) {
      radius = this.shortcutFormRadius;
      formWidth = this.shortcutFormSize;
      formHeight = this.shortcutFormSize;
    }
    // 由于卡片设置了marginTop值，落位点Y轴需设置偏差，这个值会随设备变化
    let model: DropItemViewModel | undefined =
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, this.getDragKeyItem());
    let isPad = CommonConstants.PAD_DEVICE_TYPE === AppStorage.get('device');
    let offsetY = isPad ? PageDesktopModel.getInstance().getPageDesktopStyleConfig().mIconMarginVertical : 0;
    model?.setWidth(formWidth)
      .setHeight(formHeight)
      .setEndScale(EditModeUtils.getDesktopScale() / scale)
      .setRadius(radius)
      .setOffset(0, offsetY);

    AppStorage.setOrCreate('isDrag', true);
    AppStorage.setOrCreate('dragItemType', CommonConstants.DRAG_FROM_MANAGE);
    if (formItem.shortcutInfo) {
      AppStorage.setOrCreate('dragCardId', formItem.shortcutInfo.id);
    } else {
      AppStorage.setOrCreate('dragCardId', formItem.cardId);
    }
    AppStorage.setOrCreate('dragItemInfo', formItem);
    // 通知SCBFormCenter零层窗口取消焦点并重新设置热区，避免Drag事件无法透传到底层窗口导致拖拽落位异常
    GlobalContext.getContext().eventHub.emit(CommonConstants.UNFOCUS_SCB_FORM_CENTER);
    // 取消卡片的阴影
    this.parentUpdater?.attribute?.shadow(null);
    FormCenterViewModel.getInstance().dealUndoDragFormVisible();
    SwiperLayoutFormEvent.mFormCenterViewManager.closeFormCenterView();
    SwiperLayoutFormEvent.mFormCenterViewManager.closeFormManagerView();
    return dragItemInfo;
  }

  public onClick(event?: ClickEvent): void {}

  public onPreDrag(status: PreDragStatus): void {
    log.showInfo(`onPreDrag status change ${String(status)}`);
    // 浮起预览图时隐藏卡片
    if (status === PreDragStatus.PREVIEW_LIFT_STARTED &&
        FormCenterViewModel.getInstance().getIsSupportCreateAnimate()) {
        this.formUpdater?.attribute?.opacity(FormStyleConstants.DEFAULT_FORM_HIDDEN_OPACITY_VALUE);
        return;
    }
    // 预览图消失时恢复显示卡片
    if (status === PreDragStatus.PREVIEW_LANDING_FINISHED) {
      this.formUpdater?.attribute?.opacity(1);
      return;
    }
  }

  public getFormWant(): Want | undefined {
    return FormCommonUtil.getCommonWant({
      isTransparent: this.formItem.isTransparent,
      formLocation: FormLocation.FORM_MANAGER,
      cardName: this.formItem.cardName,
      bundleName: this.formItem.bundleName,
      targetFormData: this.formItem.targetFormData,
    });
  }

  public onDisAppear(): void {
    if (!this.isFormChosen()) {
      ResourceManager.getInstance().deleteAppResourceCache(`${this.cardId}${this.formItem.bundleName}`, 'cardSnapshot');
      FormManager.getInstance().deleteCard(this.cardId);
      this.formItemAnimData.dragSnapshot?.release();
    }
  }

  public onCardAcquired(cardId: string): void {
    this.cardId = cardId;
    this.setCardId(this.index, cardId);
    FormDFXUtil.reportBuildCard(this.formItem, cardId, FormLocationType.FORMCENTER);
  }

  public onCardLoad(cardId: string): void {
    if (this.isCurrentIndex(this.index)) {
      let bundleName: string = FormCenterViewModel.getInstance().isCurrentSuggestion ?
        FormStyleConstants.FORM_CENTER_DEFAULT_ITEM : this.formItem.bundleName;
      setTimeout(() => {
        AppStorage.setOrCreate('formManagerId', FormCenterFormCommonUtil.getFormItemId(bundleName, this.index));
      }, 50);
    }
  }

  public onCardError(errorMsg: string): void {
    FormDFXUtil.reportBuildCardError(this.formItem, FormLocationType.FORMCENTER, ErrorCardResultType.ONERROR, errorMsg);
  }

  public initFormUIConfig(formItemUIConfig: FormItemData, formScale?: number): void {
    this.shortcutFormSize = FormViewModel.getInstance().getShortcutFormSize();
    this.shortcutFormRadius = FormViewModel.getInstance().getShortcutFormRadius();
    formItemUIConfig.index = this.index;
    let formModel: FormCenterViewModel = FormCenterViewModel.getInstance();
    formItemUIConfig.formDisplayWidth = formModel.getFormDisplaySize(this.formItem.cardDimension, true);
    formItemUIConfig.formDisplayHeight = formModel.getFormDisplaySize(this.formItem.cardDimension, false);
    formItemUIConfig.formRadius = FormStyleConfig.getInstance().getFormBorderRadius(this.formItem.cardDimension);
    formItemUIConfig.formScale = FormCenterViewData.getInstance().getFormDimensionScale(this.formItem.cardDimension);
    if (!CheckEmptyUtils.isEmpty(this.formItem.shortcutInfo)) {
      formItemUIConfig.hiddenStrokes = true;
      formItemUIConfig.formRadius = this.shortcutFormRadius;
      formItemUIConfig.formDisplayWidth = this.shortcutFormSize;
      formItemUIConfig.formDisplayHeight = this.shortcutFormSize;
    }
    this.swiperFormAnimate.setFormWidth(this.index, formItemUIConfig.formDisplayWidth);
    const location: FormCenterLocation = SwiperLayoutFormEvent.mFormCenterViewManager.getFormCenterLocation();
    if (location === FormCenterLocation.SCENE_PANEL) {
      formItemUIConfig.hasFadeInAnimation = true;
    }

    formItemUIConfig.parentUpdater = new ParentUpdater(formItemUIConfig, this.formItem,
      this.isCurrentIndex(this.index), this.swiperFormAnimate);
    this.parentUpdater = formItemUIConfig.parentUpdater;
    formItemUIConfig.formUpdater = new FormUpdater(formItemUIConfig, this.isDragable());
    this.formItemUIConfig = formItemUIConfig;
    this.formUpdater = formItemUIConfig.formUpdater;
    this.setParentUpdater?.(this.index, this.parentUpdater, this.formUpdater);
  }

  public initAnimateData(formItemAnimData: FormItemAnimData, index?: number): void {
    this.formItemAnimData = formItemAnimData;
  }

  public isDragable(): boolean {
    return this.isCurrentIndex(this.index) && FormCenterViewModel.getInstance().getIsSupportDrag();
  }

  protected scaleAnimate(isZoomOut: boolean): void {
    let animateUtil = FormCenterAnimateUtil.getInstance();
    let params: CardAnimParams = animateUtil.getPressAnimParams(isZoomOut, this.formItem.cardDimension);
    animateTo(params.params, () => {
      this.formItemAnimData.animateScale = params.scale;
    });
  }

  public getFormItemSnapId(): string {
    let bundleName: string = FormCenterViewModel.getInstance().isCurrentSuggestion ?
      FormStyleConstants.FORM_CENTER_DEFAULT_ITEM : this.formItem.bundleName;
    return FormCenterFormCommonUtil.getFormItemId(bundleName, this.index);
  }

  protected copyCard(): CardItemInfo {
    let copyItem: CardItemInfo = ObjectCopyUtil.deepClone(this.formItem);
    copyItem.appName = this.appInfo?.applicationName;
    copyItem.cardId = this.cardId;
    copyItem.id = copyItem.cardId;
    copyItem.dimension = copyItem.cardDimension;
    copyItem.name = copyItem.cardName;
    log.showWarn(`getChooseCard id: ${copyItem.cardId} dimension: ${copyItem.dimension}`);
    return copyItem;
  }

  protected isFormChosen(): boolean {
    let isCurrentIndex: boolean = this.isCurrentIndex(this.index);
    let isChosen: boolean = FormCenterViewModel.getInstance().getCloseReason() === CloseReason.CLOSE_BY_ADD_FORM;
    log.showWarn(`isFormChosen,${this.index}, ${isCurrentIndex}, ${isChosen}`);
    return this.isCurrentIndex(this.index) &&
      FormCenterViewModel.getInstance().getCloseReason() === CloseReason.CLOSE_BY_ADD_FORM;
  }

  public getIsCurrentIndex(index: number): boolean {
    return this.isCurrentIndex(index);
  }

  private isAccessibilityMode(): boolean {
    return AccessibilityManager.getInstance().getIsAccessibilityMode();
  }
}