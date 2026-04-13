/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import type abilityCommon from '@ohos.app.ability.common';
import { componentSnapshot, curves, performanceMonitor } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import ctx from '@ohos.app.ability.common';
import {
  dropAnimationManager,
  ForceType,
  GravityAnimationConfig,
  GravityAnimationManager,
} from '@ohos/componentanimator/Index';
import {
  AppStorageUtil,
  CheckEmptyUtils,
  DataProperty,
  DomainName,
  LogDomain,
  LogHelper,
  TraceUtil,
  RectInfo,
  PixelMapUtil,
} from '@ohos/basicutils';
import {
  DragDataType,
  DragEventManager,
  DragExtraInfo,
  DragItemPosition,
} from '@ohos/componentdrag';
import {
  GlobalContext,
  HiSysEventUtil,
  localEventManager,
  DeviceHelper,
  ResourceManager,
  AccessibilityManager,
} from '@ohos/frameworkwrapper';
import {
  SnapshotType,
  desktopUtil,
  dragSnapshotHelper,
  ObjectCopyUtil,
  ItemUtils,
  DragAccessibilityUtils
} from '@ohos/componenthelper';
import {
  scbEventExclusiveManager,
  EventType,
  launcherStatusUtil,
  ResUtils,
} from '@ohos/windowscene';
import { NumberConstants } from '@ohos/commonconstants';
import {
  DropAnimationCancelReason,
  DropAnimationDestination,
  DropAnimationListener,
  dropAnimationObserver,
  DropAnimationParam,
  DropAnimationScene
} from '@ohos/componentanimator';
import { SwiperLoadData } from '@ohos/swiperdata';
import { RemoveCardResultType } from '@ohos/form/src/main/ets/default/util/FormHiSysEventUtil';
import {
  CardItemInfo,
  ClickCardEvent,
  CloseAppManager,
  CommonConstants,
  editModeManager,
  EditModeUtils,
  EventConstants,
  Extend1Data,
  FormCommonUtil,
  FormHiSysEventReporter,
  FormLayoutCacheManager,
  FormModel,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
  RemoveCardEvent,
  StyleConstants,
  ThemeServiceManager,
  DesktopItemVibratorManager,
  EditModeConstants,
  lockLayoutManager,
  desktopItemDraggableManager,
  DesktopDragResult,
  GrayAppListManager
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import CardLockManager from '@ohos/launchercommon/src/main/ets/manager/CardLockManager';
import { FormStyleConfig, FormViewModel } from '@ohos/form';
import { HoverAnimationUtil, batchUninstallChain, ForwardType } from '@ohos/launchercommon/Index';
import { PageDesktopDragHandler } from '../../../PageDesktopDragHandler';
import { PageDesktopViewModel } from '../../../viewmodel/PageDesktopViewModel';
import {
  CardAnimParams,
  CardArea,
  FormAnimateData,
  FormBackboardVm,
  FormItemRelativeVm,
  FormMaskVm
} from './FormItemRelativeVm';
import { AttributeUpdater, ImageModifier } from '@ohos.arkui.modifier';
import { FormMenuEvent } from './FormMenuEvent';
import lazy { outerAddAppIconManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAddAppIconManager';
import { FormZoomViewManager, FormZoomViewParam } from '@ohos/launchercommon/src/main/ets/manager/FormZoomViewManager';
import { FormZoomManager } from '../../formAdjust/common/FormZoomManager';
import { formZoomController } from '../../formAdjust/viewModel/FormZoomController';

const TAG = 'FormItemRelativeEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DROP_ANIMATE_EXTRA_TRANSLATE_Y = 6;
const FOREGROUND_BLUR_RADIUS = 70;
const DRAG_SNAPSHOT_DELAY_MS = 30;
// 空函数
function noop(): void {};

export class FormItemRelativeEvent {
  protected mFormItemVm: FormItemRelativeVm;
  private mFormBackVm: FormBackboardVm;
  private mFormMaskVm: FormMaskVm;
  protected mFormItem: CardItemInfo = new CardItemInfo();
  protected mFormItemHeight: number = 0;
  protected mFormItemWidth: number = 0;
  protected mFormComponentBuilderId: string = '';
  private mBlurRatio: number = 1;
  private mBackplaneAutoDisappearTimer: number = 0;
  protected mDesktopContext: abilityCommon.ServiceExtensionContext = GlobalContext.getContext();
  private mDevicePC: boolean = DeviceHelper.isPC();
  private mDefaultType: boolean = DeviceHelper.isPhone()
  private mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
  private mFormViewModel: FormViewModel = FormViewModel.getInstance();
  protected mFormStyleConfig: FormStyleConfig = this.mFormViewModel.getFormStyleConfig();
  private mPageDragHandler: PageDesktopDragHandler = PageDesktopDragHandler.getInstance();
  private mUpdateEditModeUninstallInfo?: (isShowCancelDialog: boolean) => void;
  private getFormVisibility?: () => boolean;
  private getFormOpacity?: () => number;
  private setFormVisibility?: (visibility: boolean) => void;
  private setNameOpacity?: (opacity: number) => void;
  protected updateDragImage?: (formImage: image.PixelMap) => void;
  private updateMenuShowState?: (state: boolean) => void;
  private updateFormUninstallState?: (state: boolean) => void;
  private eventhubCancelItemEvent: Function = (isCancel: boolean): void => this.onEventhubCancelItemEvent(isCancel);
  private eventhubSetFormShowEvent: Function = (): void => this.onEventhubSetFormShowEvent();
  private eventhubCoveredItemEvent: Function = (isShow: boolean): void => this.onEventhubCoveredItemEvent(isShow);
  protected eventhubOtherIconLongPressCancel: Function = (): void => this.cancelLongPressAnimation();
  private eventhubFormItemDraggedRemoved: Function = (cardId: string): void => this.onFormItemDraggedRemoved(cardId);
  private eventhubPrepageToRemoved: Function = (): void => this.onFormItemPrepageToRemoved();
  private eventhubItemDropEvent: Function =
    (dragItemInfos: GridLayoutItemInfo[], dragResult: DesktopDragResult): void =>
    this.onEventhubItemDropEvent(dragItemInfos, dragResult);
  private eventhubAppUninstallEvent: Function = (): void => this.onEventhubUninstallEventHandler();
  private isOuter?: boolean;
  private isAddedToStack: boolean = false; //是否形成了堆叠
  private updateFormZoomId?: (value: string) => void;
  private isOuterDesktop: boolean = false;

  constructor(formItemVm: FormItemRelativeVm, formBackVm: FormBackboardVm, formMaskVm: FormMaskVm,
    isOuter: boolean = false) {
    this.mFormItemVm = formItemVm;
    this.mFormBackVm = formBackVm;
    this.mFormMaskVm = formMaskVm;
    this.isOuter = isOuter;
  }

  public initFunction(
    updateEditPara?: (isShowCancelDialog: boolean) => void,
    getFormVisibility?: () => boolean,
    setFormVisibility?: (visibility: boolean) => void,
    getFormOpacity?: () => number,
    setNameOpacity?: (opacity: number) => void,
    updateDragImage?: (formImage: image.PixelMap) => void,
    updateMenuShowState?: (state: boolean) => void,
    updateFormUninstallState?: (state: boolean) => void,
    updateFormZoomId?: (value: string) => void,
  ): void {
    this.mUpdateEditModeUninstallInfo = updateEditPara;
    this.getFormVisibility = getFormVisibility;
    this.setFormVisibility = setFormVisibility;
    this.getFormOpacity = getFormOpacity;
    this.setNameOpacity = setNameOpacity;
    this.updateDragImage = updateDragImage;
    this.updateMenuShowState = updateMenuShowState;
    this.updateFormUninstallState = updateFormUninstallState;
    this.updateFormZoomId = updateFormZoomId;
  }

  public initFormInfo(formItem: CardItemInfo, formHeight: number, formWidth: number,
    formComponentBuilderId?: string): void {
    this.mFormItem = formItem;
    this.mFormItemHeight = formHeight;
    this.mFormItemWidth = formWidth;
    this.mFormComponentBuilderId = formComponentBuilderId ?? '';
    this.mBlurRatio = this.mFormStyleConfig.getBlurRatio(formItem.cardDimension);
  }

  public initEventhubEvent(): void {
    if (CheckEmptyUtils.isEmpty(this.mDesktopContext) || CheckEmptyUtils.isEmpty(this.mFormItem) ||
      CheckEmptyUtils.checkStrIsEmpty(this.mFormItem.cardId)) {
      log.showWarn('initEventhubEvent param is invalid');
      return;
    }
    // 编辑模式拖拽移除右上角事件
    let eventId: string = `cancelUninstall${this.mFormItem.cardId}`;
    this.mDesktopContext.eventHub.on(eventId, this.eventhubCancelItemEvent);

    eventId = `dropStackCard${this.mFormItem.cardId}`;
    this.mDesktopContext.eventHub.on(eventId, this.eventhubItemDropEvent);

    eventId = `dragItemCard${this.mFormItem.cardId}`;
    this.mDesktopContext.eventHub.on(eventId, this.eventhubSetFormShowEvent);

    eventId = `coveredCard${this.mFormItem.cardId}`;
    this.mDesktopContext.eventHub.on(eventId, this.eventhubCoveredItemEvent);

    // 应用卸载事件
    eventId = `appUninstall${this.mFormItem.bundleName}`;
    this.mDesktopContext.eventHub.on(eventId, this.eventhubAppUninstallEvent);

    log.showWarn('event registration completed');
  }

  public unInitEventhubEvent(): void {
    if (CheckEmptyUtils.isEmpty(this.mDesktopContext) || CheckEmptyUtils.checkStrIsEmpty(this.mFormItem.cardId)) {
      log.showWarn('unInitEventhubEvent param is invalid');
      return;
    }

    let eventId: string = `cancelUninstall${this.mFormItem.cardId}`;
    this.mDesktopContext.eventHub.off(eventId, this.eventhubCancelItemEvent);

    eventId = `dropStackCard${this.mFormItem.cardId}`;
    this.mDesktopContext.eventHub.off(eventId, this.eventhubItemDropEvent);

    eventId = `dragItemCard${this.mFormItem.cardId}`;
    this.mDesktopContext.eventHub.off(eventId, this.eventhubSetFormShowEvent);

    eventId = `coveredCard${this.mFormItem.cardId}`;
    this.mDesktopContext.eventHub.off(eventId, this.eventhubCoveredItemEvent);

    eventId = `appUninstall${this.mFormItem.bundleName}`;
    this.mDesktopContext.eventHub.off(eventId, this.eventhubAppUninstallEvent);

    this.mDesktopContext?.eventHub.off(EditModeConstants.EVENT_EDIT_MODE_DROP_TO_DELETE + this.mFormItem.cardId,
      this.eventhubPrepageToRemoved);
    this.mDesktopContext?.eventHub.off('formItemDraggedRemoved', this.eventhubFormItemDraggedRemoved);
    log.showWarn('event unRegistration completed');
  }

  public getFormAppModuleName(bundleName: string): string {
    return FormModel.getInstance().getAppInfoByBundleName(bundleName)?.moduleName as string;
  }

  public onHoverEvent(isHover: boolean): void {
    HoverAnimationUtil.hoverEffect(isHover, false, (hoverScale: number) => {
      this.mFormItemVm.mAnimateScale = hoverScale;
    });
  }

  private getHoverScale(isHover: boolean, cardDimension?: number): number {
    let hoverScale: number = isHover ? 1.02 : 1;
    if (!isHover || !cardDimension) {
      return hoverScale;
    }
    switch (cardDimension) {
      case CommonConstants.CARD_DIMENSION_1x2: hoverScale = 1.04; break;
      case CommonConstants.CARD_DIMENSION_2x2: hoverScale = 1.04; break;
      case CommonConstants.CARD_DIMENSION_2x4: hoverScale = 1.02; break;
      case CommonConstants.CARD_DIMENSION_4x4: hoverScale = 1.01; break;
      case CommonConstants.CARD_DIMENSION_6x4: hoverScale = 1.01; break;
    }
    return hoverScale;
  }

  private doSmallCardAnimation(animateScale: number): void {
    animateTo({
      duration: 150,
      curve: Curve.Sharp
    }, () => {
      this.mFormItemVm.mAnimateScale = animateScale;
    })
  }

  private doLargeCardAnimation(animateScale: number): void {
    animateTo({
      duration: 200,
      curve: Curve.Smooth
    }, () => {
      this.mFormItemVm.mAnimateScale = animateScale;
    })
  }

  public onHoverEventHandler(isHover: boolean, cardDimension?: number): void {
    log.showWarn(`current is hover: ${isHover}`);
    let isDrag: boolean = AppStorage.get<boolean>('isDrag') as boolean;
    if (isDrag) {
      return;
    }
    let animateScale: number = this.getHoverScale(isHover, cardDimension);
    if (cardDimension && cardDimension < CommonConstants.CARD_DIMENSION_2x4) {
      this.doSmallCardAnimation(animateScale);
    } else {
      this.doLargeCardAnimation(animateScale);
    }
  }

  public removeHoverEffect(): void {
    log.showInfo('removeHoverEffect');
    this.mFormItemVm.mAnimateScale = 1;
  }

  public handleLongPressVibration(formMenuEvent: FormMenuEvent, event?: GestureEvent): void {
    if (lockLayoutManager.isLockLayout()) {
      lockLayoutManager.toastLockedLayout();
    }

    if (formZoomController.getDragState()) {
      log.showInfo('form in drag zoom, dont show menu');
      formZoomController.setDragState(false);
      return;
    }

    if (this.getFormOpacity?.() === 0) {
      // 卡片透明度还没恢复，不显示菜单，否则会显示透明
      return
    }
    if (this.mDevicePC && event?.source === SourceType.Mouse) {
      // 鼠标长按不响应震动
      log.showWarn('handleLongPressVibration, not response for mouse action');
      return;
    }
    // 编辑模式 能够卸载的app 通知显示删除按钮
    if (editModeManager.isInEditMode()) {
      let batchItem: GridLayoutItemInfo[] = [this.mFormItem as Object as GridLayoutItemInfo];
      batchUninstallChain.forward(ForwardType.LONG_PRESS, batchItem);
    }
    if (this.mFormItemVm.mIsInFormHotArea &&
      !scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK)) {
      DesktopItemVibratorManager.getInstance().longPressVibrator(TAG);
    }
    // 拖拽适配无障碍朗读普通卡片起拖播报
    DragAccessibilityUtils.textAnnouncedForDragStart();
    if (!editModeManager.isInEditMode() && !AppStorage.get<boolean>('isDrag') && !DeviceHelper.isPC()) {
      formMenuEvent.setMenuShowState(true);
    }
    // 延时加载放缩组件，避免菜单弹出时出现跳闪
    setTimeout(() => {
      this.setFormZoomId();
    }, 10)
  }

  public sendFormZoomViewData(formComponentId: string): void {
    let rectInfo: RectInfo = ItemUtils.getRectById(formComponentId);
    // 优先使用RectInfo中的元素宽高值
    let formItemWidth: number = rectInfo.width ?? this.mFormItemWidth;
    let formItemHeight: number = rectInfo.height ?? this.mFormItemHeight;
    let formBorderRadius: number = this.mFormItemVm.mFormBorderRadius;
    if (editModeManager.isInEditMode()) {
      let position: number[] = GridLayoutUtil.getIconCenterPosition(this.mFormItem.row, this.mFormItem.column, this.mFormItem.area, this.mFormItem.page);
      let left: number = position[0] - 0.5 * (rectInfo.width || 0);
      let top: number = position[1] - 0.5 * (rectInfo.height || 0);
      rectInfo.left = left;
      rectInfo.top = top;
      formItemWidth = EditModeUtils.convertWithDesktopScale(formItemWidth);
      formItemHeight = EditModeUtils.convertWithDesktopScale(formItemHeight);
      formBorderRadius = EditModeUtils.convertWithDesktopScale(formBorderRadius);
    }

    let formZoomViewParam: FormZoomViewParam = {
      formComponentId,
      rectInfo,
      formItemWidth,
      formItemHeight,
      formBorderRadius,
      formInfo: this.mFormItem,
    }
    FormZoomViewManager.getInstance().openFormZoomView(formZoomViewParam);
  }

  public setFormZoomId(): void {
    // 锁定布局下不显示拖拽线框
    if (lockLayoutManager.isLockLayout()) {
      log.showWarn('layout is locked, do not show form zoom component');
      return;
    }
    let layoutCachedFormItem: GridLayoutItemInfo | undefined =
      FormLayoutCacheManager.getInstance().selectGridLayoutItemByCardId(this.mFormItem.cardId);
    // 1.布局缓存中有此卡片;2.此卡片支持调整大小, 满足以上条件显示拖拽组件
    if (layoutCachedFormItem && this.isSupportZoomCard()) {
      let formComponentId: string = FormCommonUtil.getFormComponentId(this.mFormItem);
      this.sendFormZoomViewData(formComponentId);
      this.updateFormZoomId?.(formComponentId);
    }
  }

  public handleLongPressVibrationEnd(): void {
    // 编辑模式 能够卸载的app 通知隐藏删除按钮
    if (editModeManager.isInEditMode()) {
      batchUninstallChain.forward(ForwardType.LONG_PRESS_END);
    }
  }

  public async dealWithFromName(): Promise<string> {
    let appName: string = '';
    return appName;
  }

  public onTouchEventHandler(event: TouchEvent, itemId: string, isInDrag: boolean): void {
    if (CheckEmptyUtils.isEmpty(event)) {
      log.showWarn('touch event is null');
      return;
    }
    if (scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK)) {
      log.showWarn('form item touch in exclusive scene!');
      return;
    }
    if (event.type === CommonConstants.TOUCH_TYPE_DOWN) {
      log.showWarn('onTouch down start');
      this.mDesktopContext?.eventHub.on(`otherIconLongPressEffectCancel`, this.eventhubOtherIconLongPressCancel);
      // 退出动效过程中，取缓存截图，避免消失问题
      if (this.getFormOpacity?.() === 0) {
        log.showWarn('close app animation state, get card snap shot cache');
        let value: image.PixelMap = ResourceManager.getInstance().getCachedCardSnapshot(itemId);
        this.updateDragImage?.(value);
      } else {
        if (DeviceHelper.isPC()) {
          // pc保留触摸截图的逻辑以满足鼠标单击后直接拖拽的场景，手机设备则在长按中进行截图以避免长按其余图标时触摸此处导致的长按预览图标空白
          this.dragSnapshotHandler(itemId, itemId, isInDrag);
        }
        this.snapshotForCloseApp(itemId);
      }

      this.mFormItemVm.mIsInFormHotArea = true;
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      this.playLongPressAnimation(true, this.mFormItem.cardDimension);
    } else if (event.type === CommonConstants.TOUCH_TYPE_UP) {
      log.showInfo('onTouch up start');
      this.mDesktopContext?.eventHub.off(`otherIconLongPressEffectCancel`, this.eventhubOtherIconLongPressCancel);
      this.showForm();
      this.playLongPressAnimation(false, this.mFormItem.cardDimension);
      //Set startAppType before the form animation.
      if (DeviceHelper.isPC()) {
        this.formClickEvent();
      }
    }

    if (event.type === CommonConstants.TOUCH_TYPE_UP || event.type === TouchType.Cancel) {
      this.mFormItemVm.mIsInFormHotArea = false;
    }
  }

  public showFormBackplaneAnimate(isCardBackplaneOpen: boolean): void {
    if (!this.mFormBackVm.mIsFormBackOpen && !isCardBackplaneOpen) {
      log.showDebug('backplane disappeared, no action required.');
      return;
    }

    if (isCardBackplaneOpen) {
      log.showWarn('showAppBackplaneAnimate start');
      this.mFormBackVm.mIsFormBackOpen = true;
      animateTo({
        curve: curves.springMotion(0.45, 1),
      }, () => {
        // 背板动效
        this.mFormBackVm.mFormBackboardScale = 2 - this.mFormBackVm.mSizeRatio;
        this.mFormBackVm.mFormBackboardRadius = StyleConstants.CARD_BACKGROUND_SIDE_OFFSET;

        // 蒙版透明度渐变和缩放
        this.mFormMaskVm.mFormMaskOpacity = 0.1;
        // 底部卡片缩放
        this.mFormItemVm.mDropAnimateScale = this.mFormBackVm.mSizeRatio;
        // 出现背板的时候，隐去卡片的名字
        this.setNameOpacity?.(0);
      })
    } else {
      log.showWarn('showAppBackplaneAnimate end');
      animateTo({
        curve: curves.springMotion(0.45, 1),
      }, () => {
        this.mFormBackVm.mIsFormBackOpen = false;
        // 背板动效
        this.mFormBackVm.mFormBackboardScale = 1;
        this.mFormBackVm.mFormBackboardRadius = 0;

        // 蒙版透明度渐变和缩放
        this.mFormMaskVm.mFormMaskOpacity = 0;
        // 底部卡片缩放
        this.mFormItemVm.mDropAnimateScale = 1;
        // 背板消失时，显示卡片的名字
        this.setNameOpacity?.(1);
      })
    }
  }

  public cancelLongPressAnimation(): void {
    log.showWarn('formIconLongPress animation cancel');
    animateTo({
      duration: 0,
      onFinish: () => {
        this.mFormItemVm.mDropAnimateScale = StyleConstants.DEFAULT_1;
        this.mDesktopContext?.eventHub.off(`otherIconLongPressEffectCancel`, this.eventhubOtherIconLongPressCancel);
      }
    }, () => {
      this.mFormItemVm.mDropAnimateScale = StyleConstants.CANCEL_LONG_PRESS_SCALE;
    })
  }

  public handlerDragStart(event: DragEvent): DragItemInfo {
    let itemId: string = FormCommonUtil.getFormComponentId(this.mFormItem);
    this.updateMenuShowState?.(false);
    if (!this.getFormVisibility?.()) {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_DESKTOP_MENU_EVENT, 1);
    }
    performanceMonitor.begin(HiSysEventUtil.DRAG_ITEM_ANI, performanceMonitor.ActionType.FIRST_MOVE, 'item:[Form]');
    TraceUtil.startTrace(DomainName.HOME, HiSysEventUtil.DRAG_ITEM_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    return this.dragStart(event);
  }

  public getDragModifier(): ImageModifier {
    return new ImageModifier().borderRadius(EditModeUtils.convertWithDesktopScale(this.mFormItemVm.mFormBorderRadius));
  }

  public handlerDragEnd(): void {
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_FORM_ITEM_VISIBLE, true);
    AppStorageUtil.setOrCreate('isDrag', false, new DataProperty(true, false));
    let itemKey: string = GridLayoutUtil.generateUniqueKey(this.mFormItem as Object as GridLayoutItemInfo);
    DragEventManager.getInstance(launcherStatusUtil.getShowOutLauncherStatus()).startDrop(itemKey);
    AppStorageUtil.setOrCreate('dragItemInfo', new CardItemInfo(), new DataProperty(true, false, 'CardItemInfo'));
    (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)
      ?.eventHub?.emit(CommonConstants.EVENTHUB_ICON_OR_CARD_DROP);
    if (!this.getFormVisibility?.()) {
      this.setFormVisibility?.(true);
    }
    // 拖拽结束后，将hover动效放大的图标设置为初始值，防止落位动效完成后，出现图标一帧变大
    this.mFormItemVm.mAnimateScale = 1;
    FormZoomManager.getInstance().setIsReady(true);
    this.playLongPressAnimation(false, this.mFormItem.cardDimension);
  }

  public playLongPressAnimation(isZoomOut: boolean, cardDimension: number, endScale?: number): void {
    if (isZoomOut) {
      let curve = this.getPressAnimParams(cardDimension).curve;
      let scale = this.getPressAnimParams(cardDimension).scale;
      log.showWarn(`formItemComponentLongPress zoom out, scale: ${scale}`);
      animateTo({
        curve: curve,
        playMode: PlayMode.Normal,
      }, () => {
        this.mFormItemVm.mDropAnimateScale = scale;
      });
      // 长按触发恢复时长
      const delay: number = editModeManager.isInEditMode() ? NumberConstants.CONSTANT_NUMBER_550 :
        NumberConstants.LONG_PRESS_ZOOM_IN_WITH_MENU;
      const recoveryScale: number = editModeManager.isInEditMode() ? StyleConstants.EDIT_MODE_LONG_PRESS_SCALE :
        StyleConstants.DEFAULT_1;
      // 防止焦点被卡片内容抢占后长按事件不触发，添加recover机制
      const tId: number = setTimeout(() => {
        if (this.mFormItemVm.mDropAnimateScale < StyleConstants.DEFAULT_1) {
          this.playLongPressAnimation(false, cardDimension, recoveryScale);
        }
        clearTimeout(tId);
      }, delay);
    } else {
      animateTo({
        duration: NumberConstants.CONSTANT_NUMBER_250,
        curve: Curve.Friction,
        playMode: PlayMode.Normal,
      }, () => {
        if (!this.isAbnormalCard() && this.mFormItemVm.supportZoom) {
          this.mFormItemVm.mDropAnimateScale = StyleConstants.DEFAULT_1;
          log.showWarn(`formItemComponentLongPress zoom in, scale: ${StyleConstants.DEFAULT_1}`);
        } else {
          log.showWarn(`formItemComponentLongPress zoom in, endScale: ${endScale}`);
          this.mFormItemVm.mDropAnimateScale = endScale ?? StyleConstants.DEFAULT_1;
        }
      });
    }
  }

  public formClickEvent(): void {
    if (editModeManager.isInEditMode()) {
      return;
    }
    log.showWarn('click form');
    this.reportClickCardEvent();
    this.setStartAppInfo();
  }

  public doRemoveFormAnimate(indexInSwiper: number): void {
    log.showWarn(`removeFormAnimate start`);
    let formAnimateData: FormAnimateData = AppStorage.get('formAnimateData') as FormAnimateData;
    if (formAnimateData.isOpenRemoveFormDialog && formAnimateData.cardId === this.mFormItem.cardId) {
      this.gravityAnimationHandler(indexInSwiper);

      TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_REMOVE_FORM_ANI);
      // 删除单卡时无障播报，二次弹窗确认后播报
      if (AccessibilityManager.getInstance().getIsAccessibilityMode()) {
        let deleteCardName: string = ResourceManager.getInstance()
          .getCachedAppName(this.mFormItem?.appLabelId, this.mFormItem?.bundleName, this.mFormItem?.moduleName);
        let deleteFormText: string = ResUtils.getInnerStringNumS(
          $r('app.string.delete_stack_form'), `${deleteCardName ?? ''}`);
        AccessibilityManager.getInstance()
          .sendTextAnnouncedForAccessibility(deleteFormText, 'textAnnouncedForRemoveForm');
      }
      animateTo({
        duration: 250,
        tempo: 0.5,
        curve: '(0.3,0,0.9,1)',
        delay: 0,
        iterations: 1,
        playMode: PlayMode.Normal,
        onFinish: () => {
          TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_REMOVE_FORM_ANI);
          this.removeForm();
        }
      }, () => {
        this.mFormItemVm.mAnimateScale = 0;
        this.mFormItemVm.mAnimateOpacity = 0;
        this.mFormItemVm.mAnimateBlur = FOREGROUND_BLUR_RADIUS * this.mBlurRatio;
      })
    }
  }

  public setStartAppInfo() {
    log.showWarn(`startApp cardId: ${this.mFormItem.cardId}`);
  }

  public uninstallAppResultHandler(bundleName: string, resultCode: number): void {
    if (bundleName === this.mFormItem.bundleName && resultCode !== CommonConstants.UNINSTALL_SUCCESS) {
      log.showWarn('app uninstall fail, restore form shadow.');
      this.updateFormUninstallState?.(false);
    }
  }

  public reportRemoveCardEvent(resultType: number): void {
    const cardItem: CardItemInfo = this.mFormItem;
    if (!cardItem) {
      log.showWarn('report remove card UE event failed, cardItem is undefined.');
      return;
    }
    if (!cardItem.area || cardItem.area.length === 0) {
      log.showWarn(`report remove card UE event failed, please check params, area=${cardItem.area?.length}.`);
      return;
    }
    let position: string = `[${cardItem.page},${cardItem.column},${cardItem.row}]`;
    const event: RemoveCardEvent = {
      packageName: cardItem.bundleName,
      area: cardItem.area,
      formId: cardItem.cardId.toString(),
      moduleName: cardItem.moduleName,
      formName: cardItem.cardName,
      position: position,
      resultType: resultType,
      sourceType: Extend1Data.getCardSourceType(cardItem.extend1),
      formType: FormCommonUtil.getFormType(cardItem.gameCardInfo),
    };
    FormHiSysEventReporter.reportRemoveCard(event);
  }

  /**
   * 判断是否接受对应的手势
   *
   * @param gestureInfo 手势信息
   * @param event 手势事件
   * @returns 是否接受对应的手势
   */
  public onGestureJudgeBegin(gestureInfo: GestureInfo, event: BaseGestureEvent): GestureJudgeResult {
    if (gestureInfo.type === GestureControl.GestureType.LONG_PRESS_GESTURE) {
      return GestureJudgeResult.REJECT;
    }

    if (gestureInfo.type === GestureControl.GestureType.DRAG) {
      if (editModeManager.isInEditMode() &&
        !editModeManager.isDraggable(this.mFormItem as Object as GridLayoutItemInfo) ||
        !desktopItemDraggableManager.getEnableDrag()) {
        return GestureJudgeResult.REJECT;
      }
    }
    return GestureJudgeResult.CONTINUE;
  }

  protected snapshotForCloseApp(itemId: string): void {
    // 手机设备触摸截图不保留为拖拽落位预览图，只用于应用启动退出
    componentSnapshot.get(itemId).then((value: image.PixelMap) => {
      PixelMapUtil.addName(value, `FormItemRelativeEvent_card_snapshot_${itemId}`);
      CloseAppManager.getInstance().setCardStartSnapshot(itemId, value);
      value.release();
    })
      .catch((err: Error) => {
        log.error('componentSnapshot error', err);
      });
  }

  protected dragSnapshotHandler(itemId: string, cacheId: string, isInDrag: boolean = false): void {
    TraceUtil.startTrace(DomainName.HOME, `snapshotFromId:${itemId}`);
    dragSnapshotHelper.snapshotFromId(itemId, SnapshotType.BOTH,
      GridLayoutUtil.generateUniqueKey(this.mFormItem as Object as GridLayoutItemInfo),
      (value: image.PixelMap) => {
        FormModel.getInstance().setPixmapMemoryName(value, `FormItem_${this.mFormItem.cardId}`);
        this.updateDragImage?.(value);
        ResourceManager.getInstance().setAppResourceCache(cacheId, 'cardSnapshot', value);
        TraceUtil.endTrace(DomainName.HOME, `snapshotFromId:${itemId}`);
        log.showInfo(`snapshotFromId ${cacheId} ok`);
      }, undefined, undefined, 'FormItemRelativeEvent_dragSnap');
  }

  private gravityAnimationHandler(indexInSwiper: number): void {
    const cached: GridLayoutItemInfo | undefined = LaunchLayoutCacheManager.getInstance().selectGridLayoutItemByItem(
      this.mFormItem as Object as GridLayoutItemInfo);
    if (cached) {
      log.showWarn('trigger gravity animation with card [%{public}d:%{public}d,%{public}d] removed',
        indexInSwiper, cached.row, cached.column);
      const cachedPos: number[] = GridLayoutUtil.getIconCenterPosition(cached.row, cached.column, cached.area,
        indexInSwiper);
      GravityAnimationManager.getInstance()
        .runLater(GravityAnimationConfig.getDelayOnRemoveCard(),
          SwiperLoadData.getInstance().getSwiperKeyByIndex(indexInSwiper),
          cachedPos,
          ForceType.GRAVITATION, cached.area as number[]);
    } else {
      log.showError('cannot get item %{public}s/%{public}s cache info', this.mFormItem.typeId,
        this.mFormItem.bundleName);
    }
  }

  private showForm(): void {
    if (!editModeManager.isInEditMode()) {
      return;
    }
    setTimeout(() => {
      if (!this.getFormVisibility?.()) {
        this.setFormVisibility?.(true);
      }
    }, CommonConstants.RESTORE_TIME_FOR_FLOATING_EFFECT);
  }

  private onEventhubCoveredItemEvent(isShow: boolean): void {
    const dragItemType: number = AppStorage.get<number>('dragItemType') as number;
    if ((dragItemType === CommonConstants.DRAG_FROM_DESKTOP || dragItemType === CommonConstants.DRAG_FROM_APP_ICON ||
    CommonConstants.DRAG_FROM_DOCK || CommonConstants.DRAG_FROM_MANAGE ||
    CommonConstants.DRAG_FROM_FORM_SERVICE) && !this.mDevicePC) {
      this.showFormBackplaneAnimate(isShow);
    }
  }

  private onEventhubSetFormShowEvent(): void {
    this.mFormItemVm.mIsDragItem = true;
  }

  private onEventhubUninstallEventHandler(): void {
    log.showWarn('app uninstalling, set form shadow null.');
    this.updateFormUninstallState?.(true);
  }

  private onEventhubItemDropEvent(dragItemInfos: GridLayoutItemInfo[], dragResult: DesktopDragResult): void {
    log.showWarn(`onEventhubItemDropEvent start`);
    // 注册落位动效结束回调
    const dropAniListener: DropAnimationListener = {
      onDropAnimationEnd: (a: DropAnimationDestination, b: DropAnimationParam, c: boolean, isCancel: boolean) => {
        // 清除监听动画结束事件
        dropAnimationObserver.unregisterDropAnimationListener(dropAniListener);
        this.mFormItemVm.mIsDragItem = false;
        this.mFormBackVm.mIsFormBackOpen = false;
        this.setNameOpacity?.(1);
        // 更新缓存
        GlobalContext.getContext()?.eventHub.emit(EventConstants.CREATE_FORM_STACK_NOTIFY_EVENT);
        // 刷新布局
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
      }
    }
    dropAnimationObserver.registerDropAnimationListener(dropAniListener);
    // 落位动效执行中，隐藏菜单，防止长按打断落位动效同时弹出菜单
    this.updateMenuShowState?.(false);
    this.isAddedToStack = true;
    dragResult.parallelAnimation = () => this.dropAnimation();
  }

  private dropAnimation = () => {
    // 背板动效
    this.mFormBackVm.mFormBackboardScale = 1;
    this.mFormBackVm.mFormBackboardRadius = 0;
    // 卡片上移
    this.mFormItemVm.mDropAnimateTranslateY =
      -(this.mFormItemHeight * (1 - this.mFormBackVm.mSizeRatio) / 2 + DROP_ANIMATE_EXTRA_TRANSLATE_Y);
    // 蒙版透明度渐变和跟随卡片上移
    this.mFormMaskVm.mFormMaskOpacity = 0.9;
  }

  private getPressAnimParams(cardDimension: number): CardAnimParams {
    let area = this.getFormArea(cardDimension);
    let curve: curves.ICurve;
    let scale: number;
    if (area === CardArea.SMALL) {
      curve = curves.interpolatingSpring(1, 1, 410, 38);
      scale = StyleConstants.DEFAULT_LONG_PRESS_SCALE_90;
    } else if (area === CardArea.MIDDLE) {
      curve = curves.interpolatingSpring(0.5, 1, 350, 35);
      scale = StyleConstants.DEFAULT_LONG_PRESS_SCALE_95;
    } else {
      curve = curves.interpolatingSpring(0, 1, 240, 28);
      scale = StyleConstants.DEFAULT_LONG_PRESS_SCALE_95;
    }
    return { curve, scale };
  }

  private getFormArea(cardDimension: number): number {
    switch (cardDimension) {
      case CommonConstants.CARD_DIMENSION_1x2:
        return CardArea.SMALL;
      case CommonConstants.CARD_DIMENSION_2x2:
      case CommonConstants.CARD_DIMENSION_2x4:
        return CardArea.MIDDLE;
      case CommonConstants.CARD_DIMENSION_4x4:
      default:
        return CardArea.LARGE;
    }
  }

  private dragStart(event: DragEvent): DragItemInfo {
    let x: number = event.getWindowX();
    let y: number = event.getWindowY();
    this.mDesktopContext?.eventHub.off('formItemDraggedRemoved', this.eventhubFormItemDraggedRemoved);
    this.mDesktopContext?.eventHub.on('formItemDraggedRemoved', this.eventhubFormItemDraggedRemoved);
    this.mDesktopContext?.eventHub.on(EditModeConstants.EVENT_EDIT_MODE_DROP_TO_DELETE + this.mFormItem.cardId,
      this.eventhubPrepageToRemoved);
    AppStorageUtil.setOrCreate('isDrag', true, new DataProperty(true, false));
    ContextMenu.close();
    AppStorageUtil.setOrCreate('selectItem', '', new DataProperty(false, false));
    if (!this.mDefaultType) {
      this.mPageDesktopViewModel.selectItemClear();
    }
    AppStorageUtil.setOrCreate('dragItemType', CommonConstants.DRAG_FROM_DESKTOP, new DataProperty(true, false));
    AppStorageUtil.setOrCreate('dragItemInfo', this.mFormItem, new DataProperty(true, false, 'CardItemInfo'));

    if (editModeManager.isInEditMode()) {
      let dragItem: CardItemInfo = new CardItemInfo();
      ObjectCopyUtil.deepClone(this.mFormItem, dragItem);
      this.mUpdateEditModeUninstallInfo?.(false);
    }

    const selectAppIndex: number = this.mPageDragHandler.getItemIndex(x, y);
    const startPosition: DragItemPosition = this.mPageDragHandler.getTouchPosition(x, y)
    this.mPageDragHandler.onDragStart(x, y);
    this.mPageDragHandler.setStartPosition(startPosition);
    // 由于卡片设置了marginTop值，落位点Y轴需设置偏差，这个值会随设备变化
    const pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
    AppStorage.setOrCreate('selectAppIndex', selectAppIndex);
    log.showWarn(`onDragStart position=[${x}, ${y}], selectAppIndex=${selectAppIndex}`);
    const itemUniqueKey: string = GridLayoutUtil.generateUniqueKey(this.mFormItem as Object as GridLayoutItemInfo);
    dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, itemUniqueKey)
    ?.setWidth(EditModeUtils.convertWithDesktopScale(this.mFormItemWidth))
      .setHeight(EditModeUtils.convertWithDesktopScale(this.mFormItemHeight))
      .setRadius(EditModeUtils.convertWithDesktopScale(this.mFormItemVm.mFormBorderRadius))
      .setOffset(0, DeviceHelper.isPC() ? GridLayoutUtil.getFloorVp(StyleConstants.DEFAULT_4) : 0);
    const dragImage: image.PixelMap | undefined = dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, itemUniqueKey);
    const realScale: number = EditModeUtils.getDesktopScale();
    if (realScale !== 1) {
      // 跟手图尺寸不为1时需要缩放
      dragImage?.scaleSync(realScale, realScale);
    }

    const dragItemInfo: DragItemInfo = {
      extraInfo: new DragExtraInfo(DragDataType.FORM).setRadius(-1).toString(),
      pixelMap: dragImage
    };
    return dragItemInfo;
  }

  private onFormItemDraggedRemoved(cardId: string): void {
    log.showWarn(`onFormItemDraggedRemoved, cardId:${cardId}`);
    if (cardId === this.mFormItem.cardId) {
      this.removeForm();
      const pageIndex: number = desktopUtil.getPageIndexValue();
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub
        .emit(`rect${pageIndex}`, false, false, [0, 0]);
    }
    this.mDesktopContext?.eventHub.off('formItemDraggedRemoved', this.eventhubFormItemDraggedRemoved);
  }

  private onFormItemPrepageToRemoved(): void {
    log.showWarn(`onFormItemPrepageToRemoved`);
    this.mUpdateEditModeUninstallInfo?.(true);
    this.mDesktopContext?.eventHub.off(EditModeConstants.EVENT_EDIT_MODE_DROP_TO_DELETE + this.mFormItem.cardId,
      this.eventhubPrepageToRemoved);
  }

  private reportClickCardEvent(): void {
    if (this.mFormItem.page === undefined || this.mFormItem.column === undefined || this.mFormItem.row === undefined) {
      log.showError('report click card event failed, the value of necessary property is undefined');
      return;
    }
    const layoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
    let dpSize = this.mFormStyleConfig.mFormWidth?.get(this.mFormItem.cardDimension.toString()) + '*' +
    this.mFormStyleConfig.mFormHeight?.get(this.mFormItem.cardDimension.toString());
    let event: ClickCardEvent = {
      bundleName: this.mFormItem.bundleName,
      cellSize: this.mFormItem.area?.[0] + '*' + this.mFormItem.area?.[1],
      dpSize: dpSize,
      page: this.mFormItem.page,
      pageCount: layoutManager.selectPageCount(),
      formId: this.mFormItem.cardId.toString(),
      moduleName: this.mFormItem.moduleName,
      formName: this.mFormItem.cardName,
      column: this.mFormItem.column,
      row: this.mFormItem.row,
      infoType: 0,
      sourceType: Extend1Data.getCardSourceType(this.mFormItem.extend1),
    };
    FormHiSysEventReporter.reportClickCard(event);
  }

  private onEventhubCancelItemEvent(isCancel: boolean): void {
    this.mFormItemVm.mAnimateScale = 0;
    this.showAppFromDialog(isCancel);
  }

  private showAppFromDialog(isCancel: boolean): void {
    if (isCancel) {
      animateTo({
        curve: curves.springMotion(0.468, 0.63),
        onFinish: () => {
          this.mUpdateEditModeUninstallInfo?.(false);
        }
      }, () => {
        this.mFormItemVm.mAnimateScale = 1;
      })
    }
  }

  private removeForm(): void {
    log.showWarn(`removeFormAnimate end`);
    AppStorageUtil.setOrCreate('formAnimateData', new FormAnimateData(), new DataProperty(false, true));
    this.reportRemoveCardEvent(RemoveCardResultType.REMOVE);
    FormModel.getInstance().deleteFormCacheByCardItem(this.mFormItem, this.isOuter);
    this.mPageDesktopViewModel.afterDeleteDesktopItem(this.isOuter);
    if (this.mFormItem.bundleName === CommonConstants.THEME_MANAGER_BUNDLE) {
      // 主题卡打点
      log.showInfo('themeCard delete, start checkScbOnlineTheme');
      const serviceManager: ThemeServiceManager = new ThemeServiceManager(getContext(this) as common.UIAbilityContext);
      serviceManager.checkScbOnlineTheme();
    }
  }

  private deleteSceneBoardFormRelation(cardId: string): void {
    log.showInfo(`deal with scene board relation : ${cardId}`);
  }

  private isSupportZoomCard(): boolean {
    // 1.非PC卡片; 2.卡片配置可调整大小; 3.卡片ID合法; 4.非禁用、上锁卡片
    return !this.mDevicePC && this.mFormItemVm.supportZoom && this.mFormItem.cardId !== '0' && !this.isAbnormalCard();
  }

  public isAbnormalCard(): boolean {
    let isLockedCard: boolean = CardLockManager.getInstance().mainAppHasLock(this.mFormItem.bundleName) &&
      !CardLockManager.getInstance().getLockedCardIsReleased(this.mFormItem.bundleName, this.mFormItem.cardId);
    let isGrayCard: boolean =
      GrayAppListManager.getInstance().isGrayAppIcon({ bundleName: this.mFormItem.bundleName, appIndex: 0 });
    return isLockedCard || isGrayCard;
  }

  public enableFormZoom(): boolean {
    return !lockLayoutManager.isLockLayout() && !this.isAbnormalCard() && this.mFormItemVm.supportZoom;
  }

  public handleFormWrapperClickEvent(): void {}

  public handleLongPressGestureAction(): void {
    // 截图前判断卡片状态，避免长按截图为空或内容显示错误
    // 1.当前卡片支持调整大小; 2.当前卡片不在拖拽调整大小过程中;
    if (this.isSupportZoomCard() && !formZoomController.getDragState()) {
      let id: string = FormCommonUtil.getFormComponentId(this.mFormItem);
      FormZoomManager.getInstance().setFormZoomSnapshot(id, undefined);
    }

    if (!editModeManager.isInEditMode() && !this.isAddedToStack) {
      this.playLongPressAnimation(false, this.mFormItem.cardDimension);
    }
  }

  public handleLongPressGestureActionEnd(): void {}

  public handleTouchEvent: Function = (event: TouchEvent, itemId: string, isInDrag: boolean) => {
    this.removeHoverEffect();
    this.onTouchEventHandler(event, itemId, isInDrag);
  };

  /**
   * 非pc卡片长按时进行截图
   * @param itemId 卡片id
   * @param isInDrag 是否拖拽中
   */
  public handleLongPressGestureEvent(itemId: string, isInDrag: boolean): void {
    if (!DeviceHelper.isPC()) {
      this.dragSnapshotHandler(itemId, itemId, isInDrag);
    }
  };

  public handleMenuDisappear(): void {}

  public handleLongPressVibrationCancel(): void {}

  public handleLongPressGestureActionCancel(): void {}

  public onMouseEvent(event: MouseEvent): void {}

  public getFormComponentModifier(): AttributeUpdater<StackAttribute> | undefined {
		return undefined;
	}

  public updateConnectionInfo(): void {}

  /**
   * 当语言发生改变是，是否需要刷新各Event在组件内定制逻辑
   */
  public async updateFormName(): Promise<string> {
    return '';
  }

  /**
   * 阻断刷新appName
   */
  public isBlockUpdateName(): boolean {
    return false;
  }

  public isNeedBuildAppName(isDragItem: boolean): boolean {
    // 原有平台业务逻辑,需要初始化AppName逻辑
    return !this.mFormItem.isTransparent && !isDragItem && !this.isOuterDesktop;
  }

  public setOuterDesktop(isOuterDesktop: boolean) {
    this.isOuterDesktop = isOuterDesktop;
  }

  public getOuterDesktop(): boolean {
    return this.isOuterDesktop;
  }

  public handleFormStatusChange(): void {}
}