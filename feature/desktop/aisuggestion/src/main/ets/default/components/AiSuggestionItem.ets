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

import curves from '@ohos.curves';
import display from '@ohos.display';
import image from '@ohos.multimedia.image';
import type ctx from '@ohos.app.ability.common';
import {
  AppStorageUtil,
  CheckEmptyUtils,
  DataProperty,
  DomainName,
  LogDomain,
  LogHelper,
  RectInfo,
  TraceUtil
} from '@ohos/basicutils';
import {
  AccessibilityManager,
  DeviceHelper,
  GlobalContext,
  localEventManager,
  ResourceManager
} from '@ohos/frameworkwrapper';
import {
  desktopUtil,
  DragAccessibilityUtils,
  dragSnapshotHelper,
  ItemUtils,
  ObjectCopyUtil,
  SCBVisualEffectMgr,
  SnapshotType
} from '@ohos/componenthelper';
import { EventType, launcherStatusUtil, ResUtils, scbEventExclusiveManager } from '@ohos/windowscene';
import { BaseDragHandler, } from '@ohos/componentdrag';
import { NumberConstants } from '@ohos/commonconstants';
import { DropAnimationCancelReason, DropAnimationListener, dropAnimationObserver } from '@ohos/componentanimator';
import {
  AppName,
  batchUninstallChain,
  DeskTopItemStyle,
  FormMenu,
  ForwardType,
  HoverAnimationUtil,
  MenuCommonUtil,
  nameAppearAnimate,
  CardNodeControllerManager,
} from '@ohos/launchercommon/Index';
import {
  CardItemInfo,
  CommonConstants,
  DeviceState,
  EditModeConstants,
  EventConstants,
  FormCommonUtil,
  GridLayoutItemInfo,
  GridLayoutUtil,
  MenuInfo,
  MenuInfoManager,
  PresetStyleConstants,
  StyleConstants,
  UninstallDialogStatus,
  DesktopItemVibratorManager,
  ReceiveEventInfo,
  lockLayoutManager,
  EditModeState,
  DesktopDragResult,
  FormHostService,
  PageDesktopModel,
} from '@ohos/launchercommon';
import { FormStyleConfig } from '@ohos/form/src/main/ets/default/common/FormStyleConfig';
import { FormViewModel } from '@ohos/form/src/main/ets/default/viewmodel/FormViewModel';
import FormStyleConstants from '@ohos/form/src/main/ets/default/common/constants/FormStyleConstants';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import { AppNameVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppNameVm';
import { AppNameEvent } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppNameEvent';
import { CardNodeController } from '@ohos/launchercommon/src/main/ets/buildernode/CardNodeController';
import {
  AiFormBasicParams,
  AiFormComponentBasicData,
  AiFormComponentBasicEvent,
  FormOccupyParams
} from '@ohos/launchercommon/src/main/ets/manager/CardNodeControllerManager';
import { AiSuggestionAnimHelper } from '../animation/AiSuggestionAnimHelper';
import { AiSuggestionFormManager } from '../manager/AiSuggestionFormManager';
import { AiSuggestionViewData } from '../viewmodel/AiSuggestionViewData';
import { AiSuggestionDragEventProcessor } from '../event/AiSuggestionDragEventProcessor';
import { AiSuggestionItemStateController } from '../event/AiSuggestionItemStateController';
import { AbilityFormUtil } from '../utils/AbilityFormUtil';
import lazy { outerAddAppIconManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAddAppIconManager';
import { AiSuggestionDataHelper } from '../helper/AiSuggestionDataHelper';
import {
  AiSuggestionConstants,
  LongPressType
} from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';

const TAG = 'AiSuggestionItem'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);
const DROP_ANIMATE_EXTRA_TRANSLATE_Y = 6;
const FOREGROUND_BLUR_RADIUS = 70;

// 菜单的group数
const MENU_GROUP_NUM = 1;

/**
 * 语音助手建议卡片组件
 *
 * @since 2023-08-11
 */
@Component
export struct AiSuggestionItem {
  private dragEventProcessor?: AiSuggestionDragEventProcessor;
  private formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  private mPageDesktopDragHandler?: BaseDragHandler;
  private mFormViewModel: FormViewModel = FormViewModel.getInstance();
  private mTag: string = '';
  private eventIds: Map<string, Function> = new Map();
  private cancelEventHandler: (isCancel: boolean) => void =
    (isCancel: boolean): void => this.onEventhubCancelItemEvent(isCancel);
  private coveredItemEventHandler: (isShow: boolean) => void =
    (isShow: boolean): void => this.onEventhubCoveredItemEvent(isShow);
  private formShowEventHandler: () => void = (): void => this.onEventhubSetFormShowEvent();
  private itemDropEventHandler: (dragItemInfos: GridLayoutItemInfo[], dragResult: DesktopDragResult) => void
    = (dragItemInfos: GridLayoutItemInfo[], dragResult: DesktopDragResult): void =>
  this.onEventhubItemDropEvent(dragItemInfos, dragResult);
  private prepareRemoveHandler: () => void = (): void => this.prepareRemove();
  private otherIconLongPressEffectCancelFunc: () => void = (): void => this.cancelLongPressAnimation();
  private isDesktopItem: boolean = false;
  private mAppNameVm: AppNameVm = new AppNameVm();
  private mAppNameEvent: AppNameEvent = new AppNameEvent(this.mAppNameVm);
  private menuInfoList: MenuInfo[] = [];
  private isOuterDesktop: boolean = false;
  @State animateOpacity: number = 1.0;
  @State mFormNameHeight: number = StyleConstants.DEFAULT_APP_NAME_HEIGHT;
  @State mFormNameWidth: number = StyleConstants.DEFAULT_APP_ITEM_WIDTH;
  @State mFormNameSize: number = StyleConstants.DEFAULT_APP_NAME_SIZE;
  @State appName: string = '';
  @State mMenuPlacement: Placement = Placement.BottomLeft;
  @State formBorderRadius: number = ResUtils.getNumber($r('app.float.dimension_20'));
  @State viewData: AiSuggestionViewData = new AiSuggestionViewData();
  @State @Watch('updateCardNode') isLongPressZoomIn: boolean = false;
  @State containerId: string = '';
  @State containerIdWithName: string = '';
  private iconNameMarginTop: number = StyleConstants.DEFAULT_10;
  private formMarginTop: number = 0;
  @State mFormItemWidth: number = 0;
  @State mFormItemHeight: number = 0;
  @StorageLink('notifyFlush') notifyFlush: number = 0;
  @StorageLink('createFormId') @Watch('doOnCreateForm') createFormId: string = '';
  @State isCreateFormAnimation: boolean = false;
  @State appNameBackgroundColor: string = StyleConstants.DEFAULT_DESKTOP_BACKGROUND_COLOR;
  private mNameLines: number = PresetStyleConstants.DEFAULT_APP_NAME_LINES;
  @State animateBlur: number = 0;
  @State borderOpacity: number = 1;
  private isItemSelected: boolean = false;
  private desktopContext?: ctx.ServiceExtensionContext = GlobalContext.getContext();
  private mBlurRatio: number = 1;
  // 普通卡片拖拽到语音助手建议形成堆叠动效
  @State mSizeRatio: number = 0;
  @State isDragItem: boolean = false;
  @State dropAnimateTranslateY: number = 0;
  @State mFormStackMaskOpacity: number = 0;
  @State isFormBackgroundOpen: boolean = false;
  @State mFormBackboardScale: number = 1;
  @State mFormBackboardRadius: number = 0;
  @State isShowCancelDialog: boolean = false;
  @Consume isShowingUninstallDialog: number;
  @Consume dragToUninstallItemInfo: CardItemInfo;
  private getIndexInSwiper: Function = (): number => 0;
  @StorageProp('isPortrait') @Watch('onPortraitChange') mIsPortrait: boolean = true;
  @StorageProp('desktopIconChange') @Watch('updateFormSize') desktopIconChange: number = 0;
  @Consume @Watch('isEqualToDragItemChange') isDragStart: boolean;
  @Consume isInDrag: boolean;
  @Consume translateX: number;
  @Consume translateY: number;
  @State iconScale: number = 1;
  @State formNameOpacity: number = 1;
  @StorageLink('themeStyle') @Watch('onThemeChange') themeStyle: string = '';
  @StorageLink('foldStatusForOuterScreen') @Watch('folderStatusChangeOuterScreen') foldStatusForOuterScreen: number =
    DeviceState.DEFAULT_STATE;
  // 堆叠卡落回桌面卡片显隐控制
  @State mIsFormStackExpandClosed: boolean = true;
  // 外屏显示菜单显隐控制
  @State mIsOuterMenuShow: boolean = false;
  @ObjectLink @Watch('desktopStyleUpdate') desktopStyle: DeskTopItemStyle;
  @State isHiddenEffect: boolean = false;
  @StorageLink('folderStatusMenu') @Watch('folderStatusChange') folderStatus: number = DeviceState.DEFAULT_STATE;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @State mPixMap: image.PixelMap | undefined = undefined;
  @State editModeState: EditModeState = editModeManager.getEditModeState();
  private cardController: CardNodeController | null = null;
  private mUseEffect: boolean = false;
  private isOnHover: boolean = false;
  private nameAppearCallback = () => {
    this.formNameOpacity = 1;
    log.showInfo(`cardId: ${this.formItem.cardId}, name appear with no delay`);
  }
  private stateController: AiSuggestionItemStateController = {
    prepareToUninstall: () => this.prepareToUninstall(),
    setAppNameBackgroundColor: (color: string) => this.setAppNameBackgroundColor(color),
  };
  private onEventhubFsClosed = (cardId: string) => this.onEventhubFsClosedEvent(cardId);
  private mOuterMenuCloseListener?: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: string): void => {
      log.showInfo(`localEventListener receive event: ${event}, params: ${params}.`);
      if (event === EventConstants.EVENT_REQUEST_OUTER_MENU_CLOSE && params === this.formItem.cardId) {
        this.mIsOuterMenuShow = false;
      }
    }
  };

  private onCardNodeUpdate = (cardId: string): void => {
    if (this.formItem?.cardId === cardId && (this.mFormItemWidth === 0 || this.mFormItemHeight === 0)) {
      this.updateFormSizeIfNeed();
      this.updateCardNode();
    }
  }

  private onThemeChange(): void {
    let formStyleConfig = FormViewModel.getInstance().getFormStyleConfig();
    let formRadius = formStyleConfig.getFormBorderRadius(this.formItem.cardDimension);
    if (formRadius !== CommonConstants.INVALID_VALUE && !this.isOuterDesktop) {
      this.formBorderRadius = formRadius;
    }
    log.showWarn(`theme change, aiSuggestion[${this.formItem.cardId}] new radius: ${this.formBorderRadius}.`);
    this.updateCardNode();
  }

  updateCardNode(): void {
    log.showInfo('updateCardNode');
    CardNodeControllerManager.getAiCardNode(this.formItem.cardId)?.update(new AiFormBasicParams(
      this.getAiFormComponentBasicData(),
      this.getAiFormComponentBasicEvent()
    ));
    // 尝试更新占位FC节点
    const controller = CardNodeControllerManager.getCardController(this.formItem.cardId) as CardNodeController;
    if (controller) {
      const formParams = controller.formParams as FormOccupyParams;
      const params = formParams?.formParams;
      if (params) {
        params.basicData.width = this.mFormItemWidth;
        params.basicData.height = this.mFormItemHeight;
        params.basicData.borderRadius =
          FormViewModel.getInstance().getFormStyleConfig().getFormBorderRadius(this.formItem.cardDimension);
        CardNodeControllerManager.getCardNode(this.formItem.cardId)?.update(params);
      }
    }
  }

  desktopStyleUpdate() {
    this.viewData.animateScale = CheckEmptyUtils.isEmpty(this.desktopStyle) ? 1 : this.desktopStyle.scale;
  }

  private folderStatusChangeOuterScreen() {
    this.updateFormSize();
  }

  private folderStatusChange() {
    if (this.viewData.isMenuShow) {
      this.isHiddenEffect = true;
    }
    this.updateFormSize();
  }

  private isEqualToDragItemChange(): void {
    log.showInfo('isEqualToDragItemChange, isDragStart:%{public}s', this.isDragStart);
    if (!this.isDragStart && !DeviceHelper.isPC()) {
      this.delayNameAppearAnimate();
    }
  }

  private doOnCreateForm(): void {
    log.showInfo(`doOnCreateForm createFormId=${this.createFormId}, currentCardId=${this.formItem.cardId}`);
    this.isCreateFormAnimation = AiSuggestionDataHelper.isPlayCreateAnimation(this.createFormId, this.formItem.cardId);
    if (this.isCreateFormAnimation) {
      this.delayNameAppearAnimate(350);
    }
  }

  private prepareToUninstall(): void {
    this.dragToUninstallItemInfo = new CardItemInfo();
    ObjectCopyUtil.deepClone(this.formItem, this.dragToUninstallItemInfo);
    this.isShowingUninstallDialog = UninstallDialogStatus.INITIAL_STATE;
  }

  private setAppNameBackgroundColor(color: string): void {
    this.appNameBackgroundColor = color;
  }

  private delayNameAppearAnimate(delay: number = 0) {
    log.showInfo(`cardId: ${this.formItem.cardId}, name appear animation enter`);
    if (delay === 0) {
      this.formNameOpacity = 0;
      nameAppearAnimate(this.nameAppearCallback);
    } else {
      this.formNameOpacity = 0;
      setTimeout(() => {
        nameAppearAnimate(this.nameAppearCallback);
      }, delay);
    }
  }

  private onPortraitChange(): void {

    // 不可见时不需要下放动效
    if (FormHostService.getInstance().queryInvisibleListItem(this.formItem.cardId)) {
      log.showDebug(`card ${this.formItem.cardId} invisible, do not need animation`);
      this.updateFormSize();
      return;
    }
    // 应框架要求，由于卡片使用逐帧动效造成转屏帧率掉帧，转屏场景不使用统一动效
    animateTo({
      duration: 100,
      curve: Curve.Linear,
    }, () => {
      this.updateFormSize();
    })
  }

  private updateFormSizeIfNeed(): void {
    const cardDimension: string = this.formItem.cardDimension?.toString() ?? '';
    if (cardDimension) {
      const formStyleConfig: FormStyleConfig = FormViewModel.getInstance().getFormStyleConfig();
      const formWidth: number | undefined =
        this.isOuterDesktop ? formStyleConfig?.mOuterFormWidth?.get(cardDimension) :
        formStyleConfig?.mFormWidth?.get(cardDimension);
      const formHeight: number | undefined =
        this.isOuterDesktop ? formStyleConfig?.mOuterFormHeight?.get(cardDimension) :
        formStyleConfig?.mFormHeight?.get(cardDimension);
      if (formWidth && !Number.isNaN(formWidth) && formWidth > 0) {
        this.mFormItemWidth = formWidth;
        log.showInfo(`updateFormSizeIfNeed formWidth:${formWidth}`);
      }
      if (formHeight && !Number.isNaN(formHeight) && formHeight > 0) {
        this.mFormItemHeight = formHeight;
        log.showInfo(`updateFormSizeIfNeed formHeight:${formHeight}`);
      }
    }
  }

  updateFormSize() {
    this.updateFormSizeIfNeed();
    log.showInfo(`updateFormSize ${this.formItem.cardId}, ${this.isOuterDesktop},` +
      ` Width = ${this.mFormItemWidth}, Height = ${this.mFormItemHeight}`);
    this.dragEventProcessor?.setFormSize(this.mFormItemWidth, this.mFormItemHeight);
    this.updateCardNode();
  }

  private initConfig() {
    let styleConfig = PageDesktopModel.getInstance().getPageDesktopStyleConfig();
    this.iconNameMarginTop = styleConfig.mIconNameMarginTop;
    this.mFormNameHeight = styleConfig.mNameHeight;
    this.mFormNameWidth = styleConfig.mNameWidth;
    this.mNameLines = styleConfig.mNameLines;
    this.mFormNameSize = styleConfig.mNameSize;

    if (this.formItem && this.formItem.cardDimension) {
      let formStyleConfig = FormViewModel.getInstance().getFormStyleConfig();
      if (this.isOuterDesktop) {
        this.mFormItemWidth = Number(formStyleConfig.mOuterFormWidth.get(this.formItem.cardDimension.toString()));
        this.mFormItemHeight = Number(formStyleConfig.mOuterFormHeight.get(this.formItem.cardDimension.toString()));
      } else {
        this.mFormItemWidth = Number(formStyleConfig.mFormWidth.get(this.formItem.cardDimension.toString()));
        this.mFormItemHeight = Number(formStyleConfig.mFormHeight.get(this.formItem.cardDimension.toString()));
      }
      let formRadius = formStyleConfig.getFormBorderRadius(this.formItem.cardDimension);
      if (formRadius !== CommonConstants.INVALID_VALUE) {
        this.formBorderRadius = formRadius;
      }
      this.mFormBackboardRadius = this.formBorderRadius;
      this.mBlurRatio = formStyleConfig.getBlurRatio(this.formItem.cardDimension);

      log.showInfo('desktopMode %{public}d, formWidth %{public}d, formHeight %{public}d, borderRadius %{public}d',
        editModeManager.getDesktopMode(), this.mFormItemWidth, this.mFormItemHeight, this.formBorderRadius);
    }

    if (this.mFormItemWidth) {
      this.mSizeRatio = (this.mFormItemWidth - StyleConstants.CARD_BACKGROUND_SIZE_OFFSET) / this.mFormItemWidth;
    }
  }

  private initDragEventProcessor(): void {
    this.dragEventProcessor = new AiSuggestionDragEventProcessor({
      formItem: this.formItem,
      containerId: this.containerId,
      containerIdWithName: this.containerIdWithName,
      formItemWidth: this.mFormItemWidth,
      formItemHeight: this.mFormItemHeight,
      formBorderRadius: this.formBorderRadius,
      eventIds: this.eventIds,
      pageDesktopDragHandler: this.mPageDesktopDragHandler,
      itemStateController: this.stateController,
      viewData: this.viewData,
    });
  }

  private getMenuInfo(responseType: ResponseType): MenuInfo[] {
    let menuInfoList: MenuInfo[] = MenuInfoManager.getInstance().getContextMenuListener(this.formItem.cardId)
    ?.onMenuBuild(CommonConstants.CONTAINER_DESKTOP, responseType) ?? [];
    if (!MenuCommonUtil.isShowBottom(this.mMenuPlacement)) {
      menuInfoList.reverse();
    }
    return menuInfoList;
  }

  private registerOuterMenuCloseListener(): void {
    localEventManager.registerEventListener(this.mOuterMenuCloseListener, [
      EventConstants.EVENT_REQUEST_OUTER_MENU_CLOSE
    ]);
    log.showInfo('registerOuterMenuCloseListener listener on create');
  }

  aboutToAppear(): void {
    /**
     * ! PC 新版本没有语音助手应用，时不能展示语音助手卡片的，但PC端加载布局数据时，没有清理脏数据，导致桌面出现透明语音助手卡片
     * ! 此处为临时方案，对于PC端，直接删掉语音助手卡片，待后续PC端完善脏数据清理逻辑后，再删掉
     */
    if (DeviceHelper.isPC()) {
      log.showWarn('PC dose not support AiSuggestion, delete it.');
      this.deleteForm(false);
      return;
    }

    log.showInfo(`aboutToAppear formItem cardId=${this.formItem.cardId}`);
    this.containerId = FormCommonUtil.getFormComponentId(this.formItem as Object as CardItemInfo, false);
    this.containerIdWithName = `${this.mTag}_FormItem_${this.formItem.bundleName}_${this.formItem.cardId}`;

    // 语音助手建议尺寸不存在，计算一下并赋值
    if (!this.formItem.cardDimension) {
      let dimension: number = CardItemInfo.getCardDimension(this.formItem.area);
      this.formItem.cardDimension = dimension;
    }
    this.initConfig();
    this.initDragEventProcessor();
    this.doOnCreateForm();

    this.initEventhubEvent();
    if (!this.isCreateFormAnimation) {
      this.delayNameAppearAnimate(50);
    }
    this.mAppNameEvent.init();
    // 堆叠展开态拖拽或者删除剩一张卡片回落
    if (AppStorage.get<boolean>('formStackEditShow') &&
      AppStorage.get<string>('cardDropByFromStackExpandClose') === this.formItem.cardId) {
      this.initFsExpandStatusEventhub();
    }
    if (this.isOuterDesktop) {
      this.registerOuterMenuCloseListener();
    }
    this.cardController = new CardNodeController(new AiFormBasicParams(
      this.getAiFormComponentBasicData(),
      this.getAiFormComponentBasicEvent()
    ), TAG);

    this.desktopContext?.eventHub?.on(`${EventConstants.EVENT_AI_CARDNODE_UPDATE}_${this.formItem.cardId}`,
      this.onCardNodeUpdate);
  }

  private getAiFormComponentBasicData(): AiFormComponentBasicData {
    return new AiFormComponentBasicData(
      this.formItem.cardId as string,
      this.mFormItemWidth,
      this.mFormItemHeight,
      this.formItem,
      FormViewModel.getInstance().getFormStyleConfig().getFormBorderRadius(this.formItem.cardDimension),
      this.containerId,
      this.isOuterDesktop,
      this.isLongPressZoomIn,
      this.isCreateFormAnimation,
    );
  }

  private getAiFormComponentBasicEvent(): AiFormComponentBasicEvent {
    return {
      deleteForm: (playAnimation: boolean, formItem?: GridLayoutItemInfo,
        isOuter?: boolean) => this.deleteForm(playAnimation, formItem, isOuter),
      updateFormId: async (newCardId: string) => await this.updateFormId(newCardId),
      updateAppName: (name: string) => this.updateAppName(name),
      onItemHover: (event: HoverEvent): void => this.onItemHover(event),
      onItemSelected: (index: number) => this.onItemSelected(index),
      isUseEffect: (useEffect: boolean) => this.isUseEffect(useEffect),
      isDuringAppExitAnim: () => {
      },
    };
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear aiSuggestionItem');
    if (this.eventIds.size > 0) {
      log.showInfo(`deregister events: ${this.eventIds.toString()}`);
      this.eventIds.forEach((handler, id) => {
        this.desktopContext?.eventHub.off(id, handler);
      });
    }
    if (this.dragEventProcessor) {
      this.dragEventProcessor.destroy();
    }
    if (this.isOuterDesktop) {
      localEventManager.unregisterEventListener(this.mOuterMenuCloseListener);
    }
    this.cardController = null;
    this.desktopContext?.eventHub?.off(`${EventConstants.EVENT_AI_CARDNODE_UPDATE}_${this.formItem.cardId}`,
      this.onCardNodeUpdate);
  }

  private deleteForm(playAnimation: boolean, formItem?: GridLayoutItemInfo, isOuter?: boolean): void {
    log.showInfo(`deleteForm cardId: ${this.formItem.cardId}`);
    if (playAnimation === false) {
      AiSuggestionFormManager.getInstance().acquireDefaultCardError(formItem, isOuter);
      return;
    }
    TraceUtil.startTrace(DomainName.HOME, TraceUtil.UNINSTALL_CARD);
    animateTo({
      duration: 250,
      tempo: 0.5,
      curve: '(0.3,0,0.9,1)',
      delay: 0,
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: () => {
        if (this.formItem.cardId) {
          log.showInfo('deleteForm end');
          TraceUtil.endTrace(DomainName.HOME, TraceUtil.UNINSTALL_CARD);
          localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_DELETE,
            this.formItem.cardId);
          AiSuggestionFormManager.getInstance().deleteCardInfoAfterAnimation(this.formItem.cardId);
        }
      }
    }, () => {
      this.viewData.animateScale = 0;
      this.animateBlur = FOREGROUND_BLUR_RADIUS * this.mBlurRatio;
      this.animateOpacity = 0;
      this.iconScale = 0;
    })
  }

  private async updateFormId(newCardId: string) {
    if (AbilityFormUtil.isUpdateFormId(this.formItem)) {
      // 预置的卡片需要更新ID
      log.showInfo(`updateFormId ${newCardId}`);
      try {
        await this.mFormViewModel.updateCardIdOfPreloadForm(this.formItem as Object as CardItemInfo,
          newCardId, this.isOuterDesktop).catch((error: Error) => {
          log.showError(`updateCardIdOfPreloadForm newCardId:${newCardId} error`);
        });
      } catch (error) {
        log.showError(`updateFormId newCardId:${newCardId} error`);
      }
      this.formItem.cardId = newCardId;
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
    }
  }

  private initEventhubEvent(): void {
    if (!AbilityFormUtil.isCardIdInvalid(this.formItem.cardId) && this.desktopContext) {
      let cancelItemEventId: string = `cancelUninstall${this.formItem.cardId}`;
      this.desktopContext.eventHub.on(cancelItemEventId, this.cancelEventHandler);
      this.eventIds.set(cancelItemEventId, this.cancelEventHandler);

      let coveredCardEventId: string = `coveredCard${this.formItem.cardId}`;
      this.desktopContext.eventHub.on(coveredCardEventId, this.coveredItemEventHandler);
      this.eventIds.set(coveredCardEventId, this.coveredItemEventHandler);

      let dragCardEventId: string = `dragItemCard${this.formItem.cardId}`;
      this.desktopContext.eventHub.on(dragCardEventId, this.formShowEventHandler);
      this.eventIds.set(dragCardEventId, this.formShowEventHandler);

      let dropStackCardEventId: string = `dropStackCard${this.formItem.cardId}`;
      this.desktopContext.eventHub.on(dropStackCardEventId, this.itemDropEventHandler);
      this.eventIds.set(dropStackCardEventId, this.itemDropEventHandler);

      let prepareRemoveEventId: string = EditModeConstants.EVENT_EDIT_MODE_DROP_TO_DELETE + this.formItem.cardId;
      this.desktopContext.eventHub.on(prepareRemoveEventId, this.prepareRemoveHandler);
      this.eventIds.set(prepareRemoveEventId, this.prepareRemoveHandler);
    }
  }

  private onEventhubCancelItemEvent(isCancel: boolean): void {
    log.showInfo(`onEventhubCancelItemEvent item:${this.formItem.cardId}, isCancel:${isCancel}`);
    this.viewData.animateScale = 0;
    this.showAppFromDialog(isCancel);
  }

  private onEventhubCoveredItemEvent(isShow: boolean): void {
    const dragItemType: number = AppStorage.get<number>('dragItemType') as number;
    if ((dragItemType === CommonConstants.DRAG_FROM_DESKTOP || dragItemType === CommonConstants.DRAG_FROM_APP_ICON ||
    CommonConstants.DRAG_FROM_DOCK || CommonConstants.DRAG_FROM_MANAGE || CommonConstants.DRAG_FROM_FORM_SERVICE) &&
    DeviceHelper.isPhoneOrPad()) {
      this.showFormBackplaneAnimate(isShow);
    }
  }

  private showFormBackplaneAnimate(isCardBackplaneOpen: boolean): void {
    if (!this.isFormBackgroundOpen && !isCardBackplaneOpen) {
      log.showInfo('backplane disappeared, no action required.');
      return;
    }

    if (isCardBackplaneOpen) {
      log.showInfo('showAppBackplaneAnimate start');
      this.isFormBackgroundOpen = true;
      animateTo({
        curve: curves.springMotion(0.45, 1),
      }, () => {
        // 背板动效
        this.mFormBackboardScale = 2 - this.mSizeRatio;
        this.mFormBackboardRadius = this.formBorderRadius + StyleConstants.CARD_BACKGROUND_SIDE_OFFSET;
        // 蒙版透明度渐变和缩放
        this.mFormStackMaskOpacity = 0.1;
        // 底部卡片缩放
        this.iconScale = this.mSizeRatio;
        // 背板出现，隐去语音助手建议卡片的名字
        this.formNameOpacity = 0;
      })
    } else {
      log.showInfo('showAppBackplaneAnimate end');
      animateTo({
        curve: curves.springMotion(0.45, 1),
      }, () => {
        this.isFormBackgroundOpen = false;
        // 背板动效
        this.mFormBackboardScale = 1;
        this.mFormBackboardRadius = this.formBorderRadius;
        // 蒙版透明度渐变和缩放
        this.mFormStackMaskOpacity = 0;
        // 底部卡片缩放
        this.iconScale = 1;
        // 背板消失，显示语音助手建议卡片的名字
        this.formNameOpacity = 1;
      })
    }
  }

  private onEventhubSetFormShowEvent(): void {
    this.isDragItem = true;
  }

  private onEventhubItemDropEvent(dragItemInfos: GridLayoutItemInfo[], dragResult: DesktopDragResult): void {
    log.showInfo('onEventhubItemDropEvent start');
    // 注册落位动效结束回调
    const dropAniListener: DropAnimationListener = {
      onDropAnimationEnd: (a, b, c, d) => {
        // 清除监听动画结束事件
        dropAnimationObserver.unregisterDropAnimationListener(dropAniListener);
        this.isDragItem = false;
        this.isFormBackgroundOpen = false;
        this.formNameOpacity = 1;
        // 更新缓存
        GlobalContext.getContext()?.eventHub.emit(EventConstants.CREATE_FORM_STACK_NOTIFY_EVENT);
        // 刷新布局
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
      }
    }
    dropAnimationObserver.registerDropAnimationListener(dropAniListener);
    dragResult.parallelAnimation = () => this.dropAnimation();
  }

  private dropAnimation = () => {
    // 背板动效
    this.mFormBackboardScale = 1;
    this.mFormBackboardRadius = this.formBorderRadius;
    // 卡片上移
    this.dropAnimateTranslateY = -(this.mFormItemHeight * (1 - this.mSizeRatio) / 2 + DROP_ANIMATE_EXTRA_TRANSLATE_Y);
    // 蒙版透明度渐变和跟随卡片上移
    this.mFormStackMaskOpacity = 0.9;
  }

  private showAppFromDialog(isCancel: boolean): void {
    if (isCancel) {
      animateTo({
        curve: curves.springMotion(0.468, 0.63),
        onFinish: () => {
          this.isShowingUninstallDialog = UninstallDialogStatus.INITIAL_STATE;
          this.dragToUninstallItemInfo = new CardItemInfo();
        }
      }, () => {
        this.viewData.animateScale = 1;
      })
    }
  }

  private prepareRemove(): void {
    this.isShowCancelDialog = true;
  }

  private cancelHoverEffect(): void {
    this.viewData.animateScale = 1;
  }

  private playHoverAnimation(isHover: boolean): void {
    log.showInfo(`playHoverAnimation isHover ${isHover}`);
    this.isOnHover = isHover;
    let isPad = CommonConstants.PAD_DEVICE_TYPE === AppStorage.get('device');
    if (isPad) {
      let isDrag: boolean = AppStorage.get<boolean>('isDrag') as boolean;
      if (isDrag) {
        log.showDebug('isDragging');
        return;
      }
      if (isHover) {
        animateTo({
          duration: 250,
          curve: Curve.Friction
        }, () => {
          this.viewData.animateScale = 1.02
        })
      } else {
        animateTo({
          duration: 250,
          curve: Curve.Friction
        }, () => {
          this.viewData.animateScale = 1;
        })
      }
    } else {
      HoverAnimationUtil.hoverEffect(isHover, false, (hoverScale: number) => {
        this.viewData.animateScale = hoverScale;
      });
    }
  }

  private onItemSelected(index: number): void {
    log.showInfo(`onItemSelected index = ${index}`);
    this.isItemSelected = index >= 0;
  }

  private getTranslateX(): number {
    if (CheckEmptyUtils.isEmpty(this.desktopStyle)) {
      return this.translateX;
    }
    return this.desktopStyle.translateX + this.translateX;
  }

  private getTranslateY(): number {
    if (CheckEmptyUtils.isEmpty(this.desktopStyle)) {
      return this.translateY;
    }
    return this.desktopStyle.translateY + this.translateY;
  }

  private isLockLayoutInEditmode(): boolean {
    return lockLayoutManager.isLockLayout() && this.editModeState.isInEditMode();
  }

  build() {
    Column() {
      Stack() {
        this.contentBuilder()
      }
      .width(this.mFormItemWidth)
      .height(this.mFormItemHeight)
      .onTouch(event => this.processTouchEvent(event))
      .longPressGestureStyle()
      .menuStyles()
      .dragStyles()
      .onHover((isHover: boolean) => this.playHoverAnimation(isHover))
      .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')

      if (DeviceHelper.isPC()) {
        this.pcAppNameBuilder()
      } else if (!this.isOuterDesktop) {
        this.appNameBuilder()
      }
    }
    .id(this.containerIdWithName)
    .visibility(this.isHiddenContainer() ? Visibility.Hidden : Visibility.Visible)
    .translate({
      x: this.getTranslateX(),
      y: this.getTranslateY()
    })
    .scale({
      x: this.viewData.animateScale,
      y: this.viewData.animateScale,
      centerX: this.desktopStyle && this.desktopStyle.unLockAnimate ?
      this.desktopStyle.centerX : FormStyleConstants.FORM_PORTRAIT_SCALE_X,
      centerY: this.desktopStyle && this.desktopStyle.unLockAnimate ?
      this.desktopStyle.centerY : FormStyleConstants.FORM_PORTRAIT_SCALE_Y,
    })
    .foregroundEffect({ radius: this.animateBlur })
    .opacity((CheckEmptyUtils.isEmpty(this.desktopStyle) ? 1 : this.desktopStyle.alpha) * this.animateOpacity)
    .width(StyleConstants.PERCENTAGE_100)
    .height(StyleConstants.PERCENTAGE_100)
    .padding({ top: DeviceHelper.isPC() ? StyleConstants.DEFAULT_4 : StyleConstants.DEFAULT_0 })
    .margin({ top: this.formMarginTop })
    .accessibilityLevel(this.isAccessibilityMode ? 'yes' : 'auto')
    .accessibilityDescription(this.isAccessibilityMode && !this.isLockLayoutInEditmode() ?
    ResUtils.getInnerString($r('app.string.cc_accessibility_str_long_click')) : ',')
    .accessibilityText(this.isAccessibilityMode ?
      `${this.appName}${ResUtils.getInnerStringByName('form_service')}` : '')
  }

  private isHiddenContent(): boolean {
    return !this.viewData.isFormShow || this.isInDrag || this.isCreateFormAnimation;
  }

  private updateAppName(name: string): void {
    log.showInfo(`updateAppName: ${name}, cardId=${this.formItem.cardId}, width=${this.mFormItemWidth}, height=${this.mFormItemHeight}`);
    this.appName = name;
    if (AccessibilityManager.getInstance().getIsAccessibilityMode()) {
      AccessibilityManager.getInstance().requestFocusForAccessibility(this.containerIdWithName);
    }
  }

  private onItemHover(event: HoverEvent): void {
    this.menuInfoList = MenuInfoManager.getInstance().getContextMenuListener(String(this.formItem.cardId))
    ?.onMenuBuild(CommonConstants.CONTAINER_DESKTOP) ?? [];
    this.setFormMenuPositionWhenHover(event, this.menuInfoList);
  }

  private isUseEffect(useEffect: boolean): void {
    this.mUseEffect = useEffect;
  }

  @Builder
  contentBuilder() {
    if (this.isFormBackgroundOpen) {
      FormBackboard({
        mFormItemWidth: this.mFormItemWidth,
        mFormItemHeight: this.mFormItemHeight,
        mFormBackboardScale: this.mFormBackboardScale,
        mFormBackboardRadius: this.mFormBackboardRadius,
      })
    }
    NodeContainer(this.cardController)
      .width(this.mFormItemWidth)
      .height(this.mFormItemHeight)
      .borderRadius(this.formBorderRadius)
      .scale({ x: this.iconScale, y: this.iconScale })
      .opacity(this.isHiddenContent() ? 0 : 1)
      .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
      .translate({ x: 0, y: this.dropAnimateTranslateY })
    if (this.isFormBackgroundOpen) {
      FormMask({
        mFormItemWidth: this.mFormItemWidth,
        mFormItemHeight: this.mFormItemHeight,
        mFormStackMaskOpacity: this.mFormStackMaskOpacity,
        dropAnimateScale: this.iconScale,
        dropAnimateTranslateY: this.dropAnimateTranslateY,
        formBorderRadius: this.formBorderRadius,
      })
    }
  }

  @Builder
  pcAppNameBuilder() {
    Column() {
      this.appNameBuilder()
    }
    .onHover((isHover: boolean) => this.playHoverAnimation(isHover))
    .height(this.mFormNameHeight + this.iconNameMarginTop)
  }

  @Builder
  appNameBuilder() {
    if (!this.isDragItem) {
      AppName({
        bundleName: this.formItem.bundleName,
        moduleName: this.formItem.moduleName,
        labelId: this.formItem.appLabelId,
        nameHeight: this.mFormNameHeight,
        nameWidth: this.mFormNameWidth,
        nameSize: this.mFormNameSize,
        nameFontColor: PageDesktopModel.getInstance().getPageDesktopStyleConfig().mNameFontColor,
        appName: this.appName,
        isNeedUpdateName: false,
        nameLines: this.mNameLines,
        marginTop: PageDesktopModel.getInstance().getPageDesktopStyleConfig().mIconNameMargin,
        getIndexInSwiper: this.getIndexInSwiper,
        isDesktopItem: this.isDesktopItem,
        nameBackgroundColor: this.appNameBackgroundColor,
        colStart: this.formItem.column,
        colEnd: GridLayoutUtil.calculateItemColEnd(this.formItem),
        rowEnd: GridLayoutUtil.calculateItemRowEnd(this.formItem),
        parentItem: this.formItem,
        modifier: this.mAppNameVm.modifier
      })
        .opacity(this.formNameOpacity)
        .margin({ top: this.iconNameMarginTop })
    }
  }

  private cancelLongPressAnimation(): void {
    log.showInfo('cancelLongPressAnimation animation cancel');
    animateTo({
      duration: 0,
      curve: Curve.Friction,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.iconScale = StyleConstants.DEFAULT_1;
        this.desktopContext?.eventHub.off(`otherIconLongPressEffectCancel`, this.otherIconLongPressEffectCancelFunc);
      }
    }, () => {
      this.iconScale = StyleConstants.CANCEL_LONG_PRESS_SCALE;
    })
  }

  @Styles
  longPressGestureStyle() {
    .parallelGesture(
      GestureGroup(GestureMode.Parallel,
        LongPressGesture({ repeat: false, duration: NumberConstants.CONSTANT_NUMBER_150 })
          .onAction(() => {
            GlobalContext.getContext()?.eventHub.emit('appIconLongPressEffectCancel', true);
            this.playLongPressAnimation(true);
          }),
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_VIBRATOR_TIME })
          .onAction(() => {
            if (!scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK)) {
              DesktopItemVibratorManager.getInstance().longPressVibrator(TAG);
            }
            if (lockLayoutManager.isLockLayout()) {
              lockLayoutManager.toastLockedLayout();
            }
            // 拖拽适配无障碍朗读语音助手建议起拖播报
            DragAccessibilityUtils.textAnnouncedForDragStart();
            let isDrag: boolean = AppStorage.get<boolean>('isDrag') as boolean;
            if (!editModeManager.isInEditMode() && !isDrag) {
              this.viewData.isMenuShow = true;
              if (this.isOuterDesktop) {
                localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_OUTER_MENU_OPEN, [this.formItem,
                  true]);
                this.mIsOuterMenuShow = true;
              }
            }
            // 编辑模式 能够卸载的app 通知显示删除按钮
            if (editModeManager.isInEditMode()) {
              let batchItem: GridLayoutItemInfo[] = [this.formItem];
              batchUninstallChain.forward(ForwardType.LONG_PRESS, batchItem);
            }
          })
          .onActionEnd(() => {
            // 编辑模式 能够卸载的app 通知隐藏删除按钮
            if (editModeManager.isInEditMode()) {
              batchUninstallChain.forward(ForwardType.LONG_PRESS_END);
            }
          }),
        LongPressGesture({ repeat: false, duration: AiSuggestionConstants.LONG_PRESS_SELECT_ITEM_DURATION })
          .onAction(() => {
            if (!editModeManager.isInEditMode() && this.isItemSelected) {
              this.desktopContext?.eventHub.emit(`mFormStackPressTypeChange_${this.formItem.cardId}`,
                LongPressType.SELECTED_ITEM);
            }
          }),
        LongPressGesture({ repeat: false, duration: AiSuggestionConstants.LONG_PRESS_SELECT_ITEM_SNAP_DURATION })
          .onAction(() => {
            if (!editModeManager.isInEditMode() && this.isItemSelected) {
              if (this.mUseEffect) {
                dragSnapshotHelper.snapshotUntilRenderFinishedFromId(`AiSuggestionComponent_grid_${this.formItem.cardId}`,
                  SnapshotType.DROP, GridLayoutUtil.generateUniqueKey(this.formItem), (pixmap: image.PixelMap) => {
                    this.mPixMap = pixmap;
                  });
                dragSnapshotHelper.snapshotFromId(this.containerId, SnapshotType.DRAG,
                  GridLayoutUtil.generateUniqueKey(this.formItem), (value) => {
                    ResourceManager.getInstance().setAppResourceCache(this.containerId, 'cardSnapshot', value);
                  });
              } else {
                dragSnapshotHelper.snapshotFromId(this.containerId, SnapshotType.BOTH,
                  GridLayoutUtil.generateUniqueKey(this.formItem), (value) => {
                    ResourceManager.getInstance().setAppResourceCache(this.containerId, 'cardSnapshot', value);
                  });
              }
            }
          }),
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_ZOOM_IN })
          .onAction(() => {
            if (editModeManager.isInEditMode()) {
              this.playLongPressAnimation(false, StyleConstants.EDIT_MODE_LONG_PRESS_SCALE);
              this.isLongPressZoomIn = true;
            }
          })
          .onActionEnd(() => {
            if (editModeManager.isInEditMode()) {
              this.isLongPressZoomIn = false;
            }
          })
          .onActionCancel(() => {
            if (editModeManager.isInEditMode()) {
              this.isLongPressZoomIn = false;
            }
          }),
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_ZOOM_IN_WITH_MENU })
          .onAction(() => {
            if (!editModeManager.isInEditMode()) {
              this.playLongPressAnimation(false);
              this.isLongPressZoomIn = true;
            }
          })
          .onActionEnd(() => {
            if (!editModeManager.isInEditMode()) {
              this.isLongPressZoomIn = false;
            }
          })
          .onActionCancel(() => {
            if (!editModeManager.isInEditMode()) {
              this.isLongPressZoomIn = false;
            }
          }),
      )
    )
  }

  private playLongPressAnimation(isZoomOut: boolean, endScale?: number): void {
    if (isZoomOut) {
      if (this.isItemSelected) {
        return;
      }
      log.showInfo('long press zoom out');
      const curve: curves.ICurve = AiSuggestionAnimHelper.getCurveByDimension(this.formItem?.cardDimension ??
      FormDimension.Dimension_2_2);
      const scale: number = AiSuggestionAnimHelper.getScaleByDimension(this.formItem?.cardDimension ??
      FormDimension.Dimension_2_2, this.isOuterDesktop);

      animateTo({
        curve: curve,
        playMode: PlayMode.Normal,
      }, () => {
        this.iconScale = scale;
      });
    } else {
      log.showInfo('long press zoom in');
      animateTo({
        duration: NumberConstants.CONSTANT_NUMBER_250,
        curve: Curve.Friction,
        playMode: PlayMode.Normal,
      }, () => {
        this.iconScale = endScale ?? StyleConstants.DEFAULT_1;
      });
    }
  }

  private isHiddenContainer(): boolean {
    return this.isDragStart || this.isShowCancelDialog || !this.mIsFormStackExpandClosed || this.mIsOuterMenuShow;
  }

  @Styles
  dragStyles() {
    .onDragStart((event: DragEvent) => this.dragEventProcessor?.dragStart(event,
      GridLayoutUtil.generateUniqueKey(this.formItem), this.isOuterDesktop))
    .onDragEnd((event: DragEvent) => {
      this.dragEventProcessor?.dragEnd();
      this.playLongPressAnimation(false);
      if (this.isOuterDesktop) {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_OUTER_CARD_DRAG_END,
          this.formItem.cardId);
      }
    })
    .dragPreviewOptions({ mode: DragPreviewMode.DISABLE_SCALE }, {
      isDragPreviewEnabled: false
    })
    .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
      return this.dragEventProcessor?.onGestureJudgeBegin(gestureInfo, event);
    })
  }

  private processTouchEvent(event: TouchEvent): void {
    if (DeviceHelper.isPC()) {
      this.cancelHoverEffect();
      if (event.type === CommonConstants.TOUCH_TYPE_DOWN || event.type === CommonConstants.TOUCH_TYPE_MOVE) {
        this.appNameBackgroundColor = StyleConstants.PRESS_DESKTOP_APPNAME_BACKGROUND_COLOR;
      } else {
        this.appNameBackgroundColor = StyleConstants.DEFAULT_DESKTOP_BACKGROUND_COLOR;
      }
    }

    if (event.type === TouchType.Down) {
      log.showInfo('onTouch down start');
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      this.desktopContext?.eventHub.off(`otherIconLongPressEffectCancel`, this.otherIconLongPressEffectCancelFunc);
      this.desktopContext?.eventHub.on(`otherIconLongPressEffectCancel`, this.otherIconLongPressEffectCancelFunc);
      this.menuInfoList = MenuInfoManager.getInstance().getContextMenuListener(String(this.formItem.cardId))
      ?.onMenuBuild(CommonConstants.CONTAINER_DESKTOP) ?? [];
      this.setFormMenuPosition(event, this.menuInfoList);
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      this.desktopContext?.eventHub.off(`otherIconLongPressEffectCancel`, this.otherIconLongPressEffectCancelFunc);
      this.playLongPressAnimation(false);
      this.showForm();
    }
  }

  private showForm(): void {
    if (!editModeManager.isInEditMode()) {
      return;
    }
    setTimeout(() => {
      if (!this.viewData.isFormShow) {
        this.viewData.isFormShow = true;
      }
    }, CommonConstants.RESTORE_TIME_FOR_FLOATING_EFFECT);
  }

  private setFormMenuPositionWhenHover(event: BaseEvent, menuInfoList: MenuInfo[]): void {
    try {
      display.getAllDisplays((err, data) => {
        if (err.code) {
          log.showError(`setFormMenuPosition Failed ${err.message}`);
          this.mMenuPlacement = Placement.BottomLeft;
          return;
        }
        let formGlobalPositionY = Number(event.target.area.globalPosition.y);
        const menuHeight: number = menuInfoList.length > 0 ? menuInfoList.length * StyleConstants.DEFAULT_44 : 0;
        let screenHeight = data[0].height;
        let densityPixels = data[0].densityPixels;
        if (((formGlobalPositionY - menuHeight) * densityPixels / screenHeight) > 0.12) {
          this.mMenuPlacement = Placement.BottomLeft;
        } else {
          this.mMenuPlacement = Placement.TopLeft;
        }
        log.showInfo('menuForward:%{public}s, positionY:%{public}d, screenHeight:%{public}d, densityPixels:%{public}d',
          this.mMenuPlacement, formGlobalPositionY, screenHeight, densityPixels);
      });
    } catch (e) {
      log.showError(`set form menu position when hover failed: error: ${e?.message}, use default BottomLeft`);
      this.mMenuPlacement = Placement.BottomLeft;
    }
  }

  private setFormMenuPosition(event: TouchEvent, menuInfoList: MenuInfo[]): void {
    display.getAllDisplays((err, data) => {
      if (err.code) {
        log.showError(`setFormMenuPosition Failed ${err.message}`);
        return;
      }
      let menuItemNum = menuInfoList?.length ?? 0;
      let aiSuggestionRect: RectInfo = ItemUtils.getRectById(this.containerId);
      this.mMenuPlacement = MenuCommonUtil.getMenuPlacement(event, aiSuggestionRect, menuItemNum, MENU_GROUP_NUM);
    });
  }

  /**
   * 监听卡片从堆叠展开态回落，fs: formStack缩写
   */
  private initFsExpandStatusEventhub(): void {
    this.mIsFormStackExpandClosed = false;
    let eventId: string = `formStackClosed${this.formItem.cardId}`;
    this.desktopContext?.eventHub.off(eventId);
    this.desktopContext?.eventHub.on(eventId, this.onEventhubFsClosed);
    log.showInfo(`event formstack close status completed: ${this.formItem.cardId}`);
  }

  private onEventhubFsClosedEvent(cardId: string): void {
    log.showInfo('formstack close done');
    this.mIsFormStackExpandClosed = true;
    let eventId: string = `formStackClosed${cardId}`;
    this.desktopContext?.eventHub.off(eventId);
    AppStorageUtil.setOrCreate('cardDropByFromStackExpandClose', 0, new DataProperty(true, false));
  }

  private getTransition() {
    return this.isHiddenEffect ? TransitionEffect.asymmetric(
      TransitionEffect.opacity(0),
      TransitionEffect.IDENTITY.animation({ duration: 0 })) : undefined
  }

  private getMenuScale(menuAnimation?: boolean): AnimationRange<number> {
    if (DeviceHelper.isPC()) {
      return [StyleConstants.MENU_ANIMATION_FROM, StyleConstants.MENU_ANIMATION_FROM];
    } else {
      return [menuAnimation ? StyleConstants.MENU_ANIMATION_FROM : StyleConstants.MENU_ANIMATION_FROM_DEFAULT,
        StyleConstants.EDIT_MODE_NORMAL_ITEM_SCALE_RATIO_MAX];
    }
  }

  @Builder
  private menuPreviewBuilder(): CustomBuilder {
    Image(this.mPixMap ?? dragSnapshotHelper.getSnapshot(SnapshotType.DROP,
      GridLayoutUtil.generateUniqueKey(this.formItem)))
      .draggable(false)
      .width(this.mFormItemWidth)
      .height(this.mFormItemHeight)
      .borderRadius(this.formBorderRadius)
      .syncLoad(true)
      .interpolation(ImageInterpolation.Medium)
      .autoResize(false)
      .backgroundBlurStyle(SCBVisualEffectMgr.isFolderSolidColor() ? BlurStyle.NONE : BlurStyle.Thin, undefined,
        { disableSystemAdaptation: true })
  }

  private getContextMenu(mMenuPlacement: Placement | undefined, previewMode?: boolean,
    menuAnimation?: boolean): ContextMenuOptions {
    return {
      placement: mMenuPlacement,
      preview: () => {
        this.menuPreviewBuilder()
      },
      onDidDisappear: () => {
        log.showInfo('MenuBuilder onDidDisappear');
        if (this.isShowCancelDialog === true) {
          this.isShowCancelDialog = false;
        }
      },
      layoutRegionMargin: { left: 0, right: 0 },
      previewAnimationOptions: {
        scale: this.getMenuScale(menuAnimation),
        transition: this.getTransition(),
      },
      transition: this.getTransition(),
    };
  }

  private showContextMenu(responseType: ResponseType): boolean {
    let menuInfo: MenuInfo[] = MenuInfoManager.getInstance().getContextMenuListener(String(this.formItem.cardId))
    ?.onMenuBuild(CommonConstants.CONTAINER_DESKTOP, responseType) ?? [];
    if (menuInfo?.length > 0) {
      return true;
    }
    return false;
  }

  @Styles
  menuStyles() {
    .bindContextMenu(this.viewData.isMenuShow && !this.isOuterDesktop, this.showContextMenu(ResponseType.LongPress) ?
    this.MenuBuilder(ResponseType.LongPress) : (): void => {
      }, this.getContextMenu(this.mMenuPlacement, true, true))
    .bindContextMenu(this.showContextMenu(ResponseType.RightClick) ? this.MenuBuilder(ResponseType.RightClick) :
      (): void => {
      }, ResponseType.RightClick, this.getContextMenu(undefined))
  }

  @Builder
  MenuBuilder(responseType: ResponseType) {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      FormMenu({
        menuInfoList: this.getMenuInfo(responseType),
      })
        .id(`${TAG}_AppMenu_longPressMenu`)
        .width(this.isOuterDesktop ? desktopUtil.getSmallFoldFormMenuWidthColumns() :
        StyleConstants.CONTEXT_FORM_MENU_WIDTH)
        .onAppear(() => {
          log.showInfo('MenuBuilder onAppear');
          if (!this.isOnHover && responseType === ResponseType.LongPress) {
            this.isShowCancelDialog = true;
          }
          MenuInfoManager.getInstance().getContextMenuListener(String(this.formItem.cardId))
          ?.onMenuAppear?.(responseType);
          // 以上为手机PC通用场景及业务处理
          if (DeviceHelper.isPC()) {
            return;
          }
          this.mAppNameEvent.appNameDisappearAnimate(true);
          this.desktopContext?.eventHub.emit('AIBarShow', true);
        })
        .onDisAppear(() => {
          log.showInfo('MenuBuilder onDisAppear');
          this.isShowCancelDialog = false;
          this.desktopContext?.eventHub.emit('AIBarShow', false);
          AppStorage.setOrCreate<string>('notifyEnterFormManagerAnimate', this.formItem.cardId);
          MenuInfoManager.getInstance().getContextMenuListener(String(this.formItem.cardId))
          ?.onMenuDisappear?.(responseType);
          this.viewData.isMenuShow = false;
          // 以上为手机PC通用场景及业务处理
          if (DeviceHelper.isPC()) {
            return;
          }
          this.isHiddenEffect = false;
          this.mAppNameEvent.appNameDisappearAnimate(false);
          if (this.mPixMap) {
            this.mPixMap.release(() => {
              this.mPixMap = undefined;
            })
          }
        })
    }
  }
}

@Component
struct FormBackboard {
  @Prop mFormItemWidth: number;
  @Prop mFormItemHeight: number;
  @Prop mFormBackboardScale: number;
  @Prop mFormBackboardRadius: number;

  build() {
    Column() {
    }
    .width(this.mFormItemWidth)
    .height(this.mFormItemHeight)
    .borderRadius(this.mFormBackboardRadius)
    .backgroundBlurStyle(BlurStyle.Thin, { policy: 1 }, { disableSystemAdaptation: true })
    .scale({ x: this.mFormBackboardScale, y: this.mFormBackboardScale })
    .id(`${TAG}_Column_backboard`)
  }
}

@Component
struct FormMask {
  @Prop mFormItemWidth: number;
  @Prop mFormItemHeight: number;
  @Prop mFormStackMaskOpacity: number;
  @Prop dropAnimateScale: number;
  @Prop formBorderRadius: number;
  @Prop dropAnimateTranslateY: number;
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;

  build() {
    Column() {
    }
    .width(this.mFormItemWidth)
    .height(this.mFormItemHeight)
    .borderRadius(this.formBorderRadius)
    .id(`${TAG}_Column_formMask`)
    .backgroundColor(this.currColorMode === 0 ? '#e67e7f80' : '#FFD7D8D9')
    .opacity(this.mFormStackMaskOpacity)
    .scale({ x: this.dropAnimateScale, y: this.dropAnimateScale })
    .translate({ y: this.dropAnimateTranslateY })
  }
}