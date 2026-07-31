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

// 页面控制器
// 日志
import { bundleResourceManager } from '@kit.AbilityKit';
import bundleManager from '@ohos.bundle.bundleManager';
import bundleResource from '@ohos.bundle.bundleResourceManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BaseViewController } from '@ohos/frameworkcommon';
import {
  settingsDataManager,
  ViewCallback,
  viewMgrPolicy,
  ViewType,
  sSettingsUtil,
  DeviceHelper,
  HiSysEventUtil
} from '@ohos/frameworkwrapper';
import {
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBSystemSceneSession,
  SCBSceneContainerSessionArray,
  SCBSceneSession
} from '@ohos/windowscene';
import { AppModel, StyleConstants } from '@ohos/launchercommon';
import { CommonData } from '@ohos/controlcentercommon/Index';
import type { CommonEventData } from 'commonEvent/commonEventData';
import mTools from '../utils/SystemTools';
import { RunningAppListState, RunningAppListStateArray } from './RunningAppListState';
import { ShutDownDialog } from './ShutDownDialog';
import { VirtualMachineCloseDialog } from './VirtualMachineCloseDialog';
import { SystemShutdownStyle } from './SystemShutdownStyle';
import { ShutdownViewConstant } from './ShutdownViewConstants';
import { rpcShutdownPolicy } from '../policy/RpcShutdownPolicy';
import { FoldShutdownViewProxyManager } from '../fold/FoldShutdownViewProxyManager';
import { SCBFoldState, PowerManagerEventType } from '../utils/Constants';
import ShutDownViewFoldModel, { ShutDownViewDialogChangeCallback } from './ShutDownViewFoldModel';
import { BUNDLE_NAME_SETTINGS, pcShutdownDialogVMP } from './PcShutdownDialogVMP';
import { HibernateEvent, EVRNT_NAME_EXIT_HIBERNATE, EVRNT_NAME_ENTER_HIBERNATE } from '../utils/HibernateEvent';

const TAG = 'SCBshutdownView';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const POWER_STATUS_HIBERNATE = 3;
const MASTER_APPLICATION = 0;
const ONE_HALF_OF_SCREEN = 2;
const QUARTER_OF_SCREEN = 4;

// 发送打开副屏关机中断弹窗广播事件
export class PublishExtShutdownEvent {
  public static eventTypeName: string = 'PublishExtShutdownEvent';

  public state: boolean = false; // true打开 false关闭
  public dlgHeight: number = SystemShutdownStyle.confirmDialogMaxHeight;
  public runningAppList: RunningAppListState[] = [];
  public isReboot: boolean = false;
  public isHibernate: boolean = true;
}

@Component
export struct ShutDownView {
  persistentId: number = 0;
  systemSceneSession?: SCBSystemSceneSession;
  private publishExtShutdownEvent: PublishExtShutdownEvent = new PublishExtShutdownEvent;
  private sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance()
  @State dlgHeight: number = SystemShutdownStyle.confirmDialogMaxHeight;
  @State virtualMachineDlgHeight: number = SystemShutdownStyle.virtualMachineCloseDialogHeight;
  @Link screenProp: SCBScreenProperty;
  @State shutdownViewController: BaseViewController = new BaseViewController(ViewType.SHUTDOWN_VIEW);
  @State isLoading: boolean = true;
  @State isVirtualMachineUpdate: boolean = true;
  @State runningAppList: RunningAppListState[] = [];
  @State runningVirtualMachine: string = '';
  @State dialogOffsetY: number = 0;
  @State isReboot: boolean = false;
  @State isHibernate: boolean = true;
  @State isModeChange: boolean = false;
  @StorageLink('DarkModeModel_DarkModeStatus') @Watch('onDarkModeChanged') darkModeData: CommonData = new CommonData();
  dialogController: CustomDialogController = new CustomDialogController({
    builder: ShutDownDialog({
      runningAppList: this.runningAppList,
      dlgHeight: this.dlgHeight,
      isReboot: this.isReboot,
      isHibernate: this.isHibernate,
      isModeChange: this.isModeChange,
    }),
    customStyle: true,
    maskColor: $r('app.color.transparent'),
    autoCancel: false,
    offset: { dx: 0, dy: this.dialogOffsetY }
  })
  virtualMachineCloseDialog: CustomDialogController = new CustomDialogController({
    builder: VirtualMachineCloseDialog({
      runningVirtualMachine: this.runningVirtualMachine,
      virtualMachineDlgHeight: this.virtualMachineDlgHeight,
      isReboot: this.isReboot
    }),
    customStyle: true,
    maskColor: $r('app.color.transparent'),
    autoCancel: false,
    offset: { dx: 0, dy: this.dialogOffsetY }
  })

  private updateDialogOffsetY(): void {
    const curFoldState = FoldShutdownViewProxyManager.getInstance().getCurSuperFoldStatus();
    const curBSideHeight = FoldShutdownViewProxyManager.getInstance().getBSideRegion().height.getPx();
    switch (curFoldState) {
      case SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD:
      case SCBFoldState.HALF_FOLDED_PHYSICAL_KEYBOARD:
      case SCBFoldState.HALF_FOLDED:
        this.dialogOffsetY = -curBSideHeight / QUARTER_OF_SCREEN;
        break;
      default:
        this.dialogOffsetY = 0;
    }
  }

  private updateDialogSize() {
    let height: number = this.isVirtualMachineUpdate ? this.dlgHeight : this.virtualMachineDlgHeight;
    log.showInfo(`${TAG} updateDialogSize height ${height}`);
    this.shutdownViewController.updateRect(
      (DeviceHelper.isPC() && DeviceHelper.isFold()) ?
        {
          left: (px2vp(this.screenProp.width) - SystemShutdownStyle.confirmDialogWidth) / ONE_HALF_OF_SCREEN,
          top: (px2vp(this.screenProp.height) - height) / ONE_HALF_OF_SCREEN + this.dialogOffsetY,
          width: SystemShutdownStyle.confirmDialogWidth,
          height: height
        }
        :
        {
          left: 0,
          top: 0,
          width: px2vp(this.screenProp.width),
          height: px2vp(this.screenProp.height)
        })
    this.shutdownViewController.updateArea(
      (DeviceHelper.isPC() && DeviceHelper.isFold()) ?
        {
          left: (px2vp(this.screenProp.width) - SystemShutdownStyle.confirmDialogWidth) / ONE_HALF_OF_SCREEN,
          top: (px2vp(this.screenProp.height) - height) / ONE_HALF_OF_SCREEN + this.dialogOffsetY,
          width: SystemShutdownStyle.confirmDialogWidth,
          height: height
        }
        :
        {
          left: 0,
          top: 0,
          width: px2vp(this.screenProp.width),
          height: px2vp(this.screenProp.height)
        })
  }

  private updateSize() {
    this.updateDialogOffsetY();
    this.updateDialogSize();
  }

  private shutDownViewDialogChangeCallback: ShutDownViewDialogChangeCallback = {
    onCustomDialogOffsetYChange: (offsetY: number) => {
      log.showInfo(`${TAG} onCustomDialogOffsetYChange ${offsetY}`);
      this.dialogOffsetY = offsetY;
      this.updateDialogSize();
    },
  }

  private onDarkModeChanged() {
    log.showInfo(`${TAG} ondarkmodechanged data: ${this.darkModeData.status}`);
    if (this.systemSceneSession instanceof SCBSystemSceneSession) {
      this.systemSceneSession.color = this.darkModeData.status ? ShutdownViewConstant.sessionColorDark :
      ShutdownViewConstant.sessionColor;
    }
  }

  private dealWithContainerSessions(containerSessionList: SCBSceneContainerSessionArray, resList: string[]): string[] {
    log.showInfo(`${TAG} dealWithContainerSessions begin`);
    if (!containerSessionList) {
      log.showInfo(`${TAG} dealWithContainerSessions containerSessionList is null!`);
      return resList;
    }
    for (const containerSession of containerSessionList) {
      if (containerSession.isActive && containerSession.primarySession) {
        const primarySession: SCBSceneSession = containerSession.primarySession;
        if (!pcShutdownDialogVMP.isCurrentSessionRight(primarySession)) {
          continue;
        }
        const primaryBundleName: string = primarySession?.sceneInfo?.bundleName || '';
        if (rpcShutdownPolicy.getRpcView() && primaryBundleName === BUNDLE_NAME_SETTINGS) {
          log.showInfo(`${TAG} rpc not close settings`);
          continue;
        }
        if (resList.indexOf(primaryBundleName) === -1) {
          resList.push(primaryBundleName);
        }
      }
    }

    // 二分屏
    for (const containerSession of containerSessionList) {
      if (containerSession.isActive && containerSession.secondarySession) {
        const secondarySession: SCBSceneSession = containerSession.secondarySession;
        if (!pcShutdownDialogVMP.isCurrentSessionRight(secondarySession)) {
          continue;
        }
        const secondaryBundleName: string = secondarySession?.sceneInfo?.bundleName || '';
        if (rpcShutdownPolicy.getRpcView() && secondaryBundleName === BUNDLE_NAME_SETTINGS) {
          log.showInfo(`${TAG} rpc not close settings`);
          continue;
        }
        if (resList.indexOf(secondaryBundleName) === -1) {
          resList.push(secondaryBundleName);
        }
      }
    }
    return resList;
  }

  private getRunningAppBundleName(): Array<string> {
    log.showInfo(`${TAG} getRunningAppBundleName begin`);
    let resList: string[] = [];
    try {
      let containerSessionList =
        (DeviceHelper.is2In1DevicePadType() || DeviceHelper.is2In1DevicePcType()) ?
        SCBSceneSessionManager.getInstance().getContainerSessionList() :
        SCBSceneSessionManager.getInstance().getAllContainerSessionList();
      resList = this.dealWithContainerSessions(containerSessionList, resList);
      // 悬浮窗
      if (DeviceHelper.is2In1DevicePadType() || DeviceHelper.is2In1DevicePcType()) {
        log.showInfo('getRunningAppBundleName deal with floatingSessions');
        let floatingSessionList = SCBSceneSessionManager.getInstance().getFloatingSessionList();
        resList = this.dealWithContainerSessions(floatingSessionList, resList);
      }
    } catch (e) {
      log.showError(`${TAG} getRunningAppBundleName failed! code: ${e?.code}, message: ${e?.message}`);
    }
    return resList;
  }

  private initRunningAppList(): RunningAppListStateArray {
    log.showInfo(`${TAG} initRunningAppList begin`);
    const notifyRes = this.getRunningAppBundleName();
    const runningAppTemp: RunningAppListStateArray = [];
    for (const appBundleName of notifyRes) {
      try {
        this.normalInitRunningAppList(runningAppTemp, appBundleName);
      } catch (err) {
        log.showError(`${TAG} initRunningAppList failed! code: ${err?.code}, message: ${err?.message}`);
      }
    }
    return runningAppTemp;
  }

  private normalInitRunningAppList(runningAppList: RunningAppListStateArray, bundleName: string) {
    log.showInfo(`${TAG} normalInitRunningAppList begin`);
    try {
      let appInfoList = AppModel.getInstance().getAppInfoByBundleNameAndAppIndex(bundleName, MASTER_APPLICATION);
      if (appInfoList.length === 0) {
        log.showInfo(`${TAG} get appInfoList length 0, bundleName: ${bundleName}`);
        return;
      }
      let appInfo = appInfoList[MASTER_APPLICATION];
      let appIconImage: string | Resource = $r('app.media.ic_normal_unknown');
      if (!appInfo) {
        log.showInfo(`${TAG} getAppIconWithCache with invalid appInfo, bundleName: ${bundleName}`);
        return;
      }
      let flags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY;
      let bundleInfo: bundleManager.BundleInfo = bundleManager.getBundleInfoSync(bundleName, flags);
      let sortedBundleLabel = bundleResource.getBundleResourceInfo(bundleInfo.name,
        bundleResource.ResourceFlag.GET_RESOURCE_INFO_WITH_LABEL |
        bundleResource.ResourceFlag.GET_RESOURCE_INFO_WITH_ICON);
      appIconImage = bundleResource.getBundleResourceInfo(
        bundleName,
        bundleResource.ResourceFlag.GET_RESOURCE_INFO_WITH_LABEL |
        bundleResource.ResourceFlag.GET_RESOURCE_INFO_WITH_ICON
      ).icon;
      const tempAppState: RunningAppListState = {
        // 待完成，这里需要添加文档名称
        icon: appIconImage,
        appName: sortedBundleLabel.label,
        hasDivider: true
      };
      runningAppList.push(tempAppState)
      log.showInfo(`${TAG} push app: ${tempAppState.appName}`);
    } catch (e) {
      log.showError(`${TAG} normalInitRunningAppList failed! code: ${e?.code}, message: ${e?.message}`);
    }
  }

  private isSupportHibernate() {
    if (DeviceHelper.isHYM() || (!DeviceHelper.isPcNot2in1Device())) {
      this.isHibernate = false;
    }
  }

  private ifExtendRpcShutdown(): boolean {
    if (!rpcShutdownPolicy.getRpcView()) {
      log.showInfo(`${TAG} ifExtendRpcShutdown not rpc`);
      return false;
    }
    let mainScreenContainerSessionList =
      this.sceneSessionManager.getContainerSessionList(this.sceneSessionManager.mainScreenId);
    if (!mainScreenContainerSessionList) {
      log.showInfo(`${TAG} ifExtentRpcShutdown mainScreenContainerSessionList is null!`);
      return false;
    }
    for (const mainScreenContainerSession of mainScreenContainerSessionList) {
      const mainScreenCurrentSession = mainScreenContainerSession.primarySession;
      if (!pcShutdownDialogVMP.isCurrentSessionRight(mainScreenCurrentSession)) {
        continue;
      }
      const bundleName: string = mainScreenCurrentSession?.sceneInfo?.bundleName || '';
      if (bundleName === BUNDLE_NAME_SETTINGS) {
        log.showInfo(`${TAG} rpc settings in main screen`);
        return false;
      }
    }
    return true;
  }

  private judgeCurrentView() {
    try {
      let virtualMachineVal: string =
        settingsDataManager.getValue(null, ShutdownViewConstant.virtualMachineKey, 'true');
      log.showInfo(`${TAG} virtualMachineVal: ${virtualMachineVal}`);
      this.isVirtualMachineUpdate = virtualMachineVal === 'false' ? false : true;
      if (!this.isVirtualMachineUpdate) {
        let runningVirtualMachineBundleName: string = settingsDataManager.getValue(null,
          ShutdownViewConstant.virtualMachineBundleName, '');
        if (runningVirtualMachineBundleName !== '') {
          this.runningVirtualMachine = runningVirtualMachineBundleName;
          this.updateSize();
          this.virtualMachineCloseDialog.open();
          return;
        }
      }
      let runningAppTemp = this.initRunningAppList();
      if (runningAppTemp.length === 0) {
        log.showInfo(`${TAG} AllRunningAppInfo: all runnning apps were closed.`);
        this.judgeEventType();
      } else {
        if (runningAppTemp.length >= 1) {
          log.showInfo(`${TAG} AllRunningAppInfo: exist running apps`);
          if (rpcShutdownPolicy.getRpcView()) {
            this.isReboot = true;
          }
          runningAppTemp[runningAppTemp.length - 1].hasDivider = false;
        }
        this.runningAppList = runningAppTemp;
        log.showInfo(`${TAG} all runnning apps temp length: ${runningAppTemp.length}`);
        this.updateSize();
        this.dialogController.open();
      }
    } catch (e) {
      log.showError(`${TAG} judgeCurrentView err, code: ${e?.code}, message: ${e?.message}`);
    }
  }

  private judgeEventType(): void {
    if (rpcShutdownPolicy.getRpcView()) {
      this.isReboot = true;
      rpcShutdownPolicy.rpcShutDownView('noRunningAppList');
      viewMgrPolicy.hideView(ViewType.SHUTDOWN_VIEW);
      return;
    }
    if (this.isReboot) {
      HiSysEventUtil.reportPowerManagerEvent(PowerManagerEventType.noRunningAppReboot);
      mTools.reboot();
      viewMgrPolicy.hideView(ViewType.SHUTDOWN_VIEW);
      return;
    } else {
      this.isSupportHibernate();
      if (this.isHibernate) {
        HiSysEventUtil.reportPowerManagerEvent(PowerManagerEventType.noRunningAppHibernate);
        mTools.hibernate();
      } else {
        HiSysEventUtil.reportPowerManagerEvent(PowerManagerEventType.noRunningAppShutdown);
        mTools.shutdown();
      }
      viewMgrPolicy.hideView(ViewType.SHUTDOWN_VIEW);
      return;
    }
  }

  private screenPropertyChangeCallbacks = () => {
    this.updateSize();
  }

  aboutToAppear(): void {
    log.showInfo(`${TAG} aboutToAppear`);
    this.isLoading = true;
    viewMgrPolicy.registerViewController(ViewType.SHUTDOWN_VIEW, this.shutdownViewController);
    viewMgrPolicy.registerViewCallback(ViewType.SHUTDOWN_VIEW, this.shutdownCallback);
    this.shutdownViewController.updateId(this.persistentId);

    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.screenPropertyChangeCallbacks)
    log.showInfo(`${TAG} is dark mode: ${this.darkModeData.status}`)
    this.systemSceneSession = this.sceneSessionManager.getSystemSceneSessionWithId(this.persistentId);
    this.systemSceneSession.radius = SystemShutdownStyle.shadowRadius;
    this.systemSceneSession.offsetX = SystemShutdownStyle.shadowOffsetX;
    this.systemSceneSession.offsetY = SystemShutdownStyle.shadowOffsetY;
    this.systemSceneSession.borderRadius = SystemShutdownStyle.confirmDialogBorderRadius;
    this.onDarkModeChanged();
    pcShutdownDialogVMP.init();
    HibernateEvent.registerHibernateEventCallback(this.hibernateEventCallback);
  }

  private hibernateEventCallback : (data: CommonEventData) => void = (data: CommonEventData): void => {
    log.showInfo(`${TAG} Enter hibernateEventCallback`);
    if (data.event === EVRNT_NAME_ENTER_HIBERNATE) {
      log.showInfo(`${TAG} Enter_Hibernate`);
      if (!data.parameters) {
        log.showInfo(`${TAG} Enter_Hibernate data.parameters is undefined`);
      } else {
        if (data.parameters['clearMemory'] === true) {
          log.showInfo(`${TAG} Enter_Hibernate with logout`);
          SCBScreenSessionManager.getInstance().getPowerStatusController()?.changePowerStatus(POWER_STATUS_HIBERNATE);
        }
      }
    } else if (data.event === EVRNT_NAME_EXIT_HIBERNATE) {
      log.showInfo(`${TAG} Exit_Hibernate`);
    }
  }

  aboutToDisappear() {
    log.showInfo(`${TAG} aboutToDisAppear`);
    viewMgrPolicy.unregisterViewController(ViewType.SHUTDOWN_VIEW);
    viewMgrPolicy.unRegisterViewCallback(ViewType.SHUTDOWN_VIEW, this.shutdownCallback);
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChangeCallbacks);
    pcShutdownDialogVMP.destroy();
    HibernateEvent.unregisterHibernateEventCallback();
  }

  build() {
    Column()
      .width(StyleConstants.PERCENTAGE_100)
      .height(this.isVirtualMachineUpdate ? this.dlgHeight : this.virtualMachineDlgHeight)
      .borderRadius(SystemShutdownStyle.confirmDialogBorderRadius)
      .onAreaChange((oldValue: Area, newValue: Area) => {
        if (oldValue.height !== newValue.height) {
          this.updateSize()
        }
      })
  }

  private shutdownCallback: ViewCallback = {
    onShow: (): void => {
      ShutDownViewFoldModel.getInstance()
        .registerShutDownViewDialogChangeCallback(this.shutDownViewDialogChangeCallback);
      this.isLoading = true;
      this.runningAppList = [];
      this.persistentId = 0;
      const eventType: string | undefined = AppStorage.get('currentClickRebootOrShutdown');
      if (eventType) {
        log.showInfo(`${TAG} on show shutdown view ${eventType}`);
      } else {
        log.showInfo(`${TAG} get view error! ${eventType}`);
      }
      this.isReboot = eventType === 'reboot';
      if (!this.isReboot) {
        let hibernateVal: string = sSettingsUtil.getValue(ShutdownViewConstant.hibernateKey);
        if (!hibernateVal || hibernateVal === '') {
          log.showInfo(`${TAG} get hibernateVal from db fail, default to shutdown.`);
          this.isHibernate = false;
        } else {
          this.isHibernate = hibernateVal === ShutdownViewConstant.isHibernateOpen;
          log.showInfo(`${TAG} get hibernateVal from db succ. hibernateVal: ${hibernateVal}, isHibernate: ${this.isHibernate}`);
        }
      }
      this.judgeCurrentView();
    },
    onHide: (): void => {
      this.dialogController?.close();
      log.showInfo(`${TAG} hide shutdown view`);
      ShutDownViewFoldModel.getInstance()
        .unregisterShutDownViewDialogChangeCallback(this.shutDownViewDialogChangeCallback);
    }
  };
}
