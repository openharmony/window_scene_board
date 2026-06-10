/**
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
  DomainName,
  LogHelper,
  TraceUtil,
  AnimateToScheduleUtils,
  UIContextHelper,
  SingleContext
} from '@ohos/basicutils';
import {
  GlobalContext,
  HiSysEventUtil,
  ViewManagerPolicy,
  viewMgrPolicy,
  ViewType,
  ViewCallback,
  ApsUtils,
} from '@ohos/frameworkwrapper';
import { BaseViewController } from '@ohos/frameworkcommon';
import {
  SCBPropertyChangeReason,
  SCBScreenProperty,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  FocusChangeReason
} from '@ohos/windowscene';
import { curves } from '@kit.ArkUI';
import { LayoutViewModel, StyleConstants } from '@ohos/launchercommon';
import { AcDragStatusMgr, AppCenterDynamicEffects, AppGridLayout } from '@ohos/appcenter';
import { AppGridPresenter } from '@ohos/appcenter';
import { AppCenterModel } from '@ohos/launchercommon';
import { AppCenterViewModel } from '@ohos/appcenter';
import KeyCodeConstants from '@ohos/multiinput/src/main/ets/default/common/constants/KeyCodeConstants';
import {
  AccountHelper,
  SwitchEventData
} from '@ohos/screenlockcommon'
import PowerStatusChangeAnimationController from '../scenemanager/PowerStatusChangeAnimationController';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { KeyCode } from '@kit.InputKit';
import inputMethod from '@ohos.inputMethod';
import { AppCenterDragMgr } from '@ohos/appcenter/src/main/ets/default/controller/AppCenterDragMgr';
import { SCBDefaultZIndex } from '../scenemanager/SCBScreen';
import AppGridLayoutUtil from '@ohos/appcenter/src/main/ets/default/common/util/AppGridLayoutUtil';
import { FoldedDeviceAcViewModel } from '@ohos/appcenter/src/main/ets/default/folded/FoldedDeviceAcViewModel';
import { SCBFoldedState } from '@ohos/appcenter/src/main/ets/default/folded/FoldedDeviceAcViewModel';
import { MultiInputViewModel } from '@ohos/multiinput';
import { SystemAnimatedScene, systemAniSceneCtrl } from '@ohos/pcmode';
import { AppLayoutInfo } from '@ohos/appcenter/src/main/ets/default/common/viewmodel/AppLayoutInfo';
import { RecentAndAppCenterSwitchManager } from '../../common/manager/RecentAndAppCenterSwitchManager';
import { EVENT_ENABLE_DRAG_STATE_CHANGE, APP_CENTER_SWIPER_KEY } from '@ohos/appcenter/src/main/ets/default/constants/LayoutConstants';
import { CloneWallpaperMgr } from './ViewModel/CloneWallpaperMgr';
import { SCBScreenSessionArray } from '@ohos/windowscene';
import { ModeChangeUtils } from '@ohos/frameworkwrapper/src/main/ets/utils/ModeChangeUtils';
import { Queue } from '@kit.ArkTS';

const TAG = 'SCBAppCenterView';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const START_CURVE: ICurve = curves.cubicBezierCurve(0.1, 0, 0.4, 1);
const HIDE_OPACITY_CURVE: ICurve = curves.cubicBezierCurve(0.7, 0, 0.7, 1);
const HIDE_OPACITY_CURVE_TIME_AJUSTMENT: number = 200;
const START_ANIMATE_TIME = 200;
const APPCENTER_SEARCH_INPUT_KEY = 'AppCenter_Search_Input';
const DEFAULT_CARET_COLOR = $r('sys.color.font_on_primary');
const REFOCUS_TO_EXIT_DELAY = 200;
const DELAY_HANDLE_CHANGE_WHEN_EXIT = 300;
const HIDE_WALLPAPER_DELAY = 100;
const SHOW_ICON_DELAY = 70;
const HIDE_ICON_AND_TRANSLATION_TIME_HPR = 200;
const SEARCH_APP_INPUT_POY = -123;
const SEARCH_INPUT_OPACITY_DURATION = 150;
const SEARCH_INPUT_OPACITY_CURVE = curves.cubicBezierCurve(0.33, 0, 0.67, 1);
const SEARCH_INPUT_SHOW_DELAY = 20;
const DELAY_STEP = 50;
const HIDE_ANIM_END_RESET_DELAY = 300;

@Component
export struct SCBAppCenterView {
  persistentId: number = 0;
  @Prop
  screenProp: SCBScreenProperty;
  @State singleContext?: SingleContext = { extendScreenId: this.screenProp.screenId };
  @State
  appCenterController: BaseViewController = this.getAppCenterCtrl(this.screenProp.screenId);
  @State
  workSpaceHeight: number = 0;
  @State
  dockHeight: number = 0;
  @State
  indicatorHeight: number = 0;
  private mLayoutViewModel: LayoutViewModel | null = null;
  @StorageLink('openAppCenterPageIndex')
  curOpenPageIndex: number = 0;
  @StorageLink('isLock') @Watch('onLock') isLock: boolean = true;
  @State
  private mScreenHeight: number = 0;
  private mAppGridPresenter: AppGridPresenter | null = null;
  private appItemPosX: number[] = [];
  private rtlAppItemPosX: number[] = [];
  private appItemPosY: number[] = [];
  private appItemOpacity: number[] = [];
  @State bkOpacity: number = 0;
  private timeAsc: number[] = [];
  private timeDesc: number[] = [];
  private appItemEdgePos: Array<Array<number>> = [];
  private circleMap: Map<number, number[]> = new Map();
  private inputRequestFocusTime: number = 500;
  private viewCallback: ViewCallback = {
    onShow: (): void => this.onViewShow(),
    onHide: (): void => this.onViewHide()
  };
  mTimeMeter: number = 0;
  mTimeIntoAppCenter: number = 0;
  swiperPaddingTop = 0;
  @StorageLink('engineThemeStatic')
  engineThemeStatic: boolean = true;
  @State
  searchInputText: string = '';
  @State
  arrowIsHover: boolean = false;
  @State isGainFocus: boolean = false;
  private isWallpaperChanged: boolean = false;
  @State isFocusAble: boolean = false;
  private opacityTimeAsc: number[] = [];
  private currentScreenHeight: number = this.screenProp.height;
  private currentScreenWidth: number = this.screenProp.width;
  @StorageLink('isAppCenterShow') @Watch('onAppCenterShow') isAppCenterShow: boolean = AppStorage.get<boolean>('isAppCenterShow') ?? false;
  private isFolded: boolean = false;
  @State isEnterKeyEvent: boolean = false;
  private initializedAnimationData: boolean = false;
  @State searchAppInputPosY: number = 0;
  private onSwipeStateChangeCallback: Function | undefined = undefined;
  private showSearchInputTimerId: number | undefined = undefined;
  private hideAnimTranslateTimerId: number | undefined = undefined;
  private hideAnimOpacityTimerId: number | undefined = undefined;
  @StorageLink('isAppCenterSwiping') @Watch('onSwipeStateChange') isSwiping: boolean = false;
  private isSearchInputDefaultFocus: boolean = !ModeChangeUtils.isSupportWindowPcModeSwitch();
  onSwipeStateChange(): void {
    this.onSwipeStateChangeCallback?.(this.isSwiping);
  }

  onAppCenterShow(): void {
    if (RecentAndAppCenterSwitchManager.getInstance().getAppCenterViewHiding() &&
      this.isAppCenterShow &&
      viewMgrPolicy.isViewShowing(this.getViewType())) {
      log.showWarn('appCenterViewHiding is terminated by show');
      this.onViewShow();
    } else if (AppStorage.get<boolean>('isCtrlAltDelPanelShow') && !this.isAppCenterShow) {
      // 后续需要结合双中心切换优化应用中心无动画关闭
      log.showWarn('onAppCenterShow. hide app center from CtrlAltDelPanel');
      viewMgrPolicy.hideView(this.getViewType());
      CloneWallpaperMgr.getInstance(this.screenProp.screenId).hideAll();
    }
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear isSearchInputDefaultFocus: ${this.isSearchInputDefaultFocus}`);
    UIContextHelper.setContext(this.screenProp.screenId, this.getUIContext());
    viewMgrPolicy.registerViewController(this.getViewType(), this.appCenterController);
    AccountHelper.getInstance().registerUserSwitchListener('switching', this.onSwitchingUser);
    this.appCenterController.updateId(this.persistentId);
    this.mLayoutViewModel = LayoutViewModel.getInstance(this.singleContext);
    this.updateScreenSize();
    let isFolded = false;
    FoldedDeviceAcViewModel.getInstance().setIsFoldedDevice(isFolded);
    this.mAppGridPresenter = AppGridPresenter.getInstance();
    log.showWarn('registerAppListChange');
    this.mAppGridPresenter.registerAppListChange(this.screenProp.screenId);

    this.circleMap = AppCenterViewModel.getInstance().getCircleMap();
    this.timeAsc = AppCenterViewModel.getInstance().getTimeAsc();
    this.timeDesc = AppCenterViewModel.getInstance().getTimeDesc();
    this.appItemEdgePos = AppCenterViewModel.getInstance().getAppItemEdgePos();
    this.setOpacityTimeAsc();
    this.initGlobalHideAnimation();
    this.initHideAnimation();

    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
    LayoutViewModel.getInstance(this.singleContext)
      .registerRefreshLayoutCallback(this.screenProp.screenId, this.refreshAppCenterLayout);
    this.doRefreshAppCenterLayout();

    this.appCenterController.registerCallback(this.viewCallback);
    this.registerTransparentDetection();
    this.initFoldedDevice();
    GlobalContext.getContext()?.eventHub.on(EVENT_ENABLE_DRAG_STATE_CHANGE, this.onEnableDragStateChange);
    if (isFolded) {
      this.onSwipeStateChangeCallback = (isSwiping: boolean) => {
        log.showInfo(`onSwipeStateChangeCallback ${isSwiping}`);
        if (isSwiping) {
          if (this.showSearchInputTimerId !== undefined) {
            clearTimeout(this.showSearchInputTimerId);
            this.showSearchInputTimerId = undefined;
          }
          if (this.bkOpacity === 0) {
            return;
          }
          animateTo({
            duration: SEARCH_INPUT_OPACITY_DURATION,
            curve: SEARCH_INPUT_OPACITY_CURVE
          }, () => {
            this.bkOpacity = 0;
          });
        } else {
          if (this.showSearchInputTimerId !== undefined) {
            return;
          }
          this.showSearchInputTimerId = setTimeout(() => {
            this.showSearchInputTimerId = undefined;
            if (this.bkOpacity === AppCenterViewModel.APP_CENTER_BK_OPACITY) {
              return;
            }
            animateTo({
              duration: SEARCH_INPUT_OPACITY_DURATION,
              curve: SEARCH_INPUT_OPACITY_CURVE
            }, () => {
              this.bkOpacity = AppCenterViewModel.APP_CENTER_BK_OPACITY;
            });
          }, SEARCH_INPUT_SHOW_DELAY);
        }
      };
    }
  }

  private setOpacityTimeAsc(): void {
    if (!FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      this.opacityTimeAsc = AppCenterViewModel.getInstance().getTimeAsc();
      return;
    }
    this.opacityTimeAsc =
      FoldedDeviceAcViewModel.getInstance().isUnFolded() ?
      FoldedDeviceAcViewModel.getInstance().getUnFoldedOpacityTimeAsc() :
      FoldedDeviceAcViewModel.getInstance().getFoldedOpacityTimeAsc();
  }

  private onSwitchingUser = (switchData: SwitchEventData) => {
    this.hideAppCenterImmediately('onSwitchingUser');
    log.showInfo(`receive user switching, <${switchData?.fromAccountId} -> ${switchData?.toAccountId}>`);
  }

  private onEnableDragStateChange = (enableDrag: boolean): void => {
    log.showInfo(`onEnableDragStateChange enableDrag: ${enableDrag}`);
    this.isFocusAble = enableDrag;
  }

  private updateAnimationDataWithFoldedStateChange(): void {
    log.showInfo(`updateAnimationDataWithFoldedStateChange ${this.screenProp.screenId}-${AppCenterDragMgr.getInstance().getAppCenterViewShow()}`);
    if (AppCenterDragMgr.getInstance().getAppCenterViewShow()) {
      for (let index = 0; index < this.appItemPosX.length; index++) {
        this.appItemPosX[index] = this.appItemEdgePos[index][0];
        this.appItemPosY[index] = this.appItemEdgePos[index][1];
        this.rtlAppItemPosX[index] = this.appItemEdgePos[index][2];
        this.searchAppInputPosY = SEARCH_APP_INPUT_POY;
      }
      this.resetAnimationDataWithFoldedState();
      for (let index = 0; index < this.appItemPosX.length; index++) {
        this.appItemPosX[index] = 0;
        this.rtlAppItemPosX[index] = 0;
        this.appItemPosY[index] = 0;
        this.appItemOpacity[index] = 1;
        this.searchAppInputPosY = 0;
      }
    } else {
      this.resetAnimationDataWithFoldedState();

      // 重置Hopper的首两页动效数据
      this.resetFoldAnimationData4FirstPages();
    }
  }
  private resetFoldAnimationData4FirstPages(): void {
    log.showInfo(`resetFoldAnimationData4FirstPages-${this.screenProp.screenId}`);
    let detMap = AppCenterViewModel.getInstance().getDynamicEffectMap(this.screenProp.screenId, false);
    if (!detMap) {
      log.showWarn(`resetFoldAnimationData4FirstPages-no det map exist-${this.screenProp.screenId}`);
      return;
    }

    let det0 = detMap?.get(0);
    if (!det0) {
      log.showWarn(`resetFoldAnimationData4FirstPages-page 0 not in map-${this.screenProp.screenId}`);
      return;
    }

    if (det0.getAppItemPosX().length < this.appItemPosX.length ||
      det0.getAppItemOpacity().length < this.appItemOpacity.length) {
      log.showWarn(`resetFoldAnimationData4FirstPages-0-opa or txl size invalid-${det0.getAppItemOpacity().length}`);
      return;
    }

    for (let index = 0; index < this.appItemOpacity.length; index++) {
      det0.getAppItemOpacity()[index] = 0;
    }

    for (let index = 0; index < this.appItemPosX.length; index++) {
      det0.getAppItemPosX()[index] = this.appItemEdgePos[index][0];
      det0.getAppItemPosY()[index] = this.appItemEdgePos[index][1];
      det0.getRtlAppItemPosX()[index] = this.appItemEdgePos[index][2];
    }

    let det1 = detMap?.get(1);
    if (!det1) {
      log.showInfo(`resetFoldAnimationData4FirstPages-page 1 not in map-${this.screenProp.screenId}`);
      return;
    }

    if (det1.getAppItemPosX().length < this.appItemPosX.length ||
      det1.getAppItemOpacity().length < this.appItemOpacity.length) {
      log.showWarn(`resetFoldAnimationData4FirstPages-1-opa or txl size invalid-${det1.getAppItemOpacity().length}`);
      return;
    }

    for (let index = 0; index < this.appItemOpacity.length; index++) {
      det1.getAppItemOpacity()[index] = 0;
    }

    for (let index = 0; index < this.appItemPosX.length; index++) {
      det1.getAppItemPosX()[index] = this.appItemEdgePos[index][0];
      det1.getAppItemPosY()[index] = this.appItemEdgePos[index][1];
      det1.getRtlAppItemPosX()[index] = this.appItemEdgePos[index][2];
    }
  }

  private resetAnimationDataWithFoldedState(): void {
    let cs: SCBFoldedState = FoldedDeviceAcViewModel.getInstance().getCurrentFoldState();
    if (cs === SCBFoldedState.UNFOLDED_HORIZONTAL || !this.isMainScreen(this.screenProp.screenId)) {
      this.appItemPosX = FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).getFoldedHorizontalAppItemPosX();
      this.rtlAppItemPosX = FoldedDeviceAcViewModel.getInstance(
        this.screenProp.screenId).getFoldedHorizontalAppItemRtlPosX();
      this.appItemPosY = FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).getFoldedHorizontalAppItemPosY();
      this.circleMap = FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).getFoldedHorizontalCircleMap();
      this.appItemEdgePos = FoldedDeviceAcViewModel.getInstance(
        this.screenProp.screenId).getFoldedHorizontalAppItemEdgePos();
      this.timeAsc = FoldedDeviceAcViewModel.getInstance().getFoldedTimeAsc();
      this.opacityTimeAsc = FoldedDeviceAcViewModel.getInstance().getUnFoldedOpacityTimeAsc();
    } else if (cs === SCBFoldedState.UNFOLDED_VERTICAL) {
      this.appItemPosX = FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).getFoldedVerticalAppItemPosX();
      this.rtlAppItemPosX = FoldedDeviceAcViewModel.getInstance(
        this.screenProp.screenId).getFoldedVerticalAppItemRtlPosX();
      this.appItemPosY = FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).getFoldedVerticalAppItemPosY();
      this.circleMap = FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).getFoldedVerticalCircleMap();
      this.appItemEdgePos = FoldedDeviceAcViewModel.getInstance(
        this.screenProp.screenId).getFoldedVerticalAppItemEdgePos();
      this.timeAsc = FoldedDeviceAcViewModel.getInstance().getFoldedTimeAsc();
      this.opacityTimeAsc = FoldedDeviceAcViewModel.getInstance().getUnFoldedOpacityTimeAsc();
    } else {
      this.appItemPosX = FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).getFoldedDefaultAppItemPosX();
      this.rtlAppItemPosX = FoldedDeviceAcViewModel.getInstance(
        this.screenProp.screenId).getFoldedDefaultAppItemRtlPosX();
      this.appItemPosY = FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).getFoldedDefaultAppItemPosY();
      this.circleMap = FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).getFoldedDefaultCircleMap();
      this.appItemEdgePos = FoldedDeviceAcViewModel.getInstance(
        this.screenProp.screenId).getFoldedDefaultAppItemEdgePos();
      this.timeAsc = FoldedDeviceAcViewModel.getInstance().getFoldedTimeAsc();
      this.opacityTimeAsc = FoldedDeviceAcViewModel.getInstance().getFoldedOpacityTimeAsc();
    }

    // 兼容扩展屏场景
    AppCenterViewModel.getInstance().setAppItemEdgePosForFold(this.appItemEdgePos);
  }

  private initFoldedDevice(): void {
    let isFolded = false;
    FoldedDeviceAcViewModel.getInstance().setIsFoldedDevice(isFolded);
    AppGridLayoutUtil.initInstance(isFolded);
    if (isFolded) {
      this.isFolded = true;
      this.inputRequestFocusTime = 100;
      FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).recalculateAcDraggableAreaBottom(
        AppCenterViewModel.getInstance().getAppGridStyleConfig(this.screenProp.screenId));
      FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).initFoldedAnimationData();
      this.appItemOpacity = FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).getFoldedAppItemOpacity();
      this.timeAsc = FoldedDeviceAcViewModel.getInstance().getFoldedTimeAsc();
      this.updateAnimationDataWithFoldedStateChange();
      AppGridLayoutUtil.setExtraPaddingTopOffset(
        FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).getSwiperItemSpace(), this.screenProp.screenId);
    }
  }

  private registerTransparentDetection(): void {
    const session = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId);
    session?.registerContextTransparentCallback(() => {
      log.showError('window is transparency!!');
    })
  }

  private doRefreshAppCenterLayout = () => {
    log.showInfo(`do refreshAppCenterLayout: ${this.screenProp.screenId}`);
    this.updateScreenSize();
    AppCenterViewModel.getInstance().getAppGridStyleConfig(this.screenProp.screenId).initConfig(
      this.screenProp.screenId, true, this.screenProp.width, this.screenProp.height);
    if (this.initializedAnimationData) {
      return;
    }
    let effects: AppCenterDynamicEffects | undefined =
      AppCenterViewModel.getInstance().initAnimationData();
    if (effects) {
      this.appItemPosX = effects.getAppItemPosX();
      this.rtlAppItemPosX = effects.getRtlAppItemPosX();
      this.appItemPosY = effects.getAppItemPosY();
      this.appItemOpacity = effects.getAppItemOpacity();
      this.bkOpacity = effects.getBkOpacity();
    }
    this.initializedAnimationData = true;
  }

  private refreshAppCenterLayout = () => {
    log.showInfo('refreshAppCenterLayout');
    if (!FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      this.doRefreshAppCenterLayout();
    } else {
      let newH = this.getUIContext()?.px2vp(this.screenProp.height) as number;
      log.showInfo(`refreshAppCenterLayout-hpr-${this.mScreenHeight}-${newH}`);
      if (FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).isRotating(this.mScreenHeight, newH)) {
        log.showInfo('refreshAppCenterLayout ignore');
      } else {
        this.doRefreshAppCenterLayout();
      }
    }
  }

  onScreenPropertyChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    if (this.screenProp.screenId !== screenProperty.screenId) {
      log.showInfo(`screen id not equal: ${this.screenProp.screenId} ${screenProperty.screenId}`);
      return;
    }
    if (this.currentScreenHeight === screenProperty.height &&
      this.currentScreenWidth === screenProperty.width) {
      log.showInfo('screen width or height not change');
      return;
    }
    this.currentScreenHeight = screenProperty.height;
    this.currentScreenWidth = screenProperty.width;
    this.updateScreenSize();
    this.appCenterController.updateRect({
      left: 0,
      top: 0,
      width: px2vp(screenProperty.width),
      height: px2vp(screenProperty.height)
    });
    log.showInfo('onScreenPropertyChange ' + screenProperty.screenId);
  }

  onLock(): void {
    if (this.isLock) {
      this.hideAppCenterImmediately('onLockScreen');
    }
  }

  private hideAppCenterImmediately(msg: string): void {
    if (viewMgrPolicy.isViewShowing(this.getViewType())) {
      log.showInfo(`${msg} hide AppCenter`);
      viewMgrPolicy.hideView(this.getViewType());
      this.closeAllCloneWallpaper();
    }
  }

  /**
   * @param openAfterClose 是否是抢占, 需要关闭后打开
   */
  initGlobalHideAnimation(): void {
    let hideAppCenterWithAnimation:
      (screenId?: number, openAfterClose?: boolean) => void = (screenId = 0, openAfterClose): void => {
        let isMainShowing = viewMgrPolicy.isViewShowing(ViewType.APP_CENTER);
        if (isMainShowing) {
          if (GlobalContext.getInstance().hasObject('hideMainAppCenterWithAnimation')) {
            let hideAppCenterWithAnimation = (GlobalContext.getInstance()
              .getObject('hideMainAppCenterWithAnimation')) as Function;
            log.showInfo(`hideMainAppCenterWithAnimation screenId:` + screenId)
            hideAppCenterWithAnimation(screenId, openAfterClose);
          }
        }
        let isExtShowing = viewMgrPolicy.getViewController(ViewType.APP_CENTER_EXT) &&
        viewMgrPolicy.isViewShowing(ViewType.APP_CENTER_EXT);
        if (isExtShowing) {
          if (GlobalContext.getInstance().hasObject('hideExtAppCenterWithAnimation')) {
            let hideAppCenterWithAnimation = (GlobalContext.getInstance()
              .getObject('hideExtAppCenterWithAnimation')) as Function;
            log.showInfo(`hideExtAppCenterWithAnimation screenId:` + screenId)
            hideAppCenterWithAnimation(screenId, openAfterClose);
          }
        }
      }
    GlobalContext.getInstance().setObject('hideAppCenterWithAnimation', hideAppCenterWithAnimation);
    AppCenterModel.getInstance().setHideAppCenterFunc(hideAppCenterWithAnimation);
    PowerStatusChangeAnimationController.getInstance().registerExitAppCenterCallback(hideAppCenterWithAnimation);
  }

  initHideAnimation(): void {
    let hideAppCenterWithAnimation:
      (screenId?: number, openAfterClose?: boolean) => void = (screenId = 0, openAfterClose): boolean => {
      if ((!viewMgrPolicy.isViewShowing(ViewType.APP_CENTER) &&
        !viewMgrPolicy.isViewShowing(ViewType.APP_CENTER_EXT)) ||
          RecentAndAppCenterSwitchManager.getInstance().getAppCenterViewHiding()) {
        log.showInfo('app center view is already hidden, return.');
        return false;
      }
      /**
       * 从任务中心->应用中心，updateSystemBarProperty是在克隆壁纸层级切换后调用。
       * 如果快速切换，会导致updateSystemBarProperty不会调用，所以在应用中心隐藏时补一个
       */
      SCBSceneSessionManager.getInstance().updateSystemBarProperty();
      RecentAndAppCenterSwitchManager.getInstance().setAppCenterViewHiding(true);
      AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_START);
      HiSysEventUtil.reportExitAppCenter('0');
      ContextMenu.close();
      log.showInfo('start hide app center view now.');
      if (!this.isSearchInputDefaultFocus) {
        try {
          this.getUIContext().getFocusController().requestFocus(APP_CENTER_SWIPER_KEY);
        } catch (error) {
          log.showInfo(`getFocus error: ${error}`);
        }
      }
      TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_STOP_APP_CENTER_ANIMATION);
      systemAniSceneCtrl.enqueue(SystemAnimatedScene.EXIT_APP_CENTER);
      SCBSceneSessionManager.getInstance()
        .requestUnfocus(this.persistentId, FocusChangeReason.SCB_SESSION_REQUEST_UNFOCUS);
      AppStorage.setOrCreate('isAppCenterShow', false);
      AppCenterModel.getInstance().setViewState(screenId, false);
      let showDesktop = this.isWallpaperChanged;
      animateTo({
        delay: HIDE_WALLPAPER_DELAY,
        duration: HIDE_OPACITY_CURVE_TIME_AJUSTMENT,
        curve: HIDE_OPACITY_CURVE,
        onFinish: () => {
          RecentAndAppCenterSwitchManager.getInstance().setAppCenterViewHiding(false);
          log.showInfo(`end hide app center view. ${showDesktop}-${this.isWallpaperChanged}-${this.isAppCenterShow}`);
          if (showDesktop !== this.isWallpaperChanged || this.isAppCenterShow) {
            log.showInfo('terminate by show');
            return;
          }
          if (viewMgrPolicy.getViewController(ViewType.APP_CENTER)) {
            viewMgrPolicy.hideView(ViewType.APP_CENTER);
          }
          if (viewMgrPolicy.getViewController(ViewType.APP_CENTER_EXT)) {
            viewMgrPolicy.hideView(ViewType.APP_CENTER_EXT);
          }
          performanceMonitor.end(HiSysEventUtil.EXIT_APP_CENTER);
          performanceMonitor.end(HiSysEventUtil.PC_DOCK_EXIT_APP_CENTER);
          performanceMonitor.end(HiSysEventUtil.PC_SHORTCUT_EXIT_APP_CENTER);
          if (openAfterClose) {
            if (this.isMainScreen(screenId)) {
              if (viewMgrPolicy.getViewController(
                ViewType.APP_CENTER_EXT) && !viewMgrPolicy.isViewShowing(ViewType.APP_CENTER_EXT)) {
                viewMgrPolicy.showView(ViewType.APP_CENTER_EXT);
              }
            } else {
                viewMgrPolicy.showView(ViewType.APP_CENTER);
            }
          }
        }
      }, () => {
        let screenSessionList: SCBScreenSessionArray = SCBScreenSessionManager.getInstance().getScreenSessionList();
        if (!RecentAndAppCenterSwitchManager.getInstance().recentIsShowing()) {
          screenSessionList.forEach((screen) => {
            CloneWallpaperMgr.getInstance(screen.session.screenId).hide();
          })
        }
        this.bkOpacity = 0;
      });

      let inSearch = this.searchInputText ? true : false;
      let localCurOpenIndex = this.curOpenPageIndex;
      let curSearchIndex = AppCenterViewModel.getInstance().getCurSearchPageIndex();
      let det: AppCenterDynamicEffects | undefined = undefined;

      let detMap = AppCenterViewModel.getInstance().getDynamicEffectMap(this.screenProp.screenId, false);
      if (!detMap) {
        log.showError(`hide anim loop fail as no det map exist-${this.screenProp.screenId} - ${inSearch}`);
      }

      let detSearchMap = AppCenterViewModel.getInstance().getDynamicEffectMap(this.screenProp.screenId, true);
      if (!detSearchMap) {
        log.showError(`hide anim loop fail as no det map exist-${this.screenProp.screenId} - ${inSearch}`);
      }

      log.showInfo(`hide anim loop-${this.curOpenPageIndex}-${localCurOpenIndex}-${inSearch}-${curSearchIndex}`);
      if (inSearch) {
        det = detSearchMap?.get(curSearchIndex);
      } else {
        det = detMap?.get(this.curOpenPageIndex);
      if (det) {
        log.showInfo(`hide anim loop opa-${this.curOpenPageIndex}-${localCurOpenIndex}`);
      } else {
          log.showWarn(`hide anim loop fail as no det exist-${this.screenProp.screenId}-${this.curOpenPageIndex}` +
            `-${inSearch}-${curSearchIndex}`);
        }
      }

      if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
        let detC: AppCenterDynamicEffects | undefined = undefined;
        if (inSearch) {
          if (!FoldedDeviceAcViewModel.getInstance().isKeyboardOnCSide()) {
            if (detSearchMap?.has(curSearchIndex + 1)) {
              detC = detSearchMap?.get(curSearchIndex + 1);
              log.showInfo(`hide anim loop fold sch-${curSearchIndex}`);
            }
          }
        } else {
        // 在hopper第二页退出应用中心时，如果拉起虚拟键盘或者接入磁吸键盘，不对第三页图标进行透明度处理
        if (detMap?.has(localCurOpenIndex + 1) && !FoldedDeviceAcViewModel.getInstance().isKeyboardOnCSide()) {
          detC = detMap?.get(localCurOpenIndex + 1);
          log.showInfo(`hide anim loop fold-${localCurOpenIndex}`);
          }
        }

        animateToImmediately({
          delay: SHOW_ICON_DELAY,
          duration: HIDE_ICON_AND_TRANSLATION_TIME_HPR,
          curve: Curve.Sharp,
          onFinish: () => {
            log.showInfo(`hide anim opa onFinish-${localCurOpenIndex}-${this.curOpenPageIndex}`);
            if (inSearch) {
              return;
            }
            if (localCurOpenIndex <= 1) {
              return;
            }

            clearTimeout(this.hideAnimOpacityTimerId);
            this.hideAnimOpacityTimerId = setTimeout(() => {
              log.showInfo(`hide anim opa onFinish-to-${this.curOpenPageIndex}`);
              for (let index = 0; index < this.appItemOpacity.length; index++) {
                if (det) {
                  det.getAppItemOpacity()[index] = 1;
                }

                if (detC) {
                  detC.getAppItemOpacity()[index] = 1;
                }
              }
            }, HIDE_ANIM_END_RESET_DELAY);

            // 结束时重置首页的透明度
            let det0 = detMap?.get(0);
            if (det0) {
              for (let index = 0; index < this.appItemOpacity.length; index++) {
                det0.getAppItemOpacity()[index] = 0;
              }
            }

            let det1 = detMap?.get(1);
            if (det1) {
              for (let index = 0; index < this.appItemOpacity.length; index++) {
                det1.getAppItemOpacity()[index] = 0;
              }
            }
          }
        }, () => {
          for (let index = 0; index < this.appItemOpacity.length; index++) {
            this.appItemOpacity[index] = 0;

            if (det) {
              det.getAppItemOpacity()[index] = 0;
            }

            if (detC) {
              detC.getAppItemOpacity()[index] = 0;
            }
          }
        });
        animateTo({
          delay: SHOW_ICON_DELAY,
          duration: HIDE_ICON_AND_TRANSLATION_TIME_HPR,
          curve: Curve.Friction,
          onFinish: () => {
            TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_STOP_APP_CENTER_ANIMATION);
            systemAniSceneCtrl.dequeue(SystemAnimatedScene.EXIT_APP_CENTER);
            log.showInfo(`hide anim txl onFinish-${localCurOpenIndex}-${this.curOpenPageIndex}`);
            if (inSearch) {
              return;
            }
            if (localCurOpenIndex <= 1) {
              return;
            }

            clearTimeout(this.hideAnimTranslateTimerId);
            this.hideAnimTranslateTimerId = setTimeout(() => {
              log.showInfo(`hide anim txl onFinish-to-${this.curOpenPageIndex}`);

              // 结束时必须还原本页的位移
              for (let index = 0; index < this.appItemPosX.length; index++) {
                if (det) {
                  det.getAppItemPosX()[index] = 0;
                  det.getAppItemPosY()[index] = 0;
                  det.getRtlAppItemPosX()[index] = 0;
                }

                if (detC) {
                  detC.getAppItemPosX()[index] = 0;
                  detC.getAppItemPosY()[index] = 0;
                  detC.getRtlAppItemPosX()[index] = 0;
                }
              }
            }, HIDE_ANIM_END_RESET_DELAY);

            // 结束时重置首两页的位移
            let det0 = detMap?.get(0);
            if (det0) {
              for (let index = 0; index < this.appItemPosX.length; index++) {
                det0.getAppItemPosX()[index] = this.appItemEdgePos[index][0];
                det0.getAppItemPosY()[index] = this.appItemEdgePos[index][1];
                det0.getRtlAppItemPosX()[index] = this.appItemEdgePos[index][2];
              }
            }

            let det1 = detMap?.get(1);
            if (det1) {
              for (let index = 0; index < this.appItemPosX.length; index++) {
                det1.getAppItemPosX()[index] = this.appItemEdgePos[index][0];
                det1.getAppItemPosY()[index] = this.appItemEdgePos[index][1];
                det1.getRtlAppItemPosX()[index] = this.appItemEdgePos[index][2];
              }
            }
          }
        }, () => {
          for (let index = 0; index < this.appItemPosX.length; index++) {
            this.appItemPosX[index] = this.appItemEdgePos[index][0];
            this.appItemPosY[index] = this.appItemEdgePos[index][1];
            this.rtlAppItemPosX[index] = this.appItemEdgePos[index][2];
            this.searchAppInputPosY = SEARCH_APP_INPUT_POY;

            if (det) {
              det.getAppItemPosX()[index] = this.appItemEdgePos[index][0];
              det.getAppItemPosY()[index] = this.appItemEdgePos[index][1];
              det.getRtlAppItemPosX()[index] = this.appItemEdgePos[index][2];
            }

            if (detC) {
              detC.getAppItemPosX()[index] = this.appItemEdgePos[index][0];
              detC.getAppItemPosY()[index] = this.appItemEdgePos[index][1];
              detC.getRtlAppItemPosX()[index] = this.appItemEdgePos[index][2];
            }
          }
        });
      } else {
        this.circleMap.forEach((value: Array<number>, key: number) => {
          animateToImmediately({
            duration: this.timeDesc[key] - 100,
            curve: Curve.Sharp,
            onFinish: () => {
              if ((key + 1) === this.circleMap.size) {
                if (localCurOpenIndex <= 0) {
                  return;
                }

                // 结束时必须还原本页的透明度
                clearTimeout(this.hideAnimOpacityTimerId);
                this.hideAnimOpacityTimerId = setTimeout(() => {
                  for (let index = 0; index < this.appItemOpacity.length; index++) {
                    if (det) {
                      det.getAppItemOpacity()[index] = 1;
                    }
                  }
                }, HIDE_ANIM_END_RESET_DELAY);

                // 结束时重置首页的透明度
                let det0 = detMap?.get(0);
                if (det0) {
                  for (let index = 0; index < this.appItemOpacity.length; index++) {
                    det0.getAppItemOpacity()[index] = 0;
                  }
                }
              }
            }
          }, () => {
            for (let index = 0; index < this.appItemOpacity.length; index++) {
              if (value.includes(index)) {
                this.appItemOpacity[index] = 0;

                if (det) {
                  det.getAppItemOpacity()[index] = 0;
                }
              }
            }
          })

          animateTo({
            duration: this.timeDesc[key],
            curve: Curve.Friction,
            onFinish: () => {
              if (key === 0) {
                TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_STOP_APP_CENTER_ANIMATION);
                systemAniSceneCtrl.dequeue(SystemAnimatedScene.EXIT_APP_CENTER);
              }
              if ((key + 1) === this.circleMap.size) {
                if (localCurOpenIndex <= 0) {
                  return;
                }

                // 结束时必须还原本页的位移
                clearTimeout(this.hideAnimTranslateTimerId);
                this.hideAnimTranslateTimerId = setTimeout(() => {
                  for (let index = 0; index < this.appItemPosX.length; index++) {
                    if (det) {
                      det.getAppItemPosX()[index] = 0;
                      det.getAppItemPosY()[index] = 0;
                      det.getRtlAppItemPosX()[index] = 0;
                    }
                  }
                }, HIDE_ANIM_END_RESET_DELAY);

                // 结束时重置首页的位移
                let det0 = detMap?.get(0);
                if (det0) {
                  for (let index = 0; index < this.appItemPosX.length; index++) {
                    det0.getAppItemPosX()[index] = this.appItemEdgePos[index][0];
                    det0.getAppItemPosY()[index] = this.appItemEdgePos[index][1];
                    det0.getRtlAppItemPosX()[index] = this.appItemEdgePos[index][2];
                  }
                }
              }
            }
          }, () => {
            if (det) {
              log.showInfo(`hide anim loop translate`);
            }
            for (let index = 0; index < this.appItemPosX.length; index++) {
              if (value.includes(index)) {
                this.appItemPosX[index] = this.appItemEdgePos[index][0];
                this.appItemPosY[index] = this.appItemEdgePos[index][1];
                this.rtlAppItemPosX[index] = this.appItemEdgePos[index][2];
                this.searchAppInputPosY = SEARCH_APP_INPUT_POY;

                if (det) {
                  det.getAppItemPosX()[index] = this.appItemEdgePos[index][0];
                  det.getAppItemPosY()[index] = this.appItemEdgePos[index][1];
                  det.getRtlAppItemPosX()[index] = this.appItemEdgePos[index][2];
                }
              }
            }
          })
        })
      }

      AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_END);
      return true;
    };
    if (this.screenProp.screenId === 0) {
      GlobalContext.getInstance().setObject('hideMainAppCenterWithAnimation', hideAppCenterWithAnimation);
    } else {
      GlobalContext.getInstance().setObject('hideExtAppCenterWithAnimation', hideAppCenterWithAnimation);
    }
  }

  aboutToDisappear(): void {
    UIContextHelper.delContext(this.screenProp.screenId);
    AppStorage.setOrCreate('isAppCenterShow', false);
    AppCenterModel.getInstance().setViewState(this.screenProp.screenId, false);
    AppCenterDragMgr.getInstance().setAppCenterViewShow(false);
    log.showWarn('unregisterAppListChange');
    this.mAppGridPresenter?.unregisterAppListChange(this.screenProp.screenId);
    AccountHelper.getInstance().unRegisterUserSwitchListener('switching', this.onSwitchingUser);
    this.appCenterController.unRegisterCallback(this.viewCallback);
    LayoutViewModel.getInstance(this.singleContext)
      .unregisterRefreshLayoutCallback(this.screenProp.screenId, this.refreshAppCenterLayout);
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
    GlobalContext.getContext()?.eventHub.off(EVENT_ENABLE_DRAG_STATE_CHANGE, this.onEnableDragStateChange);
    AppCenterViewModel.getInstance().destroyAnimationParamsByScreen(this.screenProp.screenId, false);
    AppCenterViewModel.getInstance().destroyAnimationParamsByScreen(this.screenProp.screenId, true);
    FoldedDeviceAcViewModel.deleteInstance(this.screenProp.screenId);
    if (this.screenProp.screenId !== 0 && AcDragStatusMgr.getInstance().isDraggingNow()) {
      AppCenterDragMgr.getInstance().onDragCancel();
    }

    if (this.screenProp.screenId > 0 && this.curOpenPageIndex > 0 &&
      !viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
      log.showWarn('reset openAppCenterPageIndex when ext screen disconnect');
      AppStorage.setOrCreate('openAppCenterPageIndex', 0);
    }
    clearTimeout(this.hideAnimTranslateTimerId);
    clearTimeout(this.hideAnimOpacityTimerId);
  }


  resetAnimationData(): void {
    for (let index = 0; index < this.appItemPosX.length; index++) {
      this.appItemPosX[index] = this.appItemEdgePos[index][0];
      this.appItemPosY[index] = this.appItemEdgePos[index][1];
      this.rtlAppItemPosX[index] = this.appItemEdgePos[index][2];
      this.appItemOpacity[index] = 0;
      this.searchAppInputPosY = SEARCH_APP_INPUT_POY;
    }
    this.bkOpacity = 0;
    // 重置首页动效参数
    this.resetFirstPagesAnim();
  }
  private resetFirstPagesAnim(): void {
    let detMap = AppCenterViewModel.getInstance().getDynamicEffectMap(this.screenProp.screenId, false);
    if (!detMap) {
      log.showError(`resetFirstPagesAnim fail as no det map exist-${this.screenProp.screenId}`);
      return;
    }
    // 重置首两页的位移
    let det0 = detMap?.get(0);
    if (!det0) {
      log.showWarn(`resetFirstPagesAnim-page 0 not in map-${this.screenProp.screenId}`);
      return;
    }
    if (det0.getAppItemPosX().length < this.appItemPosX.length ||
      det0.getAppItemOpacity().length < this.appItemOpacity.length) {
      log.showWarn(`resetFirstPagesAnim-0-opa or txl size invalid-${det0.getAppItemOpacity().length}`);
      return;
    }
    for (let index = 0; index < this.appItemPosX.length; index++) {
      det0.getAppItemPosX()[index] = this.appItemEdgePos[index][0];
      det0.getAppItemPosY()[index] = this.appItemEdgePos[index][1];
      det0.getRtlAppItemPosX()[index] = this.appItemEdgePos[index][2];
      det0.getAppItemOpacity()[index] = 0;
    }
    if (!this.isFolded) {
      return;
    }
    let det1 = detMap?.get(1);
    if (!det1) {
      log.showInfo(`resetFirstPagesAnim-page 1 not in map-${this.screenProp.screenId}`);
      return;
    }
    if (det1.getAppItemPosX().length < this.appItemPosX.length ||
      det1.getAppItemOpacity().length < this.appItemOpacity.length) {
      log.showWarn(`resetFirstPagesAnim-1-opa or txl size invalid-${det1.getAppItemOpacity().length}`);
      return;
    }
    for (let index = 0; index < this.appItemPosX.length; index++) {
      det1.getAppItemPosX()[index] = this.appItemEdgePos[index][0];
      det1.getAppItemPosY()[index] = this.appItemEdgePos[index][1];
      det1.getRtlAppItemPosX()[index] = this.appItemEdgePos[index][2];
      det1.getAppItemOpacity()[index] = 0;
    }
  }

  startShowAnimation(): void {
    log.showInfo('startShowAnimation');
    // ApsUtils.setApsScene(apsManager.SceneAnimation.ENTER_APPCENTER, StyleConstants.DEFAULT_1);
    let onPinchUpdating: boolean | undefined = AppStorage.get('onPinchUpdating');
    let preHeatingAppCenter: boolean | undefined = AppStorage.get('preHeatingAppCenter');
    log.showDebug(`onPinchUpdating = ${onPinchUpdating}, preHeatingAppCenter = ${preHeatingAppCenter}`);
    HiSysEventUtil.reportIntoAppCenter('0');
    if (preHeatingAppCenter) {
      log.showInfo(`startShowAnimation preHeatingAppCenter:${preHeatingAppCenter}`);
      AppStorage.setOrCreate('preHeatingAppCenter', false);
      viewMgrPolicy.hideView(this.getViewType());
      return;
    }

    if (onPinchUpdating) {
      log.showInfo(`startShowAnimation onPinchUpdating:${onPinchUpdating}`);
      AppStorage.setOrCreate('onPinchUpdating', false);
      return;
    }

    TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_START_APP_CENTER_ANIMATION);
    systemAniSceneCtrl.enqueue(SystemAnimatedScene.ENTER_APP_CENTER);

    let delayTime: number = 0;
    const isRecentToAppCenter = RecentAndAppCenterSwitchManager.getInstance().getRecentToAppCenter();
    if (isRecentToAppCenter) {
      delayTime = 200;
      RecentAndAppCenterSwitchManager.getInstance().setOneFrameVisible(this.screenProp.screenId, true);
      this.closeAllCloneWallpaperWithoutId(this.screenProp.screenId);
      AppStorage.setOrCreate('showRecent', false);
    } else {
      this.closeAllCloneWallpaperWithoutId(this.screenProp.screenId);
      CloneWallpaperMgr.getInstance(this.screenProp.screenId).updateZIndex(SCBDefaultZIndex.APP_CENTER - 1);
    }

    let detMap = AppCenterViewModel.getInstance().getDynamicEffectMap(this.screenProp.screenId, false);
    if (!detMap) {
      log.showError(`show anim loop fail as no det map exist-${this.screenProp.screenId}`);
    }

    let det = detMap?.get(0);
    if (det) {
      log.showInfo(`show anim loop`);
    }

    let det1: AppCenterDynamicEffects | undefined = undefined;
    if (this.isFolded && detMap?.has(1)) {
      det1 = detMap?.get(1);
      log.showInfo(`show anim loop 2`);
    }

    // 打开应用中心，应用中心图标的显示动效
    this.circleMap.forEach((value: Array<number>, key: number) => {
      animateTo({
        delay: key + 1 === this.circleMap.size ? SHOW_ICON_DELAY - 30 : SHOW_ICON_DELAY,
        duration: this.timeAsc[key],
        curve: Curve.Friction,
        onFinish: () => {
          if ((key + 1) === this.circleMap.size) {
            // ApsUtils.setApsScene(apsManager.SceneAnimation.ENTER_APPCENTER, StyleConstants.DEFAULT_0);
            TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_START_APP_CENTER_ANIMATION);
            performanceMonitor.end(HiSysEventUtil.PC_DOCK_INTO_APP_CENTER);
            performanceMonitor.end(HiSysEventUtil.PC_INTO_APP_CENTER_ON_RECENT);
            performanceMonitor.end(HiSysEventUtil.PC_SHORTCUT_TO_APP_CENTER);
            performanceMonitor.end(HiSysEventUtil.PC_SHORTCUT_TO_APP_CENTER_ON_RECENT);
            systemAniSceneCtrl.dequeue(SystemAnimatedScene.ENTER_APP_CENTER);
            if (RecentAndAppCenterSwitchManager.getInstance().getRecentToAppCenter()) {
              CloneWallpaperMgr.getInstance(this.screenProp.screenId).updateZIndex(SCBDefaultZIndex.APP_CENTER - 1);
              RecentAndAppCenterSwitchManager.getInstance().setRecentToAppCenter(false);
              SCBSceneSessionManager.getInstance().requestFocus(this.persistentId, true, FocusChangeReason.FOREGROUND);
            }
          }
        }
      }, () => {
        if (this.screenProp.screenId > 0) {
          detMap = AppCenterViewModel.getInstance().getDynamicEffectMap(this.screenProp.screenId, false);
          if (!detMap) {
            log.showError(`show anim loop 00 fail as no det map exist-${this.screenProp.screenId}`);
          }

          det = detMap?.get(0);
          if (det) {
            log.showInfo(`show anim loop`);
          }

          if (detMap?.has(1)) {
            det1 = detMap?.get(1);
            log.showInfo(`show anim loop 2`);
          }
        }

        // 计算展开时，图标最终落位偏移量
        for (let index = 0; index < this.appItemPosX.length; index++) {
          if (value.includes(index)) {
            this.appItemPosX[index] = 0;
            this.appItemPosY[index] = 0;
            this.rtlAppItemPosX[index] = 0;
            this.searchAppInputPosY = 0;
            if (det) {
              det.getAppItemPosX()[index] = 0;
              det.getAppItemPosY()[index] = 0;
              det.getRtlAppItemPosX()[index] = 0;
            }

            if (this.isFolded && det1) {
              det1.getAppItemPosX()[index] = 0;
              det1.getAppItemPosY()[index] = 0;
              det1.getRtlAppItemPosX()[index] = 0;
            }
          }
        }
      })

      animateToImmediately({
        delay: SHOW_ICON_DELAY,
        duration: key + 1 === this.circleMap.size ? this.opacityTimeAsc[key] + 50 : this.opacityTimeAsc[key] - 100,
        curve: Curve.Sharp
      }, () => {
        if (this.screenProp.screenId > 0) {
          detMap = AppCenterViewModel.getInstance().getDynamicEffectMap(this.screenProp.screenId, false);
          if (!detMap) {
            log.showError(`show anim loop 00 fail as no det map exist-${this.screenProp.screenId}`);
          }

          det = detMap?.get(0);
          if (det) {
            log.showInfo(`show anim loop`);
          }

          if (detMap?.has(1)) {
            det1 = detMap?.get(1);
            log.showInfo(`show anim loop 2`);
          }
        }

        // 计算展开时，图标最终落位时的透明度
        for (let index = 0; index < this.appItemOpacity.length; index++) {
          if (value.includes(index)) {
            this.appItemOpacity[index] = 1;

            if (det) {
              det.getAppItemOpacity()[index] = 1;
            }

            if (this.isFolded && det1) {
              det1.getAppItemOpacity()[index] = 1;
            }
          }
        }
      })

      animateTo({
        delay: delayTime,
        duration: START_ANIMATE_TIME,
        curve: START_CURVE,
      }, () => {
        this.bkOpacity = AppCenterViewModel.APP_CENTER_BK_OPACITY;
        if (!isRecentToAppCenter) {
          CloneWallpaperMgr.getInstance(this.screenProp.screenId).show();
        }
        // hopper大屏幕机，显示应用中心的时候，不允许旋转操作
        if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
          SCBScreenSessionManager.getInstance()
            .getScreenSession(this.screenProp.screenId)?.setEnableRotate(false, 'show appcenter');
        }
      })
    })


    log.showInfo(`show det.getAppItemOpacity():${det?.getAppItemOpacity()}`);

    // 针对hopper展开进入到应用中心，圈层动效之后，数据后面的透明度全部改为1，在后续展开刷新时，可显示应用图标
    if (this.isFolded && det1 && !FoldedDeviceAcViewModel.getInstance().isKeyboardOnCSide()) {
      for (let index = 0; index < det1?.getAppItemOpacity()?.length; index++) {
        det1.getAppItemOpacity()[index] = 1;
        det1.getAppItemPosX()[index] = 0;
        det1.getAppItemPosY()[index] = 0;
        det1.getRtlAppItemPosX()[index] = 0;
      }
      log.showInfo(`show det1?.getAppItemOpacity()：${det1?.getAppItemOpacity()}`);
    }
  }

  onBackPress(screenId: number = 0): boolean {
    ContextMenu.close();
    AppStorage.setOrCreate('selectDesktopAppItem', '');
    AppStorage.setOrCreate('selectItem', '');
    if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
      log.showInfo('onBackPress. do hide app center view animation now.');
      let hideAppCenterWithAnimation = (GlobalContext.getInstance()
        .getObject('hideAppCenterWithAnimation')) as Function;
      hideAppCenterWithAnimation(screenId);
    }
    return true;
  }

  private onViewShow(): void {
    AppStorage.setOrCreate('isAppCenterShow', true);
    AppCenterModel.getInstance().setViewState(this.screenProp.screenId, true);
    AppCenterDragMgr.getInstance().setAppCenterViewShow(true);
    log.showInfo(`${TraceUtil.CORE_METHOD_INTO_APP_CENTER}`);
    TraceUtil.traceOnce(DomainName.HOME, TraceUtil.CORE_METHOD_INTO_APP_CENTER);
    HiSysEventUtil.reportIntoAppCenter('success');
    if (this.isMainScreen(this.screenProp.screenId)) {
      if (GlobalContext.getInstance().hasObject('showDockViewWithAnimation')) {
        let showDockViewWithAnimation = (GlobalContext.getInstance().getObject('showDockViewWithAnimation')) as Function;
        showDockViewWithAnimation();
      } else {
        viewMgrPolicy.showView(ViewType.SMART_DOCK);
      }
    } else {
      if (GlobalContext.getInstance().hasObject('setWholeDockVisibilityWithAnimation')) {
        let setWholeDockVisibilityWithAnimation = (GlobalContext.getInstance().getObject('setWholeDockVisibilityWithAnimation')) as Function;
        setWholeDockVisibilityWithAnimation(this.screenProp.screenId, true);
      } else {
        viewMgrPolicy.showView(ViewType.SMART_DOCK_EXT_SCREEN);
      }
    }
    this.isFocusAble = !AppCenterDragMgr.getInstance().isInDragging();
    this.startShowAnimation();
    if (this.isSearchInputDefaultFocus) {
      this.mTimeMeter = setTimeout(() => {
        try {
          this.getUIContext().getFocusController().requestFocus(APPCENTER_SEARCH_INPUT_KEY);
        } catch (error) {
          log.showInfo(`getFocus error: ${error}`);
        }
      }, this.inputRequestFocusTime);
    } else {
      this.switchFocusToFirstItem();
    }
    this.mTimeIntoAppCenter = new Date().getTime();
  }

  private onViewHide(): void {
    AppStorage.setOrCreate('isAppCenterShow', false);
    AppCenterModel.getInstance().setViewState(this.screenProp.screenId, false);
    log.showInfo('onViewHide');
    this.searchInputText = '';
    AppCenterDragMgr.getInstance().setAppCenterViewShow(false);
    AppCenterViewModel.getInstance().endSearch();
    log.showInfo(`${TraceUtil.CORE_METHOD_EXIT_APP_CENTER}`);
    TraceUtil.traceOnce(DomainName.HOME, TraceUtil.CORE_METHOD_EXIT_APP_CENTER);
    HiSysEventUtil.reportExitAppCenter('success');
    if (this.mTimeMeter) {
      clearTimeout(this.mTimeMeter);
    }
    this.resetAnimationData();
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      let screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
      screenSession?.setEnableRotate(true, 'show appcenter');
      screenSession?.rotationChangeEntry(screenSession.sensorScreenProperty.rotation, 'show appcenter rotation');
    }
    AppStorage.setOrCreate('openAppCenterPageIndex', 0);
    AppCenterDragMgr.getInstance().resetLastMovPosIfDragLeave();
    if (!RecentAndAppCenterSwitchManager.getInstance().recentIsShowing()) {
      this.closeAllCloneWallpaper();
    }
  }

  private updateScreenSize() {
    let screenWidth = this.getUIContext()?.px2vp(this.screenProp.width) as number;
    this.mScreenHeight = this.getUIContext()?.px2vp(this.screenProp.height) as number;
    if (!this.mLayoutViewModel) {
      log.showInfo('mLayoutViewModel is null');
      return;
    }
    this.workSpaceHeight = this.mLayoutViewModel.getWorkSpaceHeight();
    this.dockHeight = this.mLayoutViewModel.getDockHeight();
    this.indicatorHeight = this.mLayoutViewModel.getIndicator();
    log.showInfo(`updateScreenSize product: pc, screenWidth: ${screenWidth}, screenHeight: ${this.mScreenHeight}`);
  }

  private buildLog(): boolean {
    return true;
  }

  private handleKeyEvent(event: KeyEvent, screenId: number = 0) {
    this.isEnterKeyEvent = event?.keyCode === KeyCodeConstants.KEYCODE_ENTER;
    log.showInfo(`handleKeyEvent isHandleWinEvent：${MultiInputViewModel.getInstance()
      .isHandleWinEvent} keyText:${event.keyText}`);
    if (!this.isEnterKeyEvent) {
      AppCenterViewModel.getInstance().updateSearchInputTextBeforeEnter(this.searchInputText);
    }
    let timeNow = new Date().getTime();
    if ((event?.keyCode === KeyCodeConstants.KEYCODE_ESC || event?.keyCode === 2) &&
      event?.type === KeyType.Up) {
      HiSysEventUtil.reportKey('usual.event.ESC');
      performanceMonitor.begin(HiSysEventUtil.EXIT_APP_CENTER, performanceMonitor.ActionType.LAST_UP);
      this.onBackPress(screenId);
    } else {
      if (MultiInputViewModel.getInstance().isHandleWinEvent) {
        log.showInfo(`isHandleWinEvent`);
        MultiInputViewModel.getInstance().isHandleWinEvent = false;
        return;
      }
      if (this.needFocusOnSearchInput(event?.keyCode) && !this.isKeyPressFromLogoA(timeNow, event?.keyCode) &&
        !ViewManagerPolicy.isViewShowing(ViewType.SHORTCUT_KEY_PANEL) &&
        !AppCenterDragMgr.getInstance().isInDragging()) {
        let currentImeSubType = inputMethod.getCurrentInputMethodSubtype();
        log.showInfo(`IME locale => ${currentImeSubType?.locale}`);
        if (currentImeSubType && currentImeSubType.locale === 'zh_CN') {
          MultiInputViewModel.getInstance().isHandleWinEvent = false;
          return;
        }
      }
    }
    MultiInputViewModel.getInstance().isHandleWinEvent = false;
  }

  private isKeyPressFromLogoA(timeNow: number, keyCode: number): boolean {
    if (this.searchInputText === '' && AppStorage.get<Boolean>('winAShowAppCenter')) {
      log.showInfo('isKeyPressFromLogoA');
      return true;
    } else {
      return false;
    }
  }

  private needFocusOnSearchInput(keyCode: number): boolean {
    if (this.searchInputText) {
      return false;
    }

    if (keyCode >= KeyCode.KEYCODE_0 && keyCode <= KeyCode.KEYCODE_9) {
      return true;
    }

    if (keyCode >= KeyCode.KEYCODE_A && keyCode <= KeyCode.KEYCODE_Z) {
      return true;
    }

    if (keyCode === KeyCode.KEYCODE_GRAVE || keyCode === KeyCode.KEYCODE_MINUS ||
      (keyCode >= KeyCode.KEYCODE_LEFT_BRACKET && keyCode <= KeyCode.KEYCODE_SLASH) ||
      keyCode === KeyCode.KEYCODE_COMMA || keyCode === KeyCode.KEYCODE_PERIOD) {
      return true;
    }

    return false;
  }

  private closeAllCloneWallpaper() {
    let screenSessionList: SCBScreenSessionArray = SCBScreenSessionManager.getInstance().getScreenSessionList();
    screenSessionList.forEach((screen) => {
      CloneWallpaperMgr.getInstance(screen.session.screenId).hideFinish();
    })
  }

  private closeAllCloneWallpaperWithoutId(screenId: number) {
    let screenSessionList: SCBScreenSessionArray = SCBScreenSessionManager.getInstance().getScreenSessionList();
    screenSessionList.forEach((screen) => {
      if (screen.scbScreenProperty.screenId !== screenId) {
        CloneWallpaperMgr.getInstance(screen.session.screenId).hideFinish();
      }
    })
  }

  private getAppCenterCtrl(screenId: number): BaseViewController {
      return new BaseViewController(this.getViewType(), screenId);
  }

  /**
   * 是否是主显示器
   *
   * @param screenId
   * @returns
   */
  private isMainScreen(screenId: number): boolean {
    return SCBSceneSessionManager.getInstance().mainScreenId === screenId;
  }

  private getViewType(): ViewType {
    return this.isMainScreen(this.screenProp.screenId) ? ViewType.APP_CENTER : ViewType.APP_CENTER_EXT;
  }

  private switchFocusToFirstItem(): void {
    let appList = AppStorage.get<AppLayoutInfo[]>('appCenterLayoutInfo');
    if (!appList || appList.length <= 0) {
      log.showInfo('switchFocusToFirstItem appList is empty');
      return;
    }
    let firstPage = appList[0].pageInfo;
    if (firstPage.length <= 0) {
      log.showInfo('switchFocusToFirstItem firstPage is empty');
      return;
    }
    const iconId = `AppIconCommonView_${firstPage[0].bundleName}.${firstPage[0].abilityName}`;
    try {
      this.getUIContext().getFocusController().requestFocus(iconId);
    } catch (error) {
      log.showInfo(`switchFocusToFirstItem getFocus error: ${error}`);
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Stack({ alignContent: Alignment.Top }) {
        if (this.buildLog()) {
        }

        AppGridLayout({
          searchInputText: this.searchInputText,
          isGainFocus: this.isGainFocus,
          screenProp: this.screenProp,
          singleContext: this.singleContext,
          swiperPaddingTop: this.swiperPaddingTop,
          isEnterKeyEvent: this.isEnterKeyEvent,
          appItemPosX: this.appItemPosX,
          appItemPosY: this.appItemPosY,
          appItemOpacity: this.appItemOpacity,
          bkOpacity: this.bkOpacity,
          rtlAppItemPosX: this.rtlAppItemPosX
        })
          .width('100%')
          .height(this.getUIContext()?.px2vp(this.screenProp.height) - this.dockHeight)
          .onClick(() => {
            log.showInfo('app center blank area click.');
            if (!this.isGainFocus) {
              return;
            }
            this.onBackPress(this.screenProp.screenId);
          })
      }
      .width('100%')
      .height('100%')
    }
    .onFocus(() => {
      setTimeout(() => {
        log.showInfo('request focus');
        this.isGainFocus = true;
      }, REFOCUS_TO_EXIT_DELAY)
    })
    .onBlur(() => {
      log.showInfo('lose focus');
      this.isGainFocus = false;
    })
    .onKeyEvent((event: KeyEvent) => {
      this.handleKeyEvent(event, this.screenProp.screenId);
    })
  }
}
