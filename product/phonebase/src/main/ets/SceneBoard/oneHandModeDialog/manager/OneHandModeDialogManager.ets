/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import rpc from '@ohos.rpc';
import { BusinessError } from '@ohos.base';
import { bundleManager } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import {
  SCBSceneInfo,
  ADMIN_USERID,
  SCBSceneContainerSessionArray,
  SCBSceneContainerSession,
  SCBSceneSessionManager,
  launcherStatusUtil,
  sSCBOobeManager
} from '@ohos/windowscene';
import { AppItemInfo, AppModel, EventConstants } from '@ohos/launchercommon';
import { OneHandModeDialogConfig, OneHandModeDialogConfigInfo } from '../config/OneHandModeDialogConfig';
import { OneHandModeDialogDb } from '../config/OneHandModeDialogDb';
import { OneHandDialogConstants } from '../config/OneHandModeDialogConstants';
import lazy {
  SCBSingleHandController,
  SingleHandMode,
  SingleHandStatusChangeCallback
} from '../../scenemanager/onehandmode/SCBSingleHandController';

const TAG: string = 'OneHandModeDialogManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const OPEN_DIALOG_CMD: number = 1;
const CLOSE_DIALOG_CMD: number = 3;

export class OneHandModeDialogManager {
  private remoteProxy?: rpc.IRemoteObject;
  private static instance?: OneHandModeDialogManager;

  private handlePackageEvent = (appList: AppItemInfo[], event: string, bundleName: string, appIndex: number): void => {
    log.showInfo(`handlePackageEvent event: ${event}, bundleName: ${bundleName}`);
    if (event === EventConstants.EVENT_PACKAGE_REMOVED && !appIndex) {
      OneHandModeDialogDb.getInstance().deleteWithBundleInfo({ bundleName, appIndex });
    }
  }

  private onSingleHandStatusChange: SingleHandStatusChangeCallback = {
    onSingleHandEntered: (mode: SingleHandMode) => {
      log.showInfo('onSingleHandEntered');
      let containerSessionList: SCBSceneContainerSessionArray =
        SCBSceneSessionManager.getInstance().getContainerSessionList();
      let topContainerSession: SCBSceneContainerSession | null = containerSessionList.getTopActiveSession();
      let sceneInfo: SCBSceneInfo | undefined = topContainerSession?.primarySession?.sceneInfo;
      if (!topContainerSession || topContainerSession.isSplit || topContainerSession.isFloat || !sceneInfo) {
        return;
      }

      let config: OneHandModeDialogConfigInfo = OneHandModeDialogConfig.getInstance().getConfig();
      let bundleName: string = sceneInfo.bundleName;
      OneHandModeDialogDb.getInstance().getOpenOneHandModeCount().then((count: number) => {
        // 进入手模式并且前台应用在白名单内，总次数+1
        if (config.normalAppMap.has(bundleName)) {
          ++count;
          OneHandModeDialogDb.getInstance().setDialogPopupCount(
            { bundleName: OneHandDialogConstants.OPEN_ONE_HAND_MODE_NUM }, count);
        }
      });
    },
    onSingleHandExited: () => {}
  };

  private constructor() {
    AppModel.getInstance().registerStateChangeListener(this.handlePackageEvent);
    SCBSingleHandController.getInstance().registerSingleHandStatusChangeCallback(TAG, this.onSingleHandStatusChange);
  }

  public static getInstance(): OneHandModeDialogManager {
    if (OneHandModeDialogManager.instance === undefined) {
      OneHandModeDialogManager.instance = new OneHandModeDialogManager();
    }
    return OneHandModeDialogManager.instance;
  }

  private connectSystemDialogService(): void {
    let want: Want = {
      bundleName: 'com.ohos.sceneboard',
      abilityName: 'com.ohos.sceneboard.systemdialog',
    }
    let connectOption: common.ConnectOptions = {
      onConnect(elementName: bundleManager.ElementName, remote: rpc.IRemoteObject) {
        if (!elementName || !remote) {
          log.showError('onConnect argv is null');
          return;
        }
        this.remoteProxy = remote;
        let option = new rpc.MessageOption();
        let data = rpc.MessageSequence.create();
        let reply = rpc.MessageSequence.create();
        const parameters: Record<string, Object> = {
          'ability.want.params.uiExtensionType': 'sysDialog/common',
          'sysDialogZOrder': 1,
          'isEnableBackGesture': 1,
        };

        data.writeInt(3);
        data.writeString('bundleName');
        data.writeString('com.ohos.sceneboard');
        data.writeString('abilityName');
        data.writeString('OneHandModeDialogAbility');
        data.writeString('parameters');
        data.writeString(JSON.stringify(parameters));
        remote.sendMessageRequest(OPEN_DIALOG_CMD, data, reply, option).then((ret) => {
          let msg = reply.readInt();
          log.showInfo(`sendMessageRequest ret:${JSON.stringify(ret)} msg:${msg}`);
        }).catch((error: BusinessError) => {
          log.showInfo('sendMessageRequest failed');
        }).finally(() => {
          data.reclaim();
          reply.reclaim();
        });
        log.showInfo(`onConnect from System Dialog,elementName: ${elementName.bundleName}`);
      },
      onDisconnect(elementName) {
        log.showInfo(`DisConnect from System Dialog,elementName: ${elementName.bundleName}`);
      },
      onFailed(code) {
        log.showInfo(`Connect to System Dialog Failed,code: ${code}`);
      }
    }
    try {
      let connectionId: number = GlobalContext.getContext()?.connectServiceExtensionAbility(want, connectOption);
      log.showInfo(`connectionId: ${connectionId}`);
    } catch (e) {
      let err: BusinessError = e as BusinessError
      log.showInfo(`Connect to System Dialog Failed,code: ${err?.code}`);
    }
  }

  private isForeground(bundleName: string): boolean {
    let containerSessionList: SCBSceneContainerSessionArray =
      SCBSceneSessionManager.getInstance().getContainerSessionList();
    let topContainerSession: SCBSceneContainerSession | null = containerSessionList.getTopActiveSession();
    let sceneInfo: SCBSceneInfo | undefined = topContainerSession?.primarySession?.sceneInfo;
    if (bundleName === sceneInfo?.bundleName) {
      return true;
    }
    log.showInfo(`app not in foreground, bundleName: ${bundleName}, activeBundleName: ${sceneInfo?.bundleName}`);
    return false;
  }

  private async checkAndSetPopupCount(bundleName: string, thresholdMap: Map<string, number>): Promise<boolean> {
    if (!thresholdMap.has(bundleName)) {
      log.showInfo(`this app not allow open dialog, bundleName: ${bundleName}`);
      return false;
    }
    let popupThreshold: number = thresholdMap.get(bundleName) ?? 0;
    let popupCount: number = await OneHandModeDialogDb.getInstance().getDialogPopupCount({ bundleName: bundleName });
    if (popupCount >= popupThreshold) {
      log.showInfo('the number of app dialog boxes reaches the threshold.');
      return false;
    }
    log.showInfo(`open dialog, bundleName: ${bundleName}, threshold: ${popupThreshold}, popupCount: ${popupCount}`);
    ++popupCount;
    OneHandModeDialogDb.getInstance().setDialogPopupCount({ bundleName: bundleName }, popupCount);
    return true;
  }

  private async checkAllowedOpenDialog(bundleName: string): Promise<boolean> {
    // 非主用户、OOBE场景、小折叠外屏、已经在单手模式、应用不在前台不弹框
    if (AppModel.getInstance().getUserId() !== ADMIN_USERID || sSCBOobeManager.isOobeActivated() ||
      launcherStatusUtil.getShowOutLauncherStatus() ||
      SCBSingleHandController.getInstance().GetCurrentMode() !== SingleHandMode.MIDDLE ||
      !this.isForeground(bundleName)) {
      log.showWarn('the state not allow open dialog');
      return false;
    }

    // 特性开关判断
    let config = OneHandModeDialogConfig.getInstance().getConfig();
    if (!config.enable) {
      log.showInfo('not enable one hand mode dialog');
      return false;
    }

    // 进入单手模式总次数校验
    let openOneHandModeCount = await OneHandModeDialogDb.getInstance().getOpenOneHandModeCount();
    if (openOneHandModeCount >= config.inOneHandThreshold) {
      log.showInfo('the total number of times reaches the threshold.');
      return false;
    }

    // 白名单校验
    if (await this.checkAndSetPopupCount(bundleName, config.normalAppMap)) {
      return true;
    }
    return false;
  }

  public async openDialogIfNeed(bundleName: string): Promise<void> {
    // 延迟1S拉起弹框
    setTimeout(async () => {
      if (await this.checkAllowedOpenDialog(bundleName)) {
        log.showInfo(`open one hand mode dailog bundleName: ${bundleName}`);
        this.connectSystemDialogService();
      }
    }, 1000);
  }

  public closeDialog(): void {
    if (!this.remoteProxy) {
      return;
    }
    let option = new rpc.MessageOption();
    let data = rpc.MessageSequence.create();
    let reply = rpc.MessageSequence.create();
    this.remoteProxy.sendMessageRequest(CLOSE_DIALOG_CMD, data, reply, option).then((ret) => {
      let msg = reply.readInt();
      log.showInfo(`closeDialog sendMessageRequest ret:${ret} msg:${msg}`);
    }).catch((error: BusinessError) => {
      log.showInfo(`closeDialog sendMessageRequest failed, code: ${error?.code}`);
    }).finally(() => {
      data.reclaim();
      reply.reclaim();
    });
  }
}