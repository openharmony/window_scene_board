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

import type ctx from '@ohos.app.ability.common';
import curves from '@ohos.curves';
import display from '@ohos.display';
import {
  CardItemInfo,
  CloseAppManager,
  CommonConstants,
  ContextMenuListener,
  DeviceState,
  EditModeUtils,
  FormCommonUtil,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LauncherAnimUtil,
  MenuInfoManager,
  StyleConstants,
  FormHostService,
} from '@ohos/launchercommon';
import { CheckEmptyUtils, LogDomain, LogHelper, StartType } from '@ohos/basicutils';
import { dragSnapshotHelper, SCBVisualEffectMgr, SnapshotType } from '@ohos/componenthelper';
import { ResUtils, SCBTransitionController, SCBTransitionManager } from '@ohos/windowscene';
import { DeviceHelper, GlobalContext, ResourceManager, } from '@ohos/frameworkwrapper';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { EditModeState } from '@ohos/launchercommon/src/main/ets/editmode/data/EditModeState';
import { AgentChip } from '@ohos/launchercommon/src/main/ets/aisuggestion/AgentInfo';
import { FormViewModel } from '@ohos/form/src/main/ets/default/viewmodel/FormViewModel';
import { AiSuggestionConstants,
  LongPressType } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import { AiSuggestionFormManager } from '../manager/AiSuggestionFormManager';
import AiSuggestionActionManager from '../manager/AiSuggestionActionManager';
import { AbilityFormUtil } from '../utils/AbilityFormUtil';
import { PortfolioInfoDisplayMode } from '../constants/PortfolioInfoDisplayMode';
import { AiSuggestionEventReporter } from '../donate/AiSuggestionEventReporter';
import { AiSuggestionAnimHelper } from '../animation/AiSuggestionAnimHelper';
import { AiSuggestionDataHelper } from '../helper/AiSuggestionDataHelper';
import { AiSuggestionLayoutStyle, LayoutComponentId } from '../config/AiSuggestionLayoutStyle';
import { AiSuggestionLayoutStyleFactory } from '../config/AiSuggestionLayoutStyleFactory';
import { ChipItem } from './ChipItem';
import { AiSuggestionHeader } from './AiSuggestionHeader';
import { AiSuggestionAppIcon } from './AiSuggestionAppIcon';
import CardLockManager from '@ohos/launchercommon/src/main/ets/manager/CardLockManager';
import { image } from '@kit.ImageKit';
import componentUtils from '@ohos.arkui.componentUtils';
import {
  AiFormComponentBasicEvent,
  CardNodeControllerManager,
  CardNodeOption,
  FormOccupyParams
} from '@ohos/launchercommon/src/main/ets/manager/CardNodeControllerManager';
import { CardNodeController } from '@ohos/launchercommon/src/main/ets/buildernode/CardNodeController';
import { AiSuggestionAppGroup } from './AiSuggestionAppGroup';
import { AiSuggestionSubFormConfig } from '../config/AiSuggestionSubFormConfig';
import componentSnapshot from '@ohos.arkui.componentSnapshot';
import { AiSuggestionViewModel } from '../model/AiSuggestionViewModel';
import { AiSuggestionComponentData } from '../bean/AiSuggestionComponentData';
import { AiSuggestionViewModelBuilder } from '../model/AiSuggestionViewModelBuilder';
import { AiSuggestionRdbHelper } from '../helper/AiSuggestionRdbHelper';
import { AiSuggestionDataProcess } from '../helper/AiSuggestionDataProcess';
import { LocalEventHandler } from '../event/handler/LocalEventHandler';
import { LayoutChangeEventProcessor } from '../event/handler/LayoutChangeEventProcessor';
import { AiSuggestionMenuListener } from '../listener/AiSuggestionMenuListener';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { PortfolioInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/PortfolioInfo';

const TAG = 'AiSuggestionComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);
const DESKTOP_WALLPAPER_ID = 'DesktopWallpaper_Image_wallpaper';
const DESKTOP_WALLPAPER_ID_SUB = 'DesktopWallpaper_Image_wallpaper_sub';
function noop() {

}

/**
 * 语音助手建议卡片组件内容展示
 *
 * @since 2023-08-11
 */
@Component
export struct AiSuggestionComponent {
  @Prop @Watch('refreshIconStyle') formItemWidth: number = 0;
  @Prop @Watch('refreshIconStyle') formItemHeight: number = 0;
  @Prop @Watch('refreshIconStyle') formBorderRadius: number = 0;
  @Prop containerId: string = '';
  @Prop isCreateFormAnimation: boolean;
  private zIndexIllustration: number = -1;
  private zIndexDesc: number = 0;
  private zIndexGrid: number = 0;
  private zIndexChips: number = 1;
  @Prop formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  @Prop defaultCardId: string = ''; // 预置布局卡片ID为空，卡片框架返回真实ID后，要使用新ID去替换旧ID/非预置布局和form的ItemCardId一致
  private selectedItemIndex: number = 0;
  private desktopContext?: ctx.ServiceExtensionContext = GlobalContext.getContext();
  private otherIconLongPressEffectCancelFunc: () => void = (): void => this.cancelLongPressAnimation();
  private layoutStyle?: AiSuggestionLayoutStyle;
  // 手指触摸按压缩放动效
  @State private recItemCardsScale: ScaleOptions[] = [];
  @Prop @Watch('basicEventChanged') basicEvent: AiFormComponentBasicEvent = new AiFormComponentBasicEvent();
  deleteForm?: (playAnimation: boolean, formItem?: GridLayoutItemInfo, isOuter?: boolean) => void;
  updateFormId?: Function;
  updateAppName?: (name: string) => void;
  onItemHover?: (event: HoverEvent) => void;
  onItemSelected?: (index: number) => void;
  isUseEffect?: (useEffect: boolean) => void;
  isDuringAppExitAnim?: (isAppExiting: boolean) => void;
  private recCardTransitionControllerMap: Map<String, SCBTransitionController> = new Map();
  @State @Watch('editModeStateChange') editModeState: EditModeState = editModeManager.getEditModeState();
  private mRadialGradientRadius: number = 0;
  private mRadialGradientCenter: Array<number> = [];
  private mRadialGradientMid: number = 0;
  private illustrationHeight: string = '100%';
  private descWidth: string = '100%';
  @State backGroundAnimationImageOpacity: number = 0;
  @StorageLink('isDrag') @Watch('processDragEvent') isDrag: boolean = false;
  @StorageLink('desktopAppNameChange') @Watch('onLanguageChange') language: string = '';
  private clearForm: () => void = () => {
  };
  @Prop @Watch('isLongPressZoomInChange') isLongPressZoomIn: boolean = false;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @StorageProp('isClearInvalidCardsDone') @Watch('onClearInvalidStateChange') isClearInvalidCardsDone: boolean = false;
  @StorageLink('folderStatusMenu') @Watch('folderStatusChange') folderStatus: number = DeviceState.DEFAULT_STATE;
  @StorageLink('foldStatusForOuterScreen') @Watch('folderStatusChangeOuterScreen') foldStatusForOuterScreen: number =
    DeviceState.DEFAULT_STATE;
  @State private mPixMap?: image.PixelMap | undefined = undefined;
  @State itemOpacity: number = 1;
  @Prop @Watch('aboutToAppear') isFormStackChildItem: boolean = false;
  private isOuterDesktop: boolean = false; // 内外屏卡片无法互通、这里不需要状态变量
  private viewData: AiSuggestionComponentData = new AiSuggestionComponentData();
  private mViewModel?: AiSuggestionViewModel;
  private mContextMenuListener?: AiSuggestionMenuListener;

  private editModeStateChange(): void {
    if (this.editModeState.isInEditMode()) {
      this.getCropWallPaperPixelMap?.();
    }
  }

  private basicEventChanged(): void {
    // 隔离节点、basicEvent为空对象、此时调用事件会报错、需要置为noop
    this.deleteForm = this.basicEvent.deleteForm || noop;
    this.updateFormId = this.basicEvent.updateFormId || noop;
    this.updateAppName = this.basicEvent.updateAppName || noop;
    this.onItemHover = this.basicEvent.onItemHover || noop;
    this.onItemSelected = this.basicEvent.onItemSelected || noop;
    this.isUseEffect = this.basicEvent.isUseEffect || noop;
    this.isDuringAppExitAnim = this.basicEvent.isDuringAppExitAnim || noop;
    this.updateViewModel();
    this.isUseEffect?.(this.viewData.isUseEffectValue);
    this.updateAppName?.(this.viewData.updateAppNameValue);
  }

  isLongPressZoomInChange(): void {
    if (this.isLongPressZoomIn) {
      if (!this.viewData.isItemSelected) {
        return;
      }
      this.processDragEnd();
    }
  }

  folderStatusChangeOuterScreen(): void {
    log.showInfo(`folderStatusChangeOuterScreen ${this.formItem.cardId}, isOuterDesktop: ${this.isOuterDesktop}`);
    this.mViewModel?.updateSubFormSizeIfNeed();
  }

  folderStatusChange(): void {
    log.showInfo(`folderStatusChange ${this.formItem.cardId}, isOuterDesktop: ${this.isOuterDesktop}`);
    this.mViewModel?.updateSubFormSizeIfNeed();
  }

  private processDragEnd(): void {
    if (this.viewData.selectedItem?.itemType === CommonConstants.TYPE_CARD) {
      this.playCardLongPressAnimationZoomIn(this.selectedItemIndex, 0);
    }
  }

  cancelFormDialog(): void {
    log.showInfo('cancel dialog');
    this.clearForm();
  };

  private updateCardSuccess(): void {
    log.showInfo('updateCardSuccess')
    if (this.viewData.recItems.length > 0 &&
      (this.viewData.selectedItem === null || this.viewData.selectedItem === undefined)) {
      this.viewData.selectedItem = this.viewData.recItems[0];
    }
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear cardId=%{public}s, cardDimension=%{public}d', this.formItem.cardId,
      this.formItem.cardDimension);
    this.initParams();
    this.basicEventChanged();
    this.initLocalEvent();
    const dragCardId: string | undefined = AppStorage.get('dragCardId');
    let isCreatingCard: boolean = this.isCreateFormAnimation;
    if (dragCardId === this.formItem.cardId) {
      AppStorage.set('dragCardId', '');
      isCreatingCard = true;
    }
    this.mViewModel?.initCard(isCreatingCard);
  }

  private initParams(): void {
    this.layoutStyle = AiSuggestionLayoutStyleFactory.createLayoutStyle(this.formItem);
    if (!this.mViewModel) {
      this.mViewModel = this.initViewModel();
    } else {
      this.updateViewModel();
    }
    this.mViewModel.initEvent(this.formItem.cardId, this.formItem);
    this.viewData.formItemWidth = this.formItemWidth;
    this.viewData.formItemHeight = this.formItemHeight;
    if (CheckEmptyUtils.checkStrIsEmpty(this.containerId)) {
      this.containerId = FormCommonUtil.getFormComponentId(this.formItem as Object as CardItemInfo);
    }
    this.mRadialGradientRadius =
      Math.sqrt(this.formItemHeight * this.formItemHeight + this.formItemWidth * this.formItemWidth);
    this.mRadialGradientCenter = AbilityFormUtil.is2x4Form(this.formItem) ?
      [0, this.formItemHeight] : [this.formItemWidth, 0];
    this.mRadialGradientMid = AbilityFormUtil.is2x4Form(this.formItem) ? 0.18 : 0.38;
    this.illustrationHeight = AbilityFormUtil.is4x4Form(this.formItem) ? '50%' : '100%';
    this.descWidth = AbilityFormUtil.is2x4Form(this.formItem) ? '50%' : '100%';
  }

  private initViewModel(): AiSuggestionViewModel {
    return new AiSuggestionViewModelBuilder().setFormItem(this.formItem)
      .setCardId(this.formItem.cardId ?? '')
      .setViewData(this.viewData)
      .setLayoutStyle(this.layoutStyle)
      .isOuterDesktop(this.isOuterDesktop)
      .isFormStackChildItem(this.isFormStackChildItem)
      .isUseEffectFunction(this.isUseEffect)
      .isDuringAppExitAnim(this.isDuringAppExitAnim)
      .setDeleteFormFunction(this.deleteForm)
      .setUpdateAppNameFunction(this.updateAppName)
      .setUpdateCardSuccess(this.updateCardSuccess)
      .setGetCropWallPaperPixelMap(this.getCropWallPaperPixelMap)
      .build();
  }

  private updateViewModel(): void {
    new AiSuggestionViewModelBuilder(this.mViewModel).setFormItem(this.formItem)
      .setCardId(this.formItem.cardId ?? '')
      .setViewData(this.viewData)
      .setLayoutStyle(this.layoutStyle)
      .isOuterDesktop(this.isOuterDesktop)
      .isFormStackChildItem(this.isFormStackChildItem)
      .isUseEffectFunction(this.isUseEffect)
      .isDuringAppExitAnim(this.isDuringAppExitAnim)
      .setDeleteFormFunction(this.deleteForm)
      .setUpdateAppNameFunction(this.updateAppName)
      .setUpdateCardSuccess(this.updateCardSuccess)
      .setGetCropWallPaperPixelMap(this.getCropWallPaperPixelMap);
  }

  private initLocalEvent(): void {
    LocalEventHandler.getInstance();
    LayoutChangeEventProcessor.getInstance();
  }

  /**
   * 获取根据卡片坐标裁剪后的壁纸
   */
  private getCropWallPaperPixelMap = (): void => {
    if (!this.mViewModel?.isEmptyBgColor() || !this.isFormStackChildItem || SCBVisualEffectMgr.isFolderSolidColor()) {
      log.showInfo('getCropWallPaperPixelMap return');
      return;
    }

    let screenWidth: number = 0;
    let screenHeight: number = 0;
    try {
      const displayData: display.Display = display.getDefaultDisplaySync();
      screenWidth = displayData.width;
      screenHeight = displayData.height;
    } catch (err) {
      log.error('getCropWallPaperPixelMap getDefaultDisplaySync error');
    }

    const info: componentUtils.ComponentInfo = componentUtils.getRectangleById(this.containerId);
    const pixMap = componentSnapshot.getSync(this.isOuterDesktop ? DESKTOP_WALLPAPER_ID_SUB : DESKTOP_WALLPAPER_ID);
    if (!pixMap) {
      log.showWarn('getCropWallPaperPixelMap pixMap empty');
      return;
    }
    pixMap.cropSync({
      x: Math.abs(info.screenOffset.x) % screenWidth,
      y: Math.abs(info.screenOffset.y) % screenHeight,
      size: { height: info.size.height, width: info.size.width }
    });
    log.showInfo(`getCropWallPaperPixelMap x: ${info.screenOffset.x}, y: ${info.screenOffset.y}, screenWidth: ${screenWidth},
      screenHeight: ${screenHeight}`);
    this.mPixMap = pixMap;
  }

  private releaseSnapshot(): void {
    if (this.mPixMap) {
      this.mPixMap.release(() => {
        this.mPixMap = undefined;
        log.showInfo('release pixelMap');
      });
    }
  }

  aboutToDisappear() {
    log.showInfo('aiSuggestionComponent aboutToDisappear cardId:%{public}s', this.formItem.cardId);
    this.recCardTransitionControllerMap.forEach((controller) => {
      SCBTransitionManager.getInstance().unRegisterTransitionController(controller);
    });
    this.recCardTransitionControllerMap.clear();
    this.releaseSnapshot();
    this.mViewModel?.unRegisterEvent();
  }

  private refreshIconStyle(): void {
    log.showInfo(`refreshIconStyle width:${this.formItemWidth},height:${this.formItemHeight},formBorderRadius:${this.formBorderRadius}`);
    if (this.formItemWidth && this.formItemHeight) {
      this.viewData.formItemWidth = this.formItemWidth;
      this.viewData.formItemHeight = this.formItemHeight;
      this.mViewModel?.refreshIconStyle(this.viewData.launcherDisplayCardInfo, this.viewData.recItems);
    }
    if (!this.formBorderRadius || this.formBorderRadius <= 0) {
      this.formBorderRadius = ResUtils.getNumber($r('app.float.form_corner_radius'));
    }
  }

  private deleteFormIfNecessary(item: LauncherRecItem): void {
    if (AbilityFormUtil.isDefaultCard(item)) {
      // 默认卡加载失败时直接删除卡片
      this.deleteForm?.(false, this.formItem, this.isOuterDesktop);
    }
  }

  private onFormIdAcquired(recItem: LauncherRecItem, newCardId: string): void {
    log.showWarn('onFormIdAcquired voice:%{public}s, recItem:%{public}s, new id:%{public}s, old id:%{public}s',
      this.formItem.cardId, recItem.bundleName, newCardId, recItem.cardId);
    if (recItem.cardId === newCardId) {
      return;
    }
    recItem.cardId = newCardId;
    AiSuggestionFormManager.getInstance().updateSubCardId(this.formItem.cardId, recItem, newCardId);
    AbilityFormUtil.formHostNotifyVisibleChange(this.formItem.cardId, true, [String(newCardId)]);
    AiSuggestionFormManager.getInstance().cacheCardId(newCardId);
    AiSuggestionRdbHelper.updateAiSuggestionCardRdbInfo(this.formItem.cardId);
    if (!AbilityFormUtil.isDefaultCard(recItem)) {
      if (this.viewData.recItemCompId) {
        // 获取OOBE退出动效落点ID
        this.viewData.recItemCompId = AiSuggestionDataHelper.getFormId(recItem);
      }
      return;
    }
    if (AbilityFormUtil.isUpdateFormId(this.formItem)) {
      this.mViewModel?.setCardId(newCardId);
      this.mViewModel?.initEvent(newCardId, this.formItem);
      AiSuggestionFormManager.getInstance().updateVoiceCardId(this.formItem.cardId, newCardId);
      // 默认卡ID刷新后反向同步到父组件
      this.updateFormId?.(newCardId);
      // 更新节点缓存
      CardNodeControllerManager.updateAiCardNode(this.defaultCardId, newCardId);
      CardNodeControllerManager.updateAiCardController(this.defaultCardId, newCardId);
      return;
    }
    if (this.viewData.recItemCompId) {
      this.viewData.recItemCompId = AiSuggestionDataHelper.getFormId(recItem);
    }
  }

  private setSelectItemOnTouch(recItem: LauncherRecItem, event: TouchEvent, index: number): void {
    if (event.type === TouchType.Down) {
      this.onItemSelected?.(index);
      this.viewData.isItemSelected = true;
      this.viewData.selectedItem = AiSuggestionDataHelper.getRealRecItem(recItem, this.viewData.recItems);
      this.selectedItemIndex = index;
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      this.viewData.isItemSelected = false;
      this.onItemSelected?.(-1);
      this.viewData.selectedItem = undefined;
    }
  }

  private setSelectItemOnHover(recItem: LauncherRecItem, isHover: boolean, event: HoverEvent, index: number): void {
    this.viewData.isItemSelected = isHover;
    log.showInfo(`setSelectItemOnHover cardId=${recItem.cardId}, appIconId=${recItem.appIconId}, hover=${isHover}`);
    if (isHover) {
      MenuInfoManager.getInstance()
        .registerContextMenuListener(this.formItem.cardId, this.mContextMenuListener =
          new AiSuggestionMenuListener(this.formItem, this.viewData, this.isOuterDesktop, this.isFormStackChildItem));
      this.onItemSelected?.(index);
      this.viewData.selectedItem = AiSuggestionDataHelper.getRealRecItem(recItem, this.viewData.recItems);
      this.onItemHover?.(event);
    } else {
      this.onItemSelected?.(-1);
    }
  }

  private processDragEvent(): void {
    log.showInfo(`processDragEvent isDrag=${this.isDrag} formBorderRadius=${this.formBorderRadius}`);
    if (!this.isDrag) {
      this.processDragEnd();
      this.releaseSnapshot();
    }
  }

  private playCardLongPressAnimationZoomOut(recItem: LauncherRecItem, index: number): void {
    if (this.isFormStackChildItem) {
      log.showInfo('formstack child item, aiSuggestion component do not response touch animate.');
      return;
    }

    log.showInfo('voiceInnerCardItem zoom out');
    let curve: curves.ICurve = AiSuggestionAnimHelper.getCurveByDimension(recItem.dimension);
    let scale: number = AiSuggestionAnimHelper.getScaleByDimension(recItem.dimension, this.isOuterDesktop);

    animateTo({
      delay: 100,
      curve: curve,
      playMode: PlayMode.Normal,
    }, () => {
      this.recItemCardsScale[index] = { x: scale, y: scale };
    });
  }

  private playCardLongPressAnimationZoomIn(index: number, delayTime: number): void {
    log.showInfo('voiceInnerCardItem zoom in');
    animateTo({
      delay: delayTime,
      duration: 250,
      curve: Curve.Friction,
      playMode: PlayMode.Normal,
    }, () => {
      this.recItemCardsScale[index] = { x: StyleConstants.DEFAULT_1, y: StyleConstants.DEFAULT_1 };
    });
  }

  private cancelLongPressAnimation(): void {
    log.showInfo('cancelLongPressAnimation animation cancel');
    animateTo({
      duration: 0,
      curve: Curve.Friction,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.desktopContext?.eventHub.off(`otherIconLongPressEffectCancel`, this.otherIconLongPressEffectCancelFunc);
      }
    }, () => {
      this.recItemCardsScale[this.selectedItemIndex] = { x: StyleConstants.DEFAULT_1, y: StyleConstants.DEFAULT_1 };
    })
  }

  private processCardTouchEvent(recItem: LauncherRecItem, index: number, event: TouchEvent,
    isVisible: () => boolean): void {
    this.setSelectItemOnTouch(recItem, event, index);
    AiSuggestionFormManager.getInstance()
      .cacheSnapshotImage(recItem, index, event.type, this.formItem.cardId, isVisible);
    if (event.type === TouchType.Down) {
      this.desktopContext?.eventHub.off(`otherIconLongPressEffectCancel`, this.otherIconLongPressEffectCancelFunc);
      this.desktopContext?.eventHub.on(`otherIconLongPressEffectCancel`, this.otherIconLongPressEffectCancelFunc);
      this.playCardLongPressAnimationZoomOut(recItem, index);
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      this.desktopContext?.eventHub.off(`otherIconLongPressEffectCancel`, this.otherIconLongPressEffectCancelFunc);
      this.playCardLongPressAnimationZoomIn(index, 100);
    }
  }

  private setTransEffectForNewCard(): TransitionEffect {
    if (AiSuggestionDataHelper.isNeedShowPortfolioInfo(this.viewData.portfolioInfo, this.viewData.isArrivedTime) ||
      !this.mViewModel?.isNewAddComponent()) {
      return TransitionEffect.IDENTITY;
    } else {
      return TransitionEffect.OPACITY
        .animation({
          delay: this.viewData.portfolioInfo?.delaySeconds ?? 0,
          duration: AiSuggestionConstants.ITEM_TRANSITION_TIME,
          curve: Curve.FastOutLinearIn
        });
    }
  }

  @Builder
  agentChipsBuilder() {
    if (this.viewData.portfolioInfo?.agentInfo?.chips?.length === 2 && this.viewData.portfolioInfo.desc1 &&
    this.viewData.portfolioInfo.desc2) {
      ForEach(this.viewData.portfolioInfo.agentInfo.chips, (agentChip: AgentChip, index: number) => {
        ChipItem({
          cardResourceInfo: this.viewData.cardResourceInfo,
          title: agentChip.chipText,
          isOuterDesktop: this.isOuterDesktop,
          chipsClick: (): void => this.onChipsClick(agentChip.chipId),
        })
          .margin(this.viewData.chipItemMargin)
          .alignRules(index === 0 ? this.layoutStyle?.chip1AlignRules() : this.layoutStyle?.chip2AlignRules())
          .id(index === 0 ? LayoutComponentId.AGENT_CHIP1 : LayoutComponentId.AGENT_CHIP2)
          .zIndex(this.zIndexChips)
          .opacity(this.itemOpacity)
      });
    }
  }

  private onChipsClick(chipId: string): void {
    if (editModeManager.isInEditMode()) {
      log.showInfo('onChipsClick isInEditMode');
      return;
    }
    if (this.viewData.portfolioInfo?.agentInfo) {
      log.showInfo(`onChipsClick chipId = ${chipId}`);
      CloseAppManager.getInstance().setStartAppType(StartType.CARD, this.formItem.cardId);
      AiSuggestionActionManager.getInstance()
        .clickAgentChip(this.formItem, this.viewData.portfolioInfo.agentInfo.agentId,
          chipId, this.viewData.portfolioInfo.agentInfo.intentId, this.viewData.portfolioInfo.agentInfo.intentUuId);
    }
  }

  private onGuideClick(): void {
    if (editModeManager.isInEditMode()) {
      log.showInfo('onGuideClick isInEditMode');
      return;
    }
    if (this.viewData.portfolioInfo?.agentInfo) {
      log.showInfo(`onGuideClick guideId = ${this.viewData.portfolioInfo.agentInfo.guideId}`);
      CloseAppManager.getInstance().setStartAppType(StartType.CARD, this.formItem.cardId);
      AiSuggestionActionManager.getInstance()
        .clickAgentGuide(this.formItem, this.viewData.portfolioInfo.agentInfo.agentId,
          this.viewData.portfolioInfo.agentInfo.guideId, this.viewData.portfolioInfo.agentInfo.intentId,
          this.viewData.portfolioInfo.agentInfo.intentUuId);
    }
  }

  private buildCardLog(recItem: LauncherRecItem, index: number): boolean {
    log.showWarn(`build card voice: ${this.formItem.cardId} item: ${recItem.bundleName}, ${recItem.cardId}, ` +
      `isOuterDesktop = ${this.isOuterDesktop}`);
    return true;
  }

  @Builder
  illustrationBuilder() {
    // 场景卡picResId不为空, 常规卡pic1ResId不为空
    if ((this.viewData.cardResourceInfo?.picResId && this.viewData.portfolioInfo?.displayMode !==
    PortfolioInfoDisplayMode.DISPLAY_MODE_NOT_EXIST) || this.viewData.cardResourceInfo?.pic1ResId) {
      Image(this.viewData.portfolioPicUrl)
        .height(this.illustrationHeight)
        .width(StyleConstants.PERCENTAGE_100)
        .imageStyle(this.setTransEffectForNewCard(), ImageFit.Cover)
        .alignRules(this.layoutStyle?.illustrationAlignRules())
        .id(LayoutComponentId.ILLUSTRATION)
        .zIndex(this.zIndexIllustration)
        .matchTextDirection(true)
        .opacity(this.itemOpacity)
    }
  }

  @Builder
  descBuilder() {
    if (this.viewData.portfolioInfo &&
      this.viewData.portfolioInfo.displayMode !== PortfolioInfoDisplayMode.DISPLAY_MODE_NOT_EXIST) {
      if (this.viewData.portfolioInfo?.desc1) {
        Text(this.viewData.portfolioInfo?.desc1)
          .descTextStyle(this.viewData.cardResourceInfo.desc1Clr,
            this.layoutStyle?.getDescFontSize(this.isOuterDesktop),
            this.layoutStyle?.getDescLineHeight(this.isOuterDesktop))
          .transition(this.setTransEffectForNewCard())
          .padding(this.viewData.descPadding)
          .alignRules(this.layoutStyle?.desc1AlignRules())
          .width(this.descWidth)
          .id(LayoutComponentId.PORTFOLIO_DESC1)
          .zIndex(this.zIndexDesc)
          .onClick(this.viewData.portfolioInfo?.agentInfo ? () => this.onGuideClick() : undefined)
          .maxFontScale(StyleConstants.FONT_MAX_SCALE_FORM_TEXT)
          .accessibilityLevel('yes')
          .opacity(this.itemOpacity)
      }
      if (this.viewData.portfolioInfo?.desc2) {
        Text(this.viewData.portfolioInfo?.desc2)
          .descTextStyle(this.viewData.cardResourceInfo.desc2Clr,
            this.layoutStyle?.getDescFontSize(this.isOuterDesktop),
            this.layoutStyle?.getDescLineHeight(this.isOuterDesktop))
          .transition(this.setTransEffectForNewCard())
          .padding({ left: 12, right: 12 })
          .alignRules(this.layoutStyle?.desc2AlignRules())
          .width(this.descWidth)
          .id(LayoutComponentId.PORTFOLIO_DESC2)
          .zIndex(this.zIndexDesc)
          .onClick(this.viewData.portfolioInfo?.agentInfo ? () => this.onGuideClick() : undefined)
          .maxFontScale(StyleConstants.FONT_MAX_SCALE_FORM_TEXT)
          .accessibilityLevel('yes')
          .opacity(this.itemOpacity)
          .margin({ top: this.viewData.desc2TopMargin })
      }
      if (this.viewData.portfolioInfo?.desc) {
        Text(this.viewData.portfolioInfo?.desc)
          .subTitleStyle(this.viewData.cardResourceInfo.descClr)
          .transition(this.setTransEffectForNewCard())
          .padding({ left: 12, right: 12 })
          .margin({ top: 6 })
          .width(this.descWidth)
          .alignRules(this.layoutStyle?.descAlignRules())
          .id(LayoutComponentId.PORTFOLIO_DESC)
          .zIndex(this.zIndexDesc)
          .maxFontScale(StyleConstants.FONT_MAX_SCALE_FORM_TEXT)
          .accessibilityLevel('yes')
          .opacity(this.itemOpacity)
      }
      if (this.viewData.portfolioInfo?.desc1) {
        Blank()
          .height(this.layoutStyle?.getHeaderHeight(this.viewData.launcherDisplayCardInfo, this.isOuterDesktop,
            this.formItemHeight))
          .width(StyleConstants.PERCENTAGE_100)
          .alignRules(this.layoutStyle?.blankAlignRules())
          .id(LayoutComponentId.BLANK)
          .zIndex(this.zIndexGrid)
      }
    }
  }

  private isItemEnable(index: number): boolean {
    if (this.viewData.formPressType !== LongPressType.SELECTED_ITEM || !this.viewData.isItemSelected) {
      this.itemOpacity = AiSuggestionConstants.ITEM_SELECTED_OPACITY;
      return true;
    }

    this.itemOpacity = AiSuggestionConstants.ITEM_NORMAL_OPACITY;
    return this.selectedItemIndex === index;
  }

  @Builder
  gridBuilder() {
    Grid() {
      ForEach(this.viewData.recItems, (recItem: LauncherRecItem, index) => {
        GridItem() {
          if (!AiSuggestionDataHelper.checkDisplay(recItem, this.viewData.portfolioInfo, this.viewData.isArrivedTime,
            [this.viewData.launcherDisplayCardInfo.sceneSpanX, this.viewData.launcherDisplayCardInfo.sceneSpanY])) {
          } else if (recItem.itemType === AiSuggestionConstants.TYPE_APP) {
            this.appItemBuilder(recItem, index, false)
          } else if (recItem.itemType === AiSuggestionConstants.TYPE_CARD) {
            this.cardBuilder(recItem, index)
          } else if (recItem.itemType === AiSuggestionConstants.TYPE_APP_GROUP) {
            this.appGroupBuilder(recItem, index)
          } else {
          }
        }
        .rowStart(recItem.rowStart)
        .columnStart(recItem.columnStart)
        .rowEnd(recItem.rowStart + recItem.rowSpan - 1)
        .columnEnd(recItem.columnStart + recItem.columnSpan - 1)
        .align(this.layoutStyle?.gridItemAlignment(recItem, this.mViewModel?.isEmptyBgColor() ?? false))
        .transition(AiSuggestionAnimHelper.getTransition(recItem, index,
          this.mViewModel?.getChangeItemIds() ?? new Set<string>(),
          this.mViewModel?.getDisappearLastIndex() ?? 0))
        .onDisAppear(() => {
          AiSuggestionDataProcess.releaseCardItemIfNeed(recItem, this.viewData.recItems, this.formItem.cardId,
            this.recCardTransitionControllerMap);
        })
        .enabled(this.isItemEnable(index))
        .accessibilityText(recItem.itemType === AiSuggestionConstants.TYPE_CARD ?
          ResourceManager.getInstance().getBundleAppName(recItem.bundleName) : '');
      }, (recItem: LauncherRecItem) => LauncherRecItem.getItemUniqueKey(this.formItem, recItem));
    }
    .width(this.formItemWidth)
    .columnsGap(this.viewData.launcherDisplayCardInfo.columnGap)
    .rowsGap(this.viewData.launcherDisplayCardInfo.rowGap)
    .columnsTemplate(this.viewData.launcherDisplayCardInfo.columnsTemplate)
    .rowsTemplate(this.viewData.launcherDisplayCardInfo.rowsTemplate)
    .padding(this.viewData.gridPadding)
    .hitTestBehavior(HitTestMode.Transparent)
    .alignRules(this.layoutStyle?.gridAlignRules())
    .id(`${TAG}_grid_${this.formItem.cardId}`)
    .zIndex(this.zIndexGrid)
  }

  @Builder
  appGroupBuilder(recItem: LauncherRecItem, index: number) {
    AiSuggestionAppGroup({
      formItem: this.formItem,
      recItem: recItem,
      recItemIndex: index,
      iconSize: this.viewData.iconSize,
      iconRadius: this.viewData.iconRadius,
      formBorderRadius: this.formBorderRadius,
      disappearLastIndex: this.mViewModel?.getDisappearLastIndex(),
      setSelectItemOnTouch: (recItem: LauncherRecItem, event: TouchEvent,
        index: number) => this.setSelectItemOnTouch(recItem, event, index),
      setSelectItemOnHover: (recItem: LauncherRecItem, isHover: boolean, event: HoverEvent, index: number): void => {
        this.setSelectItemOnHover(recItem, isHover, event, index);
      },
      gridPadding: this.viewData.gridPadding,
      changedItemIdsSet: this.mViewModel?.getChangeItemIds(),
      appGroupBgColor: this.viewData.appGroupBgColor,
      mFormPressType: this.viewData.formPressType,
    })
  }

  @Builder
  appItemBuilder(recItem: LauncherRecItem, index: number, needTransition: boolean) {
    AiSuggestionAppIcon({
      iconSize: this.viewData.iconSize,
      iconRadius: this.viewData.iconRadius,
      isAccessibilityMode: this.isAccessibilityMode,
      recItem: recItem,
      recItemIndex: index,
      needTransition: needTransition,
      formItem: this.formItem,
      recItems: this.viewData.recItems,
      disappearLastIndex: this.mViewModel?.getDisappearLastIndex(),
      isEmptyBgColor: this.mViewModel?.isEmptyBgColor(),
      iconSelectItemOnTouch: (event: TouchEvent): void => {
        this.setSelectItemOnTouch(recItem, event, index);
        if (event?.type === TouchType.Down) {
          CloseAppManager.getInstance().setAdaptiveIcon(recItem.bundleName,
            recItem.moduleName, recItem.abilityName, recItem.appIconId);
        }
      },
      iconSelectItemOnHover: (isHover: boolean, event: HoverEvent): void => {
        this.setSelectItemOnHover(recItem, isHover, event, index);
      }
    })
  }

  private updateSubFormSize(change: boolean, recItem: LauncherRecItem): Size {
    return this.buildSubFormConfig(recItem).getSubFormLayoutSize();
  }

  private updateSubFormScale(change: boolean, recItem: LauncherRecItem): ScaleOptions {
    return this.buildSubFormConfig(recItem).getSubFormLayoutScale();
  }

  private buildSubFormConfig(recItem: LauncherRecItem): AiSuggestionSubFormConfig {
    return new AiSuggestionSubFormConfig({
      dimension: this.formItem.cardDimension as number,
      width: this.formItemWidth,
      height: this.formItemHeight,
      gridPadding: this.viewData.gridPadding,
      columnsGap: this.viewData.launcherDisplayCardInfo.columnGap,
      rowsGap: this.viewData.launcherDisplayCardInfo.rowGap,
      titleHeight: this.layoutStyle?.getHeaderHeight(this.viewData.launcherDisplayCardInfo, this.isOuterDesktop,
        this.formItemHeight) ?? 0,
      rows: this.viewData.launcherDisplayCardInfo.rowsTemplate.split(' ')
        .length,
      columns: this.viewData.launcherDisplayCardInfo.columnsTemplate.split(' ')
        .length,
      isOuterDesktop: this.isOuterDesktop,
    }, {
      dimension: recItem.dimension
    });
  }

  @Builder
  formComponentBuilder(recItem: LauncherRecItem, index: number) {
    if (this.buildCardLog(recItem, index)) {
    }
    // 语音助手建议卡片推荐内容卡片，内容需要进行缩放显示，否则可能存在截断
    Stack() {
      FormComponent({
        id: FormCommonUtil.transformCardId(recItem.cardId),
        name: recItem.formName,
        bundle: recItem.bundleName,
        ability: recItem.abilityName,
        module: recItem.moduleName,
        dimension: recItem.dimension,
        want: AiSuggestionDataHelper.getWant(recItem, this.formItem, this.isFormStackChildItem),
      })
        .size(this.updateSubFormSize(this.viewData.isFormSizeChange, recItem))
        .scale(this.updateSubFormScale(this.viewData.isFormSizeChange, recItem))
        .allowUpdate(true)
        .onAcquired((info: FormCallbackInfo) => {
          if (CheckEmptyUtils.isEmpty(info)) {
            log.showError('aiSuggestion form item onAcquired formCallbackInfo invalid!');
            return;
          }

          // 这个info.id实际是string类型
          log.showWarn(`FormComponent card id is: ${info.idString}, ${typeof info.id}, ${recItem.bundleName}`);
          if (!info['isLocked']) { //sdk未更新、绕过TS校验
            CardLockManager.getInstance().addReleasedForm(recItem.bundleName, info.idString);
          }
          this.onFormIdAcquired(recItem, info.idString);
        })
        .onUninstall((form: FormCallbackInfo) => {
          log.showWarn(`aiSuggestionComponent onUninstall formId: ${form?.idString}, cardId: ${recItem.cardId}`);
          AiSuggestionActionManager.getInstance().requestData(this.formItem);
        })
        .onLoad(() => {
          const controller = AiSuggestionDataHelper.regTransController(
            this.formItem,
            this.formBorderRadius - this.viewData.gridPadding,
            () => {
              log.showInfo(`on active, visible=false bundle=${recItem.bundleName}`);
              this.viewData.recItemCardsVisibility.set(index, false);
            },
            () => {
              log.showInfo(`on inactive, visible=true bundle=${recItem.bundleName}`);
              this.viewData.recItemCardsVisibility.clear();
            },
            recItem
          );
          const formItemId = AiSuggestionDataHelper.getFormId(recItem);
          if (controller) {
            this.recCardTransitionControllerMap.set(formItemId, controller);
          }
        })
        .onError((error) => {
          log.showError(`FormComponent error msg: ${error.errcode} - ${error.msg}`);
          this.deleteFormIfNecessary(recItem);
        })
        .onRouter(() => {
          log.showWarn(`AiSuggestion FormComponent onRouter, cardId: ${recItem.cardId}.`);
          CloseAppManager.getInstance().setStartAppType(StartType.CARD, recItem.cardId, undefined, undefined,
            recItem.bundleName);
          AiSuggestionActionManager.getInstance()
            .clickRecItem(AiSuggestionDataHelper.getRealRecItem(recItem, this.viewData.recItems), this.formItem);
          AiSuggestionEventReporter.getInstance().reportSuggestionFormClick(this.formItem, recItem);
        })
        .onTouch((event) => {
          if (!event) {
            log.showWarn('onTouch event is undefined');
            return;
          }
          this.processCardTouchEvent(recItem, index, event,
            () => CheckEmptyUtils.isEmpty(this.viewData.recItemCardsVisibility.get(index)));
        })
        .onAppear(() => {
          log.showInfo(`Form is on appear, ${recItem.bundleName} ${recItem.cardId}`);
        })
        .onDisAppear(() => {
          log.showInfo(`Form is on disappear, ${recItem.bundleName} ${recItem.cardId}`);
        })
        .enabled(!this.editModeState.isInEditMode())
    }
    .id(this.viewData.recItemCompId ?? AiSuggestionDataHelper.getFormId(recItem))
    .scale(this.recItemCardsScale[index])
    .width(StyleConstants.PERCENTAGE_100)
    .height(StyleConstants.PERCENTAGE_100)
    .opacity((CheckEmptyUtils.isEmpty(this.viewData.recItemCardsVisibility.get(index)) ||
      (this.mViewModel?.isDuringAppExitAnim() && this.viewData.selectedItem)) ? 1 : 0)
    .transition(TransitionEffect.IDENTITY)
    .hoverEffect(HoverEffect.None)
    .borderRadius(this.mViewModel?.isEmptyBgColor() ? this.viewData.iconRadius :
      (this.formBorderRadius - this.viewData.gridPadding))
    .clip(true)
    .hitTestBehavior(this.editModeState.isInEditMode() || (DeviceHelper.isPhone() && this.isDrag) ?
    HitTestMode.None : HitTestMode.Default)
    .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
  }

  @Builder
  cardBuilder(recItem: LauncherRecItem, index: number) {
    // 语音助手建卡时、如果存在节点缓存，走复用逻辑，避免闪烁；缓存中没有走原有建卡逻辑
    if (recItem.isCreating && CardNodeControllerManager.getCardNode(recItem.cardId)) {
      NodeContainer(new CardNodeController(new FormOccupyParams(recItem.cardId), TAG, new CardNodeOption(false, true)))
        .width('100%')
        .height('100%')
    } else if (DeviceHelper.isPhone()) {
      this.formComponentBuilder(recItem, index)
    } else {
      // FormComponent组件不响应hover事件
      Column() {
        this.formComponentBuilder(recItem, index)
      }
      .onHover((isHover, event) => {
        this.setSelectItemOnHover(recItem, isHover, event, index);
      })
    }
  }

  private processContainerTouchEvent(event: TouchEvent): void {
    if (event.type === TouchType.Down) {
      LauncherAnimUtil.setIsUIBusy(TAG, true);
      log.showInfo('onTouch down start');
      MenuInfoManager.getInstance()
        .registerContextMenuListener(this.formItem.cardId, this.mContextMenuListener =
          new AiSuggestionMenuListener(this.formItem, this.viewData, this.isOuterDesktop, this.isFormStackChildItem));
      if (this.isFormStackChildItem || this.mViewModel?.isDuringAppExitAnim() ||
        this.viewData.recItemCardsVisibility.size > 0) {
        log.showWarn('isFormStackChildItem or isDuringAppExitAnim');
        return;
      }
      if (this.mViewModel?.isEmptyBgColor() && !SCBVisualEffectMgr.isFolderSolidColor()) {
        dragSnapshotHelper.snapshotFromId(`${TAG}_grid_${this.formItem.cardId}`, SnapshotType.DROP,
          GridLayoutUtil.generateUniqueKey(this.formItem));

        dragSnapshotHelper.snapshotFromId(this.containerId, SnapshotType.DRAG,
          GridLayoutUtil.generateUniqueKey(this.formItem), (value) => {
            ResourceManager.getInstance().setAppResourceCache(this.containerId, 'cardSnapshot', value);
          }, EditModeUtils.getDesktopScale(), EditModeUtils.getDesktopScale(), 'AiSuggestComponent_processTouch');
      } else {
        dragSnapshotHelper.snapshotFromId(this.containerId, SnapshotType.BOTH,
          GridLayoutUtil.generateUniqueKey(this.formItem), (value) => {
            ResourceManager.getInstance().setAppResourceCache(this.containerId, 'cardSnapshot', value);
          }, EditModeUtils.getDesktopScale(), EditModeUtils.getDesktopScale(), 'AiSuggestComponent_processTouch');
      }
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      LauncherAnimUtil.setIsUIBusy(TAG, false, true);
      this.viewData.formPressType = LongPressType.DEFAULT;
    }
  }

  @Builder
  headerBuilder() {
    if (this.viewData.portfolioInfo?.title &&
      this.viewData.portfolioInfo.displayMode !== PortfolioInfoDisplayMode.DISPLAY_MODE_DISAPPEAR) {
      AiSuggestionHeader({
        title: this.viewData.portfolioInfo.title,
        layoutStyle: this.layoutStyle,
        titleClr: this.viewData.cardResourceInfo.titleClr,
        lineHeight: this.layoutStyle?.getHeaderHeight(this.viewData.launcherDisplayCardInfo, this.isOuterDesktop,
          this.formItemHeight),
        zIndexGrid: this.zIndexGrid,
        gridPadding: this.viewData.gridPadding,
        formItem: this.formItem,
        supportChange: AbilityFormUtil.is2x2Form(this.formItem) &&
          AiSuggestionFormManager.getInstance().getFeatureVersion() >= 1,
        isPortfolioCard: PortfolioInfo.isPortfolioCard(this.viewData.portfolioInfo.portfolioId),
        onItemSelected: this.onItemSelected,
        isOuterDesktop: this.isOuterDesktop,
        itemOpacity: this.itemOpacity,
      })
    }
  }

  private onLanguageChange(): void {
    log.showInfo('onLanguageChange');
    this.mViewModel?.updateLanguage(this.viewData.portfolioInfo);
    this.updateAppName?.(this.mViewModel?.getAppName() ??
    ResUtils.getInnerString($r('app.string.aisuggestion_app_name')));
  }

  private onClearInvalidStateChange(): void {
    log.showInfo(`onClearInvalidCardsStateChange: ${this.isClearInvalidCardsDone}`);
    if (this.isClearInvalidCardsDone) {
      this.mViewModel?.initCard();
    }
  }

  @Builder
  wallpaperSnapShotBuilder() {
    if ((this.viewData.formPressType === LongPressType.SHOW_WALLPAPER || this.viewData.formPressType ===
    LongPressType.SELECTED_ITEM || this.editModeState.isInEditMode()) && this.mViewModel?.isEmptyBgColor() &&
    this.isFormStackChildItem && !SCBVisualEffectMgr.isFolderSolidColor()) {
      Image(this.mPixMap)
        .draggable(false)
        .width(this.formItemWidth)
        .height(this.formItemHeight)
        .borderRadius(this.formBorderRadius)
        .syncLoad(true)
        .interpolation(ImageInterpolation.Medium)
        .autoResize(false)
        .foregroundBlurStyle(BlurStyle.Thin, undefined, { disableSystemAdaptation: true })
   }
  }

  build() {
    RelativeContainer() {
      // 卡片头部组件
      this.headerBuilder()
      // 插画
      this.illustrationBuilder()
      // 描述
      this.descBuilder()
      // 堆叠中的模糊壁纸截图
      this.wallpaperSnapShotBuilder()
      // 推荐服务网格
      this.gridBuilder()
      // 分身chips信息
      this.agentChipsBuilder();
    }
    .id(this.containerId)
    .focusable(false)
    .radialGradient({
      center: this.mRadialGradientCenter,
      radius: this.mRadialGradientRadius,
      colors: [[this.mViewModel?.isHideRadialGradient() ? '' : this.viewData.cardResourceInfo?.bgStartClr, 0],
        [this.mViewModel?.isHideRadialGradient() ? '' : this.viewData.cardResourceInfo?.bgMidClr,
          this.mRadialGradientMid],
        [this.mViewModel?.isHideRadialGradient() ? '' : this.viewData.cardResourceInfo?.bgEndClr, 1]],
    })
    .backgroundColor(this.viewData.backgroundColor ?? (this.viewData.cardResourceInfo?.fgStartClr ?? Color.Transparent))
    .useEffect(this.viewData.mUseEffect)
    .width(this.formItemWidth)
    .height(this.formItemHeight)
    .borderRadius(this.formBorderRadius)
    .clip(true)
    .onTouch((event) => this.processContainerTouchEvent(event))
    .onClick(() => {
      //消费onClick事件，避免编辑模式下，onClick事件透传到PageDesktopLayout中导致退出编辑模式
      if (editModeManager.isInEditMode()) {
        return;
      }
      AiSuggestionEventReporter.getInstance().reportSuggestionFormClick(this.formItem);
    })
    .onHover((isHover) => {
      if (isHover) {
        MenuInfoManager.getInstance()
          .registerContextMenuListener(this.formItem.cardId, this.mContextMenuListener =
            new AiSuggestionMenuListener(this.formItem, this.viewData, this.isOuterDesktop, this.isFormStackChildItem));
      }
    })
    .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
  }
}

@Extend(Image)
function imageStyle(value: TransitionEffect, imageFit: ImageFit = ImageFit.Auto) {
  .draggable(false)
  .objectFit(imageFit)
  .interpolation(ImageInterpolation.Medium)
  .autoResize(false)
  .transition(value)
}

@Extend(Text)
function descTextStyle(fontColor: string, fontSize: string = '19vp', lineHeight: string = '26vp') {
  .fontSize(fontSize)
  .lineHeight(lineHeight)
  .fontFamily('HarmonyOS_Serif')
  .fontColor(fontColor)
  .maxLines(1)
  .textOverflow({ overflow: TextOverflow.Ellipsis })
  .draggable(false)
}

@Extend(Text)
function subTitleStyle(fontColor: string) {
  .fontFamily('HarmonyHeiTi')
  .draggable(false)
  .fontSize('10vp')
  .opacity($r('sys.float.ohos_id_alpha_content_secondary'))
  .fontWeight(FontWeight.Regular)
  .fontColor(fontColor)
  .textOverflow({ overflow: TextOverflow.Ellipsis })
  .maxLines(1)
}