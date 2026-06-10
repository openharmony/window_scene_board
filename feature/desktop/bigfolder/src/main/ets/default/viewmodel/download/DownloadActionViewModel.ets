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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { desktopUtil } from '@ohos/componenthelper';
import {
  AppStatus,
  CommonConstants,
  ContractedFolderLayoutViewModel,
} from '@ohos/launchercommon/src/main/ets/TsIndex';


const TAG: string = 'DownloadActionViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const NEAR_ZERO = 0.01;

/**
 * 下载动效的业务类
 */
export class DownloadActionViewModel {
  private itemDownloadState: number = AppStatus.INSTALLED;

  /**
   * 开始播放完成动效
   *
   * @param folderId 文件夹id
   * @param opacity 透明度
   * @param retryCount 重试次数
   */
  public playInstallingAni(folderId: string): void {
    if (!desktopUtil.isDesktopForeground()) {
      log.showInfo(`do not playInstallingAni for background`);
      return;
    }

    this.itemDownloadState = AppStatus.INSTALLING;
    this.playInstallingAniRun(folderId, 1);
  }

  private playInstallingAniRun(folderId: string, opacity: number, retryCount: number = 0): void {
    log.showInfo(`playInstallingAni ${opacity}`);
    animateTo({
      curve: Curve.Sharp,
      duration: 750,
      onFinish: () => {
        if (this.itemDownloadState === AppStatus.INSTALLING &&
          retryCount < CommonConstants.INSTALLING_ANIMATE_MAX_COUNT && desktopUtil.isDesktopForeground()) {
          let downloadOpacity: number =
            ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folderId).getDownloadMaskOpacity();
          const realOpacity = downloadOpacity < 1 ? 1 : NEAR_ZERO;
          this.playInstallingAniRun(folderId, realOpacity, ++retryCount);
        }
      }
    }, () => {
      const realOpacity = opacity < NEAR_ZERO ? NEAR_ZERO : opacity;
      ContractedFolderLayoutViewModel.getInstance()
        .getViewOsrMgr(folderId).downloadMaskOpacity('installing-opacity', realOpacity);
    })
  }

  /**
   * 完成下载动效
   *
   * @param folderId 文件夹id
   */
  public finishDownloadAni(folderId: string): void {
    this.itemDownloadState = AppStatus.INSTALLED;
    const layoutVm: ContractedFolderLayoutViewModel = ContractedFolderLayoutViewModel.getInstance()
    animateTo({
      duration: 0,
      onFinish: () => {
      }
    }, () => {
      layoutVm.getViewOsrMgr(folderId).downloadMaskOpacity('installed-opacity', 0);
    });
  }
}