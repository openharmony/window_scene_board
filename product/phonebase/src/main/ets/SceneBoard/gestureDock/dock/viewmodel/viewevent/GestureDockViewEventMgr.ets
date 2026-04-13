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

import { CheckEmptyUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';
import { BaseViewController, } from '@ohos/frameworkcommon';
import {
  GlobalContext,
  localEventManager,
  ResourceManager,
  SceneIdentificationManager,
  SceneState,
  ViewCallback,
  ViewManagerPolicy,
  viewMgrPolicy,
  ViewType,
  WallpaperManager,
  WallpaperType
} from '@ohos/frameworkwrapper';
import {
  GestureNavigationState,
  GestureType,
  PcKeyType,
  SCBEventId,
  scbGestureManager,
  SCBPropertyChangeReason,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBSystemSceneSession,
  SCBTransitionManager,
  SCBUnlockTransitionController,
  ScenePanelState
} from '@ohos/windowscene';
import {
  AppModel,
  CommonConstants,
  EventConstants,
  ReceiveEventInfo,
  SettingsModel,
  StyleConstants
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { GestureDockItemInfo } from '../../../dockbar/model/GestureDockItemInfo';
import { GestureDockConstants, GestureDockMode } from '../../../common/GestureDockConstants';
import { GestureDockUtil } from '../../../common/util/GestureDockUtil';
import {
  HiSysDockDisappearModeData,
  HiSysDockEditType
} from '@ohos/frameworkwrapper/src/main/ets/hisysevent/HiSysData';
import GestureDockItemDragHandler from '../../../dockbar/viewmodel/viewhandler/GestureDockItemDragHandler';
import type ServiceExtensionContext from 'application/ServiceExtensionContext';
import GestureDockViewDataMgr from '../viewdata/GestureDockViewDataMgr';
import { GestureDockViewParam, SCBGestureDockParam } from '../viewdata/GestureDockParam';
import { SCBDefaultZIndex } from '../../../../scenemanager/SCBScreen';
import { GestureDockPullOutModel } from '../../../../gesturenavigation/back/model/GestureDockPullOutModel';
import { image } from '@kit.ImageKit';
import { CallStateHandler } from '../viewhandler/CallStateHandler';
import GestureDockViewAnimate from '../viewanimate/GestureDockViewAnimate';
import { GestureDockPreferenceMgr } from '../../../common/preference/GestureDockPreferenceMgr';
import { GestureDockViewEvent } from './GestureDockViewEvent';
import { GestureDockBarViewModel } from '../../../dockbar/viewmodel/GestureDockBarViewModel';
import { GestureDockAllAppsViewModel } from '../../../dockallapps/viewmodel/GestureDockAllAppsViewModel';
import { effectKit } from '@kit.ArkGraphics2D';
import { Size } from '@kit.ArkUI';
import { SystemNavReporter } from '../../../common/util/SystemNavReporter';
import { GestureDockViewModel } from '../GestureDockViewModel';
import { GestureDockDataController } from '../../../dockallapps/viewmodel/viewdata/GestureDockDataController';

const TAG = 'GestureDockViewEventMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);
const CROP_BLUR_EDGE_THRESHOLD: number = 30;

/**
 * 底部挖孔参数
 */
@Observed
export class BottomGestureParams {
  public translation: number = 0;
  public bottomCutOutDistance: number = 0;
  public shadow: ShadowStyle | undefined = undefined;
}

/**
 * 侧边dock方向 1--左 2--右
 */
export enum GestureDockDirection {
  GESTURE_DOCK_LEFT = 1,
  GESTURE_DOCK_RIGHT = 2,
}

/**
 * 侧边dock状态
 */
export enum GestureDockState {
  GESTURE_DOCK_IN = 0,
  GESTURE_DOCK_LEFT_OUT = 1,
  GESTURE_DOCK_RIGHT_OUT = 2,
  GESTURE_DOCK_LEFT_IN_RIGHT_OUT = 3,
  GESTURE_DOCK_RIGHT_IN_LEFT_OUT = 4,
}

/**
 * SCBGestureDockViewEvent
 */
export default class GestureDockViewEventMgr implements GestureDockViewEvent {
  public viewDataMgr: GestureDockViewDataMgr;
  public dockAllAppsViewModel: GestureDockAllAppsViewModel = GestureDockAllAppsViewModel.getInstance();
  public dockBarViewModel: GestureDockBarViewModel = GestureDockBarViewModel.getInstance();
  public gestureDockParam: GestureDockViewParam;
  public scbGestureDockParam: SCBGestureDockParam = SCBGestureDockParam.getInstance();
  public viewAnimate: GestureDockViewAnimate;
  private callStateHandler: CallStateHandler;
  private viewController: BaseViewController = new BaseViewController(TAG);
  private viewCallback: GestureDockViewCallback = new GestureDockViewCallback();
  private persistentId: number = 0;
  private screenProperty?: SCBScreenProperty;
  private sysSceneSession?: SCBSystemSceneSession;
  protected mAppModel: AppModel;
  private gestureDockDataController: GestureDockDataController;
  private dockPreference: GestureDockPreferenceMgr = GestureDockPreferenceMgr.getInstance();
  public bottomGestureParams: BottomGestureParams = new BottomGestureParams();
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private dockStartTime: number = 0;
  private isPullingOutGestureDock: boolean = false;
  private readonly localEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: number | boolean): void => {
      switch (event) {
        case EventConstants.HOME_KEY_INPUT:
          if (!scbGestureManager.isGestureEnable()) {
            log.showInfo('onHomeKeyInput ignore, gesture navigation not enable.');
            return;
          }
          this.onHomeOrRecentKeyInput();
          break;
      }
    }
  };

  /**
   * 构造器
   *
   * @param viewDataMgr 数据管理
   */
  public constructor(viewDataMgr: GestureDockViewDataMgr) {
    this.viewDataMgr = viewDataMgr;
    this.gestureDockParam = this.viewDataMgr.gestureDockParam;
    this.viewAnimate = new GestureDockViewAnimate(this.viewDataMgr);
    this.callStateHandler = new CallStateHandler(this.viewDataMgr);
    this.mAppModel = AppModel.getInstance();
    this.gestureDockDataController = GestureDockDataController.getInstance();
  }

  /**
   * 动效结束后gestureDock是否下树
   *
   * @param isShow
   */
  public showGestureDock(isShow: boolean): void {
    if (!isShow && this.isPullingOutGestureDock) {
      log.showInfo(`showGestureDock isShow:${isShow}, isExtrudeBallsBegin:${this.isPullingOutGestureDock}`);
      return;
    }
    this.scbGestureDockParam.isGestureDockShow = isShow;
  }

  /**
   * aboutToAppear
   *
   * @param screenProperty
   * @param persistentId
   */
  public aboutToAppear(screenProperty: SCBScreenProperty, persistentId: number): void {
    log.showInfo(`aboutToAppear persistentId:${persistentId}`);
    this.persistentId = persistentId;
    this.screenProperty = screenProperty;
    this.sysSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(persistentId);
    this.sysSceneSession?.setSkipEventAndShowOnVirtualScreen(true);
    viewMgrPolicy.registerViewController(TAG, this.viewController);
    this.viewController.updateId(this.persistentId);
    this.viewController.show();
    this.updateGestureDockResponseRegion();
    viewMgrPolicy.onGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId, this.gestureBackCallback);
    // 焦点监控
    viewMgrPolicy.registerViewCallback(TAG, this.viewCallback);
    this.initScreenPropertyListener();
    this.updateAppInfos();
    GestureDockPullOutModel.getInstance().registerDockAnimation(this.dockAnimationCallback);
    GestureDockPullOutModel.getInstance().setPersistentId(this.persistentId);
    GestureDockBarViewModel.getInstance().getViewEvent()?.setCutOutDistance();
    this.registerEventhub();
    this.registerGestureNavigationEventCallback();
    WallpaperManager.getInstance().getWallpaper(WallpaperType.DESKTOP, TAG).then((wallpaper: image.PixelMap) => {
      // 使用effectKit把壁纸提前模糊好，避免闪烁
      this.viewDataMgr.blurImage = wallpaper;
    });
    SCBTransitionManager.getInstance().registerUnlockTransitionController(this.unLockTransitionController, false);
    // 注册来电监听事件
    this.callStateHandler.subscribeCallStateChange();
    // 进入通知悬浮窗
    SceneIdentificationManager.notify(SceneState.GESTURE_DOCK_ENTER);
    this.desktopContext?.eventHub?.emit(GestureDockConstants.GESTURE_DOCK_APPEAR);
  }

  /**
   * aboutToDisappear
   */
  public aboutToDisappear(): void {
    log.showInfo(`[${TAG}] about to disappear`);
    this.resetPositionWithoutAnimation(this.screenProperty);
    // 侧边dock消失，还原AllAppsParam
    GestureDockAllAppsViewModel.getInstance().getViewEvent()?.resetAllAppsParam();
    this.statusBarPropertyControl();
    viewMgrPolicy.offGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId);
    GestureDockPullOutModel.getInstance().unRegisterDockAnimation();
    SCBSceneSessionManager.getInstance().unregisterGrayAppIconCallback();
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChangeCallback);
    SCBScreenSessionManager.getInstance().UnregisterStartFoldToExpandChangeCallback(
      this.startFoldToExpandChangeCallback, SCBDefaultZIndex.GESTURE_DOCK, this.screenProperty?.screenId);
    this.unRegisterEventhub();
    this.unregisterGestureNavigationEventCallback();
    this.releaseAllAppsBlurImage();
    SCBTransitionManager.getInstance().unRegisterUnlockTransitionController(this.unLockTransitionController, false);
    // 注册来电监听事件
    this.callStateHandler.unSubscribeCallStateChange();
    // 退出通知悬浮窗
    SceneIdentificationManager.notify(SceneState.GESTURED_DOCK_EXIT);
    this.desktopContext?.eventHub?.emit(GestureDockConstants.GESTURE_DOCK_DISAPPEAR);
    this.sysSceneSession?.setSkipEventAndShowOnVirtualScreen(false);
    // 释放AppStorage内存
    AppStorage.delete('gestureDockList');
    AppStorage.delete('isDrag');
    AppStorage.delete('isGestureDockDrag');
    AppStorage.delete('isLongPress');
    AppStorage.delete('notifyEnterFormManagerAnimate');
    AppStorage.delete('gestureDockDragItemInfo');
    AppStorage.delete('isGestureDockDrag');
    viewMgrPolicy.unRegisterViewCallback(TAG, this.viewCallback);
  }

  /**
   * 锁屏/解锁监听器
   */
  public unLockTransitionController: SCBUnlockTransitionController = {
    name: `${TAG}_gestureDock`,
    onLock: (): void => this.onLockReceived(),
    onUnlock: (): void => this.onUnLockReceived()
  };

  private onLockReceived(): void {
    if (this.gestureDockParam.gestureDockDirection > GestureDockState.GESTURE_DOCK_IN) {
      this.gestureDockParam.isShowAllApps = false;
      this.resetPositionWithoutAnimation();
      this.updateGestureDockResponseRegion();
    }
  }

  private onUnLockReceived() {
    log.showInfo('onUnLockReceived.');
  }

  /**
   * 注册事件
   */
  private registerEventhub(): void {
    this.desktopContext?.eventHub.on(GestureDockConstants.GESTURE_DOCK_DROP_ITEM, this.handleDragDrop);
    this.desktopContext?.eventHub?.on(SCBConstants.IS_ACCESSIBILITY_MODE_OPEN, this.onAccessibilityModeChange);
    log.showInfo('registerEventhub finish');
  }

  /**
   * 反注册事件
   */
  private unRegisterEventhub(): void {
    this.desktopContext?.eventHub.off(GestureDockConstants.GESTURE_DOCK_DROP_ITEM, this.handleDragDrop);
    this.desktopContext?.eventHub?.off(SCBConstants.IS_ACCESSIBILITY_MODE_OPEN, this.onAccessibilityModeChange);
    log.showInfo('unRegisterEventhub finish');
  }

  /**
   * 刷新App信息
   */
  public async updateAppInfos() {
    this.dockPreference.appList = this.gestureDockDataController.getAllAppsList(async () => {
      log.showInfo('getAppList callBack');
      this.dockPreference.syncPreferencesCache();
      this.dockPreference.getRecentDockList().then((recentItemInfoList: GestureDockItemInfo[]) => {
        log.showInfo(`dockInfoListLen: ${recentItemInfoList.length}, appListLen is ${this.dockPreference.appList.length}`)
        this.gestureDockParam.recentApps = recentItemInfoList;
        this.dockPreference.getDockApps().then((dockAppList: GestureDockItemInfo[]) => {
          this.gestureDockParam.dockApps = dockAppList;
          AppStorage.setOrCreate('gestureDockList', dockAppList);
          this.dockBarViewModel.getViewEvent()?.updateDockBarAppData();
          this.dockBarViewModel.getViewEvent()?.updateDockBarMaxHeight(this.screenProperty);
        });
        this.gestureDockParam.appList = this.dockPreference.appList;
      }).catch((reason: string) => {
        log.showError(`getRecentDockList rejected: ${reason}`);
      });
    });
  }

  /**
   * allApps显示
   */
  public showAllApps(): void {
    if (!this.gestureDockParam.isShowAllApps) {
      animateToImmediately({
        curve: Curve.Sharp,
        duration: 300
      }, () => {
        this.gestureDockParam.gestureDockShowMode = GestureDockMode.ALL_APPS;
        GestureDockAllAppsViewModel.getInstance().getViewEvent()?.onAllAppsShowChange(true);
        GestureDockBarViewModel.getInstance().getViewEvent()?.onAllAppsShowChange(true);
      });
      this.gestureDockParam.isShowAllApps = true;
      this.doTranslateAnimateOnAllAppsShow();
      SystemNavReporter.reportEnterDockEdit(HiSysDockEditType.ALL_APPS);
      // 进入allApps页面退出多任务
      if (AppStorage.get<number>('scenePanelState') === ScenePanelState.RECENT) {
        SCBSceneSessionManager.getInstance()?.exitRecent(this.screenProperty?.screenId);
      }
    } else {
      this.gestureDockParam.isShowAllApps = false;
      this.doTranslateAnimateOnAllAppsShow();
    }
  }

  /**
   * 隐藏allApps
   */
  public hideAllApps(): void {
    this.gestureDockParam.isShowAllApps = false;
    GestureDockBarViewModel.getInstance().getViewEvent()?.onAllAppsShowChange(false);
  }

  /**
   * 打开或关闭AllApps时的位移动效
   */
  public doTranslateAnimateOnAllAppsShow(): void {
    this.statusBarPropertyControl();
    GestureDockBarViewModel.getInstance().getViewEvent()?.doTranslateAnimateOnAllAppsShow();
  }

  /*
   * allApps页面状态栏沉浸
   * */
  public statusBarPropertyControl(): void {
    if (AppStorage.get<number>('scenePanelState') === ScenePanelState.RECENT) {
      log.showInfo(`scenePanelState is recent`);
      return;
    }
    if (!this.gestureDockParam.isShowAllApps) {
      this.gestureDockParam.gestureDockShowMode = GestureDockMode.APPEAR;
      SCBSceneSessionManager.getInstance().enterRecentTask(false);
    } else {
      SCBSceneSessionManager.getInstance().enterRecentTask(true);
    }
  }

  /**
   * 挤出融球动效开始
   */
  public onExtrudeBallsBegin(): void {
    log.showInfo(`gestureDock onExtrudeBallsBegin`);
    this.isPullingOutGestureDock = true;
  }

  /**
   * 挤出融球动效结束
   */
  public onChangeToDockImgAnimFinish(): void {
    log.showInfo(`gestureDock onExtrudeBallsFinish`);
    this.isPullingOutGestureDock = false;
  }

  /**
   * 侧边dock进入编辑模式
   */
  public startAllAppsEdit(): void {
    this.gestureDockParam.gestureDockShowMode = GestureDockMode.EDIT;
    log.showInfo(`gestureDock showMode is ${this.gestureDockParam.gestureDockShowMode}`);
  }

  /**
   * 侧边dock退出编辑模式
   */
  public finishAllAppsEdit(): void {
    this.gestureDockParam.gestureDockShowMode = GestureDockMode.ALL_APPS;
  }

  /**
   * back事件回调
   */
  private gestureBackCallback = () => {
    log.showInfo(`gestureBackCallback...gestureDock in`);
    this.dockExitReporter();
    if (this.gestureDockParam.gestureDockDirection > GestureDockState.GESTURE_DOCK_IN) {
      GestureDockPullOutModel.getInstance().notifyDockAnimation(GestureDockState.GESTURE_DOCK_IN, () => {
        if (this.isPullingOutGestureDock) {
          log.showInfo(`GESTURE_DOCK_IN ExtrudeBalls begin:${this.isPullingOutGestureDock}`);
          return;
        }
        this.scbGestureDockParam.isGestureDockShow = false;
      });
    } else {
      this.scbGestureDockParam.isGestureDockShow = false;
    }
  }

  private initScreenPropertyListener(): void {
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropertyChangeCallback);
    SCBScreenSessionManager.getInstance().registerStartFoldToExpandChangeCallback(this.startFoldToExpandChangeCallback,
      SCBDefaultZIndex.GESTURE_DOCK, this.screenProperty?.screenId);
  }

  private screenPropertyChangeCallback = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    this.viewController.updateRect({
      left: 0,
      top: 0,
      width: px2vp(screenProperty.width),
      height: px2vp(screenProperty.height)
    });
    this.gestureDockParam.isShowAllApps = false;
    this.resetPositionWithoutAnimation(screenProperty);
  }
  private startFoldToExpandChangeCallback = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason,
    currScreenProperty?: SCBScreenProperty) => {
    if (reason === SCBPropertyChangeReason.FOLD_TO_EXPAND || reason === SCBPropertyChangeReason.EXPAND_TO_FOLD) {
      this.gestureDockParam.isShowAllApps = false;
      this.resetPositionWithoutAnimation(screenProperty);
    }
  }

  /**
   * 注册底部手势监听
   */
  private registerGestureNavigationEventCallback(): void {
    scbGestureManager.registerGestureEvent(GestureType.NAVIGATION, GestureDockConstants.GESTURE_DOCK_TAG,
      (type: GestureNavigationState, event: GestureEvent) => {
        switch (type) {
          case GestureNavigationState.START:
            this.dockExitReporter();
            this.resetDockPosition(false);
            this.hideAllApps();
            this.statusBarPropertyControl();
            break;
          default:
            break;
        }
      })
    scbGestureManager.registerPcKeyCallback(TAG, (type: PcKeyType) => {
      log.showInfo(`get PCKEY callback , type=${type}`)
      if (!scbGestureManager.isGestureEnable()) {
        return;
      }
      if (ViewManagerPolicy.isViewShowing(ViewType.KEYGUARD)) {
        return;
      }
      switch (type) {
        case PcKeyType.HOME:
        case PcKeyType.RECENT:
          this.onHomeOrRecentKeyInput();
          break;
        default:
          break;
      }
    });
    localEventManager.registerEventListener(this.localEventListener, [EventConstants.HOME_KEY_INPUT]);
  }

  private onHomeOrRecentKeyInput() {
    this.dockExitReporter();
    this.resetDockPosition(false);
    this.hideAllApps();
    this.statusBarPropertyControl();
  }

  private unregisterGestureNavigationEventCallback(): void {
    scbGestureManager.unRegisterGestureEvent(GestureType.NAVIGATION, GestureDockConstants.GESTURE_DOCK_TAG);
    scbGestureManager.unregisterPcKeyCallback(TAG);
    localEventManager.unregisterEventListener(this.localEventListener);
  }

  /**
   * 获取app图标
   *
   * @param appInfo 侧边dock中appInfo
   * @returns 缓存图标
   */
  public getAppIcon(appInfo: GestureDockItemInfo): string {
    if (this.isPadLauncher(appInfo) && appInfo.abilityName === CommonConstants.APPCENTER_ABILITY) {
      return StyleConstants.DEFAULT_ALL_APP_IMAGE;
    } else if (this.isPadLauncher(appInfo) && appInfo.abilityName === CommonConstants.RECENT_ABILITY) {
      return StyleConstants.DEFAULT_TASK_IMAGE;
    } else {
      let icon = ResourceManager.getInstance().getCachedAppIcon(appInfo.appIconId,
        appInfo.bundleName as string, appInfo.moduleName as string);
      return icon;
    }
  }

  private isPadLauncher(appInfo: GestureDockItemInfo): boolean {
    return SettingsModel.getInstance().getDevice() !== CommonConstants.DEFAULT_DEVICE_TYPE &&
      appInfo.bundleName === CommonConstants.LAUNCHER_BUNDLE;
  }

  /**
   * 初始化gestureDock参数
   * @param animationType 启动类型
   */
  public initGestureDockParam(animationType: number): void {
    this.gestureDockParam.gestureDockDirection = animationType;
    this.gestureDockParam.gestureDockShowMode = GestureDockMode.APPEAR;
    GestureDockBarViewModel.getInstance().getViewEvent()?.initDockBarParam();
    this.updateGestureDockResponseRegion();
  }

  /**
   * gesture dock栏内拖拽enter事件
   */
  public handleDragEnter(): void {
    let dockBarViewData = this.dockBarViewModel.getViewData();
    if (this.gestureDockParam.gestureDockShowMode === GestureDockMode.EDIT && dockBarViewData) {
      let residentApps = AppStorage.get('gestureDockList') as GestureDockItemInfo[];
      GestureDockItemDragHandler.getInstance().handleDragEnter(dockBarViewData.getDockBarRecentNum(),
        residentApps, this.gestureDockParam.gestureDockDirection);
    }
  }

  /**
   * gesture dock栏内拖拽move事件
   *
   * @param event 拖拽事件
   */
  public handleDragMove(event: DragEvent): void {
    if (this.gestureDockParam.gestureDockShowMode === GestureDockMode.EDIT) {
      let scrollTranslate = GestureDockBarViewModel.getInstance().getViewData()?.getScrollTranslate();
      GestureDockItemDragHandler.getInstance().handleDragMove(event, scrollTranslate);
    }
  }

  /**
   * 拖拽落位
   *
   * @param event 拖拽event
   */
  public handleDragDrop = (event?: DragEvent) => {
    if (this.gestureDockParam.gestureDockShowMode === GestureDockMode.EDIT) {
      let dragDropResult: GestureDockItemInfo[] = GestureDockItemDragHandler.getInstance().handleDragDrop(event);
      if (event) {
        event.useCustomDropAnimation = true;
      }
      AppStorage.setOrCreate('gestureDockList', dragDropResult);
      this.gestureDockParam.dockApps = dragDropResult;
      this.dockPreference.updateDockAppsPreference(dragDropResult);
      this.desktopContext?.eventHub.emit(GestureDockConstants.GESTURE_DOCK_ITEM_SQUEEZE_CANCEL);
    }
    AppStorage.setOrCreate('isGestureDockDrag', false);
    event?.setResult(DragResult.DRAG_SUCCESSFUL);
  }
  private onAccessibilityModeChange = (isAccessibilityMode: boolean) => {
    log.showInfo(`isAccessibilityMode is ${isAccessibilityMode}`);
    if (isAccessibilityMode && this.scbGestureDockParam.isGestureDockShow) {
      this.gestureDockParam.isShowAllApps = false;
      this.resetDockPosition(false);
    }
  }
  /**
   * 侧边dock动效回调
   *
   * @param animationType 动效类型
   * @param dockAnimFinish dock动效结束回调
   */
  public dockAnimationCallback = (animationType: number, dockAnimFinish?: Function) => {
    let dockAllAppsEvent = GestureDockAllAppsViewModel.getInstance().getViewEvent();
    if (dockAllAppsEvent && !dockAllAppsEvent.isAllAppsAnimateFinish()) {
      log.showError(`isAllAppsAnimateFinish, return. ${GestureDockAllAppsViewModel.getInstance().getViewEvent()}`);
      return;
    }
    log.showInfo(`animationType is ${animationType}, originDirection is ${this.gestureDockParam.gestureDockDirection}`);
    switch (animationType) {
      case GestureDockState.GESTURE_DOCK_IN:
        SystemNavReporter.reportDockDisappear(this.gestureDockParam.gestureDockDirection,
          new Date().getTime() - this.dockStartTime, HiSysDockDisappearModeData.BACK_GESTURE);
        this.resetDockPosition(true, dockAnimFinish);
        this.updateGestureDockResponseRegion();
        break;
      case GestureDockState.GESTURE_DOCK_LEFT_OUT:
        this.gestureDockShow(animationType);
        break;
      case GestureDockState.GESTURE_DOCK_RIGHT_OUT:
        this.gestureDockShow(animationType)
        break;
      case GestureDockState.GESTURE_DOCK_LEFT_IN_RIGHT_OUT:
        SystemNavReporter.reportDockDisappear(this.gestureDockParam.gestureDockDirection,
          new Date().getTime() - this.dockStartTime, HiSysDockDisappearModeData.GESTURE_DOCK_LEFT_IN_RIGHT_OUT);
        this.resetDockPosition(true);
        this.updateGestureDockResponseRegion();
        break;
      case GestureDockState.GESTURE_DOCK_RIGHT_IN_LEFT_OUT:
        SystemNavReporter.reportDockDisappear(this.gestureDockParam.gestureDockDirection,
          new Date().getTime() - this.dockStartTime, HiSysDockDisappearModeData.GESTURE_DOCK_RIGHT_IN_LEFT_OUT);
        this.resetDockPosition(true);
        this.updateGestureDockResponseRegion();
        break;
      default:
        log.showError(`gesture dock type error`);
        break;
    }
  };

  private gestureDockShow(animationType: number): void {
    this.initGestureDockParam(animationType);
    SystemNavReporter.reportGestureDockShow(this.gestureDockParam.gestureDockDirection);
    this.dockStartTime = new Date().getTime();
    GestureDockBarViewModel.getInstance().getViewEvent()?.showDockBar(animationType);
    this.desktopContext?.eventHub?.emit(GestureDockConstants.GESTURE_DOCK_SHOW);
    if (this.sysSceneSession?.isTouchable === false) {
      this.sysSceneSession.setSessionTouchable(true);
    }
  }

  /**
   * 侧边dock恢复原始位置
   *
   * @param isGestureDockAppear
   * @param resetDockPositionCallback
   * @param immediately
   */
  public resetDockPosition(isGestureDockAppear: boolean, resetDockPositionCallback?: Function,
    immediately?: boolean): void {
    log.showInfo(`originDirection is ${this.gestureDockParam.gestureDockDirection}, isGestureDockAppear is ${isGestureDockAppear} `);
    let originDirection = this.gestureDockParam.gestureDockDirection;
    this.gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_IN;
    this.dockBarViewModel.getViewEvent()?.doRestPositionAnimate(
      originDirection, isGestureDockAppear, resetDockPositionCallback, immediately);
  }

  /**
   * 复原gestureDock参数
   *
   * @param screenProperty 屏幕特性
   */
  public resetPositionWithoutAnimation(screenProperty?: SCBScreenProperty): void {
    log.showInfo(`onScreenChange,direction is ${this.gestureDockParam.gestureDockDirection}`);
    GestureDockUtil.hideTextInput();
    this.gestureDockParam.gestureDockShowMode = GestureDockMode.INVISIBLE;
    this.scbGestureDockParam.isGestureDockShow = false;
    this.gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_IN;
    GestureDockBarViewModel.getInstance().getViewEvent()?.resetDockBarParams(screenProperty);
  }

  /**
   * 空白区域点击
   */
  public onBlankAreaClick(): void {
    log.showInfo(`blank area onClick`);
    if (this.gestureDockParam.isShowAllApps) {
      log.showError('all apps show,return');
      return;
    }
    SystemNavReporter.reportDockDisappear(this.gestureDockParam.gestureDockDirection,
      new Date().getTime() - this.dockStartTime, HiSysDockDisappearModeData.BLANK_AREA_CLICK);
    this.resetDockPosition(false);
    this.updateGestureDockResponseRegion();
  }

  /**
   * 设置侧滑控件的控制区域
   */
  public updateGestureDockResponseRegion(): void {
    log.showInfo(`sceneSessionSetResponseRegion Status is ${this.gestureDockParam.gestureDockDirection}`);
    if (CheckEmptyUtils.isEmpty(this.sysSceneSession)) {
      return;
    }
    if (this.gestureDockParam.gestureDockDirection > GestureDockState.GESTURE_DOCK_IN) {
      this.sysSceneSession?.setResponseRegion([{
        x: 0,
        y: 0,
        width: this.screenProperty?.width,
        height: this.screenProperty?.height
      }]);
    } else {
      this.sysSceneSession?.setResponseRegion([{
        x: 0,
        y: 0,
        width: 0,
        height: 0
      }]);
    }
  }

  /**
   * 释放AllApps图片内存
   */
  public releaseAllAppsBlurImage(): void {
    if (this.viewDataMgr.blurImage) {
      GestureDockUtil.releaseSrc(this.viewDataMgr.blurImage, TAG);
    }
    this.viewDataMgr.blurImage = undefined;
    GestureDockAllAppsViewModel.getInstance().getViewEvent()?.releaseAllAppsBlurImage();
  }

  /**
   * 对图片进行模糊处理,并裁切  CROP_BLUR_EDGE_THRESHOLD 裁切边缘阈值
   * @param image
   * @returns blurImage
   */
  public getEffectImage(wallpaper: image.PixelMap): image.PixelMap {
    try {
      const iconSize: Size = wallpaper.getImageInfoSync().size;
      const cropTransparentEdgeSize = CROP_BLUR_EDGE_THRESHOLD;
      let cropSize: image.Size = {
        width: iconSize.width - cropTransparentEdgeSize * 2,
        height: iconSize.height - cropTransparentEdgeSize * 2
      };
      let cropRegion: image.Region = {
        size: cropSize,
        x: cropTransparentEdgeSize,
        y: cropTransparentEdgeSize
      };
      let effectImage: image.PixelMap =
        effectKit.createEffect(wallpaper).blur(GestureDockConstants.BLUR_RADIUS).getPixelMap();
      effectImage.cropSync(cropRegion);
      return effectImage;
    } catch (error) {
      log.showWarn(`crop error, ${error}`);
      return wallpaper;
    }
  }

  /**
   * 记录手势Dock退出事件
   */
  private dockExitReporter(): void {
    switch (this.gestureDockParam.gestureDockShowMode) {
      case GestureDockMode.EDIT:
        SystemNavReporter.reportExitDockEdit(HiSysDockEditType.EDIT);
        break;
      case GestureDockMode.ALL_APPS:
        SystemNavReporter.reportExitDockEdit(HiSysDockEditType.ALL_APPS);
        break;
      default:
        break;
    }
  }

  /**
   * 空白区域触摸事件
   * @param event
   */
  public onBlankAreaTouch(event: TouchEvent): void {
  }

  /**
   * allApps位移
   * @param translation
   */
  public doAllAppsViewTranslate(translation: number): void {
    this.gestureDockParam.allAppsTranslation = translation;
  }

  /**
   * 以防allApps过早消失，在动效中显示
   * @param isDisappearing
   */
  public setDisappearing(isDisappearing: boolean): void {
    this.gestureDockParam.isDisappearing = isDisappearing;
  }
}

/**
 * 焦点监听
 */
class GestureDockViewCallback implements ViewCallback {
  /**
   * 聚焦回调
   */
  onGainFocus(): void {
    log.showInfo('GestureDockViewCallback onGainFocus')
  }

  /**
   * 失焦回调
   */
  onLoseFocus(): void {
    // 侧边栏失焦后自动关闭 CCB评审暂不解决
    log.showInfo('GestureDockViewCallback onGainFocus')
  }
}
