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
import {
  DomainName,
  LogDomain,
  LogHelper,
  Trace,
  TraceUtil,
  SingleContext
} from '@ohos/basicutils';
import {
  INVALID_SCREEN_ID,
  SCBPropertyChangeReason,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBSystemBarProperty,
} from '@ohos/windowscene';
import {
  GlobalContext,
  localEventManager,
  ViewArea,
  viewMgrPolicy,
  WallpaperColorManager,
  ViewType,
  DeviceHelper
} from '@ohos/frameworkwrapper';
import { BaseViewController } from '@ohos/frameworkcommon';
import { PowerStatus, WallpaperConstants } from '@ohos/commonconstants';
import { PCUtils } from '../../../common/utils/PCUtils';
import { ExtendScreenDockView } from '@ohos/pcsmartdock/src/main/ets/extmode/view/ExtendScreenDockView';
import {
  ExtendScreenDockViewData
} from '@ohos/pcsmartdock/src/main/ets/extmode/viewmodel/viewdata/ExtendScreenDockViewData';
import { ScbExtDockViewData } from '../viewmodel/viewdata/ScbExtDockViewData';
import PcSmartDockViewModel from '@ohos/pcsmartdock/src/main/ets/default/viewmodel/SmartDockViewModel';
import { EsDockEventManager } from '@ohos/pcsmartdock/src/main/ets/extmode/viewmodel/event/EsDockEventManager';
import { ExtendScreenDockEvent } from '@ohos/pcsmartdock/src/main/ets/extmode/viewmodel/event/ExtendScreenDockEvent';
import {
  ExtScreenModeDockViewModel
} from '@ohos/pcsmartdock/src/main/ets/extmode/viewmodel/ExtScreenModeDockViewModel';
import EventConstants from '@ohos/multiinput/src/main/ets/default/common/constants/EventConstants';
import { DockContinuableInfo, DockItemInfo, FormCenterViewManager, LayoutViewModel } from '@ohos/launchercommon';
import { SmartDockStyleConfig } from '@ohos/smartdock/src/main/ets/default/common/SmartDockStyleConfig';
import { EsDockEventListener } from '@ohos/pcsmartdock/src/main/ets/extmode/viewmodel/event/EsDockEventManager';
import { curves } from '@kit.ArkUI';
import SmartDockModel from '@ohos/smartdock/src/main/ets/default/model/SmartDockModel';
import { VisibleInfo } from '../../systemscene/SCBSmartDockMask';
import { DockBackgroundMgr } from '@ohos/pcsmartdock';
import {
  PcDockStyleConfig,
  PcSmartDockStyleManager
} from '@ohos/pcsmartdock/src/main/ets/default/common/PcSmartDockStyleManager';
import { DesktopSwitchController, VmStateCallBack } from '../../virtualmachine/DesktopSwitchController';
import { PcDockPopupMgr } from '@ohos/pcsmartdock/src/main/ets/default/manager/PcDockPopupMgr';

const TAG = 'SCBExtendScreenDock';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

const VS_INITIAL: number = 0;
const VS_SHOWING: number = 1;
const VS_HIDING: number = 2;
const DOCK_DELAY_TO_HIDE = 100;
let delayHideDock: number | null = null;

@Component
export struct SCBExtendScreenDock {
  /* 扩展屏、窗口控件参数 */
  @Link screenProp: SCBScreenProperty;
  @State singleContext?: SingleContext = { extendScreenId: this.screenProp.screenId };
  private persistentId: number = 0;
  private isHover: boolean = false;
  private isVisible: boolean = true;
  private dockDisplayState: number = VS_INITIAL;
  private translateY: number = 0;
  private ratio: number = 1;
  @State viewData: ScbExtDockViewData = new ScbExtDockViewData();
  private childViewData?: ExtendScreenDockViewData;
  viewController: BaseViewController = new BaseViewController(ViewType.SMART_DOCK_EXT_SCREEN, this.screenProp.screenId);
  /* Dock栏图标模型数据-常驻区全量应用列表 */
  @StorageLink('residentList') @Watch('onResidentAppListChange') globalResidentList: DockItemInfo[] = [];
  @StorageLink('recentList') @Watch('onRecentAppListChange') globalRecentList: DockItemInfo[] = [];
  @StorageLink('continueDeviceInfo') deviceInfo: DockContinuableInfo = new DockContinuableInfo();
  @StorageLink('isLock') @Watch('onLock') isLock: boolean = true;
  @StorageLink('clearDelayHideDock') @Watch('onClearDelayHideDock') clearDelayHideDock: VisibleInfo = new VisibleInfo();
  @StorageLink('isAppCenterShow') @Watch('onAppCenterViewChange') isAppCenterShow: boolean = false;
  @State currColorMode: number = 0;
  @State itemColorMode: number = 0;
  @State isFullScreenLayout: boolean = false;
  private mStyleConfig: SmartDockStyleConfig = PcSmartDockViewModel.getInstance().getStyleConfig();
  private mExtViewModel: ExtScreenModeDockViewModel = ExtScreenModeDockViewModel.getInstance();
  private dockAppListChangeHandler: EsDockEventListener = (evt: ExtendScreenDockEvent): void => {
    if (evt.eventType === ExtendScreenDockEvent.EVENT_TYPE_RESIDENT_APPS_CHANGED) {
      this.viewData.localResidentList = evt.eventParams as DockItemInfo[];
    } else if (evt.eventType === ExtendScreenDockEvent.EVENT_TYPE_RECENT_APPS_CHANGED) {
      this.viewData.localRecentList = evt.eventParams as DockItemInfo[];
    } else if (evt.eventType === ExtendScreenDockEvent.EVENT_TYPE_SYSTEM_APPS_CHANGED) {
      this.viewData.systemItemList = evt.eventParams as DockItemInfo[];
    } else {
      log.showInfo(`invalid eventType ${evt.eventType}`);
    }
  };
  private popupMgr: PcDockPopupMgr = PcDockPopupMgr.getInstance();

  private screenPropertyChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo(`ext screenProperty change reson:${reason}-rsID:${this.screenProp.rsId} screenId:${this.screenProp.screenId}-${this.screenProp.width}-` +
      `${this.screenProp.height}-${screenProperty.width}-${screenProperty.height}`);
    this.updateDockArea(screenProperty);

    if (screenProperty.width > 0) {
      this.mExtViewModel.initViewModel(this.screenProp);
      this.initView();
    }
  };

  private updateDockArea(screenProperty: SCBScreenProperty): void {
    // 窗口向下取整
    let dockHeightPx: number = Math.floor(this.getUIContext()?.vp2px(this.viewData.dockHeight));
    const newVpRect: ViewArea = {
      left: 0,
      top: this.getUIContext()?.px2vp(screenProperty.height) - this.viewData.dockHeight,
      width: this.getUIContext()?.px2vp(screenProperty.width),
      height: this.viewData.dockHeight
    };
    const newVpRectPx: ViewArea = {
      left: 0,
      top: screenProperty.height - dockHeightPx,
      width: screenProperty.width,
      height: dockHeightPx
    };
    this.viewController.updateArea(newVpRect);
    this.viewController.updateRectInPx(newVpRectPx);
    DockBackgroundMgr.getInstance().setDockRegion(screenProperty.screenId, screenProperty.height, dockHeightPx);
  }

  private backgroundChangeCallback = (colorMode: number, isFullScreen: boolean) => {
    log.showInfo(`DockBackgroundMgr screenId:${this.screenProp.screenId} colorMode:${colorMode} fullScreen:${isFullScreen}`);
    if (this.currColorMode != colorMode) {
      this.currColorMode = colorMode;
      this.mExtViewModel.setCurrColorMode(this.currColorMode);
    }
    if (this.isFullScreenLayout !== isFullScreen) {
      this.isFullScreenLayout = isFullScreen;
      this.setShadow(!isFullScreen);
    }
  }

  private itemColorChangeCallback = (colorMode: number) => {
    if ((colorMode > 0 && this.itemColorMode === 0) || (colorMode === 0 && this.itemColorMode > 0)) {
      this.itemColorMode = colorMode;
    }
  }

  private dockVisibleCallback = (visible: boolean) => {
    log.showInfo(`registerDockVisibleCallbackExt: ${visible}`);
    this.isVisible = visible;
    let isRecentPanel: boolean = AppStorage.get<boolean>('showRecent') as boolean;
    if (visible || viewMgrPolicy.isViewShowing(ViewType.APP_CENTER_EXT) || isRecentPanel) {
      this.doWholeDockVisibilityAnimationInNeed(this.screenProp.screenId, true);
    } else {
      this.doWholeDockVisibilityAnimationInNeed(this.screenProp.screenId, false);
    }
  }

  private vmStateCallback: VmStateCallBack = (isVm: boolean, tarVmScreenId: number) => {
    let isVmDesktop = isVm && tarVmScreenId === this.screenProp.screenId;
    log.showInfo(`vmStateCallback, isVmDesktop: ${isVmDesktop}, screenId: ${this.screenProp.screenId},` +
      ` ExtDockVisibleState: ${this.isVisible}`);
    if (isVmDesktop) {
      this.doWholeDockVisibilityAnimationInNeed(this.screenProp.screenId, false);
    } else if (this.isVisible) {
      this.doWholeDockVisibilityAnimationInNeed(this.screenProp.screenId, true);
    }
  }

  private registerAfterUpdateRectCallback() {
    let systemSceneSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId);
    systemSceneSession?.registerAfterUpdateRectCallback((rect)=>{
      SCBSceneSessionManager.getInstance().refreshAvailableArea(this.screenProp.screenId);
    });
  }

  private unRegisterAfterUpdateRectCallback() {
    let systemSceneSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId);
    systemSceneSession?.unregisterAfterUpdateRectCallback();
  }

  public aboutToAppear(): void {
    log.showInfo('Start');

    viewMgrPolicy.registerViewController(ViewType.SMART_DOCK_EXT_SCREEN, this.viewController);
    this.viewController.updateId(this.persistentId);
    this.setShadow(true);
    this.mExtViewModel.initViewModel(this.screenProp);
    this.mExtViewModel.setCurrColorMode(this.currColorMode);
    this.initView();
    this.registerAfterUpdateRectCallback();

    // 事件处理器注册
    this.initializeWholeDockAnimation();
    this.initEventListener();

    // 专项日志
    this.printAllInfo();

    // 执行Dock栏显示
    this.viewController.show();

    // 注册虚拟机状态回调
    DesktopSwitchController.getInstance().registerVmStateCallback(this.vmStateCallback);
  }

  public aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    const screenId: number = this.screenProp.screenId;
    this.unRegisterAfterUpdateRectCallback();
    EsDockEventManager.getInstance().unregisterAllEsDockEventListeners();
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChange, screenId);
    SCBSceneSessionManager.getInstance().unregisterDockVisibleCallback(screenId);
    DockBackgroundMgr.getInstance().deInit(screenId);
    DesktopSwitchController.getInstance().unregisterVmStateCallback(this.vmStateCallback);
  }

  private initEventListener(): void {
    DockBackgroundMgr.getInstance().init(this.screenProp.screenId, this.backgroundChangeCallback,
      this.itemColorChangeCallback);
    // 应用图标列表变化事件
    EsDockEventManager.getInstance()
      .registerEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_RESIDENT_APPS_CHANGED,
        this.dockAppListChangeHandler);
    EsDockEventManager.getInstance()
      .registerEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_RECENT_APPS_CHANGED,
        this.dockAppListChangeHandler);
    EsDockEventManager.getInstance()
      .registerEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_SYSTEM_APPS_CHANGED,
        this.dockAppListChangeHandler);

    // 窗体全屏和分屏变化回调注册
    const screenId: number = this.screenProp.screenId;
    SCBSceneSessionManager.getInstance().registerDockVisibleCallback(this.dockVisibleCallback, screenId);
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropertyChange, screenId);
  }

  private initView(): void {
    // 刷新Dock栏的可视区域
    this.resetDockViewSizeAndPosition();
    this.mExtViewModel.updateStyleConfig(this.screenProp);

    // 初始化常驻区图标的列表数据
    log.showInfo(`1L=>${this.globalResidentList.length}`);
    log.showInfo(`2L=>${this.globalRecentList.length}`);

    // 计算Dock的图标个数、列表宽度、布局信息
    this.initDockAppList();

    this.refreshViewData();

    PcSmartDockViewModel.getInstance().extScreenWidth = px2vp(this.screenProp.width);
    PcSmartDockViewModel.getInstance().extScreenHeight = px2vp(this.screenProp.height);
  }

  private refreshViewData(): void {
    this.viewData.localResidentList = this.mExtViewModel.getModelData().localResidentList;
    this.viewData.localRecentList = this.mExtViewModel.getModelData().localRecentList;
    this.viewData.residentListAreaWidth = this.mExtViewModel.getModelData().residentListAreaWidth;
    this.viewData.recentListAreaWidth = this.mExtViewModel.getModelData().recentListAreaWidth;
    this.viewData.systemItemList = this.mExtViewModel.getModelData().systemItemList;
    log.showInfo(`3L=>${this.viewData.localResidentList.length},${this.viewData.systemItemList.length},${this.viewData.localRecentList.length},${this.viewData.residentListAreaWidth}`);

    if (!this.childViewData) {
      this.childViewData = new ExtendScreenDockViewData();
    }

    this.childViewData.localResidentList = this.viewData.localResidentList;
    this.childViewData.localRecentList = this.viewData.localRecentList;
    this.childViewData.isResidentArrowShow = this.mExtViewModel.getModelData().arrowModel?.isResidentArrowShow ?? false;
    this.childViewData.currColorMode = this.currColorMode;
    this.childViewData.screenId = this.screenProp.screenId;
    this.childViewData.residentListAreaWidth = this.viewData.residentListAreaWidth;
    this.childViewData.recentListAreaWidth = this.viewData.recentListAreaWidth;
    this.childViewData.residentNum = this.mExtViewModel.getModelData().residentNum;
    this.childViewData.recentNum = this.mExtViewModel.getModelData().recentNum;
    this.childViewData.systemItemList = this.viewData.systemItemList;
    log.showInfo(`4L=>${this.childViewData.localResidentList.length},${this.childViewData.systemItemList.length},${this.childViewData.localRecentList.length},${this.childViewData.residentListAreaWidth}`);
  }

  private resetDockViewSizeAndPosition(): void {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    this.ratio = config.updateConfig(this.screenProp);
    this.viewData.dockHeight = config.mDockHeight;
    log.showInfo(`ES0-${this.screenProp.height}-${this.screenProp.width}-${this.viewData.dockHeight} `);
    this.updateDockArea(this.screenProp);
  }

  private initDockAppList(): void {
    this.onDockAppListDataChange(false, false);
    this.onDockAppListDataChange(true, false);
  }

  /**
   * 监听最近任务列表变化
   */
  private onRecentAppListChange(): void {
    log.showInfo('onRecentAppListChange');
    this.onDockAppListDataChange(false, true);
  }

  private onResidentAppListChange(): void {
    log.showInfo('onResidentAppListChange');
    this.onDockAppListDataChange(true, true);
  }

  private onLock(): void {
    if (this.isLock) {
      this.lockSmartDockCallback();
    } else {
      this.unlockSmartDockCallback();
    }
  }

  private lockSmartDockCallback(): void {
    this.setTranslateY(0, 'transparent by lockSmartDockCallback');
  }

  private unlockSmartDockCallback(): void {
    this.setTranslateY(0, 'transparent by unlockSmartDockCallback');
  }

  private setTranslateY(offsetY: number, reason: string) {
    log.showInfo(`setTranslateY curr:${this.translateY} next:${offsetY} reason:${reason}`);
    if (this.translateY === offsetY) {
      return;
    }
    this.translateY = offsetY;
    SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId)?.setTranslate(0, offsetY, 0);
  }

  private setShadow(shadowEnable: boolean): void {
    if (shadowEnable) {
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId)
      ?.setShadowChange(20, '#1a000000', 0, -2);
    } else {
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId)
      ?.setShadowChange(0, '#00000000', 0, 0);
    }
  }

  /**
   * 常驻区或者运行区数据变化
   */
  private onDockAppListDataChange(isResident: boolean, isAnim: boolean): void {
    Trace.start('ScbExtendSmartDock_onDockListChange');
    this.mExtViewModel.handleDockAppListDataChange(isResident, this.globalResidentList, this.globalRecentList);

    const callback = () => {
      this.mExtViewModel.handleDockAppListChangeForAnimation(isResident, this.globalResidentList, this.globalRecentList,
        false);
      this.refreshViewData();
    };
    if (isAnim && !this.isLock) {
      this.getUIContext().animateTo({
        duration: this.mExtViewModel.getModelData().arrowModel?.scrollAnimDuration ?? 0,
        curve: curves.interpolatingSpring(0, 1, 528, 40)
      }, callback);
    } else {
      callback();
    }
    Trace.end('ScbExtendSmartDock_onDockListChange');
  }

  private printAllInfo(): void {
    log.showInfo(`1ES-${this.viewData.residentListAreaWidth}`);
    log.showInfo(`3ES-${this.mStyleConfig.mListItemWidth}-${this.mStyleConfig.mListItemGap}`);
    log.showInfo(`4ES-${this.viewData.localResidentList.length}-${this.viewData.localRecentList.length}-${this.viewData.systemItemList.length}`);
    log.showInfo(`5ES-${this.globalResidentList.length}-${this.globalRecentList.length}`);
    log.showInfo(`7ES-${vp2px(1)}`);
    log.showInfo(`8ES-${GlobalContext.getContext().config.displayId}`);
    log.showInfo(`9ES-${this.screenProp.width}-${this.screenProp.height}`);
  }

  private doWholeDockVisibilityAnimationInNeed(screenId: number, visible: boolean): void {
    if (GlobalContext.getInstance().hasObject('setWholeDockVisibilityWithAnimation')) {
      let setWholeDockVisibilityWithAnimation = (GlobalContext.getInstance()
        .getObject('setWholeDockVisibilityWithAnimation')) as Function;
      setWholeDockVisibilityWithAnimation(screenId, visible);
    } else {
      if (visible) {
        viewMgrPolicy.showView(this.mExtViewModel.getDockViewType(screenId));
      } else {
        viewMgrPolicy.hideView(this.mExtViewModel.getDockViewType(screenId));
      }
    }
  }

  private initializeWholeDockAnimation(): void {
    let setWholeDockVisibilityWithAnimation = ((screenId: number, visible: boolean): void => {
      log.showInfo(`DOCK EXT ANIM 1 ${screenId}-${visible}`);
      let vt = this.mExtViewModel.getDockViewType(screenId);
      if (visible) {
        log.showInfo(`DOCK EXT ANIM 2 - ${vt}-${screenId}`);
        let powStatus: PowerStatus = AppStorage.get('powerStatus') as PowerStatus;
        let showing = viewMgrPolicy.isViewShowing(vt);
        if (powStatus !== PowerStatus.RUNNING ||
          (viewMgrPolicy.isViewShowing(vt) && this.dockDisplayState === VS_SHOWING)) {
          log.showInfo(`not show dock, powerStatus: ${powStatus},isShowing: ${showing}, vs: ${this.dockDisplayState}`);
          return;
        }
        if (this.isLock) {
          this.onLock();
        }
        log.showInfo(`show dock start,vs: ${this.dockDisplayState},transY:${this.translateY},` +
          `blurRatio:${this.viewData.blurRatio},scaleRatio:${this.viewData.scaleRatio}`);
        EsDockEventManager.getInstance().setNeedHideDockAfterPopupExit(screenId, false);
        TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_SMART_DOCK_VIEW_SHOW_ANIMATION);
        this.dockDisplayState = VS_SHOWING;
        viewMgrPolicy.showView(vt);
        if (this.translateY === 0 && this.viewData.blurRatio === 0 && this.viewData.scaleRatio === 1) {
          log.showInfo(`Interrupt dock show, transY: ${this.translateY},` +
            `blur: ${this.viewData.blurRatio}, scale: ${this.viewData.scaleRatio}`);
          return;
        }
        this.getUIContext()?.animateTo({
          duration: 400,
          curve: curves.interpolatingSpring(0, 1, 320, 36),
          onFinish: () => {
            log.showInfo(`show dock end, finalState: ${this.dockDisplayState}`);
            TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_SMART_DOCK_VIEW_SHOW_ANIMATION);
          }
        }, () => {
          this.setTranslateY(0, 'dockShowWithAnimation');
          this.viewData.blurRatio = 0;
          this.viewData.scaleRatio = 1;
        });
      } else {
        log.showInfo('DOCK EXT ANIM 3');
        const appCenterShow = viewMgrPolicy.isViewShowing(ViewType.APP_CENTER_EXT);
        log.showInfo(`DOCK EXT ANIM isExtAppCenterShow: ${appCenterShow}`);
        if (AppStorage.get('powerStatus') !== PowerStatus.RUNNING ||
          (!viewMgrPolicy.isViewShowing(vt) && this.dockDisplayState === VS_HIDING) ||
          appCenterShow || this.isHover) {
          log.showInfo(`not hide dock, powerStatus: ${AppStorage.get('powerStatus')}, ` +
            `isShowing: ${viewMgrPolicy.isViewShowing(vt)}, finalState: ${this.dockDisplayState}`);
          return;
        }

        const isDockMenuShow = this.popupMgr.isDockMenuShow(screenId);
        const isDockPopupShow = this.popupMgr.isDockPopupShow(screenId);
        if (isDockMenuShow || isDockPopupShow) {
          log.showInfo(`not hide dock, screenId: ${screenId}, isDockMenuShow: ${isDockMenuShow}, ` +
            `isDockPopupShow: ${isDockPopupShow}`);
          EsDockEventManager.getInstance().setNeedHideDockAfterPopupExit(screenId, true);
          return;
        }

        EsDockEventManager.getInstance().setNeedHideDockAfterPopupExit(screenId, false);

        log.showInfo(`hide dock start,vs: ${this.dockDisplayState},transY:${this.translateY},` +
          `blurRatio:${this.viewData.blurRatio},scaleRatio:${this.viewData.scaleRatio}`);
        this.dockDisplayState = VS_HIDING;
        TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_SMART_DOCK_VIEW_HIDE_ANIMATION);
        // 执行隐藏动效
        this.getUIContext()?.animateTo({
          duration: 400,
          curve: Curve.Friction,
          onFinish: () => {
            log.showInfo(`hide dock end, finalState: ${this.dockDisplayState}`);
            if (this.dockDisplayState != VS_SHOWING) {
              viewMgrPolicy.hideView(vt);
            }
            TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_SMART_DOCK_VIEW_HIDE_ANIMATION);
          }
        }, () => {
          this.setTranslateY(this.viewData.dockHeight, 'dockHideWithAnimation');
          this.viewData.blurRatio = 50;
          this.viewData.scaleRatio = 1;
        });
      }
    });
    GlobalContext.getInstance()
      .setObject('setWholeDockVisibilityWithAnimation', setWholeDockVisibilityWithAnimation);
  }

  onClearDelayHideDock(): void {
    log.showInfo(`onClearDelayHideDock ${this.clearDelayHideDock.isHover}, ${this.clearDelayHideDock.screenId}`);
    if (this.clearDelayHideDock.screenId === this.screenProp.screenId) {
      if (this.clearDelayHideDock.isHover) {
        this.clearTimer();
      } else {
        this.delayHideDock();
      }
    }
  }

  private onAppCenterViewChange(): void {
    DockBackgroundMgr.getInstance().setAppCenterShow(
      this.isAppCenterShow && viewMgrPolicy.isViewShowing(ViewType.APP_CENTER_EXT), this.screenProp.screenId);
  }

  private clearTimer(): void {
    if (delayHideDock) {
      clearTimeout(delayHideDock);
      delayHideDock = null;
    }
  }

  private delayHideDock(): void {
    this.clearTimer();
    delayHideDock = setTimeout(() => {
      log.showInfo('SCBSmartDock onHover false trigger');
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_DOCK_DISPLAY_VISIBLE_CHANGE, {
        'isVisible': false,
        'screenId': this.screenProp.screenId
      });
    }, DOCK_DELAY_TO_HIDE);
  }

  build() {
    Column() {
      ExtendScreenDockView({
        screenProp: this.screenProp,
        ratio: this.ratio,
        viewData: this.childViewData,
        currColorMode: this.currColorMode,
        itemColorMode: this.itemColorMode,
        isFullScreenLayout: this.isFullScreenLayout,
      })
    }
    .width('100%')
    .height(this.viewData.dockHeight)
    .scale({ x: this.viewData.scaleRatio, y: this.viewData.scaleRatio })
    .blur(this.viewData.blurRatio)
    .onMouse((mouseEvent) => {
      if (mouseEvent.action === MouseAction.Release) {
        SCBSceneSessionManager.getInstance().exitActiveSplit(INVALID_SCREEN_ID);
      }
    })
    .onHover((isHover) => {
      AppStorage.setOrCreate<boolean>('enableRenderGroupInExt', !isHover);
      this.isHover = isHover;
      if (!isHover) {
        log.showInfo('SCBExtScreenDock onHover false trigger');
        if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER_EXT)) {
          log.showInfo('resident or recent fold dock panel showing, dock not change');
          return;
        }
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_DOCK_DISPLAY_VISIBLE_CHANGE, {
          'isVisible': false,
          'screenId': this.screenProp.screenId
        });
      } else {
        this.clearTimer();
      }
    })
    .pointLight({
      lightSource: PCUtils.is2D() ? {
        positionX: 0,
        positionY: 0,
        positionZ: 0,
        intensity: 0
      } : {
        positionX: this.viewData.lightPositionX,
        positionY: this.viewData.lightPositionY,
        positionZ: this.viewData.lightPositionZ,
        intensity: this.viewData.intensityValue
      }
    })
  }
}