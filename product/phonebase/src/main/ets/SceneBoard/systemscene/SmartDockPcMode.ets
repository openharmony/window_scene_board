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
  CommonConstants,
  LayoutViewModel,
  EventConstants,
  UninstallDialogStatus,
  editModeManager,
  FolderDataModelManager,
  DockItemInfo,
  FormCenterViewManager,
  ResidentLayoutCacheMgr,
  FolderStyleManager,
  FolderActionLifeCycleEventManager,
  FolderManager,
  FolderActionLifeCycleEvent,
  FolderLifeCyclePriority,
  StyleConstants,
  DeleteDockItem,
  SmallFolderConstants,
} from '@ohos/launchercommon';
import {
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBSceneSessionManager,
  SCBPropertyChangeReason,
  ResUtils,
  SCBSessionRect,
  SCBUnlockTransitionController
} from '@ohos/windowscene';
import {
  localEventManager,
  ViewType,
  viewMgrPolicy,
  HiSysEventUtil,
  GlobalContext,
  sOutSideWindowMgr,
  WallpaperManager,
  WallpaperChangeListener,
  WallpaperType,
  WallpaperColorManager,
  NegativeScreenConstants,
  ViewArea,
  DfxEvent,
  reportIntervalMgr,
  DockAppCntParams,
  ReportParams,
  ThemeActivationEvent
} from '@ohos/frameworkwrapper';
import {
  LogDomain,
  LogHelper,
  DomainName,
  TraceUtil,
  CompanionIconInfo,
  SingleContext,
} from '@ohos/basicutils';
import { BaseViewController, } from '@ohos/frameworkcommon';
import { SCBConstants, WallpaperConstants } from '@ohos/commonconstants';
import { SmartDock } from '@ohos/smartdock/src/main/ets/default/layout/SmartDock';
import { ReceiveEventInfo } from '@ohos/launchercommon';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { DesktopMode } from '@ohos/launchercommon';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import parameter from '@ohos.systemparameter';
import SmartDockConstants from '@ohos/smartdock/src/main/ets/default/common/constants/SmartDockConstants';
import { AttributeUpdater } from '@ohos.arkui.modifier';
import { EventConstants as CommonEventConstants } from '@ohos/launchercommon';
import SmartDockModel from '@ohos/smartdock/src/main/ets/default/model/SmartDockModel';
import hiSysEvent from '@ohos.hiSysEvent';
import { componentUtils, inspector } from '@kit.ArkUI';
import { SCBDefaultZIndex } from '../scenemanager/SCBScreen';
import { SmartDockEventMgr } from '@ohos/smartdock/src/main/ets/default/manager/SmartDockEventMgr';

const TAG = 'SmartDockPcMode';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

enum SCBSmartDockViewState {
  VIEW_INITIAL = 0,
  VIEW_SHOWING = 1,
  VIEW_HIDING = 2,
}

class SCBDesktopScaleModifier extends AttributeUpdater<CommonAttribute> {
  private onInit: ((instance: CommonAttribute) => void) | undefined;

  constructor(onInit: (instance: CommonAttribute) => void) {
    super();
    this.onInit = onInit;
  }

  initializeModifier(instance: CommonAttribute) {
    this.onInit?.(instance);
  };
}

@Component
export struct SmartDockPcMode {
  private persistentId: number = 0;
  private finalState: number = SCBSmartDockViewState.VIEW_INITIAL;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  @Link screenProp: SCBScreenProperty;
  @State singleContext?: SingleContext = { extendScreenId: this.screenProp.screenId };
  @StorageLink('dockHeight') dockHeight: number = 0;
  @State smartDockController: BaseViewController = new BaseViewController(ViewType.SMART_DOCK);
  private scaleRatio: number = 1;
  @State needHideDockAfterPopupExit: boolean = false;
  @Provide desktopMode: DesktopMode = DesktopMode.NORMAL_MODE;

  @Provide('clearDesktopMemory') trimSmartDockMemory: boolean = false;
  @Provide('releaseDesktopMemory') releaseSmartDockMemory: boolean = false;
  @Provide('convertFolderId') @Watch('convertFolderIdChange') convertFolderId : string = '-1';
  @Provide('startConvert') @Watch('startConvertChange') startConvert: number = CommonConstants.DEFAULT_CONVERT;
  @Provide('startToSmall') startToSmall: number = CommonConstants.DEFAULT_CONVERT;
  @Provide('isShowingUninstallDialog') isShowingUninstallDialog: number = UninstallDialogStatus.INITIAL_STATE;
  @Provide('dragToUninstallItemInfo') dragToUninstallItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
  @Provide('convertToSmallFolder') isConvertToSmallFolder: boolean = false;
  @Provide('isFromDock') isFromDock: boolean = false;
  @Provide('companionIconInfo') companionIconInfo: CompanionIconInfo | null = null;
  @Provide('isDesktopEnabled') isDesktopEnabled: boolean = true;
  @Provide('isSmallFolderImage') isSmallFolderImage: boolean = false;
  @Provide('openSmallFolderBackgroundFlag') openSmallFolderBackgroundFlag: boolean = false;
  @Provide('globalSearchTranslateY') globalSearchTranslateY: number = 0;
  private isEnableBlur: boolean = true;
  private isPreLoadEnable: boolean = false;
  private isWindowOverlay: boolean | undefined = undefined;
  private enableBrightness: boolean = true;
  @StorageLink('currColorMode') @Watch('onColorModeChange') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;
  @State mBackgroundBrightness: number = 1;

  @State negativeProgress: number = 0;
  @State globalSearchProgress: number = 0;
  @State isHidingGlobalSearch: boolean = false;
  private animateScale: number = 1.0;
  private isNegativeScreenShowing = false;
  @StorageLink('screenWidth') screenWidth: number = 0;
  @StorageLink('screenHeight') screenHeight: number = 0;
  @StorageLink('showRecent') @Watch('onRecentCenterViewChange') isRecentCenterShow: boolean = false;
  @StorageLink ('globalSearchAnimation') @Watch('onGlobalSearchAnimation') isInGlobalSearchAnimation: boolean = false;
  private recentCenterItem: DockItemInfo | null = null;
  private collaborationListener: inspector.ComponentObserver = inspector.createComponentObserver('PcModeCollaborationLayout');
  private residentListener: inspector.ComponentObserver = inspector.createComponentObserver('PcModeResidentLayout');
  private recentListener: inspector.ComponentObserver = inspector.createComponentObserver('PcModeRecentLayout');
  private onDesktopModeChangeEvent: Function = (): void => this.onDesktopModeChange();
  private onNegativeShowEvent: Function = (): void => this.negativeShowEvent();
  private onNegativeHideEvent: Function = (): void => this.negativeHideEvent();
  private formCenterMgr = FormCenterViewManager.getInstance();
  private isFolderClosed: boolean | null = null;
  private dockZIndex: SCBDefaultZIndex = SCBDefaultZIndex.SMART_DOCK;
  private unLockTransitionController: SCBUnlockTransitionController = {
    name: `${TAG}`,
    onLock: (): void => {},
    onUnlock: (): void => this.onUnLockReceived()
  };

  private onUnLockReceived() {
    const isWindowOverlappedByDock: boolean = SCBSceneSessionManager.getInstance().existWindowOverlappedByDock(-1);
    log.showInfo(`onUnLockReceived isWindowOverlappedByDock: ${isWindowOverlappedByDock}`);
    if (isWindowOverlappedByDock) {
      viewMgrPolicy.hideView(ViewType.SMART_DOCK);
    }
  }

  private onResidentDrawEnd: () => void = (): void => {
    log.showInfo(`onResidentDrawEnd`);
    this.dockVisibleRegionChange();
  }

  private onRecentDrawEnd: () => void = (): void => {
    log.showInfo(`onRecentDrawEnd`);
    this.dockVisibleRegionChange();
  }

  private onCollaborationDrawEnd: () => void = (): void => {
    log.showInfo('onCollaborationDrawEnd');
    this.dockVisibleRegionChange();
  }

  private smartDockScaleModifier = new SCBDesktopScaleModifier((instance: CommonAttribute) => {
    instance.scale({
      x: 1.0,
      y: 1.0,
      centerX: this.screenWidth / 2,
      centerY: -this.screenHeight / 2
    });
  });

  private readonly dockAppCountEvent: DfxEvent = {
    report: (): void => {
      const residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      let shortcutNumber: number = 0;
      let appNumber: number = 0;
      residentList?.forEach(item => {
        if (item && item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
          shortcutNumber++;
          return;
        }
        appNumber++;
      })
      const params: DockAppCntParams = {
        PNAMEID: ReportParams.PACKAGE_NAME,
        PVERSIONID: ReportParams.PROCESS_NAME,
        APP_CNT: appNumber,
        SHORTCUT_CNT: shortcutNumber
      };
      HiSysEventUtil.reportEvent('DOCK_APP_CNT', params, hiSysEvent.EventType.STATISTIC);
    }
  }

  private createDockRecentAppInfo(): DockItemInfo {
    let dockItemInfo = new DockItemInfo();
    dockItemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
    dockItemInfo.abilityName = CommonConstants.RECENT_ABILITY;
    dockItemInfo.typeId = 0;
    dockItemInfo.itemType = CommonConstants.TYPE_FUNCTION;
    dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
    dockItemInfo.appIndex = 0;
    dockItemInfo.keyName = CommonConstants.LAUNCHER_BUNDLE + CommonConstants.RECENT_ABILITY;
    return dockItemInfo;
  }

  registerGestureCallback() {
    sOutSideWindowMgr.registerDesktopPageChangeListener(TAG, this);
    sOutSideWindowMgr.registerDesktopParamListener(TAG, this);
    sOutSideWindowMgr.registerNegativeProgressListener(TAG, this);
  }

  onDesktopAnimateScaleChanged(scale: number): void {
    this.smartDockScaleModifier.attribute?.scale({
      x: scale,
      y: scale,
      centerX: this.screenWidth / 2,
      centerY: -this.screenHeight / 2
    });
    this.animateScale = scale;
  }

  getAnimateScale(): number {
    return this.animateScale;
  }

  onDesktopEnableChanged(enabled: boolean, tag?: string): void {
    if (this.isDesktopEnabled !== enabled) {
      log.showInfo(`onDesktopEnableChanged setDesktopEnabled:${enabled} from ${tag}`);
      this.isDesktopEnabled = enabled;
    }
  }

  onProgressChange(progress: number): void {
    this.negativeProgress = progress;
  }

  onGlobalSearchTranslateYChange(translateY: number): void {
    log.showInfo(`onGlobalSearchTranslateYChange translateY: ${translateY}`);
    this.globalSearchTranslateY = translateY;
  }

  onIsHidingGlobalSearchChange(isHidingGlobalSearch: boolean): void {
    log.showInfo(`onIsHidingGlobalSearchChange isHidingGlobalSearch: ${isHidingGlobalSearch}`);
    this.isHidingGlobalSearch = isHidingGlobalSearch;
  }

  private onColorModeChange(): void {
    this.updateBrightness(false);
  }

  private async getDegree(updateCache: boolean): Promise<number> {
    let degree = FolderDataModelManager.getInstance().getDegree();
    if (updateCache || degree === 0) {
      degree = await WallpaperColorManager.getInstance().getDegree();
      FolderDataModelManager.getInstance().setDegree(degree);
      return degree;
    }
    return degree;
  }

  private wallPaperChange: WallpaperChangeListener = {
    registeredTag: TAG,
    listenerType: WallpaperType.ALL,
    onWallPaperChange: (event: ThemeActivationEvent) => {
      log.showInfo('WallPaper Change');
      this.updateBrightness(true);
    }
  };

  private async updateBrightness(updateCache: boolean): Promise<void> {
    let degree = await this.getDegree(updateCache);
    // 1-极浅壁纸；2-浅色壁纸；3-深色壁纸；4-极深壁纸；5-普通花壁纸；6-极花壁纸
    log.showInfo(`updateBrightness Degree=${degree} and colorMode=${this.currColorMode}`);
    if (this.currColorMode === SmallFolderConstants.DARK_COLOR_MODE &&
      degree === WallpaperConstants.WALLPAPER_TYPE_FOUR) {
      // 1、深色模式 极深壁纸 brightness设置1.15
      this.mBackgroundBrightness = SCBConstants.BACK_PLANE_BRIGHTNESS_UP_FIFTEEN_PERCENT;
    } else if (this.currColorMode === SmallFolderConstants.LIGHT_COLOR_MODE &&
      degree !== WallpaperConstants.WALLPAPER_TYPE_ONE) {
      // 2、浅色模式 非极浅壁纸 brightness设置1.05
      this.mBackgroundBrightness = SCBConstants.BACK_PLANE_BRIGHTNESS_UP_FIVE_PERCENT;
    } else if (this.currColorMode === SmallFolderConstants.LIGHT_COLOR_MODE &&
      degree === WallpaperConstants.WALLPAPER_TYPE_ONE) {
      // 3、浅色模式 极浅壁纸 brightness设置0.92
      this.mBackgroundBrightness = SCBConstants.BACK_PLANE_BRIGHTNESS_DOWN_EIGHT_PERCENT;
    } else if (this.currColorMode === SmallFolderConstants.DARK_COLOR_MODE &&
      degree === WallpaperConstants.WALLPAPER_TYPE_ONE) {
      // 4、深色模式 极浅壁纸 brightness设置1
      this.mBackgroundBrightness = SCBConstants.BACK_PLANE_BRIGHTNESS_DEFAULT;
    } else {
      // 5、深色模式 非极深壁纸 brightness设置0.95
      this.mBackgroundBrightness = SCBConstants.BACK_PLANE_BRIGHTNESS_DOWN_FIVE_PERCENT;
    }
    FolderStyleManager.getInstance().setBackgroundBrightness(this.mBackgroundBrightness);
    log.showInfo(`updateBrightness mBackgroundBrightness=${this.mBackgroundBrightness} and this.enableBrightness is
      ${this.enableBrightness}`);
  }

  aboutToAppear(): void {
    log.showInfo('smartDockPcMode aboutToAppear');
    this.residentListener.on('layout', this.onResidentDrawEnd);
    this.recentListener.on('layout', this.onRecentDrawEnd);
    this.collaborationListener.on('layout', this.onCollaborationDrawEnd);
    if (!this.recentCenterItem) {
      this.recentCenterItem = this.createDockRecentAppInfo();
    }
    this.addRecentCenter();
    // 发现过一种罕见的情况，退出自由多窗后组件没有执行aboutToDisappear，导致pad模式显示任务中心图标，这里监听退出事件作为兜底
    this.isPreLoadEnable = parameter.getSync('persist.resourceschedule.app.preload.enable', '1') === '1';
    this.isEnableBlur = parameter.getSync('sceneboard.isEnableBlur', 'true') === 'true';
    this.enableBrightness = parameter.getSync('sceneboard.enableBrightness', 'true') === 'true';
    viewMgrPolicy.registerViewController(ViewType.SMART_DOCK, this.smartDockController);
    this.smartDockController.updateId(this.persistentId);
    const dockHeightVp: number = LayoutViewModel.getInstance(this.singleContext).getDockHeight();
    const dockHeightPx: number = vp2px(dockHeightVp);
    this.dockHeight = dockHeightVp;
    let area: ViewArea = {
      left: 0,
      top: px2vp(this.screenProp.height) - dockHeightVp,
      width: px2vp(this.screenProp.width),
      height: dockHeightVp
    };
    let rect: ViewArea = {
      left: 0,
      top: 0,
      width: px2vp(this.screenProp.width),
      height: px2vp(this.screenProp.height)
    };
    this.smartDockController.updateArea(area);
    this.smartDockController.updateRect(rect);
    const session = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId);
    session.sessionData.avoidRect = new SCBSessionRect(
      0, this.screenProp.height - dockHeightPx, this.screenProp.width, dockHeightPx);
    this.updateBrightness(false);
    WallpaperManager.getInstance().addWallpaperChangeListener(this.wallPaperChange);
    this.initGlobalAnimation();
    SCBSceneSessionManager.getInstance().registerUnlockTransitionCallback(this.unLockTransitionController);
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropertyChangeCallbacks);
    this.registerDockVisibleCallback();
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    localEventManager.registerEventListener(this.localEventListener, [EventConstants.EVENT_PC_HIDE_DOCK_CALLBACK,
      EventConstants.EVENT_RESET_HIDE_DOCK_AFTER_POPUP_STATE_CALLBACK]);
    FolderActionLifeCycleEventManager.getInstance().register(this.mOpenCloseCallback);
    this.desktopContext?.eventHub.on(CommonEventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    this.desktopContext?.eventHub.on(CommonConstants.NEGATIVE_SCREEN_SHOW_EVENT, this.onNegativeShowEvent);
    this.desktopContext?.eventHub.on(CommonConstants.NEGATIVE_SCREEN_HIDDEN_EVENT, this.onNegativeHideEvent);
    reportIntervalMgr.registerEvent(this.dockAppCountEvent);
    this.isNegativeScreenShowing = sOutSideWindowMgr.isShowNegative();
    const isInEditMode: boolean = editModeManager.isInEditMode();
    const isFolderOpen: boolean = FolderManager.getInstance().isFolderOpen();
    const isFormCenterView: boolean = this.formCenterMgr.isFormCenterViewShowing();
    const isWindowOverlap = SCBSceneSessionManager.getInstance().existWindowOverlappedByDock(-1);
    log.showInfo(`isShowNegative: ${this.isNegativeScreenShowing}, isInEditMode: ${isInEditMode}, ` +
      `isFolderOpen: ${isFolderOpen}, isFormCenterView: ${isFormCenterView}, isWindowOverlap: ${isWindowOverlap}`);
    if (this.isNegativeScreenShowing || isInEditMode || isFormCenterView || isWindowOverlap) {
      this.hideDock();
    } else {
      this.smartDockController.show();
    }
    if (isFolderOpen) {
      this.onFolderOpened('isFolderOpen');
    }
  }

  private screenPropertyChangeCallbacks: Function =
    (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
      let newArea: ViewArea = {
        left: 0,
        top: px2vp(screenProperty.height) - this.dockHeight,
        width: px2vp(screenProperty.width),
        height: this.dockHeight
      };
      let newRect: ViewArea = {
        left: 0,
        top: 0,
        width: px2vp(this.screenProp.width),
        height: px2vp(this.screenProp.height)
      };
      this.smartDockController.updateArea(newArea);
      this.smartDockController.updateRect(newRect);
    }

  private showDock(): void {
    if (GlobalContext.getInstance().hasObject('showDockViewWithAnimation')) {
      let showDockViewWithAnimation = (GlobalContext.getInstance()
        .getObject('showDockViewWithAnimation')) as Function;
      showDockViewWithAnimation();
    } else {
      viewMgrPolicy.showView(ViewType.SMART_DOCK);
    }
  }

  private hideDock(): void {
    localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);
    if (GlobalContext.getInstance().hasObject('hideDockViewWithAnimation')) {
      let hideDockViewWithAnimation = (GlobalContext.getInstance()
        .getObject('hideDockViewWithAnimation')) as Function;
      hideDockViewWithAnimation();
    } else {
      viewMgrPolicy.hideView(ViewType.SMART_DOCK);
    }
  }

  private negativeShowEvent(): void {
    this.isNegativeScreenShowing = true;
    this.hideDock();
  }

  private negativeHideEvent(): void {
    this.isNegativeScreenShowing = false;
    const isWindowOverlapExist = SCBSceneSessionManager.getInstance().existWindowOverlappedByDock(-1);
    log.showInfo(`negativeHideEvent: ${isWindowOverlapExist}`);
    if (!isWindowOverlapExist) {
      this.showDock();
    }
  }

  private onDesktopModeChange() {
    if (editModeManager.isInEditMode()) {
      this.hideDock();
      return
    }
    const isWindowOverlapExist = SCBSceneSessionManager.getInstance().existWindowOverlappedByDock(-1);
    log.showInfo(`onDesktopModeChange, isWindowOverlapExist: ${isWindowOverlapExist}`);
    if (!isWindowOverlapExist) {
      this.showDock();
    }
  }

  private dockVisibleRegionChange(): void {
    if (SCBSceneSessionManager.getInstance().isPcMode()) {
      let residentRect = componentUtils.getRectangleById('PcModeResidentLayout');
      let recentRect = componentUtils.getRectangleById('PcModeRecentLayout');
      let collaborationRect = componentUtils.getRectangleById('PcModeCollaborationLayout');
      log.showInfo(`residentRect: x: ${residentRect?.screenOffset?.x}, y: ${residentRect?.screenOffset?.y}` +
        `width: ${residentRect?.size?.width}, height: ${residentRect?.size?.height} `);
      log.showInfo(`recentRect: x: ${recentRect?.screenOffset?.x}, y: ${recentRect?.screenOffset?.y}` +
        `width: ${recentRect?.size?.width}, height: ${recentRect?.size?.height}`);
      log.showInfo(`collaborationRect: x: ${collaborationRect?.screenOffset?.x}, y: ${collaborationRect?.screenOffset?.y}` +
        `width: ${collaborationRect?.size?.width}, height: ${collaborationRect?.size?.height}`);
      this.smartDockController.setResponseRegion([{
        x: collaborationRect.screenOffset.x,
        y: collaborationRect.screenOffset.y,
        width: collaborationRect.size.width,
        height: collaborationRect.size.height
      }, {
        x: residentRect.screenOffset.x,
        y: residentRect.screenOffset.y,
        width: residentRect.size.width,
        height: residentRect.size.height
      }, {
        x: recentRect.screenOffset.x,
        y: recentRect.screenOffset.y,
        width: recentRect.size.width,
        height: recentRect.size.height
      }]);
    }
  }

  private onRecentCenterViewChange() {
    const isWindowOverlapExist = SCBSceneSessionManager.getInstance().existWindowOverlappedByDock(-1);
    log.showInfo(`onRecentCenterViewChange ${isWindowOverlapExist}`);
    if (!this.isRecentCenterShow && isWindowOverlapExist) {
      this.hideDock();
    }
  }

  private registerDockVisibleCallback() {
    // 注册变化函数
    SCBSceneSessionManager.getInstance().registerDockVisibleCallback(this.onDockVisibleChangeCb);
    SCBSceneSessionManager.getInstance().registerDockAvoidWindowCallback(this.onDockAvoidWindowChangeCb)
  }

  private onDockVisibleChangeCb = (visible: boolean) => {
    log.showInfo(`onDockVisibleChangeCb visible: ${visible}`);
    this.isWindowOverlay = undefined;
    this.changeDockVisibleState(visible);
  }

  private onDockAvoidWindowChangeCb = (isOverlay: boolean) => {
    if (this.isWindowOverlay === isOverlay) {
      // 窗口移动时候会频繁上报该事件, 做去重处理
      return;
    }
    this.isWindowOverlay = isOverlay;
    log.showInfo(`onDockAvoidWindowChangeCb isOverlay: ${isOverlay}`);
    this.changeDockVisibleState(!isOverlay);
  }

  private changeDockVisibleState(visible: boolean): void {
    let isRecentPanel: boolean = AppStorage.get<boolean>('showRecent') as boolean;
    if (visible || viewMgrPolicy.isViewShowing(ViewType.APP_CENTER) || isRecentPanel) {
      // 任务中心或者应用中心界面不隐藏
      this.showDock();
    } else {
      this.hideDock();
    }
  }

  private setScale(scale: number): void {
    log.showInfo(`setScale from:${this.scaleRatio} to:${scale}`);
    if (this.scaleRatio === scale) {
      return;
    }
    this.scaleRatio = scale;
    SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId)?.setWindowScale(scale);
  }

  initGlobalAnimation() {
    this.setShowDockAnimation();
    this.setHideDockAnimation();
  }

  private setShowDockAnimation(): void {
    let showDockViewWithAnimation = ((): void => {
      if (viewMgrPolicy.isViewShowing(ViewType.SMART_DOCK) && this.finalState === SCBSmartDockViewState.VIEW_SHOWING) {
        log.showInfo(`not show dock, isShowing: ${viewMgrPolicy.isViewShowing(ViewType.SMART_DOCK)}, ` +
          `finalState: ${this.finalState}`);
        return;
      }
      const isInEditMode: boolean = editModeManager.isInEditMode();
      const isFormCenterView: boolean = this.formCenterMgr.isFormCenterViewShowing();
      if (this.isNegativeScreenShowing || isInEditMode || isFormCenterView) {
        log.showInfo(`not show dock, isNegative: ${this.isNegativeScreenShowing}, isEditMode: ${isInEditMode}, ` +
          `isFormCenterView: ${isFormCenterView}`);
        return;
      }
      log.showInfo(`show dock start, finalState: ${this.finalState}, scale: ${this.scaleRatio}`);
      this.finalState = SCBSmartDockViewState.VIEW_SHOWING;
      TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_SMART_DOCK_VIEW_SHOW_ANIMATION);
      viewMgrPolicy.showView(ViewType.SMART_DOCK);

      this.initGlobalAnimationAnimateTo();
    });
    GlobalContext.getInstance().setObject('showDockViewWithAnimation', showDockViewWithAnimation);
  }

  private setHideDockAnimation(): void {
    let hideDockViewWithAnimation = ((): void => {
      if (!viewMgrPolicy.isViewShowing(ViewType.SMART_DOCK) && this.finalState === SCBSmartDockViewState.VIEW_HIDING) {
        log.showInfo(`not hide dock, isShowing: ${viewMgrPolicy.isViewShowing(ViewType.SMART_DOCK)}, ` +
          `finalState: ${this.finalState}`);
        return;
      }
      let isDockMenuShow: boolean = AppStorage.get('isDockMenuShow') as boolean;
      let isDockMissionsPopupShow: boolean = AppStorage.get('isDockMissionsPopupShow') as boolean;
      if (isDockMenuShow || isDockMissionsPopupShow) {
        log.showInfo('dock menu or snapshot showing, not hide dock now');
        this.needHideDockAfterPopupExit = true;
        return;
      }
      log.showInfo(`hide dock start, finalState: ${this.finalState}, scale: ${this.scaleRatio}`);
      this.finalState = SCBSmartDockViewState.VIEW_HIDING;
      TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_SMART_DOCK_VIEW_HIDE_ANIMATION);
      animateTo({
        duration: 400,
        curve: Curve.Friction,
        onFinish: () => {
          log.showInfo(`hide dock end, finalState: ${this.finalState}`);
          localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);
          if (this.finalState != SCBSmartDockViewState.VIEW_SHOWING) {
            viewMgrPolicy.hideView(ViewType.SMART_DOCK);
          }
          TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_SMART_DOCK_VIEW_HIDE_ANIMATION);
        }
      }, () => {
        SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId)?.setTranslate(
          0, this.dockHeight, 0);
        this.setScale(1.1);
      })
    });
    GlobalContext.getInstance().setObject('hideDockViewWithAnimation', hideDockViewWithAnimation);
  }

  private initGlobalAnimationAnimateTo(): void {
    if (this.scaleRatio == 1) {
      return;
    }
    animateTo({
      duration: 400,
      curve: Curve.Friction,
      onFinish: () => {
        log.showInfo(`show dock end, finalState: ${this.finalState}`);
        TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_SMART_DOCK_VIEW_SHOW_ANIMATION);
      }
    }, () => {
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId)?.setTranslate(0, 0, 0);
      this.setScale(1);
    })
  }

  private readonly localEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: MouseEvent) => {
      if (event === EventConstants.EVENT_PC_HIDE_DOCK_CALLBACK) {
        this.hideDockAfterPopupExit();
      } else if (event === EventConstants.EVENT_RESET_HIDE_DOCK_AFTER_POPUP_STATE_CALLBACK) {
        this.needHideDockAfterPopupExit = false;
      }
    }
  }

  private hideDockAfterPopupExit(): void {
    if (this.needHideDockAfterPopupExit) {
      if (GlobalContext.getInstance().hasObject('hideDockViewWithAnimation')) {
        let hideDockViewWithAnimation = (GlobalContext.getInstance()
          .getObject('hideDockViewWithAnimation')) as Function;
        hideDockViewWithAnimation();
      } else {
        viewMgrPolicy.hideView(ViewType.SMART_DOCK);
      }
      this.needHideDockAfterPopupExit = false;
    }
  }

  getValueWithProgress(progress: number, startValue: number, endValue: number): number {
    if (progress < 0) {
      return startValue;
    }
    return startValue + (endValue - startValue) * progress;
  }

  private onFolderOpened(reason: string): void {
    this.setDockLayoutZIndex(SCBDefaultZIndex.DESKTOP - StyleConstants.DEFAULT_1, reason);
    this.onDockAnimateScaleChanged(CommonConstants.OPEN_FOLDER_ANIMATE_SCALE, reason);
  }

  private onFolderClosed(): void {
    this.onDockAnimateScaleChanged(StyleConstants.DEFAULT_1, 'onClosedFolder');
    // 文件夹关闭恢复之前打开的窗口
    AppStorage.setOrCreate('isFolderOpen', false);
    SmartDockEventMgr.getInstance().openFrontWindow();
  }

  private onDockAnimateScaleChanged(scale: number, msg: string) {
    log.showWarn(`onDockAnimateScaleChanged changeScale to ${scale}, due to:${msg}`);
    animateTo({
      duration: 500,
      curve: Curve.Friction
    }, () => {
      this.onDesktopAnimateScaleChanged(scale);
    });
  }

  private setDockLayoutZIndex(value: number, reason: string): void {
    log.showInfo(`setDockLayoutZIndex, from ${this.dockZIndex} to ${value}, reason: ${reason}`);
    if (this.dockZIndex === value) {
      return;
    }
    this.dockZIndex = value;
    this.smartDockController.setZIndex(value);
  }

  /**
   * 全搜定位场景动效执行时候降低dock z序, 定位结束如果是非文件夹打开场景还原
   */
  private onGlobalSearchAnimation(): void {
    if (this.isInGlobalSearchAnimation) {
      this.setDockLayoutZIndex(SCBDefaultZIndex.DESKTOP - StyleConstants.DEFAULT_1, 'onGlobalSearchAnimation');
    } else {
      const isFolderOpen: boolean = FolderManager.getInstance().isFolderOpen();
      log.showInfo(`onGlobalSearchAnimation isFolderOpen: ${isFolderOpen}`);
      if (!isFolderOpen) {
        this.setDockLayoutZIndex(SCBDefaultZIndex.SMART_DOCK, 'onGlobalSearchAnimation');
      }
    }
  }

  // 新文件夹回调
  private mOpenCloseCallback: FolderActionLifeCycleEvent = {
    description: TAG,
    priority: FolderLifeCyclePriority.LOW,
    onOpeningFolder: (folder: GridLayoutItemInfo) => {
      log.showInfo('dock folder on open');
      if (editModeManager.isInEditMode()) {
        return;
      }
      // 关闭所有在前台的窗口
      AppStorage.setOrCreate('isFolderOpen', true);
      SmartDockEventMgr.getInstance().closeFrontWindow();
      this.onFolderOpened('onOpeningFolder');
    },
    onClosingFolder: (folder: GridLayoutItemInfo) => {
      log.showInfo('dock folder on close');
      if (editModeManager.isInEditMode()) {
        return;
      }
      this.isFolderClosed = true;
      this.onFolderClosed();
    },
    onClosedFolder: (folder: GridLayoutItemInfo) => {
      log.showInfo(`dock folder closed, isFolderClosed: ${this.isFolderClosed}`);
      if (editModeManager.isInEditMode()) {
        return;
      }
      if (!this.isFolderClosed) {
        // 文件夹打开之后, 文件夹解散场景无onClosingFolder回调
        this.onFolderClosed();
      }
      this.isFolderClosed = null;
      this.setDockLayoutZIndex(SCBDefaultZIndex.SMART_DOCK, 'onClosedFolder');
    }
  };

  private addRecentCenter(): void {
    const residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let isRecentCenterExist: boolean = false;
    for (let item of residentList) {
      if (item?.abilityName === CommonConstants.RECENT_ABILITY) {
        isRecentCenterExist = true;
        break;
      }
    }
    if (SCBSceneSessionManager.getInstance().isPcMode() && !isRecentCenterExist) {
      log.showInfo('addRecentCenter');
      if (this.recentCenterItem) {
        SmartDockModel.getInstance().addToSmartDock(this.recentCenterItem, 0);
      }
    }
  }

  private deleteRecentCenter(): void {
    const residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    for (let item of residentList) {
      if (!SCBSceneSessionManager.getInstance().isPcMode() && item?.abilityName === CommonConstants.RECENT_ABILITY) {
        log.showInfo('deleteRecentCenter');
        if (this.recentCenterItem) {
          SmartDockModel.getInstance().deleteDockItem(this.recentCenterItem as DeleteDockItem,
            SmartDockConstants.RESIDENT_DOCK_TYPE);
        }
        break;
      }
    }
  }

  aboutToDisappear(): void {
    log.showInfo('smartDockPcMode aboutToDisappear');
    this.residentListener.off('layout', this.onResidentDrawEnd);
    this.recentListener.off('layout', this.onRecentDrawEnd);
    this.collaborationListener.off('layout', this.onCollaborationDrawEnd);
    if (!this.recentCenterItem) {
      this.recentCenterItem = this.createDockRecentAppInfo();
    }
    this.deleteRecentCenter();
    localEventManager.unregisterEventListener(this.localEventListener);
    WallpaperManager.getInstance().removeWallpaperChangeListener(this.wallPaperChange);
    SCBSceneSessionManager.getInstance().unregisterUnlockTransitionCallback(this.unLockTransitionController);
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChangeCallbacks);
    SCBSceneSessionManager.getInstance().unregisterDockVisibleCallback();
    SCBSceneSessionManager.getInstance().unregisterDockAvoidWindowCallback();
    this.desktopContext?.eventHub.off(CommonEventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    this.desktopContext?.eventHub.off(CommonConstants.NEGATIVE_SCREEN_SHOW_EVENT, this.onNegativeShowEvent);
    this.desktopContext?.eventHub.off(CommonConstants.NEGATIVE_SCREEN_HIDDEN_EVENT, this.onNegativeHideEvent);
    FolderActionLifeCycleEventManager.getInstance().unregister(this.mOpenCloseCallback);
    reportIntervalMgr.unRegisterEvent(this.dockAppCountEvent);
    SCBSceneSessionManager.getInstance().refreshAvailableArea();
  }

  build() {
    EffectComponent() {
      Column() {
        SmartDock({
          singleContext: this.singleContext
        })
      }
      .id(`${TAG}_SmartDock_${this.persistentId}`)
      .translate({ y: this.globalSearchTranslateY })
      .onDrop((event?: DragEvent, extraParams?: string) => {
        performanceMonitor.end(HiSysEventUtil.DRAG_ITEM_ANI);
        if (event) {
          event.useCustomDropAnimation = true;
          event.setResult(DragResult.DRAG_FAILED);
        }
      })
      .width('100%')
      .height(this.dockHeight)
      .scale({
        x: this.getValueWithProgress(this.negativeProgress, 1, NegativeScreenConstants.DESKTOP_INSIDE_SCALE_SHOW),
        y: this.getValueWithProgress(this.negativeProgress, 1, NegativeScreenConstants.DESKTOP_INSIDE_SCALE_SHOW),
        centerX: NegativeScreenConstants.DESKTOP_INSIDE_SCALE_CENTER,
        centerY: NegativeScreenConstants.DESKTOP_INSIDE_SCALE_CENTER,
      })
    }
    .onHover((isHover) => {
      if (isHover) {
        localEventManager.sendLocalEvent(EventConstants.EVENT_RESET_HIDE_DOCK_AFTER_POPUP_STATE_CALLBACK);
      }
    })
    .attributeModifier(this.smartDockScaleModifier)
    .margin({ top: this.smartDockController.getArea().top })
    .backgroundEffect({
      radius: this.isEnableBlur ? ResUtils.getNumber($r('app.float.ohos_id_blur_style_thin_radius')) : 0,
      saturation: this.isEnableBlur ? ResUtils.getNumber($r('app.float.ohos_id_blur_style_thin_saturation')) : 0,
      brightness: this.enableBrightness ? this.mBackgroundBrightness : 0,
      color: $r('app.color.back_plane_bg_color')
    })
  }

  /**
   * pad 自由多窗和SCBDesktop是同级窗口
   * dock区小文件夹转大文件夹时做动效因父节点不是SCBDesktop, 改变状态变量无法直接传递到SCBDesktop，所以使用通知的形式来通信
   */
  startConvertChange() {
    localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CONVERT_TO_BIG_STATUS_CHANGE,
      this.startConvert);
  }

  /**
   * pad 自由多窗和SCBDesktop是同级窗口
   * dock区小文件夹转大文件夹时做动效因父节点不是SCBDesktop, 改变状态变量无法直接传递到SCBDesktop，所以使用通知的形式来通信
   */
  convertFolderIdChange() {
    localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CONVERT_TO_BIG_FOLDER_ID_CHANGE,
      this.convertFolderId);
  }
}
