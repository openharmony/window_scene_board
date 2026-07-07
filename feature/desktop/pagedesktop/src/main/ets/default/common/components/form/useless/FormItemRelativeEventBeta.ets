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
  StartType,
  TraceUtil,
  CommonUtils,
  RectInfo
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
  FormRelationManager,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
  RemoveCardEvent,
  StyleConstants,
  ThemeServiceManager,
  UninstallDialogStatus,
  vibratorMgr,
  EditModeConstants,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { AiSuggestionFormManager } from '@ohos/aisuggestion/src/main/ets/default/manager/AiSuggestionFormManager';
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
} from '../viewmodel/FormItemRelativeVm';
import { AttributeUpdater, ImageModifier } from '@ohos.arkui.modifier';
import { FormMenuEvent } from '../viewmodel/FormMenuEvent';
import lazy { outerAddAppIconManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAddAppIconManager';

const TAG = 'FormItemRelativeBetaEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DROP_ANIMATE_EXTRA_TRANSLATE_Y = 6;
const FOREGROUND_BLUR_RADIUS = 70;
const DRAG_SNAPSHOT_DELAY_MS = 30;
// 空函数
function noop(): void {};

export class FormItemRelativeEventBeta {
  protected mFormItemVm: FormItemRelativeVm;
  private mFormBackVm: FormBackboardVm;
  private mFormMaskVm: FormMaskVm;
  protected mFormItem: CardItemInfo = new CardItemInfo();
  private mFormItemHeight: number = 0;
  protected mFormItemWidth: number = 0;
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
  private eventhubItemDropEvent: Function = (): void => this.onEventhubItemDropEvent();
  private eventhubAppUninstallEvent: Function = (): void => this.onEventhubUninstallEventHandler();
  private isOuter?: boolean;
  private isAddedToStack: boolean = false; //是否形成了堆叠

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
    getFormOpacity?: () => number, setNameOpacity?: (opacity: number) => void,
    updateDragImage?: (formImage: image.PixelMap) => void,
    updateMenuShowState?: (state: boolean) => void,
    updateFormUninstallState?: (state: boolean) => void): void {
    this.mUpdateEditModeUninstallInfo = updateEditPara;
    this.getFormVisibility = getFormVisibility;
    this.setFormVisibility = setFormVisibility;
    this.getFormOpacity = getFormOpacity;
    this.setNameOpacity = setNameOpacity;
    this.updateDragImage = updateDragImage;
    this.updateMenuShowState = updateMenuShowState;
    this.updateFormUninstallState = updateFormUninstallState;
  }

  public initFormInfo(formItem: CardItemInfo, formHeight: number, formWidth: number): void {
    this.mFormItem = formItem;
    this.mFormItemHeight = formHeight;
    this.mFormItemWidth = formWidth;
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

  public handleLongPressVibration(formMenuEvent: FormMenuEvent): void {
    if (this.getFormOpacity?.() === 0) {
      // 卡片透明度还没恢复，不显示菜单，否则会显示透明
      return
    }
    // 编辑模式 能够卸载的app 通知显示删除按钮
    if (editModeManager.isInEditMode()) {
      let batchItem: GridLayoutItemInfo[] = [this.mFormItem as Object as GridLayoutItemInfo];
      batchUninstallChain.forward(ForwardType.LONG_PRESS, batchItem);
    }
    if (!editModeManager.isInEditMode() && this.mFormItemVm.mIsInFormHotArea &&
      !scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK)) {
      vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
        CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    }
    // 拖拽适配无障碍朗读普通卡片起拖播报
    DragAccessibilityUtils.textAnnouncedForDragStart();
    if (!editModeManager.isInEditMode() && !AppStorage.get<boolean>('isDrag') && !DeviceHelper.isPC()) {
      formMenuEvent.setMenuShowState(true);
    }
  }

  public handleLongPressVibrationEnd(): void {
    // 编辑模式 能够卸载的app 通知隐藏删除按钮
    if (editModeManager.isInEditMode()) {
      batchUninstallChain.forward(ForwardType.LONG_PRESS_END);
    }
  }

  public dealWithSceneBoardAppName(): string {
    let appName: string = '';
    if (FormRelationManager.getInstance().isSceneBoardCard(this.mFormItem.bundleName, this.mFormItem.cardName)) {
      log.showWarn(`dealWithSceneBoardAppName : ${this.mFormItem.bundleName} --- ${this.mFormItem.cardId}`);
      appName = FormRelationManager.getInstance().getAppNameByCardId(this.mFormItem.cardId);
    }
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
    this.playLongPressAnimation(false, this.mFormItem.cardDimension);
  }

  public playLongPressAnimation(isZoomOut: boolean, cardDimension: number, endScale?: number): void {
    if (isZoomOut) {
      log.showWarn(`formItemComponentLongPress zoom out`);
      let curve = this.getPressAnimParams(cardDimension).curve;
      let scale = this.getPressAnimParams(cardDimension).scale;
      animateTo({
        curve: curve,
        playMode: PlayMode.Normal,
      }, () => {
        this.mFormItemVm.mDropAnimateScale = scale;
      });
    } else {
      log.showWarn(`formItemComponentLongPress zoom in`);
      animateTo({
        duration: NumberConstants.CONSTANT_NUMBER_250,
        curve: Curve.Friction,
        playMode: PlayMode.Normal,
      }, () => {
        this.mFormItemVm.mDropAnimateScale = endScale ?? StyleConstants.DEFAULT_1;
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
    if (formAnimateData.cardId === this.mFormItem.cardId) {
      this.gravityAnimationHandler(indexInSwiper);

      TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_REMOVE_FORM_ANI);
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
    CloseAppManager.getInstance().setStartAppType(StartType.CARD, this.mFormItem.cardId, undefined, undefined,
      this.mFormItem.bundleName);
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
    if (gestureInfo.type === GestureControl.GestureType.DRAG) {
      if (editModeManager.isInEditMode() &&
        !editModeManager.isDraggable(this.mFormItem as Object as GridLayoutItemInfo)) {
        return GestureJudgeResult.REJECT;
      }
    }
    return GestureJudgeResult.CONTINUE;
  }

  protected snapshotForCloseApp(itemId: string): void {
    // 手机设备触摸截图不保留为拖拽落位预览图，只用于应用启动退出
    componentSnapshot.get(itemId).then((value: image.PixelMap) => {
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

  private onEventhubItemDropEvent(): void {
    log.showWarn(`onEventhubItemDropEvent start`);
    // 落位动效执行中，隐藏菜单，防止长按打断落位动效同时弹出菜单
    this.updateMenuShowState?.(false);
    this.isAddedToStack = true;
    // 动画执行完毕回调
    let execFunction: () => void = () => {
      this.mFormItemVm.mIsDragItem = false;
      this.mFormBackVm.mIsFormBackOpen = false;
      this.setNameOpacity?.(1);
      // 更新缓存
      GlobalContext.getContext()?.eventHub.emit(EventConstants.CREATE_FORM_STACK_NOTIFY_EVENT);
      // 刷新布局
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
      // 置空execFunction, 保证只执行一次
      execFunction = noop;
      // 清除监听动画打断事件
      dropAnimationObserver.unregisterDropAnimationListener(dropAniListener);
    }
    const finishCallBack = () => {
      execFunction();
    };
    // 动画打断回调
    const animationInterruptCallback = () => {
      finishCallBack();
    };
    const dropAniListener: DropAnimationListener = {
      onDropAnimationEnd(a: DropAnimationDestination, b: DropAnimationParam, c: boolean, isCancel: boolean) {
        if (isCancel) {
          animationInterruptCallback();
        }
      }
    }
    dropAnimationObserver.registerDropAnimationListener(dropAniListener);
    animateTo({
      curve: curves.springMotion(0.45, 1),
      onFinish: finishCallBack
    }, this.animationFunction)
  }

  private animationFunction = () => {
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
    AiSuggestionFormManager.getInstance().deleteCardInfo(cardId);
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
    FormModel.getInstance().deleteForm(this.mFormItem.cardId, false, this.isOuter);
    this.mPageDesktopViewModel.afterDeleteDesktopItem(this.isOuter);
    if (this.mFormItem.bundleName === CommonConstants.THEME_MANAGER_BUNDLE) {
      // 主题卡打点
      log.showInfo('themeCard delete, start checkScbOnlineTheme');
      const serviceManager: ThemeServiceManager = new ThemeServiceManager(getContext(this) as common.UIAbilityContext);
      serviceManager.checkScbOnlineTheme();
    }
    // 处理系统迁移场景SceneBoard卡片映射关系文件
    if (FormRelationManager.getInstance().isSceneBoardCard(this.mFormItem.bundleName, this.mFormItem.cardName)) {
      this.deleteSceneBoardFormRelation(this.mFormItem.cardId);
    }
  }

  private deleteSceneBoardFormRelation(cardId: string): void {
    log.showInfo(`deal with scene board relation : ${cardId}`);
    FormRelationManager.getInstance().deleteSceneBoardFormRelationMapByCardId(cardId);
  }

  public handleFormWrapperClickEvent(): void {}

  public handleLongPressGestureAction(): void {
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
}