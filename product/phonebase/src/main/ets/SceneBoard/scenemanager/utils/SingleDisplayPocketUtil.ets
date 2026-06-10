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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { DeviceHelper, } from '@ohos/frameworkwrapper';
import {
  SCBSceneContainerSession,
  SCBSceneSessionManager,
  sSCBOobeManager,
  SCBSceneContainerState,
  SCBSceneMode,
} from '@ohos/windowscene';
import { OuterAppManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAppManager';
import { OuterHomeManagerUtil } from '../../screenlock/utils/OuterHomeManagerUtil';

const TAG: string = 'SingleDisplayPocketUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const SETTINGS_BUNDLE_NAME: string = 'com.ohos.settings';
const ACCESS_WHITELIST: string[] = OuterAppManager.getInstance().getOuterScreenFollowPkgList();

export class SingleDisplayPocketUtil {
  /**
   * 扩展型小折叠产品展开到折叠任务退后台
   */
  public transferToBackgroundWhenLocked(): void {
    if (sSCBOobeManager.isOobeActivated()) {
      // 开机向导，非小折叠产品折叠态不需要退后台
      return;
    }
    if (this.isNeedContinuationInOuterScreen()) {
      // 需要应用接续场景不需要退后台
      return;
    }
    let activeSession = SCBSceneSessionManager.getInstance().getContainerSessionList()?.getTopActiveSession();
    log.showInfo(`exit activeSession container ${activeSession?.primarySession?.getName()}`);
  }

  private isNeedTransferToBackGround(activeSession: SCBSceneContainerSession | null): boolean {
    if (activeSession === null || activeSession === undefined) {
      log.showInfo(`activeSession is null,  skip transfer to backGround`);
      return false;
    }
    if (activeSession.isSplit) {
      // 分屏场景需要退后台
      log.showInfo(`activeSession is is split, primarySession is ${activeSession.primarySession?.getName()}` +
        `secondarySession is ${activeSession.secondarySession?.getName()},  need to transfer to BackGround`);
      return true;
    }
    if (activeSession.primarySession?.isShowWhenLocked) {
      // 锁屏之上应用不需要退后台
      log.showInfo(`activeSession is show when locked,  skip transfer to backGround`);
      return false;
    }
    return true;
  }

  private isNeedContinuationInOuterScreen(): boolean {
    // 接续应用会通过RPC连接打开接续功能，其他场景都是false
    if (!OuterHomeManagerUtil.getInstance().getAppSwitchContinuation()) {
      return false;
    }
    let activeSession = SCBSceneSessionManager.getInstance().getContainerSessionList().getTopActiveSession();
    if (activeSession === undefined || activeSession === null) {
      log.showInfo('topActiveSession is undefined or null');
      return false;
    }
    let bundleName = activeSession.primarySession?.sceneInfo?.bundleName;
    let windowMode = activeSession.primarySession?.sceneInfo?.windowMode;
    if (bundleName === undefined || windowMode === undefined) {
      log.showInfo('bundleName or windowMode is undefined')
      return false;
    }
    // 小外屏不支持悬浮窗和分屏，当前只有设置指纹全屏场景下才支持接续功能
    log.showInfo(`bundleName is: ${bundleName}, windowMode is: ${windowMode}`);
    if (ACCESS_WHITELIST.indexOf(bundleName) === -1 || windowMode !== SCBSceneMode.FULLSCREEN) {
      return false;
    }
    if (bundleName === SETTINGS_BUNDLE_NAME) {
      log.showInfo('set isBlockApp true');
      SCBSceneSessionManager.getInstance().clearActiveSessionList();
    }
    return true;
  }
}

export let singleDisplayPocketUtil: SingleDisplayPocketUtil =
  SingletonHelper.getInstance(SingleDisplayPocketUtil, TAG);