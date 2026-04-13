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

// import statusBar from '@hms.pcService.statusBar';
import { LogDomain, LogHelper, PixelMapUtil } from '@ohos/basicutils';
import { DeviceHelper, SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SCBConstants } from '@ohos/commonconstants';
import { rpc } from '@kit.IPCKit';
import { image } from '@kit.ImageKit';
import { bundleManager } from '@kit.AbilityKit';
import {
  StatusBarServiceInfo,
  StatusBarConnectEvent,
  StatusBarServiceEventManager,
  StatusBarData
} from './StatusBarServiceEventManager';
import { TrayManager } from './TrayManager';
import { AppClientNotifier } from './AppClientNotifier';

const TAG = 'StatusBarServiceManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const CHECK_TAG = 'PCService_StatusBarManager';

interface IStatusBarService {
  getStatusBarData(rpcData: rpc.MessageSequence): StatusBarData | undefined;
}

interface ReplyMsg {
  isDeleted: boolean;
  type: number;
}

class AddService implements IStatusBarService {
  getStatusBarData(rpcData: rpc.MessageSequence): StatusBarData | undefined {
    let statusBarData: StatusBarData = {};
    /* let item: statusBar.StatusBarItem = statusBar.readStatusBarItemFromParcel(rpcData);
    if (item === undefined) {
      log.showError('addToStatusbar StatusbarItem unmarshalling failed');
      return undefined;
    }
    statusBarData.statusBarItem = item;
    statusBarData.instanceKey = statusBar.readInstanceKeyToParcel(rpcData);*/
    // log.showInfo('addToStatusbar StatusbarItem unmarshalling success. statusBarData: ' + JSON.stringify(statusBarData)+', '+item?.quickOperation?.title);
    log.showInfo('addToStatusbar StatusbarItem unmarshalling success ' + JSON.stringify(statusBarData));
    return statusBarData;
  }
}

class RemoveService implements IStatusBarService {
  getStatusBarData(rpcData: rpc.MessageSequence): StatusBarData | undefined {
    let statusBarData: StatusBarData = {};
    // statusBarData.instanceKey = statusBar.readInstanceKeyToParcel(rpcData);
    log.showInfo('RemoveService StatusbarItem unmarshalling success ' + JSON.stringify(statusBarData));
    return statusBarData;
  }
}

class UpdateMenuService implements IStatusBarService {
  getStatusBarData(rpcData: rpc.MessageSequence): StatusBarData | undefined {
    let statusBarData: StatusBarData = {};
    /*let groupMenu: statusBar.StatusBarGroupMenu[] = statusBar.readGroupMenuArrayFromParcel(rpcData);
    if (groupMenu === undefined) {
      log.showError('updateRightMenu StatusBarGroupMenu unmarshalling failed');
      return undefined;
    }
    statusBarData.statusBarMenu = groupMenu;
    statusBarData.instanceKey = statusBar.readInstanceKeyToParcel(rpcData);*/
    log.showInfo('UpdateMenuService StatusbarItem unmarshalling success ' + JSON.stringify(statusBarData));
    return statusBarData;
  }
}

class UpdateOperationHeight implements IStatusBarService {
  getStatusBarData(rpcData: rpc.MessageSequence): StatusBarData | undefined {
    try {
      let statusBarData: StatusBarData = {};
      let height = rpcData.readInt();
      if (height === undefined || height < 0) {
        return undefined;
      }
      statusBarData.operationHeight = height;
      // statusBarData.instanceKey = statusBar.readInstanceKeyToParcel(rpcData);
      log.showInfo('UpdateOperationHeight StatusbarItem unmarshalling success ' + JSON.stringify(statusBarData));
      return statusBarData;
    } catch (err) {
      log.showError(`UpdateOperationHeight error code: ${err.code}`);
      return undefined;
    }
  }
}

class UpdateIconService implements IStatusBarService {
  getStatusBarData(rpcData: rpc.MessageSequence): StatusBarData | undefined {
    try {
      let statusBarData: StatusBarData = {};
      let whiteIcon = image.createPixelMapFromParcel(rpcData);
      let blackIcon = image.createPixelMapFromParcel(rpcData);
      if (whiteIcon === undefined || blackIcon === undefined) {
        return undefined;
      }
      const whiteIconInfo = whiteIcon?.getImageInfoSync();
      const blackIconInfo = blackIcon?.getImageInfoSync();
      log.showInfo(`whiteIconInfo: ${JSON.stringify(whiteIconInfo)}, blackIconInfo: ${JSON.stringify(blackIconInfo)}`);
      PixelMapUtil.addName(whiteIcon, `StatusBarServiceStub_whiteIcon`);
      PixelMapUtil.addName(blackIcon, `StatusBarServiceStub_blackIcon`);
      let icons: ESObject = {
        white: whiteIcon,
        black: blackIcon,
      };
      statusBarData.statusBarIcon = icons;
      // statusBarData.instanceKey = statusBar.readInstanceKeyToParcel(rpcData);
      log.showInfo('UpdateIconService StatusbarItem unmarshalling success ' + JSON.stringify(statusBarData));
      return statusBarData;
    } catch (err) {
      log.showError(`UpdateIconService error code: ${err.code}`);
      return undefined;
    }
  }
}

class StatusBarStub extends rpc.RemoteObject {
  private statusBarServiceMap: Map<StatusBarConnectEvent, () => IStatusBarService> = new Map();

  constructor(des: string) {
    super(des);
    this.initServiceMap();
  }

  private initServiceMap(): void {
    this.statusBarServiceMap.set(StatusBarConnectEvent.ADD_TO_STATUS_BAR, () => new AddService());
    this.statusBarServiceMap.set(StatusBarConnectEvent.REMOVE_FROM_STATUS_BAR, () => new RemoveService());
    this.statusBarServiceMap.set(StatusBarConnectEvent.UPDATE_RIGHT_MENU, () => new UpdateMenuService());
    this.statusBarServiceMap.set(StatusBarConnectEvent.UPDATE_QUICK_OPERATION_HEIGHT,
      () => new UpdateOperationHeight());
    this.statusBarServiceMap.set(StatusBarConnectEvent.UPDATE_STATUSBAR_ICON, () => new UpdateIconService());
  }

  private async assigningValuesStatusBarData(code: number, callingTokenId: number, callingPid: number,
    bundleName: string, statusBarData: StatusBarData,
    reply: rpc.MessageSequence, appIndex: number = 0): Promise<void> {
    return new Promise((resolve, reject) => {
      if (code === StatusBarConnectEvent.UNKNOWN) {
        log.showInfo('assigningValuesStatusBarData code unknown. ');
        reject();
        return;
      }
      let serviceData: StatusBarServiceInfo = {
        type: code,
        tokenId: callingTokenId,
        pid: callingPid,
        bundleName: bundleName,
        data: statusBarData,
        appIndex: appIndex,
      };
      TrayManager.getOrCreateTrayManager().updateAppTrayInfo(callingTokenId, serviceData);

      if (code === StatusBarConnectEvent.REMOVE_FROM_STATUS_BAR) {
        // 为了每个分支都有异步返回，需要保证传入的回调一定被调用
        let callback = (replyMsg: ReplyMsg) => {
          log.showInfo('remove callback');
          statusBarServiceReplyHandle(reply, replyMsg);
          replyMsg.isDeleted ? resolve() : reject();
        };
        if (DeviceHelper.isPad()) {
          callback({ type: StatusBarConnectEvent.REMOVE_FROM_STATUS_BAR, isDeleted: true })
        }
        StatusBarServiceEventManager.getInstance().postEvent(serviceData, callback);
      } else {
        // 不是移除图标时，无需等待返回移除结果
        StatusBarServiceEventManager.getInstance().postEvent(serviceData);
        reply.writeBoolean(true);
        resolve();
      }
    });
  }

  async onRemoteMessageRequest(
    code: number,
    data: rpc.MessageSequence,
    reply: rpc.MessageSequence,
    options: rpc.MessageOption
  ): Promise<boolean> {
    const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType === SCBConstants.UITYPE_PHONE && !DeviceHelper.isLargeScreenDevice()) {
      return false;
    }
    try {
      let callingSlot: number = rpc.IPCSkeleton.getCallingTokenId();
      let callingP: number = rpc.IPCSkeleton.getCallingPid();
      let callingUid: number = rpc.IPCSkeleton.getCallingUid();
      let bundleName: string = bundleManager.getBundleNameByUidSync(callingUid);
      log.showInfo(`onRemoteMessageRequest action ${code}, bundleName: ${bundleName}, who calls: ${callingP}, slot: ${callingSlot}, isAsync: ${options.isAsync()}`);
      if (data.readInterfaceToken() !== CHECK_TAG) {
        log.showWarn('onRemoteMessageRequest unknown request');
        return false;
      }
      if (code === StatusBarConnectEvent.UPDATE_RIGHT_MENU_CLICK_HANDLER) {
        // let instanceKey: ESObject = statusBar.readInstanceKeyToParcel(data);
        // let pluginSlot = callingSlot + typeof instanceKey === 'string' ? (instanceKey as string) : "";
        // log.showInfo(`onRemoteMessageRequest code: ${code}, pluginSlot: ${pluginSlot}`);
        // AppClientNotifier.getInstance().handleClientRegistration(callingP, bundleName, data);
        reply.writeBoolean(true);
        return true;
      }

      let service = this.statusBarServiceMap.get(code);
      if (!service) {
        log.showWarn(`onRemoteMessageRequest invalid request code = ${code}`);
        return false;
      }
      let statusBarData: StatusBarData | undefined = service()?.getStatusBarData(data);
      if (statusBarData === undefined) {
        log.showWarn('onRemoteMessageRequest invalid request data');
        return false;
      }
      // 服务启动时，直接添加托盘
      if (code === StatusBarConnectEvent.ADD_TO_STATUS_BAR) {
        // 图标无效不能添加
        if (!statusBarData.statusBarItem?.icons?.white || !statusBarData.statusBarItem?.icons?.black) {
          log.showError('onRemoteMessageRequest invalid request data, the icons are invalid');
          return false;
        }
        TrayManager.getOrCreateTrayManager().createTrayForApp(callingSlot, bundleName, [callingP], statusBarData.instanceKey ?? '');
      }

      let appIndex = 0;
      try {
        const identity = await bundleManager.getAppCloneIdentity(callingUid);
        appIndex = identity?.appIndex ?? 0;
        log.showInfo('get appIndex successfully');
      } catch (error) {
        log.showError(`get appIndex error:${error.message}`);
      }
      await this.assigningValuesStatusBarData(code, callingSlot, callingP, bundleName,
        statusBarData, reply, appIndex);
      log.showInfo('onRemoteMessageRequest end');
      return true;
    } catch (err) {
      log.showError(`onRemoteMessageRequest err code: ${err.code}`);
      return false;
    }
  }
}

function statusBarServiceReplyHandle(replySequence: rpc.MessageSequence, replyMsg?: ReplyMsg): boolean {
  log.showInfo('statusBarServiceReplyHandle');
  if (!replyMsg) {
    log.showInfo('statusBarServiceReplyHandle. replyMsg is null');
    return true;
  }
  switch (replyMsg.type) {
    case StatusBarConnectEvent.REMOVE_FROM_STATUS_BAR:
      try {
        replySequence.writeBoolean(replyMsg.isDeleted);
      } catch (err) {
        log.showError(`write ${replyMsg.isDeleted} failed. err code ${err.code}`);
        return false;
      }
      return replyMsg.isDeleted;
    default:
      break;
  }
  return true;
}

export function createStatusBarStub(des: string): StatusBarStub {
  return new StatusBarStub(des);
}