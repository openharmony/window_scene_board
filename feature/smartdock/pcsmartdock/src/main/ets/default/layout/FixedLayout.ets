/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  ObjUtil,
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
  Trace,
  SingleContext,
} from '@ohos/basicutils';
import {
  INVALID_SCREEN_ID,
  SCBPropertyChangeReason,
  SCBRotateChangeReason,
  SCBSceneSessionManager, SCBScreenProperty,
  SCBScreenSessionManager,
  SystemBarType, windowMgr } from '@ohos/windowscene';
import {
  EventManager,
  EvtBus,
  sEventManager,
  ResourceManager,
  obtainLocalEvent,
  IconResourceManager,
  ProcessStateChangeEvent,
  GlobalContext,
  localEventManager,
  HiSysEventUtil,
  DeviceHelper
} from '@ohos/frameworkwrapper';
import {
  StyleConstants,
  CommonConstants,
  DockItemInfo,
  GridLayoutItemInfo,
  DockContinuableInfo,
  ReceiveEventInfo,
  EventConstants,
  RecentBundleMissionInfo,
  LayoutViewModel,
  IconType,
  DockUtils,
  ResidentLayoutCacheMgr,
  GetHideAppsFromConfig
} from '@ohos/launchercommon';
import SmartDockConstants from '@ohos/smartdock/src/main/ets/default/common/constants/SmartDockConstants';
import AppItem from './AppItem';
import { PcDockPopupMgr } from '../manager/PcDockPopupMgr';
import { DockStatusBarComponent } from './DockStatusBarComponent';
import PcSmartDockViewModel from '../viewmodel/SmartDockViewModel';
import { ArrowType, FixedDockResource, HoverItemInfo, FixedDockConstants } from '../common/constants/FixedDockConstants';
import { PCDockUtils } from '../utils/PCDockUtils';
import curves from '@ohos.curves';
import {
  BundleInfo,
  StatusBarConnectEvent,
  StatusBarServiceEventManager,
  StatusBarServiceInfo,
  TrayManager
} from '@ohos/statusbarextensionservice/src/main/ets/TsIndex';
import { PcDockAnimationMgr } from '../manager/PcDockAnimationMgr';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { ToggleHomeForFixedDock } from '@ohos/togglehome';
import parameter from '@ohos.systemparameter';
import { PCDockDragMgr } from '../manager/PCDockDragMgr';
import { StatusBarType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import PcModeContinuableModel from '@ohos/smartdock/src/main/ets/default/pcmode/model/PcModeContinuableModel';
import { PcModeDockUtils } from '@ohos/smartdock/src/main/ets/default/utils/PcModeDockUtils';
import { PcSmartDockStyleManager, PcDockStyleConfig} from '../common/PcSmartDockStyleManager';
import { PluginStyleUtil } from '@ohos/statusbarcomponent/src/main/ets/pc/common/PluginStyleUtil';

const TAG = 'FixedLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

const DISTRIBUTED_COMMUNICATION = 'DISTRIBUTED_COMMUNICATION_';
const TRACE_ONDOCKLISTCHANGE = 'ScbSmartDock_onDockListChange';

@Component
export default struct FixedLayout {
  @Link screenProp: SCBScreenProperty;
  @Prop singleContext?: SingleContext;
  private leftArrowPath: ResourceStr = $r('sys.media.ohos_ic_public_arrow_left');
  private rightArrowPath: ResourceStr = $r('sys.media.ohos_ic_public_arrow_right');
  private isResidentLeftArrowClickable: boolean = true;
  private isResidentRightArrowClickable: boolean = true;
  private isResidentLeftArrowHover: boolean = false;
  private isResidentRightArrowHover: boolean = false;
  private isPreLoadEnable: boolean = false;
  private mResidentScroller: Scroller = new Scroller();
  private scrollAnimDuration: number = 600;
  private threshold: number = 0;
  private residentNum: number = 0;
  private recentNum: number = 0;
  private wpsAppPidList: number[] = [];
  private wpsTokenId: number = -1;
  private wpsAppInfo: DockItemInfo | undefined = undefined;
  private isWpsEventRegistered: boolean = false;
  private smartDockViewModel: PcSmartDockViewModel = PcSmartDockViewModel.getInstance();
  private pcDockAnimationMgr: PcDockAnimationMgr = PcDockAnimationMgr.getInstance(this.screenProp.screenId);
  private eventMgr: EventManager = EvtBus.createEventManager();
  private additionResidentListWidth: number = 0;
  private additionRecentListWidth: number = 0;
  @State baseResidentListWidth: number = 0;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private residentStartIndex: number = 0;
  private residentEndIndex: number = 0;
  private continueItemVisibleFunc: Function = () => this.isContinueItemVisible();
  private getContinuableItemIndexFunc: Function = () => this.getContinuableItemIndex();
  private mPCDockDragMgr: PCDockDragMgr = PCDockDragMgr.getInstance();
  private isResidentMovingInAnim: boolean = false;
  private readonly dockChangeAnim: AnimateParam = {curve: curves.interpolatingSpring(0, 1, 528, 40)};
  private readonly dockDragAnim: AnimateParam = {curve: curves.interpolatingSpring(0, 1, 660, 66)};
  private readonly linearAnim: AnimateParam = { curve: Curve.Linear, duration: 0 };
  @State dockWidth: number = 0;
  @State dividerAnimateParam: AnimateParam = this.dockChangeAnim;
  @State dividerOffsetXAnim: number = 0;
  private popupMgr: PcDockPopupMgr = PcDockPopupMgr.getInstance();
  @State isResidentArrowShow: boolean = false;
  @State isRecentArrowShow: boolean = false;
  @State mResidentMaxMaxNum: number = 0;
  @State mRecentMaxMaxNum: number = 0;
  @State residentLeftArrowBgColor: ResourceColor | null = null;
  @State residentRightArrowBgColor: ResourceColor | null = null;
  @State residentLeftArrowOpacity: Resource | number = 1;
  @State residentRightArrowOpacity: Resource | number = 1;
  @State residentListWidth: number = 0;
  @State recentListWidth: number = 0;
  @State isUnLockReceived: boolean = true;
  @State localResidentList: Array<DockItemInfo> = []; // 去掉应用中心、多任务后的快捷区列表
  @State localRecentList: Array<DockItemInfo> = [];

  @StorageProp('statusBarType') @Watch('onStatusBarTypeChange') statusBarType: number = StatusBarType
    .TYPE_MAIN_MAC_STATUS_BAR;
  @State @Watch('onDockStatusBarChange') rightStatusBarWidth: number = 0;
  @State @Watch('onLeftDockStatusBarChange') leftStatusBarWidth: number = 0;
  @State useSpecialJustify: boolean = false;
  @State specialFlexWidth: number = 0;
  @State animatedIconId: number = -1;

  @StorageLink('systemLanguage') language: string = '';
  @StorageLink('continueDeviceInfo') @Watch('onContinueDeviceChange') deviceInfo: DockContinuableInfo = new DockContinuableInfo();
  @StorageLink('residentList') @Watch('onDockListChange') globalResidentList: Array<DockItemInfo> = [];
  @StorageLink('recentList') @Watch('onDockListChange') globalRecentList: Array<DockItemInfo> = [];
  @StorageProp('mWallpaperAvgColor') mWallpaperAvgColor: string = '#00ffffff';
  @StorageLink('enableRenderGroup') enableRenderGroup: boolean = true;
  @Link currColorMode: number;
  @StorageLink('isDropAnimationGoing') @Watch('onDropAnimationStatusChanged') isDropAnimationGoing: boolean = false;
  private dragWidthChangeCurve: curves.ICurve = curves.interpolatingSpring(0, 1, 200, 23);
  @State isDockChange: boolean = false;
  @StorageLink('collaborationDataList') @Watch('onCollaborationDataListChange') collaborationDataList: Array<DockItemInfo> = [];
  @State localCollaborationList: DockItemInfo[] = [];
  private isRotating: boolean = false;

  @State systemItemList: DockItemInfo[] = [];
  @State enableScrollInteraction: boolean = true;
  private isReachEnd: boolean = false;
  private oldDeviceInfoBundleName: string = ''; // 记录上一次接续应用包名
  private clickArrowTimerId: number = 0;
  @StorageLink('isLock') isLock: boolean = true;

  /**
   * 落位动画结束后更新dock栏
   */
  private onDropAnimationStatusChanged() {
    log.showInfo(`onDropAnimationStatusChanged ${this.isDropAnimationGoing}`);
    if (!this.isDropAnimationGoing) {
      this.mPCDockDragMgr.onDropAnimationEnd();
    }
  }

  private listWidthChange = (isResident: boolean, additionWidth: number): void => {
    this.additionResidentListWidth = additionWidth;
    this.residentListWidth = this.baseResidentListWidth + additionWidth;
    log.showInfo(`listWidthChange,isResident:${isResident}, ${additionWidth}` +
      `${this.baseResidentListWidth},${this.residentListWidth}`);
  }

  /**
   * pad的自由多窗模式下，wps进程监听事件
   */
  private wpsAppProcessChange = (event: ProcessStateChangeEvent): void => {
    if (!SCBSceneSessionManager.getInstance().isPcMode()) {
      return;
    }
    log.showInfo(`wpsAppProcessChange : ${event.bundleName}, ${event.requestPid}, ${event.visible}`);
    if (event.bundleName !== FixedDockConstants.WPS_BUNDLE_NAME || !event.requestPid) {
      return;
    }
    if (event.visible && !this.wpsAppPidList.includes(event.requestPid)) {
      this.wpsAppPidList.push(event.requestPid)
    }
    if (!event.visible && this.wpsAppPidList.includes(event.requestPid)) {
      this.wpsAppPidList.splice(this.wpsAppPidList.indexOf(event.requestPid), 1);
      TrayManager.getOrCreateTrayManager().tokenIdProcessExit(this.wpsTokenId, event.requestPid);
    }
    log.showInfo(`wps pid list size: ${this.wpsAppPidList.length}}`)
    if (this.wpsAppPidList.length > 0) {
      this.updateAppNameListForWps();
    } else {
      // wps的所有进程全部关闭
      let openAppNameList = AppStorage.get('openAppNameList') as Array<string>;
      if (openAppNameList.includes(event.bundleName)) {
        openAppNameList.splice(openAppNameList.indexOf(event.bundleName), 1);
        AppStorage.setOrCreate('openAppNameList', openAppNameList);
      }
      let appItemIndex: number = this.globalRecentList.findIndex(item => item.bundleName === event.bundleName);
      if (appItemIndex != -1) {
        this.globalRecentList.splice(appItemIndex, 1);
      }
      TrayManager.getOrCreateTrayManager().deleteTrayForApp(this.wpsTokenId);
      this.wpsTokenId = -1;
      this.wpsAppInfo = undefined;
    }
  }

  /**
   * wps窗口启动的监听事件
   */
  private wpsWindowInfoCallback = (serviceInfo: StatusBarServiceInfo) => {
    if (!SCBSceneSessionManager.getInstance().isPcMode()) {
      return;
    }
    if (!serviceInfo) {
      log.showError(`serviceInfo is undefined`);
      return;
    }
    log.showInfo(`wpsWindowInfoCallback bundleName: ${serviceInfo.bundleName}`);
    if (serviceInfo.bundleName !== FixedDockConstants.WPS_BUNDLE_NAME) {
      log.showWarn(`serviceInfo bundleName is ${serviceInfo.bundleName}, not wps`);
      return;
    }
    if (serviceInfo.type === StatusBarConnectEvent.UPDATE_QUICK_OPERATION_HEIGHT) {
      log.showWarn('serviceInfo update height');
      this.updateWpsUnreadMessageWindow('updateHeight', serviceInfo);
      return;
    }
    if (serviceInfo.type !== StatusBarConnectEvent.ADD_TO_STATUS_BAR) {
      log.showWarn(`serviceInfo type is ${serviceInfo.type}, not add`);
      return;
    }
    if (this.wpsTokenId !== serviceInfo.tokenId) {
      if (this.wpsTokenId !== -1) {
        // 删除旧托盘
        log.showInfo(`delete last wps trap tokenId: ${this.wpsTokenId} , new TokenId: ${serviceInfo.tokenId}`);
        TrayManager.getOrCreateTrayManager().deleteTrayForApp(this.wpsTokenId);
      }
      // wps窗口程序成功创建，需要为wps创建托盘，使其可启动服务
      TrayManager.getOrCreateTrayManager().createTrayForApp(
        serviceInfo.tokenId, FixedDockConstants.WPS_BUNDLE_NAME, [serviceInfo.pid]);
      this.wpsTokenId = serviceInfo.tokenId;
    }
    this.updateWpsUnreadMessageWindow('add', serviceInfo);
    if (!this.wpsAppPidList.includes(serviceInfo.pid)) {
      this.wpsAppPidList.push(serviceInfo.pid)
    }
    if (this.wpsAppPidList.length > 0) {
      this.updateAppNameListForWps();
    }
  }

  private updateWpsUnreadMessageWindow(updateState: string, serviceInfo: StatusBarServiceInfo): void {
    let height: number | undefined;
    if (updateState === 'add') {
      height = serviceInfo.data?.statusBarItem?.quickOperation.height;
    } else if (updateState === 'updateHeight') {
      height = serviceInfo.data?.operationHeight;
    } else {
      height = undefined;
    }
    this.publishWpsUnreadMessageTitleInfo(updateState, height,
      serviceInfo.data?.statusBarItem?.quickOperation?.abilityName,
      serviceInfo.data?.statusBarItem?.quickOperation?.moduleName);
  }

  private publishWpsUnreadMessageTitleInfo(updateState: string,
                                           height: number | undefined,
                                           abilityName: string | undefined,
                                           moduleName: string | undefined): void {
    log.showInfo(`updateWpsInfo wps app: ${this.wpsAppInfo?.bundleName}`);
    this.findWpsAppInfo();
    if (!this.wpsAppInfo) {
      log.showError(`this.wpsAppInfo is undefintd`);
      return;
    }
    // 先异步获取名称和图标，然后传递wps的信息到“未读消息”窗口，用于窗口的标题
    ResourceManager.getInstance().getAppNameWithCache(
      this.wpsAppInfo?.appLabelId, this.wpsAppInfo?.bundleName, this.wpsAppInfo?.moduleName, this.wpsAppInfo?.appName,
      (name: string): void => {
        IconResourceManager.getInstance().getCombIcon(
          this.wpsAppInfo?.bundleName, this.wpsAppInfo?.moduleName, this.wpsAppInfo?.abilityName
        ).then((iconResource: string | PixelMap) => {
          log.showInfo(`updateWpsInfo state: ${updateState}, label: ${name}, height: ${height}`);
          sEventManager.publish(obtainLocalEvent('FloatingSceneEvent', {
            bundleName: this.wpsAppInfo?.bundleName,
            abilityName: abilityName,
            moduleName: moduleName,
            dockBundleName: this.wpsAppInfo?.bundleName,
            dockAbilityName: this.wpsAppInfo?.abilityName,
            dockModuleName: this.wpsAppInfo?.moduleName,
            label: name,
            height: height,
            state: updateState,
            icon: iconResource,
          }));
        });
      });


  }

  private findWpsAppInfo(): void {
    if (this.wpsAppInfo) {
      return;
    }
    for (let i = 0; i < this.globalRecentList.length; i++) {
      if (this.globalRecentList[i].bundleName === FixedDockConstants.WPS_BUNDLE_NAME) {
        this.wpsAppInfo = this.globalRecentList[i];
        return;
      }
    }
    for (let i = 0; i < this.globalResidentList.length; i++) {
      if (this.globalResidentList[i].bundleName === FixedDockConstants.WPS_BUNDLE_NAME) {
        this.wpsAppInfo = this.globalResidentList[i];
        return
      }
    }
  }

  /**
   * wps服务启动的监听事件
   */
  private wpsTrayServiceCallback = (tokenId: number, pid: number, instanceKey: string, isDetached: boolean) => {
    if (!SCBSceneSessionManager.getInstance().isPcMode()) {
      return;
    }
    log.showInfo(`wpsTrayCallback tokenId: ${tokenId} create pid: ${pid}`);
    if (tokenId !== this.wpsTokenId) {
      log.showWarn(`tokenId is ${tokenId}, not wps`);
      return;
    }
    if (!this.wpsAppPidList.includes(pid)) {
      this.wpsAppPidList.push(pid);
    }
    if (this.wpsAppPidList.length > 0) {
      this.updateAppNameListForWps();
    }
  }

  private updateAppNameListForWps(): void {
    let openAppNameList = AppStorage.get('openAppNameList') as Array<string>;
    if (!openAppNameList) {
      openAppNameList = [];
    }
    if (!openAppNameList.includes(FixedDockConstants.WPS_BUNDLE_NAME)) {
      openAppNameList.push(FixedDockConstants.WPS_BUNDLE_NAME);
      AppStorage.setOrCreate('openAppNameList', openAppNameList);
    }
    log.showInfo(`now openAppNameList size : ${openAppNameList.length}`);
  }

  /**
   * wps的预退出接口，点击wps右键弹窗选项“退出”时执行
   */
  private wpsPreExitFunc = () => {
    this.wpsAppPidList.forEach((pid: number) => {
      log.showInfo(`exit wps app pid : ${pid}`);
    })
    TrayManager.exitTrayProcess(this.wpsAppPidList);
  }

  private queryExistingWpsPid(): void {
    TrayManager.getOrCreateTrayManager().forEach((bundleInfo: BundleInfo, key: number, instanceKey: string) => {
      if (bundleInfo.bundleName !== FixedDockConstants.WPS_BUNDLE_NAME) {
        return;
      }
      this.wpsTokenId = key;
      bundleInfo.pids.forEach((pid: number) => {
        log.showInfo(`tokenID ${this.wpsTokenId} pids: ${pid}`);
        if (!this.wpsAppPidList.includes(pid)) {
          this.wpsAppPidList.push(pid);
        }
      })
      bundleInfo.backPids.forEach((pid: number) => {
        log.showInfo(`tokenId ${this.wpsTokenId} backPids: ${pid}`);
        if (!this.wpsAppPidList.includes(pid)) {
          this.wpsAppPidList.push(pid);
        }
      })
      if (this.wpsAppPidList.length > 0) {
        this.updateAppNameListForWps();
        // 延迟发送消息，需等待dock图标列表已经更新，才能获取wps图标信息
        setTimeout(() => {
          this.publishWpsUnreadMessageTitleInfo('add',
            bundleInfo.data?.quickOperation.height,
            bundleInfo.data?.quickOperation.abilityName,
            bundleInfo.data?.quickOperation.moduleName);
        }, 200);
      }
    })
  }

  private registerWpsEventListener(): void {
    if (SCBSceneSessionManager.getInstance().isPcMode()) {
      log.showInfo('register wps event listener');
      this.isWpsEventRegistered = true;
      this.eventMgr
        .on(ProcessStateChangeEvent, this.wpsAppProcessChange)
      // 注册整体托盘后台进程创建回调
      TrayManager.getOrCreateTrayManager().registerTrayManagerListener(this.wpsTrayServiceCallback);
      // 注册窗口创建信息监听
      StatusBarServiceEventManager.getInstance().registerStatusBarServiceEvent(this.wpsWindowInfoCallback);
      // 查询"监听注册之前"已经存在的进程
      this.queryExistingWpsPid();
    }
  }

  private unregisterWpsEventListener(): void {
    if (this.isWpsEventRegistered) {
      log.showInfo('unregister wps event listener');
      this.isWpsEventRegistered = false;
      this.eventMgr.offAll();
      StatusBarServiceEventManager.getInstance().unRegisterStatusBarEvent(this.wpsWindowInfoCallback);
      TrayManager.getOrCreateTrayManager().unRegisterTrayManagerListener(this.wpsTrayServiceCallback);
    }
  }

  private createDockRecentAppInfo(): DockItemInfo {
    let dockItemInfo = new DockItemInfo();
    dockItemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
    dockItemInfo.abilityName = CommonConstants.RECENT_ABILITY;
    dockItemInfo.itemType = CommonConstants.TYPE_FUNCTION;
    dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
    dockItemInfo.appIndex = 0;
    return dockItemInfo;
  }

  private createDockAppcenterAppInfo(): DockItemInfo {
    let dockItemInfo = new DockItemInfo();
    dockItemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
    dockItemInfo.abilityName = CommonConstants.APPCENTER_ABILITY;
    dockItemInfo.itemType = CommonConstants.TYPE_FUNCTION;
    dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
    dockItemInfo.appIndex = 0;
    return dockItemInfo;
  }

  private onDockListChange(reason: string): void {
    log.showInfo(`onDockListChange reason:${reason}`);
    this.updateDockListInfoWithAnimation();
  }

  /**
   * 判断是否向运行区添加接续图标占位
   * @returns
   */
  private isAddContinuableItem(): boolean {
    if (!PCDockUtils.isContinuableItemExists(this.deviceInfo)) {
      return false;
    }
    const isInResidentList = PcModeDockUtils.isInDockList(this.globalResidentList, this.deviceInfo.bundleName);
    if (isInResidentList) {
      return false;
    }
    const index = this.globalRecentList.findIndex((item: DockItemInfo) => {
      return item?.bundleName == this.deviceInfo.bundleName && (item?.appIndex ?? 0) === 0 &&
        (item?.itemType ?? 0) === CommonConstants.TYPE_APP ;
    });
    return index < 0;
  }

  private updateDockListInfoWithAnimation(isNeedAnimation: boolean = true,
      isAddContinuableItem: boolean = false): void {
    log.showInfo('ScbSmartDock Change Animation');
    Trace.start(TRACE_ONDOCKLISTCHANGE);
    this.smartDockViewModel.onDockListChange();
    let residentNum: number = 0;
    let recentNum: number = 0;
    if (SCBSceneSessionManager.getInstance().isPcMode()) {
      // 2 means appCenter and recentCenter
      residentNum = this.globalResidentList.length + 1;
    } else {
      residentNum = this.globalResidentList.length;
    }
    recentNum = this.globalRecentList.length + (this.isAddContinuableItem() ? 1 : 0);
    if (!CheckEmptyUtils.isEmptyArr(this.collaborationDataList)) {
      recentNum += this.collaborationDataList.length;
    }
    log.showInfo(`residentNum: ${residentNum}, ${this.residentNum}, recentNum: ${recentNum}, ${this.recentNum}`);
    if (!this.isResidentMovingInAnim) {
      this.isResidentMovingInAnim = recentNum === this.recentNum && residentNum < this.residentNum;
    }
    this.mPCDockDragMgr.onDockListNumChange(residentNum, recentNum);
    if (this.mPCDockDragMgr.isDockDragging && !this.isRotating) {
      // dock拖拽期间不在这里更新doc数量/长度, 在onDockListNumChangeInDrag更新, 旋转场景除外
      return;
    }
    this.residentNum = residentNum;
    this.recentNum = recentNum;
    this.setMaxNum();
    let updateUICallback = () => {
      log.showInfo(`updateUICallback residentNum:${this.residentNum} now:${this.globalResidentList.length}`);
      this.getRecentListWidth();
      this.updateLocalRecentList(isAddContinuableItem);
      this.updateLocalResidentList();
      this.initArrowState();
      this.residentVisibleListUpdate();
      this.residentListWidth = this.getResidentWidth();
      this.calculateIfIconFlexChange();
    };

    if ((!this.isRotating || isNeedAnimation) && !this.isLock) {
      animateTo(this.dockChangeAnim, updateUICallback);
    } else {
      updateUICallback();
    }
    if (this.isResidentArrowShow) {
      this.updateResidentArrowState();
    }
    Trace.end(TRACE_ONDOCKLISTCHANGE);
  }

  /**
   * 更新分割线动画参数
   */
  private updateDividerOffsetXAnim() {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    const itemWidth = (config.mListItemWidth +
      config.mListItemGap / 2);
    const leftGap = (this.isResidentArrowShow ?
    config.mRecentArrowGap : config.mListItemGap / 2);
    const rightGap = (this.isRecentArrowShow ?
    config.mRecentArrowGap : config.mListItemGap / 2);
    if (this.isResidentMovingInAnim) {
      this.dividerOffsetXAnim = itemWidth +
        (rightGap - leftGap - config.mResidentSplitLineWidth) / 2;
    } else {
      this.dividerOffsetXAnim =
        (itemWidth + rightGap - leftGap - config.mResidentSplitLineWidth) / 2;
    }
    log.showInfo(`updateDividerOffsetXAnim: ${this.dividerOffsetXAnim}`);
  }

  private calculateFixedMaxNum(): number {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    let maxNum: number = config.mFixedMaxNum;
    let maxIconListWidth: number = config.mScreenWidth - this.rightStatusBarWidth -
    this.leftStatusBarWidth;
    if (this.isMacStyle()) {
      maxIconListWidth = config.mScreenWidth - this.leftStatusBarWidth - this.leftStatusBarWidth;
    }
    if (this.isResidentArrowShow) {
      maxIconListWidth -= (2 * config.mRecentArrowWidth +
      this.getArrowLeftMargin(ArrowType.RESIDENT_LEFT) + this.getArrowRightMargin(ArrowType.RESIDENT_LEFT) +
      this.getArrowLeftMargin(ArrowType.RESIDENT_RIGHT) + this.getArrowRightMargin(ArrowType.RESIDENT_RIGHT));
    }
    if (!CheckEmptyUtils.isEmptyArr(this.globalResidentList) &&
      (!CheckEmptyUtils.isEmptyArr(this.globalRecentList) || this.isAddContinuableItem()) ||
      !CheckEmptyUtils.isEmptyArr(this.collaborationDataList)) {
      maxIconListWidth -= this.getDividerWidth();
    }
    maxNum = Math.floor(maxIconListWidth / (config.mListItemWidth + config.mListItemGap));
    log.showInfo(`FixedMaxNum: ${maxNum}`);
    return maxNum;
  }

  private calculateFixedMaxNumWithoutArrow(): number {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    let maxNum: number = config.mFixedMaxNum;
    let maxIconListWidth: number = config.mScreenWidth - this.rightStatusBarWidth -
    this.leftStatusBarWidth;
    if (this.isMacStyle()) {
      maxIconListWidth = config.mScreenWidth - this.leftStatusBarWidth - this.leftStatusBarWidth;
    }
    if (!CheckEmptyUtils.isEmptyArr(this.globalResidentList) &&
      (!CheckEmptyUtils.isEmptyArr(this.globalRecentList) || this.isAddContinuableItem() ||
        !CheckEmptyUtils.isEmptyArr(this.collaborationDataList))) {
      maxIconListWidth -= (config.mResidentSplitLineWidth + config.mListItemGap / 2 +
        config.mListItemGap / 2);
    }
    maxNum = Math.floor(maxIconListWidth /
      (config.mListItemWidth + config.mListItemGap));
    this.threshold = Math.floor(maxNum / 4) < 4 ? 4 : Math.floor(maxNum / 4);
    log.showInfo(`FixedMaxNumWithoutArrow: ${maxNum}, threshold: ${this.threshold}`);
    return maxNum;
  }

  private setMaxNum(): void {
    const fixedMaxNum: number = this.calculateFixedMaxNum();
    this.mResidentMaxMaxNum = Math.min(this.residentNum + this.recentNum, fixedMaxNum) - this.systemItemList.length;
    log.showInfo(`setMaxNum this.mResidentMaxMaxNum: ${this.mResidentMaxMaxNum} ${this.residentNum} ${this.recentNum}`);
  }

  private initArrowState(): void {
    let fixedMaxNum: number = this.calculateFixedMaxNumWithoutArrow();
    this.calculateArrowShow(fixedMaxNum);
    this.setMaxNum();
  }

  private calculateArrowShow(fixedMaxNum: number) {
    log.showInfo(`calculateArrowShow residentNum:${this.residentNum} recent:${this.recentNum} fixed:${fixedMaxNum}`);
    this.isResidentArrowShow = this.residentNum + this.recentNum > fixedMaxNum;
    this.pcDockAnimationMgr.setIsResidentArrowShow(this.isResidentArrowShow);
  }

  private updateResidentArrowState(): void {
    if (!this.isResidentArrowShow) {
      return;
    }
    this.isResidentLeftArrowClickable = this.residentStartIndex > 0;
    this.isResidentRightArrowClickable = !this.mResidentScroller.isAtEnd();
    this.refreshResidentArrowBgColor();
  }

  private refreshResidentArrowBgColor(): void {
    log.showInfo(`refreshResidentArrowBgColor ${this.isResidentLeftArrowClickable} ${this.isResidentRightArrowClickable}`);
    if (this.isResidentLeftArrowClickable) {
      this.residentLeftArrowBgColor = this.isResidentLeftArrowHover ?
        (this.isDarkMode() ? FixedDockResource.ARROW_HOVER_DARK_COLOR :
        FixedDockResource.ARROW_HOVER_LIGHT_COLOR) : null;
      this.residentLeftArrowOpacity = 1;
    } else {
      this.residentLeftArrowBgColor = null;
      this.residentLeftArrowOpacity = $r('sys.float.ohos_id_alpha_disabled');
    }
    if (this.isResidentRightArrowClickable) {
      this.residentRightArrowBgColor = this.isResidentRightArrowHover ?
        (this.isDarkMode() ? FixedDockResource.ARROW_HOVER_DARK_COLOR :
        FixedDockResource.ARROW_HOVER_LIGHT_COLOR) : null;
      this.residentRightArrowOpacity = 1;
    } else {
      this.residentRightArrowBgColor = null;
      this.residentRightArrowOpacity = $r('sys.float.ohos_id_alpha_disabled');
    }
  }

  private continueDeviceChangeOnAppear(): void {
    this.onContinueDeviceChange();
  }

  private onContinueDeviceChange(): void {
    if (GetHideAppsFromConfig.getInstance().isHideApp(this.deviceInfo.bundleName)) {
      this.deviceInfo = new DockContinuableInfo();
    }
    this.desktopContext?.eventHub?.emit('continueItemChange', this.deviceInfo);
    log.showInfo(`deviceBundleName: ${this.deviceInfo?.bundleName}`);
    if (ObjUtil.isInvalid(this.deviceInfo) ||
    ObjUtil.isInvalid(this.deviceInfo?.bundleName) ||
    ObjUtil.isInvalid(this.deviceInfo?.sourceDeviceName)) {
      this.oldDeviceInfoBundleName = '';
      this.setContinueShow(false);
      this.desktopContext?.eventHub.off('continueItemChange');
    } else {
      // 判断常驻区是否有对应的图标
      if (PcModeDockUtils.isInDockList(this.globalResidentList, this.deviceInfo.bundleName)) {
        if (PcModeDockUtils.isInDockList(this.localRecentList, this.oldDeviceInfoBundleName)) {
          // 基于上一次接续的应用判断是否需要刷新运行区
          log.showInfo('onContinueDeviceChange recentList deviceInfo need update');
          this.updateDockListInfoWithAnimation(true, false);
        }
        log.showInfo(`onContinueDeviceChange in residentList return, old: ${this.oldDeviceInfoBundleName}`);
        this.oldDeviceInfoBundleName = this.deviceInfo.bundleName;
        return;
      }
      // 判断运行区是否有对应的图标
      if (PcModeDockUtils.isInDockList(this.globalRecentList, this.deviceInfo.bundleName)) {
        if (PcModeDockUtils.isInDockList(this.localRecentList, this.oldDeviceInfoBundleName)) {
          // 基于上一次接续的应用判断是否需要刷新运行区
          log.showInfo('onContinueDeviceChange recentList deviceInfo need update');
          this.updateDockListInfoWithAnimation(true, false);
        }
        log.showInfo(`onContinueDeviceChange in recentList return, old: ${this.oldDeviceInfoBundleName}`);
        this.oldDeviceInfoBundleName = this.deviceInfo.bundleName;
        return;
      }
      this.oldDeviceInfoBundleName = this.deviceInfo.bundleName;
      this.setContinueShow(true);
    }
  }

  private closeMenuAndDockPopup(): void {
    AppStorage.setOrCreate('isPopupShow', false);
    PcDockPopupMgr.getInstance().setCurrItem(null);
    this.popupMgr.setIsDockMenuShow(this.screenProp.screenId, true);
    ContextMenu.close();
  }

  private readonly localEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: MouseEvent) => {
      if (event === EventConstants.EVENT_CLOSE_DOCK_MENU_AND_POPUP) {
        this.closeMenuAndDockPopup();
      }
    }
  }

  setContinueShow(isShow: boolean): void {
    log.showInfo(`setContinueShow, isShow: ${isShow}`);
    this.updateDockListInfoWithAnimation(true, isShow);
  }

  private updateLocalResidentList(addResidentNum: number = 0): void {
    let localResidentList: DockItemInfo[] = [];
    let localSystemList: DockItemInfo[] = [];
    let recycleBinItem: DockItemInfo | null = null;
    let fileManagerItem: DockItemInfo | null = null;
    let recentCenterItem: DockItemInfo | null = null;
    let appCenterItem: DockItemInfo | null = null;
    for (let i = this.globalResidentList.length - 1; i >= 0; i--) {
      if (this.globalResidentList[i]?.abilityName === CommonConstants.APPCENTER_ABILITY) {
        appCenterItem = this.globalResidentList[i];
        continue;
      }
      if (this.globalResidentList[i]?.abilityName === CommonConstants.RECENT_ABILITY) {
        recentCenterItem = this.globalResidentList[i];
        continue;
      }
      if (PCDockUtils.isFileManager(this.globalResidentList[i]?.bundleName)) {
        fileManagerItem = this.globalResidentList[i];
        continue;
      }
      if (this.globalResidentList[i]?.abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
        recycleBinItem = this.globalResidentList[i];
        continue;
      }
      localResidentList.unshift(this.globalResidentList[i]);
    }
    // 文管不开源
    /*if (recycleBinItem) {
      localSystemList.unshift(recycleBinItem); // 把文管加到常驻区的开头(可被翻页隐藏)
    }
    if (fileManagerItem) {
      localSystemList.unshift(fileManagerItem); // 把文管加到常驻区的开头(可被翻页隐藏)
    }*/
    if (recentCenterItem) {
      localSystemList.unshift(recentCenterItem); // 把任务中心常驻区的开头(可被翻页隐藏)
    } else {
      if (DeviceHelper.is2In1DevicePcType() && this.globalResidentList.length > 0) {
        recentCenterItem = this.createDockRecentAppInfo();
        localSystemList.unshift(recentCenterItem);
      }
    }
    if (appCenterItem) {
      localSystemList.unshift(appCenterItem); // 把应用中心加到常驻区的开头(可被翻页隐藏)
    } else {
      if (DeviceHelper.is2In1DevicePcType() && this.globalResidentList.length > 0) {
        appCenterItem = this.createDockAppcenterAppInfo();
        localSystemList.unshift(appCenterItem);
      }
    }
    this.systemItemList = localSystemList;
    this.localResidentList = localResidentList;
    this.fixGlobalResidentList();
    this.pcDockAnimationMgr.setSystemVisibleList(this.systemItemList);
    this.mPCDockDragMgr.setLocalResidentList(this.systemItemList, this.localResidentList);
  }

  private fixGlobalResidentList(): void {
    if (CheckEmptyUtils.isEmpty(this.systemItemList) || CheckEmptyUtils.isEmpty(this.globalResidentList) ||
      this.systemItemList.length > this.globalResidentList.length || !DeviceHelper.isPC()) {
      return;
    }
    for (let i = 0; i < this.systemItemList.length; i++) {
      if (!this.checkIsSameApp(this.systemItemList[i], i)) {
        log.showInfo(`GlobalResidentList need to fix ${DockUtils.getPrintParam(this.globalResidentList)}`);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('fixPcDock', this.systemItemList.concat(this.localResidentList));
        return;
      }
    }
  }

  private checkIsSameApp(item: DockItemInfo, index: number): boolean {
    return item.bundleName === this.globalResidentList[index].bundleName &&
      item.abilityName === this.globalResidentList[index].abilityName;
  }

  private residentVisibleListUpdate(): void {
    log.showInfo(`residentVisibleListUpdate ${this.residentStartIndex}, ${this.mResidentMaxMaxNum}, ` +
      `${this.localResidentList.length}, ${this.localRecentList.length}, ${this.collaborationDataList.length},` +
      `${this.isResidentArrowShow}`);
    let commonItemList = [...this.localResidentList, ...this.collaborationDataList, ...this.localRecentList];
    if (!this.isResidentArrowShow) {
      this.pcDockAnimationMgr.setCommonVisibleList(commonItemList);
      return;
    }
    // 拖拽过程中，图标隐藏了，但是实际ListItem还是存在的，实际占用index
    let endIndex: number = this.residentStartIndex + this.mResidentMaxMaxNum;
    let dragIndex: number = -1;
    if (this.mPCDockDragMgr.isDockDragging) {
      dragIndex = this.mPCDockDragMgr.getDragItemIndex(commonItemList);
      if (dragIndex >= this.residentStartIndex && dragIndex <= endIndex) {
        ++endIndex;
      }
    }
    log.showInfo(`visibleArea:${this.residentStartIndex} -> ${endIndex} dragIndex:${dragIndex}`);
    const visibleArea: DockItemInfo[] = commonItemList.slice(this.residentStartIndex, endIndex);
    this.pcDockAnimationMgr.setCommonVisibleList(visibleArea);
    if (this.residentStartIndex > 0) {
      this.pcDockAnimationMgr.resetItemEffect(commonItemList[this.residentStartIndex - 1])
    }
    if (endIndex < commonItemList.length) {
      this.pcDockAnimationMgr.resetItemEffect(commonItemList[endIndex]);
    }
  }

  private updateLocalRecentList(isAddContinuableItem: boolean = false): void {
    let localRecentList: DockItemInfo[] = [];
    for (let i = 0; i < this.globalRecentList.length; i++) {
      localRecentList.push(this.globalRecentList[i]);
    }
    PcModeContinuableModel.getInstance().updateContinuableItemInList(this.globalResidentList, this.localRecentList,
      localRecentList, this.deviceInfo, isAddContinuableItem);
    this.localRecentList = localRecentList;
    log.showInfo(`updateLocalRecentList recentListLength: ${this.localRecentList.length}`);
    this.mPCDockDragMgr.setLocalRecentList(this.localRecentList);
  }

  private isContinueItemVisible(): boolean {
    let isVisible: boolean = false;
    if (this.residentStartIndex + this.mResidentMaxMaxNum >= (this.localResidentList.length +
    this.collaborationDataList.length + this.localRecentList.length)) {
      isVisible = true;
    }
    log.showInfo(`continueVisible${this.residentStartIndex}, ${this.mResidentMaxMaxNum}, ${this.localResidentList.length}` +
      `${this.collaborationDataList.length},${this.localRecentList.length}, ${isVisible}`);
    return isVisible;
  }

  private getForeachKey(item: DockItemInfo): string {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    let keyName = item.bundleName + item.appIndex + item.abilityName +
    item.appId + config.mIconSize;
    if (!CheckEmptyUtils.isEmpty(item?.shortcutId)) {
      keyName = keyName + item?.shortcutId
    }
    if (!CheckEmptyUtils.isEmpty(item?.iconType)) {
      keyName = keyName + item?.iconType
    }
    if (!CheckEmptyUtils.checkStrIsEmpty(item?.appInstanceKey)) {
      keyName = keyName + item.appInstanceKey;
    }
    if (!CheckEmptyUtils.isEmpty(item?.persistentId)) {
      keyName = keyName + item?.persistentId;
    }
    return keyName;
  }

  private getResidentWidth(isAddDividerWidth: boolean = false): number {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    let width: number = 0;
    const itemCount = this.mResidentMaxMaxNum + this.systemItemList.length;
    if (itemCount > 0) {
      width = itemCount * (config.mListItemWidth + config.mListItemGap);
      if (this.isDividerShow()) {
        width += this.getDividerWidth();
      }
    }
    this.baseResidentListWidth = width;
    log.showInfo(`residentWidth: ${width}, baseWidth: ${this.baseResidentListWidth}, additionWidth: ${this.additionResidentListWidth}` +
      ` ,isAddDividerWidth: ${isAddDividerWidth}`);
    if (this.additionResidentListWidth) {
      width = width + this.additionResidentListWidth;
    }
    return width;
  }

  private getRecentListWidth(): void {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    this.recentListWidth = (config.mListItemWidth + config.mListItemGap) * this.recentNum;
  }

  private getArrowPath(arrowType: ArrowType): ResourceStr {
    return this.smartDockViewModel.isLeftArrow(arrowType) ? this.leftArrowPath : this.rightArrowPath;
  }

  private getArrowOpacity(arrowType: ArrowType): Resource | number {
    switch (arrowType) {
      case ArrowType.RESIDENT_LEFT:
        return this.residentLeftArrowOpacity;
      case ArrowType.RESIDENT_RIGHT:
        return this.residentRightArrowOpacity;
      default:
        log.showError('getArrowOpacity:invalid arrow type');
        return 0;
    }
  }

  private getArrowBackgroundColor(arrowType: ArrowType): ResourceColor | null {
    switch (arrowType) {
      case ArrowType.RESIDENT_LEFT:
        return this.residentLeftArrowBgColor;
      case ArrowType.RESIDENT_RIGHT:
        return this.residentRightArrowBgColor;
      default:
        log.showError('getArrowBackgroundColor:invalid arrow type');
        return null;
    }
  }

  private getArrowLeftMargin(arrowType: ArrowType): number {
    return 0;
  }

  private getArrowRightMargin(arrowType: ArrowType): number {
    return 0;
  }

  private onHoverArrow(arrowType: ArrowType, isHover: boolean): void {
    switch (arrowType) {
      case ArrowType.RESIDENT_LEFT: {
        this.isResidentLeftArrowHover = isHover;
        if (!this.isResidentLeftArrowClickable) {
          break;
        }
        this.refreshResidentArrowBgColor();
        break;
      }
      case ArrowType.RESIDENT_RIGHT: {
        this.isResidentRightArrowHover = isHover;
        if (!this.isResidentRightArrowClickable) {
          break;
        }
        this.refreshResidentArrowBgColor();
        break;
      }
      default:
        log.showError('onHoverArrow:invalid arrow type');
        break;
    }
  }

  private doScroll(scroller: Scroller, xOffset: number): void {
    scroller?.scrollTo({
      xOffset: xOffset,
      yOffset: 0,
      animation: {
        duration: this.scrollAnimDuration,
        curve: curves.interpolatingSpring(0, 1, 200, 24)
      }
    });
  }

  /**
   * 规避在拖拽图标到dock滑动list时, list的对齐功能失效问题，如果list的scrollSnapAlign对齐功能在这个场景下修复，这个函数调用可以删除
   * @param isResident
   */
  private checkStartIndexOffset(): void {
    if (CheckEmptyUtils.isEmpty(this.mResidentScroller)) {
      log.showError('scroller is null');
      return;
    }
    if (this.mResidentScroller.isAtEnd()) {
      log.showInfo('checkStartIndexOffset scroller AtEnd');
      return;
    }
    log.showInfo(`checkStartIndexOffset: ${this.residentStartIndex}`);
    this.updateResidentArrowState();
    setTimeout(() => {
      this.mResidentScroller.scrollToIndex(this.residentStartIndex, true, ScrollAlign.START);
    })
  }

  private getDividerWidth(): number {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    if (this.isResidentArrowShow) {
      return config.mResidentSplitLineWidth;
    } else {
      return (config.mResidentSplitLineWidth + config.mListItemGap);
    }
  }

  private onDragToArrow(arrowType: ArrowType): void {
    log.showInfo(`onDragToArrow ArrowType:${arrowType}`);
    if (!this.isArrowClickable(arrowType)) {
      return;
    }
    if (this.clickArrowTimerId > 0) {
      clearTimeout(this.clickArrowTimerId);
    }
    this.clickArrowTimerId = setTimeout(() => {
      this.onClickResidentArrowAction(arrowType);
      this.clickArrowTimerId = -1;
    }, 20);
  }

  private isArrowClickable(arrowType: ArrowType): boolean {
    if (arrowType === ArrowType.RESIDENT_LEFT) {
      return this.isResidentLeftArrowClickable;
    } else if (arrowType === ArrowType.RESIDENT_RIGHT) {
      return this.isResidentRightArrowClickable;
    }
    return false;
  }

  private onClickArrow(arrowType: ArrowType): void {
    log.showDebug(`onClickArrow ${arrowType}`);
    if (!this.isArrowClickable(arrowType)) {
      return;
    }
    HiSysEventUtil.reportClickDockArrowButton(arrowType);
    this.pcDockAnimationMgr.resetItemNearArrowEffect(arrowType);
    animateTo({
      curve: curves.springCurve(0, 1, 322, 30),
    }, () => {
      this.additionResidentListWidth = 0;
      this.residentListWidth = this.baseResidentListWidth;
    })
    this.onClickResidentArrowAction(arrowType);
  }

  private onClickResidentArrowAction(arrowType: ArrowType): void {
    if (!this.enableScrollInteraction) {
      return;
    }
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    const dividerWidth: number = this.getDividerWidth();
    let dividerOffset: number = 0;
    let dividerScroolOffset: number = 0;
    if (this.isDividerShow()) {
      dividerOffset = this.isDividerVisible() ? 0 : dividerWidth;
      dividerScroolOffset = this.isDividerVisible() ? dividerWidth : 0;
    }
    const currentOffset: number = this.mResidentScroller.currentOffset()?.xOffset ?? 0;
    const itemWidth: number = config.mListItemWidth + config.mListItemGap;

    if (arrowType === ArrowType.RESIDENT_LEFT) {
      const index: number = Math.round(Math.ceil(currentOffset - dividerOffset) / itemWidth);
      this.doScroll(this.mResidentScroller, (index - this.mResidentMaxMaxNum) * itemWidth + dividerScroolOffset);
    } else if (arrowType === ArrowType.RESIDENT_RIGHT) {
      const index: number = Math.round(Math.floor(currentOffset - dividerOffset) / itemWidth);
      this.doScroll(this.mResidentScroller, (index + this.mResidentMaxMaxNum) * itemWidth + dividerScroolOffset);
    }
  }

  private onTouchArrow(arrowType: ArrowType, event?: TouchEvent): void {
    switch (arrowType) {
      case ArrowType.RESIDENT_LEFT: {
        if (!this.isResidentLeftArrowClickable) {
          break;
        }
        if (event?.type === TouchType.Down) {
          this.residentLeftArrowBgColor = (this.isDarkMode() ? FixedDockResource.ARROW_CLICK_DARK_COLOR :
          FixedDockResource.ARROW_CLICK_LIGHT_COLOR);
        }
        if (event?.type === TouchType.Up) {
          if (this.isResidentLeftArrowHover) {
            this.residentLeftArrowBgColor = (this.isDarkMode() ? FixedDockResource.ARROW_HOVER_DARK_COLOR :
            FixedDockResource.ARROW_HOVER_LIGHT_COLOR);
          } else {
            this.residentLeftArrowBgColor = null;
          }
        }
        break;
      }
      case ArrowType.RESIDENT_RIGHT: {
        if (!this.isResidentRightArrowClickable) {
          break;
        }
        if (event?.type === TouchType.Down) {
          this.residentRightArrowBgColor = (this.isDarkMode() ? FixedDockResource.ARROW_CLICK_DARK_COLOR :
          FixedDockResource.ARROW_CLICK_LIGHT_COLOR);
        }
        if (event?.type === TouchType.Up) {
          if (this.isResidentRightArrowHover) {
            this.residentRightArrowBgColor = (this.isDarkMode() ? FixedDockResource.ARROW_HOVER_DARK_COLOR :
            FixedDockResource.ARROW_HOVER_LIGHT_COLOR);
          } else {
            this.residentRightArrowBgColor = null;
          }
        }
        break;
      }
      default:
        log.showError('onTouchArrow:invalid arrow type');
        break;
    }
  }

  private isDividerVisible(): boolean {
    if (!this.isDividerShow()) {
      return false;
    }
    let index = this.localResidentList.length;
    const scroller: Scroller = this.mResidentScroller;
    try {
      let rect: RectResult = scroller.getItemRect(index);
      log.showInfo(`isDividerVisible rect: ${rect.x}- ${rect.y}-${rect.width}-${rect.height} `);
      if (rect.x === 0 && rect.y === 0 && rect.width === 0 && rect.height === 0) {
        return false;
      }
      return true;
    } catch (error) {
      log.showError(`getItemRect error`);
      return false;
    }
  }

  private onAreaScrollStop(): void {
    this.updateResidentArrowState();
  }

  private onAreaReachStart(): void {
    this.updateResidentArrowState();
  }

  private onAreaReachEnd(): void {
    this.updateResidentArrowState();
  }

  private calculateAreaStartIndex(startIndex: number, endIndex: number): void {
    if (!this.isResidentArrowShow) {
      return;
    }
    this.residentStartIndex = startIndex;
    this.residentEndIndex = endIndex;
    this.residentVisibleListUpdate();
    log.showInfo(`calculateAreaStartIndex residentStartIndex: ${this.residentStartIndex}`);
  }

  /**
   * 更新dock宽度，只在dock拖动期间调用，用于更新随落位框显隐变化的dock宽度
   * @param addResidentNum 增加的常驻区图标数量
   * @param addRecentNum 增加的运行区图标数量
   * @param hasAnim 是否需要dock挤位动画
   * @param dockChanged 是否更新dock list
   */
  private onDockListNumChangeInDrag = (addResidentNum: number, addRecentNum: number, hasAnim: boolean,
    dockChanged: boolean = false): void => {
    log.showInfo(`onDockListNumChangeInDrag: ${addResidentNum} ${this.mPCDockDragMgr.residentNumCache} ${addRecentNum} ${this.mPCDockDragMgr.recentNumCache}`);
    this.dividerAnimateParam = this.dockDragAnim;
    this.residentNum = this.mPCDockDragMgr.residentNumCache + addResidentNum;
    this.recentNum = this.mPCDockDragMgr.recentNumCache + addRecentNum;
    this.setMaxNum();
    if (dockChanged) {
      this.isDockChange = true;
      let dockAnim = this.dockChangeAnim;
      dockAnim.onFinish = () => {
        this.isDockChange = false;
      };
      this.getRecentListWidth();
      this.initArrowState();
      this.updateLocalResidentList();
      this.updateLocalRecentList();
      this.getUIContext().animateTo(dockAnim, () => {
        this.residentListWidth = this.getResidentWidth();
        this.calculateIfIconFlexChange();
      })
      Trace.end(TRACE_ONDOCKLISTCHANGE);
    } else {
      if (hasAnim) {
        this.getUIContext().animateTo(this.dockDragAnim, () => {
          this.getRecentListWidth();
          this.initArrowState();
          this.residentListWidth = this.getResidentWidth();
          this.calculateIfIconFlexChange();
        });
        this.dividerOffsetXAnim = 0;
      } else {
        this.getRecentListWidth();
        this.initArrowState();
        this.updateLocalRecentList();
        this.residentListWidth = this.getResidentWidth();
        this.calculateIfIconFlexChange();
      }
    }
    this.residentVisibleListUpdate();
    this.dividerAnimateParam = this.dockChangeAnim;
    log.showInfo(`onDockListNumChangeInDrag end ${addResidentNum}, ${addRecentNum}, residentNum: ${this.residentNum}, ` +
      `recentNum: ${this.recentNum}, dockChanged: ${dockChanged}`);
  };

  private isItemVisible(indexInList: number): boolean {
    const scroller: Scroller = this.mResidentScroller;
    if (CheckEmptyUtils.isEmpty(scroller)) {
      log.showError('scroller is null');
      return false;
    }
    try {
      let rect = scroller.getItemRect(indexInList);
      log.showInfo(`isItemVisible indexInList: ${indexInList}, rect: ${rect.x}- ${rect.y}-${rect.width}-${rect.height} `);
      if (rect.x === 0 && rect.y === 0 && rect.width === 0 && rect.height === 0) {
        return false;
      }
      if (rect.x < 0 && (rect.x + (rect.width / 2)) < 0) {
        return false;
      }
      return true;
    } catch (error) {
      log.showError(`getItemRect error`);
      return false;
    }
  }

  private getVisibleIndex(indexInList: number, residentNum: number, recentNum: number): number {
    let listNum : number = residentNum + recentNum - this.systemItemList.length + (this.isDividerShow() ? 1 : 0);
    let visibleListIndex: number = indexInList + 1;
    for (let i = indexInList + 1; i < listNum; i++) {
      if (this.isDividerShow() && i === this.localResidentList.length) {
        continue;
      }
      if (this.isItemVisible(i)) {
        visibleListIndex = i;
        break;
      }
    }
    let visibleIndex: number = visibleListIndex;
    if (this.isDividerShow()) {
      if (visibleListIndex > this.localResidentList.length) {
        visibleIndex = visibleListIndex - 1;
      }
    }
    return visibleIndex;
  }

  private checkStartIndexVisible(): void {
    if (!this.isResidentArrowShow) {
      return;
    }
    let indexInList: number = this.residentStartIndex;
    if (this.isDividerShow()) {
      if (this.residentStartIndex >= this.localResidentList.length) {
        indexInList = this.residentStartIndex + 1;
      }
    }
    if (this.isItemVisible(indexInList)) {
      return;
    }
    let residentNum: number = this.globalResidentList.length;
    let recentNum: number = this.globalRecentList.length + (this.isAddContinuableItem() ? 1 : 0);
    if (!CheckEmptyUtils.isEmptyArr(this.collaborationDataList)) {
      recentNum += this.collaborationDataList.length;
    }
    let visibleIndex: number = this.getVisibleIndex(indexInList, residentNum, recentNum);
    log.showInfo(`checkStartIndexVisible indexInList:${indexInList}, ` +
      `${visibleIndex}, ${this.residentStartIndex}, ${this.mResidentMaxMaxNum}, ${residentNum}, ${recentNum}`);
    this.updateResidentArrowState();
    this.residentVisibleListUpdate();
  }

  private onStatusBarTypeChange(): void {
    this.onDockStatusBarChange();
  }

  private onDockStatusBarChange(): void {
    log.showInfo(`onDockStatusBarChange`);
    this.onDockListChange('onDockStatusBarChange');
    if (this.useSpecialJustify) {
      let isMacStyle = PluginStyleUtil.isMacStyle();
      if (isMacStyle) {
        animateTo({
          curve: this.dragWidthChangeCurve,
          duration: 300
        }, () => {
          this.useSpecialJustify = false;
        })
      }
    }
  }

  private onLeftDockStatusBarChange(): void {
    if (this.isMacStyle()) {
      log.showInfo(`onLeftDockStatusBarChange`);
      this.onDockListChange('onLeftDockStatusBarChange');
    }
  }

  /**
   * 计算dock栏图标是否与状态栏相遇，并需要使用另一套对齐方式
   */
  private calculateIfIconFlexChange(): void {
    if (this.isMacStyle()) {
      return;
    }
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    // 计算dock中图标列表控件整体宽度
    const iconsListWidth: number = this.getBaseSpaceWidth();
    let sw = this.getCurrentScreenWidthVp();
    this.useSpecialJustify = sw - iconsListWidth < this.rightStatusBarWidth * 2;
    this.specialFlexWidth = sw - this.rightStatusBarWidth;
    log.showInfo(`iconsListWidth: ${iconsListWidth}, sw: ${sw}, useSpecialJustify: ${this.useSpecialJustify}, ` +
      `specialFlexWidth: ${this.specialFlexWidth}, mScreenWidth: ${config.mScreenWidth}, ` +
      `rightStatusBarWidth: ${this.rightStatusBarWidth}`);
  }

  private getCurrentScreenWidthVp(): number {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    if (this.screenProp.screenId === 0) {
      return config.mScreenWidth;
    } else {
      return px2vp(this.screenProp.width);
    }
  }

  private getCurrentScreenHeightVp(): number {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    if (this.screenProp.screenId === 0) {
      return config.mScreenHeight;
    } else {
      return px2vp(this.screenProp.height);
    }
  }

  private onCollaborationDataListChange(): void {
    log.showInfo('onCollaborationDataListChange length:' + this.collaborationDataList?.length);
    if (CheckEmptyUtils.isEmptyArr(this.collaborationDataList)) {
      this.localCollaborationList = [];
    } else {
      this.localCollaborationList = this.collaborationDataList;
    }
    this.onDockListChange('onCollaborationDataListChange');
  }

  // 拓展屏属性变化，重新刷新dock布局
  private screenPropertyChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo(`screenPropertyChange reason:${reason}`);
    LayoutViewModel.getInstance(this.singleContext)
      .refreshConfig(screenProperty.width, screenProperty.height, 0, false, 0, screenProperty.screenId || undefined);
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);

    let ow = config.mScreenWidth;
    let oh = config.mScreenHeight;
    let ctx: UIContext = this.getUIContext();
    if (ctx) {
      config.mScreenWidth = ctx.px2vp(screenProperty.width);
      config.mScreenHeight = ctx.px2vp(screenProperty.height);
    }

    this.dockWidth = this.getCurrentScreenWidthVp();
    log.showInfo(`rdl-${this.screenProp.screenId}-${screenProperty.width}-${screenProperty.height}-${ow}-${oh}` +
      `-${this.dockWidth}-${config.mScreenWidth}-${config.mScreenHeight}` +
      `-${ctx?.vp2px(1)}`);

    this.onDockStatusBarChange();
  }

  private screenRotateChangeCallback = (screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason) => {
    if (reason == SCBRotateChangeReason.ROTATE_BEGIN) {
      this.isRotating = true;
    }
    if (reason == SCBRotateChangeReason.ROTATE_END) {
      this.isRotating = false;
    }
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear start`);
    this.registerWpsEventListener();
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    this.pcDockAnimationMgr = PcDockAnimationMgr.getInstance(this.screenProp.screenId);
    this.isPreLoadEnable = parameter.getSync('persist.resourceschedule.app.preload.enable', '1') === '1';
    this.threshold = Math.floor(config.mFixedMaxNum / 4);
    this.continueDeviceChangeOnAppear();
    AppStorage.setOrCreate('isPreLoadEnable', this.isPreLoadEnable);
    localEventManager.registerEventListener(this.localEventListener,
      [EventConstants.EVENT_CLOSE_DOCK_MENU_AND_POPUP]);
    this.mPCDockDragMgr.init();
    log.showInfo(`FixedLayout aboutToAppear screenId:${this.screenProp.screenId}`);
    this.mPCDockDragMgr.registerDockListNumChangeCallback(this.onDockListNumChangeInDrag);

    SCBScreenSessionManager.getInstance()
      .registerScreenRotateChangeCallbacks(this.screenRotateChangeCallback, this.screenProp.screenId);
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.screenPropertyChange, this.screenProp.screenId);
    log.showInfo(`aboutToAppear end reColorMode: ${this.currColorMode}`);
  }

  aboutToDisappear(): void {
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenRotateChangeCallbacks(this.screenRotateChangeCallback, this.screenProp.screenId);
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChange, this.screenProp.screenId);
    this.unregisterWpsEventListener();
    this.eventMgr.offAll();
    localEventManager.unregisterEventListener(this.localEventListener);
    this.mPCDockDragMgr.unInit();
    this.mPCDockDragMgr.unregisterDockListNumChangeCallback();
    log.showInfo('aboutToDisappear');
  }

  private onHoverEvent(isHover: boolean): void {
    this.pcDockAnimationMgr.setIsHoveringDock(isHover);
    const isDockMenuShow = this.popupMgr.isDockMenuShow(this.screenProp.screenId);
    log.showInfo(`fixedlayout,onhoverhappen, ${isHover}, ${isDockMenuShow}`);
    if (!isHover && !isDockMenuShow) {
      animateTo({
        curve: curves.springCurve(0, 1, 322, 30),
      }, () => {
        this.pcDockAnimationMgr.resetAllEffect();
        this.additionResidentListWidth = 0;
        this.residentListWidth = this.baseResidentListWidth;
      })
      log.showInfo(`hoverOut list residentWidth: ${this.residentListWidth}, recentListWidth: ${this.recentListWidth}`);
    }
  }

  @Builder
  arrowBuilder(arrowType: ArrowType, isResident: boolean) {
    Row() {
      Image(this.getArrowPath(arrowType))
        .draggable(false)
        .id(this.smartDockViewModel.getDockArrowId(isResident, arrowType))
        .objectFit(ImageFit.Fill)
        .width(StyleConstants.DEFAULT_26)
        .height(StyleConstants.DEFAULT_26)
        .fillColor(this.isDarkMode() ? '#E5FFFFFF' : '#E5000000')
        .opacity(this.getArrowOpacity(arrowType))
        .matchTextDirection(true)
    }
    .width(PcSmartDockStyleManager.getStyle(this.screenProp).mRecentArrowWidth)
    .height(PcSmartDockStyleManager.getStyle(this.screenProp).mRecentArrowHeight)
    .backgroundColor(this.getArrowBackgroundColor(arrowType))
    .borderRadius(StyleConstants.DEFAULT_8)
    .margin({
      left: this.getArrowLeftMargin(arrowType),
      right: this.getArrowRightMargin(arrowType)
    })
    .justifyContent(FlexAlign.Center)
    .onHover((isHover) => {
      this.onHoverArrow(arrowType, isHover);
    })
    .onClick(() => {
      this.onClickArrow(arrowType);
    })
    .onTouch((event?: TouchEvent) => {
      this.onTouchArrow(arrowType, event);
    })
    .onDragEnter((event?: DragEvent, extraParams?: string) => {
      this.onDragToArrow(arrowType);
    })
    .onDrop((event?: DragEvent, extraParams?: string) => {
      if (!event) {
        log.showError('onDrop params is invalid');
        return;
      }
      event.useCustomDropAnimation = true;
      event.setResult(DragResult.DRAG_SUCCESSFUL);
    })
  }

  private getForCollaborationEachKey(item: DockItemInfo): string {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    let keyName = DISTRIBUTED_COMMUNICATION + item.bundleName + item.appIndex + item.abilityName +
    item.appId + config.mIconSize;
    return keyName;
  }

  private getContinuableItemIndex(): number {
    return this.localRecentList?.findIndex((item: DockItemInfo) => {
      return item.bundleName === this.deviceInfo?.bundleName && (item.appIndex ?? 0) === 0;
    });
  }

  @Builder
  AppItemBuilder(item: DockItemInfo, isSystem: boolean, isResident: boolean) {
    ListItem() {
      AppItem({
        screenProp: this.screenProp,
        singleContext: this.singleContext,
        screenId: this.screenProp.screenId,
        currColorMode: this.currColorMode,
        appInfo: item as DockItemInfo,
        dockType: isResident ? SmartDockConstants.RESIDENT_DOCK_TYPE : SmartDockConstants.RECENT_DOCK_TYPE,
        systemFlag: isSystem,
        residentFlag: isResident,
        wpsPreExitFunc: this.wpsPreExitFunc,
        listWidthChange: this.listWidthChange,
        animatedIconId: this.animatedIconId,
        getContinuableItemIndex: this.getContinuableItemIndexFunc,
        continueItemVisibleFunc: this.continueItemVisibleFunc,
        enableScrollInteraction: this.enableScrollInteraction,
        updateAppItem: (appInfo:DockItemInfo): DockItemInfo => {
          this.localResidentList.forEach((item) => {
            if (appInfo.bundleName === item.bundleName) {
              appInfo = item;
            }
          })
          return appInfo;
        }
      })
    }
    .id(`${this.smartDockViewModel.getIdPrefix(isResident)}_AppItem_${item?.keyName ?? item?.shortcutId ?? ''}`)
    .onAppear(() => {
      this.animatedIconId = item.appIconId;
      setTimeout(() => {
        this.animatedIconId = -1;
      }, 100);
    })
    .transition(TransitionEffect.asymmetric(
      TransitionEffect.scale({ x: 0.25, y: 0.25 })
        .combine(TransitionEffect.translate(
          { x: -0.5 * (PcSmartDockStyleManager.getStyle(this.screenProp).mListItemWidth) }))
        .combine(TransitionEffect.opacity(0.0))
        .animation(this.isDockChange ?
        this.linearAnim : { curve: curves.interpolatingSpring(0, 1, 528, 40), delay: isResident ? 0 : 50 }),
      TransitionEffect.scale({ x: 0.25, y: 0.25 })
        .combine(TransitionEffect.translate(
          { x: -0.5 * (PcSmartDockStyleManager.getStyle(this.screenProp).mListItemWidth) }))
        .combine(TransitionEffect.opacity(0.0))
        .animation(this.dockChangeAnim)
    ))
  }

  @Builder
  areaNewBuilder() {
    List({ scroller:this.mResidentScroller }) {
      ForEach(this.localResidentList, (item: DockItemInfo) => {
        this.AppItemBuilder(item, false, true)
      }, (item: DockItemInfo) => this.getForeachKey(item))

      if (this.isDividerShow()) {
        ListItem() {
          this.dockDividerBuilder()
        }
      }

      if (this.localCollaborationList.length > 0) {
        ForEach(this.localCollaborationList, (item: DockItemInfo) => {
          ListItem() {
            AppItem({
              screenProp: this.screenProp,
              singleContext: this.singleContext,
              screenId: this.screenProp.screenId,
              currColorMode: this.currColorMode,
              appInfo: item as DockItemInfo,
              dockType: SmartDockConstants.RECENT_DOCK_TYPE,
              residentFlag: false,
              listWidthChange: this.listWidthChange,
              isCollaborationItem: true,
              enableScrollInteraction: this.enableScrollInteraction
            })
          }
          .transition(TransitionEffect.scale({ x: 0, y: 0 }))
        }, (item: DockItemInfo) => this.getForCollaborationEachKey(item))
      }

      ForEach(this.localRecentList, (item: DockItemInfo) => {
        this.AppItemBuilder(item, false, false)
      }, (item: DockItemInfo) => this.getForeachKey(item))
    }
    .alignListItem(ListItemAlign.Center)
    .id(FixedDockResource.DOCK_COMMON_AREA_ID)
    .listDirection(PcSmartDockStyleManager.getStyle(this.screenProp).mListDirection)
    .height('100%')
    .layoutWeight(1)
    .scrollSnapAlign(ScrollSnapAlign.START)
    .edgeEffect(EdgeEffect.None)
    .enableScrollInteraction(this.enableScrollInteraction)
    .onScrollStart(() => {
      log.showInfo('onScrollStart');
      this.pcDockAnimationMgr.resetAllEffect();
      this.pcDockAnimationMgr.setHoverItemColumnId('');
      this.pcDockAnimationMgr.setScrolling(true);
      this.isReachEnd = false;
      ContextMenu.close();
    })
    .onScrollVisibleContentChange((start: VisibleListContentInfo, end: VisibleListContentInfo) => {
      // list可见区域发生变化时, 同步更新hover的可见区域，包括隐藏的拖拽图标 + 分割线，均占有index
      log.showInfo(`onScrollVisibleContentChange start: ${start.index} end:${end.index}`);
      this.calculateAreaStartIndex(start.index, end.index);
      this.updateResidentArrowState();
    })
    .onScrollStop(() => {
      log.showInfo('onScrollStop');
      this.checkStartIndexOffset();
      this.pcDockAnimationMgr.setScrolling(false);
      let itemId: string = this.pcDockAnimationMgr.getHoverItemColumnId();
      log.showInfo(`onScrollStop hoverItemColumnId: ${itemId}`);
      if (!CheckEmptyUtils.isEmpty(itemId)) {
        let hoverItemInfo: HoverItemInfo = {
          hoverItemId: itemId,
          screenId: this.screenProp.screenId,
        }
        localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_ITEM_HOVER_CHANGE, hoverItemInfo);
      }
    })
    .onReachStart(() => {
      log.showInfo('onReachStart');
      this.onAreaReachStart();
    })
    .onReachEnd(() => {
      log.showInfo('onReachEnd');
      this.isReachEnd = true;
      this.onAreaReachEnd();
    })
    .scrollBar(BarState.Off)
    .clip(this.isResidentArrowShow)
  }

  @Builder
  systemItemAreaBuilder() {
    List() {
      ForEach(this.systemItemList, (item: DockItemInfo) => {
        this.AppItemBuilder(item, true, true)
      }, (item: DockItemInfo) => this.getForeachKey(item))
    }
    .alignListItem(ListItemAlign.Center)
    .id(FixedDockResource.DOCK_SYSTEM_AREA_ID)
    .listDirection(PcSmartDockStyleManager.getStyle(this.screenProp).mListDirection)
    .height('100%')
    .renderGroup(this.enableRenderGroup)
    .scrollSnapAlign(ScrollSnapAlign.START)
    .edgeEffect(EdgeEffect.None)
    .enableScrollInteraction(false)
    .scrollBar(BarState.Off)
  }

  @Builder
  dockStatusBarBuilder() {
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.Center
    }) {
      DockStatusBarComponent({
        isRight: false,
        leftStatusBarWidth: this.leftStatusBarWidth,
        rightStatusBarWidth: this.rightStatusBarWidth,
        currColorMode: this.currColorMode
      })
      DockStatusBarComponent({
        isRight: true,
        leftStatusBarWidth: this.leftStatusBarWidth,
        rightStatusBarWidth: this.rightStatusBarWidth,
        currColorMode: this.currColorMode
      })
    }
    .hitTestBehavior(HitTestMode.Transparent)
  }

  private isDarkMode(): boolean {
    return this.currColorMode === 0;
  }

  @Builder
  dockDividerBuilder() {
    Divider()
      .align(Alignment.Center)
      .vertical(true)
      .strokeWidth(PcSmartDockStyleManager.getStyle(this.screenProp).mResidentSplitLineWidth)
      .height(!this.isResidentArrowShow ? 20 : 28)
      .color(this.isDarkMode() ? '#33FFFFFF' : '#33000000')
      .margin({
        left: !this.isResidentArrowShow ? PcSmartDockStyleManager.getStyle(this.screenProp).mListItemGap / 2 : 0,
        right: !this.isResidentArrowShow ? PcSmartDockStyleManager.getStyle(this.screenProp).mListItemGap / 2 : 0
      })
      .lineCap(LineCapStyle.Round)
      .transition(
        TransitionEffect.asymmetric(
          TransitionEffect.scale({ x: 0, y: 0 })
            .animation(this.dividerAnimateParam)
            .combine(TransitionEffect.OPACITY),
          TransitionEffect
            .scale({ x: 0, y: 0 })
            .animation(this.dividerAnimateParam)
            .combine(TransitionEffect.OPACITY)
        ))
  }

  private getHoverSpaceWidth(): number {
    let width = this.residentListWidth;
    if (this.isResidentArrowShow) {
      width += 2 * PcSmartDockStyleManager.getStyle(this.screenProp).mRecentArrowWidth;
      width += this.getArrowLeftMargin(ArrowType.RESIDENT_LEFT) +
      this.getArrowRightMargin(ArrowType.RESIDENT_LEFT) +
      this.getArrowLeftMargin(ArrowType.RESIDENT_RIGHT) +
      this.getArrowRightMargin(ArrowType.RESIDENT_RIGHT);
    }
    return width;
  }

  private getBaseSpaceWidth(): number {
    let width = this.baseResidentListWidth;
    if (this.isResidentArrowShow) {
      width += 2 * PcSmartDockStyleManager.getStyle(this.screenProp).mRecentArrowWidth;
      width += this.getArrowLeftMargin(ArrowType.RESIDENT_LEFT) +
      this.getArrowRightMargin(ArrowType.RESIDENT_LEFT) +
      this.getArrowLeftMargin(ArrowType.RESIDENT_RIGHT) +
      this.getArrowRightMargin(ArrowType.RESIDENT_RIGHT);
    }
    return width;
  }

  private isDividerShow(): boolean {
    if (this.isResidentArrowShow) {
      return !CheckEmptyUtils.isEmptyArr(this.localResidentList) &&
        (!CheckEmptyUtils.isEmptyArr(this.localRecentList) || this.isAddContinuableItem() ||
          !CheckEmptyUtils.isEmptyArr(this.collaborationDataList)) &&
        this.recentListWidth > 0;
    } else {
      return (!CheckEmptyUtils.isEmptyArr(this.localRecentList) || this.isAddContinuableItem() ||
        !CheckEmptyUtils.isEmptyArr(this.collaborationDataList)) &&
        this.recentListWidth > 0;
    }
  }

  private isMacStyle(): boolean {
    return PluginStyleUtil.isMacStyle();
  }

  build() {
    Stack({ alignContent: Alignment.Start }) {
      Stack({ alignContent: Alignment.Start }) {
        Flex({
          direction: FlexDirection.Row,
          justifyContent: this.useSpecialJustify ? FlexAlign.End : FlexAlign.Center,
          alignItems: ItemAlign.Center
        }) {
          Row() {
            this.systemItemAreaBuilder();

            if (this.isResidentArrowShow) {
              this.arrowBuilder(ArrowType.RESIDENT_LEFT, true);
            }

            this.areaNewBuilder();

            if (this.isResidentArrowShow) {
              this.arrowBuilder(ArrowType.RESIDENT_RIGHT, true);
            }
          }
          .justifyContent(FlexAlign.Center)
          .width(this.getHoverSpaceWidth())
          .height('100%')
          .onHover((isHover: boolean) => {
            this.onHoverEvent(isHover);
          })
        }
        .width(this.useSpecialJustify ? this.specialFlexWidth : '100%')
        .height('100%')

        this.dockStatusBarBuilder();
      }
      .onTouch((event: TouchEvent) => {
        if (event && event.type === TouchType.Up && event.touches && event.touches.length > 0 &&
          event.touches[0].displayX < px2vp(this.screenProp.width) -
          PcSmartDockStyleManager.getStyle(this.screenProp).mToggleHomeWidth) {
            SCBSceneSessionManager.getInstance().exitActiveSplit(INVALID_SCREEN_ID);
        }
      })

      Row() {
        ToggleHomeForFixedDock({
          toggleHomeWidth: PcSmartDockStyleManager.getStyle(this.screenProp).mToggleHomeWidth,
        })
      }
      .justifyContent(FlexAlign.End)
      .width('100%')
      .height('100%')
      .hitTestBehavior(HitTestMode.Transparent)
    }
    .width('100%')
    .height('100%')
  }
}