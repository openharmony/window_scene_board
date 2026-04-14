/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
  CommonConstants,
  DesktopManager,
  DeviceState,
  EditModeConstants,
  EditModePageUtil,
  EditModeState,
  EditModeViewState,
  EventConstants,
  LayoutViewModel,
  lockLayoutManager,
  PageInfoManager,
  StyleConstants
} from '@ohos/launchercommon';
import { LanguageUtils, LogDomain, LogHelper, SingleContext } from '@ohos/basicutils';
import {
  AccessibilityManager,
  GlobalContext,
  NegativeScreenConstants,
  ScreenState,
  ScreenStateMonitor,
  DeviceHelper,
} from '@ohos/frameworkwrapper';
import { desktopUtil, RTLUtil } from '@ohos/componenthelper';
import { PageDragManager, PageEditItemViewData, pageEditManager, PageEditViewModel } from '@ohos/launchercommon/Index';
import { DragEventCallback, DragEventManager } from '@ohos/componentdrag';
import { PageDesktopViewModel } from '../viewmodel/PageDesktopViewModel';
import SwiperPage from './SwiperPage';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import EditModePageBackplane from '@ohos/desktopedit/src/main/ets/default/view/EditModePageBackplane';
import {
  EditModeDeleteBlankPageButton
} from '@ohos/desktopedit/src/main/ets/default/view/EditModeDeleteBlankPageButton';
import lazy OuterEditModePageBackplane from '@ohos/desktopedit/src/main/ets/default/view/OuterEditModePageBackplane';
import { editModeViewManager } from '@ohos/desktopedit/src/main/ets/default/manager/EditModeViewManager';
import { EditModeSingePageViewData } from '@ohos/desktopedit/src/main/ets/default/data/EditModeSingePageViewData';
import { EditModeExtensionData } from '@ohos/desktopedit/src/main/ets/default/data/EditModeExtensionData';
import { SwiperLoadData } from '@ohos/swiperdata/src/main/ets/TsIndex';
import { EditModeAccessibilityUtil } from '@ohos/launchercommon/src/main/ets/editmode/utils/EditModeAccessibilityUtil';
import accessibility from '@ohos.accessibility';
import { SCBConstants } from '@ohos/commonconstants';
import { DisplayCountData } from '@ohos/launchercommon/src/main/ets/displaycount/DisplayCountData';
import { DisplayCountViewModel } from '@ohos/launchercommon/src/main/ets/displaycount/DisplayCountViewModel';
import { EditModeHomePageButton } from '@ohos/desktopedit';

const TAG = 'SingePage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

class MyStackModifier implements AttributeModifier<StackAttribute> {
  public zIndex: number = 0;
  applyNormalAttribute(instance: StackAttribute): void {
    instance.zIndex(this.zIndex);
  }
}

@Component
export default struct SinglePage {
  @Prop singleContext?: SingleContext;
  private swiperKey: number = 0;
  @Link homeSwiperKey: number;
  private mPageDesktopViewModel?: PageDesktopViewModel;
  @Prop gridConfig: string | undefined;
  @State @Watch('onIndexChange') index: number = 0;
  @StorageLink('systemLanguage') @Watch('onLanguageChange') language: string = '';
  @State editModeState: EditModeState = editModeManager.getEditModeState();
  @State editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
  private panOptionStack: PanGestureOptions = new PanGestureOptions({
    distance: NegativeScreenConstants.PAN_GESTURE_MIN_DISTANCE,
    direction: LanguageUtils.isMirrorLanguage() ? PanDirection.Left : PanDirection.Right
  });
  @StorageLink('assistantIsOn') @Watch('assistantButtonChange') assistantIsOn: boolean = true;
  private desktopContext: ServiceExtensionContext = GlobalContext.getContext();
  private isDisableSwiperToIntelligent?: Function;
  private isDesktopLayout: boolean = true;
  @StorageLink('folderStatus') @Watch('folderStatusChange') folderStatus: number = DeviceState.DEFAULT_STATE;
  private onDesktopModeChangeEvent: Function = (): void => this.onDesktopModeChange();
  private onRTLChangeEvent: Function = (): void => this.updateCenterX();
  @State editModeViewState: EditModeViewState = editModeManager.getEditModeViewState();
  @State editModeSingePageViewData: EditModeSingePageViewData = editModeViewManager.getEditModeSingePageViewData();
  @State scaleCenterX: string = StyleConstants.PERCENTAGE_50;
  @StorageLink('foldStatusForOuterScreen') @Watch('folderStatusChange') foldStatusForOuterScreen: number =
    DeviceState.DEFAULT_STATE;
  @State modifier: MyStackModifier = new MyStackModifier();
  @State isInDrag: boolean = false;
  @State isCurrentPageBlank: boolean = false;
  // 是否处于编辑模式
  @State isInEditMode: boolean = editModeManager.isInEditMode();
  private mDragEventCallback: DragEventCallback = {};
  private itemKey: string = '';
  private onUpdateDeleteButtonShowState: Function = (): void => this.updateDeleteButtonShowState();
  @State pageEditItemViewData: PageEditItemViewData = new PageEditItemViewData();
  private singleHandChange: () => void = () => this.folderStatusChange();
  private onPageIndexShowedChange: Function = (): void => this.updateAccessibilityFocusable();
  @Prop @Watch('updateAccessibilityFocusable') pagesLength: number = 0;
  @State mAccessibilityFocusable: boolean = false;
  @Prop @Watch('displayCountDataChange') displayCountData: DisplayCountData =
    DisplayCountViewModel.getInstance().getDisplayCountData();
  /**
   * 监听负一屏开关的打开情况，使 priorityGesture 生效或失效
   */
  assistantButtonChange() {
    if (this.assistantIsOn) {
      log.showDebug('priorityGesture is take effect');
      this.panOptionStack.setDirection(PanDirection.Right);
      this.panOptionStack.setDistance(NegativeScreenConstants.PAN_GESTURE_MIN_DISTANCE);
    } else {
      log.showDebug('priorityGesture is unEffect');
      this.panOptionStack.setDirection(PanDirection.None);
      this.panOptionStack.setDistance(100);
    }
  }

  updateAccessibilityFocusable() {
    const isAccessibilityMode: boolean = AccessibilityManager.getInstance().getIsAccessibilityMode();
    if (!this.editModeState.isInEditMode()) {
      this.mAccessibilityFocusable = true;
      return;
    }
    if (isAccessibilityMode) {
      const pages: number[] = SwiperLoadData.getInstance().getPages();
      let mainPageIndex: number = desktopUtil.getPageIndexValue();
      log.showInfo(`onPageIndexShowedChange pages: ${pages}, swiperKey: ${this.swiperKey}, currentShowPage: ${desktopUtil.getPageIndexValue()}`);
      this.mAccessibilityFocusable = PageInfoManager.getInstance().isCurrentPageShow(this.index, mainPageIndex);
      if (this.mAccessibilityFocusable) {
        try {
          let eventInfo: accessibility.EventInfo = ({
            type: 'requestFocusForAccessibilityNotInterrupt',
            bundleName: 'com.ohos.sceneboard',
            triggerAction: 'common',
            customId: EditModeAccessibilityUtil.getEditModeBackPlaneId(this.swiperKey)
          });
          accessibility.sendAccessibilityEvent(eventInfo);
          log.showInfo(`requestFocus: ${EditModeAccessibilityUtil.getEditModeBackPlaneId(this.swiperKey)}`);
        } catch {
          log.showError('requestFocus error');
        }
      }
    }
  }

  private isOpenPanGesture(): boolean {
    if (editModeManager.isInEditMode()) {
      return false;
    }
    if (this.index === 0) {
      return true;
    }
    if (this.index === 1 && this.folderStatus === DeviceState.EXPAND_STATE) {
      return true;
    }
    if (this.index === 2 && this.folderStatus === DeviceState.EXPAND_STATE &&
      this.displayCountData.getDisplayCount() === StyleConstants.DEFAULT_3 &&
      ScreenStateMonitor.getInstance().getCurrentScreenStateModel().screenState === ScreenState.G) {
      return true;
    }
    return false;
  }

  /**
   * 更新主页持久化数据
   */
  private updateHomePage() {
    if (this.homeSwiperKey === this.swiperKey) {
      PageInfoManager.getInstance().setHomePageIndex(this.index, LayoutViewModel.getInstance().isSimpleLauncherMode());
    }
  }

  private onIndexChange() {
    this.updateHomePage();
    this.panGestureSetup();
  }

  panGestureSetup() {
    this.folderStatus = AppStorage.get('folderStatus') as number;
    if (AppStorage.get('device') as string === CommonConstants.DEFAULT_DEVICE_TYPE) {
      if (this.isOpenPanGesture()) {
        this.panOptionStack.setDirection(PanDirection.Right);
        if (LanguageUtils.isMirrorLanguage()) {
          this.panOptionStack.setDirection(PanDirection.Left);
        }
        this.panOptionStack.setDistance(NegativeScreenConstants.PAN_GESTURE_MIN_DISTANCE);
      } else {
        log.showDebug('priorityGesture is unEffect');
        this.panOptionStack.setDirection(PanDirection.None);
        this.panOptionStack.setDistance(100);
      }
    } else {
      log.showDebug('priorityGesture is unEffect');
      this.panOptionStack.setDirection(PanDirection.None);
      this.panOptionStack.setDistance(100);
    }
  }

  private initZIndex():void {
    if (this.isMidPage()) {
      this.modifier.zIndex = -1;
    } else if (DeviceHelper.isBigScreenMachine()) {
      this.modifier.zIndex = this.pagesLength - this.index;
    } else {
      this.modifier.zIndex = this.index;
    }
  }

  private onLanguageChange() {
    log.showInfo(`onLanguageChange language: ${this.language}`);
    this.panGestureSetup();
  }

  aboutToAppear(): void {
    this.initZIndex();
    this.itemKey = PageDragManager.getInstance().getPageUniqueKey(this.index);
    this.folderStatusChange();
    DesktopManager.getInstance().registerScreenChangeListener(this.singleHandChange);
    this.desktopContext.eventHub.on(EventConstants.EVENT_CHANGE_DESKTOP_MODE_LAYOUT, this.onDesktopModeChangeEvent);
    RTLUtil.registerRtlChangeCallback(this.onRTLChangeEvent);
    this.desktopContext?.eventHub.on(EditModeConstants.EVENT_FOLD_EXPAND_DUAL_SQUEEZED,
      this.onFoldExpandDualSqueezed);
    // 页面拖拽动效viewData注册
    PageEditViewModel.getInstance().singlePageItemObserver.register(this.itemKey, this.pageEditItemViewData);
    this.updateDeleteButtonShowState();
    log.showInfo(`isCurrentPageBlank ${this.isCurrentPageBlank} index ${this.index}`);
    this.desktopContext?.eventHub.on(EditModeConstants.UPDATE_BLANK_PAGE_LIST, this.onUpdateDeleteButtonShowState);
    this.desktopContext?.eventHub.on(EventConstants.EVENT_UPDATE_PAGE_FOCUS, this.onPageIndexShowedChange);
    this.desktopContext?.eventHub.on(SCBConstants.IS_ACCESSIBILITY_MODE_OPEN, this.onPageIndexShowedChange);
    this.registerDragEvent();
    this.updateAccessibilityFocusable();
    this.isInEditMode = editModeManager.isInEditMode();
  }

  aboutToDisappear(): void {
    log.showInfo(`singePage aboutToDisappear index ${this.index}`);
    DesktopManager.getInstance().unregisterScreenChangeListener(this.singleHandChange);
    this.desktopContext.eventHub.off(EventConstants.EVENT_CHANGE_DESKTOP_MODE_LAYOUT, this.onDesktopModeChangeEvent);
    RTLUtil.unregisterRtlChangeCallback(this.onRTLChangeEvent);
    this.desktopContext?.eventHub.off(EditModeConstants.EVENT_FOLD_EXPAND_DUAL_SQUEEZED,
      this.onFoldExpandDualSqueezed);
    this.desktopContext?.eventHub.off(EditModeConstants.UPDATE_BLANK_PAGE_LIST, this.onUpdateDeleteButtonShowState);
    this.unRegisterDragEvent();
    PageEditViewModel.getInstance().singlePageItemObserver.unregister(this.itemKey);
    this.desktopContext?.eventHub.off(EventConstants.EVENT_UPDATE_PAGE_FOCUS, this.onPageIndexShowedChange);
    this.desktopContext?.eventHub.off(SCBConstants.IS_ACCESSIBILITY_MODE_OPEN, this.onPageIndexShowedChange);
  }

  private registerDragEvent(): void {
    this.mDragEventCallback = {
      onItemDragStartEvent: (): void => {
        log.showInfo('onItemDragStartEvent, itemKey = %{public}s', this.itemKey);
        this.isInDrag = true;
        if (this.isMidPage()) {
          this.modifier.zIndex = -1;
        } else {
          this.modifier.zIndex = this.swiperKey === pageEditManager.dragPageData.startDragPageSwiperKey ? -1 : 0;
        }
      },
      onItemDropEndEvent: (): void => {
        log.showInfo('onItemDropEndEvent, itemKey = %{public}s', this.itemKey);
        this.isInDrag = false;
        if (this.isMidPage()) {
          this.modifier.zIndex = -1;
        } else {
          this.modifier.zIndex = 0;
        }
      },
      onStartSqueezedEvent: (translatePosition: number[][]): void => {
        if (translatePosition == null) {
          log.showError('onStartSqueezedEvent with invalid error');
          return;
        }
        const translateX: number = translatePosition[1][0] - translatePosition[0][0];
        log.showInfo('onStartSqueezedEvent key:%{public}s translateX:%{public}d', this.itemKey, translateX);
        PageEditViewModel.getInstance()
          .onAddingOrDeletingPageForAnimate(translateX, this.index, this.getUIContext(), false);
      },
      onCancelSqueezedEvent: (withAnimation: boolean): void => {
        log.showInfo('onCancelSqueezedEvent key:%{public}s withAnimation:%{public}s', this.itemKey, withAnimation);
        if (withAnimation) {
          PageEditViewModel.getInstance()
            .onAddingOrDeletingPageForAnimate(0, this.index, this.getUIContext(), false);
          return;
        }
        PageEditViewModel.getInstance().recoverPageTranslateX(this.index, false);
      }
    };
    DragEventManager.getInstance().registerDragEvent(this.mDragEventCallback, this.itemKey);
  }

  private isMidPage(): boolean {
    return (this.displayCountData.getDisplayCount() === StyleConstants.DEFAULT_3) &&
      (this.index % StyleConstants.DEFAULT_3 === StyleConstants.DEFAULT_1);
  }

  private unRegisterDragEvent(): void {
    DragEventManager.getInstance().unRegisterDragEvent(this.mDragEventCallback, this.itemKey);
  }

  private onFoldExpandDualSqueezed = (pageIndex: number) => {
    log.showInfo(`onFoldExpandDualSqueezed ${pageIndex}`);
    if (this.isMidPage()) {
      this.modifier.zIndex = -1;
      return;
    }
    if (this.modifier.zIndex === 0 && this.index !== pageIndex) {
      return;
    }
    if (this.index === pageIndex) {
      this.modifier.zIndex = 1;
    } else {
      this.modifier.zIndex = 0;
    }
  };

  private onDesktopModeChange(): void {
    this.updateDeleteButtonShowState();
    this.updateHomePageBtnShowState();
    this.panGestureSetup();
  }

  private displayCountDataChange(): void {
    this.updateCenterX();
    //  对于超大屏来说，折叠展开的时候需要刷新下第3屏是否需要拉起负一屏
    if (this.index === 2) {
      this.panGestureSetup();
    }
  }

  private updateCenterX(): void {
    this.initZIndex();
    this.scaleCenterX = EditModePageUtil.getScaleCenterX(this.index, this.displayCountData.getDisplayCount());
    log.showInfo('onDesktopModeChange index: %{public}d, scaleCenterX: %{public}s', this.index, this.scaleCenterX);
  }

  private folderStatusChange(): void {
    this.panGestureSetup();
    this.updateCenterX();
  }

  /**
   * 更新设置主页按钮展示状态
   */
  private updateHomePageBtnShowState(): void {
    this.isInEditMode = editModeManager.isInEditMode();
  }

  private updateDeleteButtonShowState(): void {
    if (!editModeManager.isInEditMode()) {
      this.isCurrentPageBlank = false;
      return;
    }
    log.showInfo(`isLargeFoldExpand ${EditModePageUtil.getIsFoldExpandStatus()}`);
    const isLargeFoldExpand: boolean = EditModePageUtil.getIsFoldExpandStatus();
    const pages = SwiperLoadData.getInstance().getPages().slice(0);
    const currentDisplayCount = DisplayCountViewModel.getInstance().getDisplayCount();
    if (!isLargeFoldExpand || (isLargeFoldExpand && pages.indexOf(this.swiperKey) % currentDisplayCount === 1)) {
      this.isCurrentPageBlank = PageEditViewModel.getInstance().isCurrentPageBlank(this.swiperKey, );
      return;
    }
    this.isCurrentPageBlank = false;
    return;
  }

  build() {
    Stack() {
      if (this.editModeViewState.isShowEditModeView()) {
          EditModePageBackplane({
            index: this.index?.valueOf(),
            swiperKey: this.swiperKey,
          })
      }

      // 编辑模式
      if (editModeManager.isShowHomePageButton(this.isInEditMode, this.index)) {
        EditModeHomePageButton({
          index: this.index,
          swiperKey: this.swiperKey,
          homeSwiperKey: this.homeSwiperKey
        })
      }

      if (this.isCurrentPageBlank && !lockLayoutManager.isLockLayout() &&
        !PageInfoManager.getInstance().isHomePage(this.index, this.homeSwiperKey)) {
        EditModeDeleteBlankPageButton({
          index: this.index,
          swiperKey: this.swiperKey,
          singleContext: this.singleContext
        })
      }
      SwiperPage({
        singleContext: this.singleContext,
        indexInSwiper: $index,
        swiperKey: this.swiperKey,
        gridConfig: this.gridConfig,
        mPageDesktopViewModel: this.mPageDesktopViewModel,
        isDesktopLayout: this.isDesktopLayout,
        isDisableSwiperToIntelligent: this.isDisableSwiperToIntelligent,
        panOptionStack: this.panOptionStack,
      })
    }
    .visibility(this.isInDrag ? Visibility.Hidden : Visibility.Visible)
    .translate({ x: this.pageEditItemViewData.translateX })
    .scale({
      x: this.editModeSingePageViewData.getSingePageSwiperScale() * this.pageEditItemViewData.pageScale,
      y: this.editModeSingePageViewData.getSingePageSwiperScale() * this.pageEditItemViewData.pageScale,
      centerX: this.scaleCenterX,
      centerY: StyleConstants.PERCENTAGE_50,
    })
    .attributeModifier(this.modifier)
    .accessibilityLevel(this.mAccessibilityFocusable ? 'auto' : 'no-hide-descendants')
  }
}