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
import {
  LogDomain,
  LogHelper,
  CommonUtils,
} from '@ohos/basicutils';
import { ScenePanelState } from '@ohos/windowscene';
import {
  GlobalContext,
  DownloadStatusChangeEvent,
  DownloadingProgressChangeEvent,
  InstallStatusChangeEvent,
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import GridLayoutUtil from '../../utils/GridLayoutUtil';
import { AppItemInfo } from '../../bean/AppItemInfo';
import {
  AppDownloadInfo,
  AppGalleryEventInfo,
  AppStatus,
  CommonConstants,
  DownloadStatusInfo
} from '../../constants/CommonConstants';
import { AppGalleryDownloadManager } from '../../manager/AppGalleryDownloadManager';
import { AppInstallImageVm } from './AppInstallImageVm';
import { NotHarmonyUtil } from '../../TsIndex';

const TAG = 'AppInstallImageEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

export class AppInstallImageEvent {
  private installImageVm: AppInstallImageVm;
  private itemInfo: AppItemInfo = new AppItemInfo();
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private scenePanelState: SubscribedAbstractProperty<ScenePanelState> =
    AppStorage.prop<ScenePanelState>('scenePanelState');
  private onItemAppStatusChange: (status: AppStatus) => void = (status: AppStatus): void => {};

  constructor(vm: AppInstallImageVm) {
    this.installImageVm = vm;
  }

  private isDesktopForeground(): boolean {
    let scenePanelState: ScenePanelState | undefined = this.scenePanelState?.get();
    return scenePanelState === ScenePanelState.HOME || scenePanelState === ScenePanelState.FLOAT_SCENE;
  }

  private isAppCenterForeground(): boolean {
    return viewMgrPolicy.isViewShowing(ViewType.APP_CENTER) || viewMgrPolicy.isViewShowing(ViewType.APP_CENTER_EXT);
  }

  private playInstallingAni(opacity: number, retryCount: number = 0): void {
    log.showInfo(`playInstallingAni ${opacity}, bundleName: ${this.itemInfo.bundleName}`);
    animateTo({
      curve: Curve.Sharp,
      duration: 750,
      onFinish: () => {
        if (this.installImageVm.notInstallState === AppStatus.INSTALLING &&
          retryCount < CommonConstants.INSTALLING_ANIMATE_MAX_COUNT) {
          this.playInstallingAni(this.installImageVm.opacity ^ 1, ++retryCount);
        }
      }
    }, () => {
      if (!this.isDesktopForeground() && !this.isAppCenterForeground()) {
        log.showInfo('playInstallingAni return for background');
        return;
      }
      this.installImageVm.opacity = opacity;
    })
  }

  private onInstallAniFinish(): void {
    const smartDockInstallAniFinishEvent: string = `smartDockInstallAniFinish${this.itemInfo.bundleName}`;
    this.desktopContext?.eventHub?.emit(smartDockInstallAniFinishEvent);
    const desktopInstallAniFinishEvent: string = `desktopInstallAniFinish${this.itemInfo.bundleName}`;
    this.desktopContext?.eventHub?.emit(desktopInstallAniFinishEvent);
  }

  private finishDownloadAni() {
    animateTo({
      duration: 0,
      onFinish: () => {
      }
    }, () => {
      this.installImageVm.opacity = 0;
    })
    this.installImageVm.progress?.updateProgress(500);
    this.setDownloadProgress(0);
    // 直径扩展动效做完后，isProgressShow可以设置false了
    this.installImageVm.isProgressShow = false;
    setTimeout(() => {
      this.onInstallAniFinish();
    }, 1000)
  }

  private initProgress(): void {
    if ((this.itemInfo.appStatus === AppStatus.WAIT_FOR_HARMONY &&
    NotHarmonyUtil.checkNotHarmonyItemLightingStatus(this.itemInfo)) ||
      (this.itemInfo.appStatus === AppStatus.PENDING && NotHarmonyUtil.checkItemLightingStatus(this.itemInfo))) {
      this.installImageVm.isProgressShow = false;
    } else {
      this.installImageVm.isProgressShow = true;
      // 兼容处理，目前只有手机适配了新的应用安装卸载，如果都适配了可以去掉
      let downloadStatusInfo: DownloadStatusInfo | undefined =
        AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo(this.itemInfo.bundleName);
      if (downloadStatusInfo && !this.itemInfo.appIndex) {
        this.installImageVm.notInstallState = downloadStatusInfo.status;
      } else {
        this.installImageVm.notInstallState = this.itemInfo.appStatus as AppStatus;
      }
      this.onItemAppStatusChange(this.installImageVm.notInstallState);

      let downloadProgress: number = this.itemInfo.downloadProgress ?? 0;
      if (this.installImageVm.notInstallState > AppStatus.INSTALLED) {
        // 兼容处理，目前只有手机适配了新的应用安装卸载，如果都适配了可以去掉
        let appDownloadInfo: AppDownloadInfo | undefined =
          AppGalleryDownloadManager.getInstance().getDownloadProgressInfo(this.itemInfo.bundleName);
        if (appDownloadInfo && !this.itemInfo.appIndex) {
          downloadProgress = appDownloadInfo.downloadedSize / appDownloadInfo.totalSize;
        }
      }
      log.showInfo(`downloadProgress: ${downloadProgress}, bundleName: ${this.itemInfo.bundleName}`);
      this.installImageVm.progress = new ProgressMask(
        this.getValidProgressValue(downloadProgress), CommonConstants.MAX_DOWNLOAD_VALUE, '#B3000000');
    }
    if (this.installImageVm.notInstallState === AppStatus.INSTALLING) {
      this.installImageVm.progress = new ProgressMask(CommonConstants.MAX_DOWNLOAD_VALUE - 1,
        CommonConstants.MAX_DOWNLOAD_VALUE, '#B3000000');
      this.playInstallingAni(this.installImageVm.opacity ^ 1);
    }
    log.showInfo(`notInstallState: ${this.installImageVm.notInstallState}, bundleName: ${this.itemInfo.bundleName}`);
  }

  private getValidProgressValue(downloadProgress: number): number {
    let progressValue: number = downloadProgress * CommonConstants.MAX_DOWNLOAD_VALUE;
    return progressValue >= CommonConstants.MAX_DOWNLOAD_VALUE - 1 ?
      CommonConstants.MAX_DOWNLOAD_VALUE - 1 : progressValue;
  }

  private getGalleryStatusChangeEventId(extraId: string): string {
    return `appGalleryStatusChange${this.itemInfo.bundleName}${this.itemInfo.appIndex}${extraId}`;
  }

  private onEventhubAppDownloadStatusChangedEvent(eventInfo: AppGalleryEventInfo): void {
    if (this.itemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON && eventInfo.status !== AppStatus.INSTALLED) {
      return;
    }
    log.showWarn(`onEventhubAppDownloadStatusChangedEvent start: ${eventInfo.bundleName} ${eventInfo.status}`);
    let appStatus: AppStatus = eventInfo.status as AppStatus;
    this.installImageVm.notInstallState = appStatus;
    this.itemInfo.appStatus = appStatus;
    this.onItemAppStatusChange(appStatus);
    switch (appStatus) {
      case AppStatus.WAIT_FOR_HARMONY:
        if (Number(eventInfo.intent?.get(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE)) === 1) {
          this.installImageVm.isProgressShow = false;
        } else {
          this.installImageVm.isProgressShow = true;
        }
        break;
      case AppStatus.PENDING:
        this.itemInfo.appStatus = appStatus;
        break;
      case AppStatus.WAITING:
      case AppStatus.DOWNLOADING:
      case AppStatus.UPDATING:
      case AppStatus.INSTALL_WAITING:
      case AppStatus.WIFI_WAITING:
      case AppStatus.PAUSING:
        this.installImageVm.isProgressShow = true;
        break;
      case AppStatus.INSTALLING:
        this.installImageVm.isProgressShow = true;
        this.installImageVm.progress?.updateProgress(CommonConstants.MAX_DOWNLOAD_VALUE - 1);
        this.playInstallingAni(1);
        break;
      case AppStatus.INSTALLED:
        this.finishDownloadAni();
        break;
    }
    log.showWarn(`onEventhubAppDownloadStatusChangedEvent end: ${this.installImageVm.notInstallState}`);
  }

  private updateDownloadProgress(process: number): void {
    if (!this.installImageVm.progress) {
      log.showWarn('appInstall installImageVm.progress object is undefined, return');
      return;
    }
    let updateValue =
      process >= CommonConstants.MAX_DOWNLOAD_VALUE - 1 ? CommonConstants.MAX_DOWNLOAD_VALUE - 1 : process;
    log.showDebug('appInstall setDownloadProgress %{public}s state:%{public}d, progress:%{public}d',
      this.itemInfo.bundleName, this.installImageVm.notInstallState, updateValue);
    this.installImageVm.progress.updateProgress(updateValue);
  }

  private setDownloadProgress(process: number): void {
    if (this.installImageVm.downloadProgress === process) {
      return;
    }
    if (!this.isDesktopForeground() && !this.isAppCenterForeground()) {
      log.showInfo(`setDownloadProgress: ${process}, bundleName: ${this.itemInfo.bundleName} return for background.`);
      return;
    }
    // 应用分身不响应进度事件
    if (this.itemInfo.appIndex !== 0) {
      return;
    }
    this.installImageVm.downloadProgress = process;
    log.showInfo(`setDownloadProgress: ${process}, bundleName: ${this.itemInfo.bundleName}`);
    if (this.installImageVm.notInstallState === AppStatus.DOWNLOADING ||
      this.installImageVm.notInstallState === AppStatus.UPDATING) {
      this.updateDownloadProgress(process);
    }
  }

  private onEventhubAppDownloadProgressChangedEvent(eventInfo: AppGalleryEventInfo): void {
    if (this.itemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      return;
    }
    if (eventInfo.totalSize && eventInfo.downloadedSize) {
      let status: AppStatus = eventInfo.status === AppStatus.UPDATING ? AppStatus.UPDATING : AppStatus.DOWNLOADING;
      this.installImageVm.notInstallState = status;
      this.onItemAppStatusChange(status);
      let totalSize: number = eventInfo.totalSize;
      let downloadedSize: number = eventInfo.downloadedSize;
      this.itemInfo.downloadProgress = downloadedSize / totalSize;
      let progress = Math.floor(this.itemInfo.downloadProgress * CommonConstants.MAX_DOWNLOAD_VALUE);
      this.setDownloadProgress(progress);
    }
    log.showInfo(`onEventhubAppDownloadProgressChangedEvent: ${this.installImageVm.notInstallState}, ` +
      `bundleName: ${this.itemInfo.bundleName}`);
  }

  private onAppGalleryEvent: (eventInfo: AppGalleryEventInfo) => void = (eventInfo: AppGalleryEventInfo): void => {
    switch (eventInfo.eventType) {
      case DownloadStatusChangeEvent.DOWNLOAD_STATUS_CHANGE:
      case InstallStatusChangeEvent.INSTALL_STATUS_CHANGE:
        this.onEventhubAppDownloadStatusChangedEvent(eventInfo);
        break;
      case DownloadingProgressChangeEvent.DOWNLOAD_PROGRESS_CHANGE:
        this.onEventhubAppDownloadProgressChangedEvent(eventInfo);
        break;
      default:
        break;
    }
    log.showInfo(`onAppGalleryEvent: ${this.installImageVm.notInstallState}, bundleName: ${this.itemInfo.bundleName}`);
  }

  private initEventhubEvent(): void {
    let eventId = this.getGalleryStatusChangeEventId('icon');
    log.showInfo(`eventID: ${eventId}`)
    this.desktopContext?.eventHub.off(eventId, this.onAppGalleryEvent);
    this.desktopContext?.eventHub.on(eventId, this.onAppGalleryEvent);
  }

  public init(itemInfo: AppItemInfo, onItemAppStatusChange: (status: AppStatus) => void) {
    this.itemInfo = itemInfo;
    this.onItemAppStatusChange = onItemAppStatusChange;
    log.showInfo('AppInstallImage init bundleName:%{public}s, appStatus:%{public}d',
      this.itemInfo.bundleName, this.itemInfo.appStatus);
    this.initProgress();
    this.initEventhubEvent();
  }

  public destroy(): void {
    log.showInfo(`AppInstallImageEvent destroy, bundleName: ${this.itemInfo.bundleName}`);
    this.desktopContext?.eventHub.off(this.getGalleryStatusChangeEventId('icon'), this.onAppGalleryEvent);
  }
}