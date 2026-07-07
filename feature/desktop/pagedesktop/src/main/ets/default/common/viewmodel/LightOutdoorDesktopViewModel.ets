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

import { LightOutdoorConfig } from '@ohos/frameworkwrapper';
import { LightOutdoorState } from './LightOutdoorState';
import { common } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';
import {
  CommonUtils,
  LogDomain,
  Logger,
} from '@ohos/basicutils';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { CommonConstants } from '@ohos/launchercommon';
import { LaunchLayoutCacheManager, PageInfoManager } from '@ohos/launchercommon';
import { SCBDesktopAddViewModel } from '../components/desktopaddapp/SCBDesktopAddViewModel';
import { PageDesktopViewModel } from './PageDesktopViewModel';

const TAG = 'LightOutdoorDesktopViewModel';
const COMMON_EVENT_SELECT_APP = 'com.ohos.sceneboard.selectapp';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

export class LightOutdoorDesktopViewModel {
  private static instance: LightOutdoorDesktopViewModel;
  private lightOutdoorState: LightOutdoorState = new LightOutdoorState();

  private constructor() {
    // 初始化
    this.lightOutdoorState.setIsOnLightOutdoorState(LightOutdoorConfig.getInstance().isOnLightOutdoorMode());
  }

  public static getInstance(): LightOutdoorDesktopViewModel {
    if (!LightOutdoorDesktopViewModel.instance) {
      LightOutdoorDesktopViewModel.instance = new LightOutdoorDesktopViewModel();
    }
    return LightOutdoorDesktopViewModel.instance;
  }

  /**
   * 更新云端2状态，该state当前会被导航点使用
   * @param isOnLightOutdoorMode
   */
  public updateIsOnLightOutdoorModeStatus(isOnLightOutdoorMode: boolean) {
    this.lightOutdoorState.setIsOnLightOutdoorState(isOnLightOutdoorMode);
  }

  public getLightOutdoorState(): LightOutdoorState {
    return this.lightOutdoorState;
  }

  /**
   * 热切云端2或在云端2下重启会添加。
   * @param layoutInfo
   */
  public appendAddIconForLightOutdoorMode(deleteBlankPage: boolean): void {
    if (!LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
      return;
    }
    //删除加号图标，由B版本升级过来，数据库中可能会存在添加应用的图标。此处移除为了规避该场景
    LaunchLayoutCacheManager.getInstance().deleteGridLayoutItemByBundleNameAndType(CommonConstants.SCENEBOARD_BUNDLE,
      CommonConstants.TYPE_ADD, '', false);
    SCBDesktopAddViewModel.getInstance().appendAddIcon();
    if (deleteBlankPage) {
      LightOutdoorDesktopViewModel.getInstance().deleteBlankPage();
    }
  }


  /**
   * 进入/退出云端2, IPC 给云端助手
   */
  public onPageDesktopRefreshFinished(): void {
    // 如果是切到云端2
    if (LightOutdoorConfig.getInstance().isHotSwitchToLightOutdoorMode()) {
      log.showInfo(TAG, `send msg to cloud after switch to  lightoutdoor mode`);
      this.sendFinishMsgToCloud();
      LightOutdoorConfig.getInstance().resetHotSwitchToLightOutdoorStatus();
    } else if (LightOutdoorConfig.getInstance().isHotSwitchToOtherMode()) {
      log.showInfo(TAG, 'start send msg to cloud after exsit lightoutdoor mode');
      let homePageIndex: number = PageInfoManager.getInstance().getHomePageIndex();
      log.showInfo(TAG, `reset pageIndex to homePage : ${homePageIndex}`);
      AppStorage.setOrCreate('pageIndex', homePageIndex);
      this.sendFinishMsgToCloud();
      LightOutdoorConfig.getInstance().resetHotSwitchToOtherModeStatus();
      this.sendExitLightOutdoorModeEvent();
    }
    // 只要是进云端2的桌面刷新，就通知SystemUI
    if (LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
      AppStorage.setOrCreate('pageIndex', 0);
      this.sendEnterLightOutdoorModeEvent();
    }
  }

  /**
   * 云端2 进入，退出都需要发送消息给云端助手
   */
  private sendFinishMsgToCloud(): void {
    let newWant: Want = {
      bundleName: 'com.ohos.cloudmodeassistant', // 请求大桌面进程中的ServiceExtention
      abilityName: 'OutdoorServiceAbility'
    }
    let connectOption: common.ConnectOptions = {
      onConnect(elementName, remote) {
        let option = new rpc.MessageOption();
        let data = rpc.MessageSequence.create();
        let reply = rpc.MessageSequence.create();
        data.writeInterfaceToken('rpcCloudAbility');
        data.writeString('systemAlertService');
        data.writeInt(2);

        remote.sendMessageRequest(0, data, reply, option)
          .then(result => {
            log.showInfo(TAG, 'send IPC message success.');
          })
          .catch((error: BusinessError) => {
            log.showError(TAG, `send IPC message error code:${error.code},message:${error.message}`)
          })
          .finally(() => {
            data.reclaim();
            reply.reclaim();
          });
      },
      onDisconnect(elementName) {
        log.showInfo(TAG, `DisConnect from Cloud IPC service,elementName: ${elementName.bundleName}`)
      },
      onFailed(code) {
        log.showError(TAG, `Connect to Cloud Service Failed,code: ${code}`);
      }
    }
    try {
      let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
      const connectionId = context?.connectServiceExtensionAbility(newWant, connectOption);
      log.showInfo(TAG, `send finish switching msg to Cloud, connectionId: ${connectionId}`);
    } catch (error) {
      let err: BusinessError = error as BusinessError
      log.showError(TAG, `Connect to Cloud Failed,code: ${err.code}`)
    }
  }

  /**
   * 切换到云端2时发送广播
   */
  private sendEnterLightOutdoorModeEvent(): void {
    let map: Map<string, string[]> = new Map<string, string[]>();
    map.set('allAddedApp', this.getUserAddedApps());
    let dataString: string = CommonUtils.mapToJonStr(map);
    let options: commonEventManager.CommonEventPublishData = {
      code: 1, // 公共事件的初始代码
      data: dataString, // 公共事件的初始数据
    };
    this.publishEvent('com.ohos.sceneboard.entercloud2', options);
  }

  /**
   * 退出云端2时发送广播
   */
  private sendExitLightOutdoorModeEvent(): void {
    let options: commonEventManager.CommonEventPublishData = {
      code: 1 // 公共事件的初始代码
    };
    this.publishEvent('com.ohos.sceneboard.exitcloud2', options);
  }

  /**
   * 反选应用场景：添加/移除应用后发送事件
   */
  public sendDesktopAppChangeEvent(): void {
    if (!LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
      return;
    }
    this.publishEvent(COMMON_EVENT_SELECT_APP, this.getCurrentAppData(this.getUserAddedApps(),
      SCBDesktopAddViewModel.getInstance().getRemovedAppList()));
  }

  /**
   * 处理云端2下长按移除应用的场景
   * @param bundleName
   */
  public handleAppItemDelete(bundleName: string): void {
    this.sendRemoveAppEvent(bundleName);
  }

  public removeAddIcon(): void {
    if (!LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
      return;
    }
    LaunchLayoutCacheManager.getInstance().deleteGridLayoutItemByBundleNameAndType(CommonConstants.SCENEBOARD_BUNDLE,
      CommonConstants.TYPE_ADD, '', false);
  }
  /**
   * 云端2 下检测并清理空白页
   */
  private deleteBlankPage(): void {
    if (!LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
      return;
    }
    let pageCount: number = PageInfoManager.getInstance().getPageCount(false);
    log.showInfo(TAG, `start delete blank page. current pageCount: ${pageCount}`);
    //遍历所有页数进行空白页的清理
    for (let i = pageCount - 1; i > 0; i --) {
      PageDesktopViewModel.getInstance().deletePage(i, false);
    }
  }

  /**
   * 桌面上长按移除场景： 移除应用后发送事件
   * @param bundleName
   */
  private sendRemoveAppEvent(bundleName: string): void {
    if (!LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
      return;
    }
    this.publishEvent(COMMON_EVENT_SELECT_APP, this.getCurrentAppData(this.getUserAddedApps(), [bundleName]));
  }

  /**
   * 发送commonEvent
   * @param eventName 事件名
   * @param option 事件参数
   */
  private publishEvent(eventName: string, option: commonEventManager.CommonEventPublishData) {
    commonEventManager.publish(eventName, option, (err: BusinessError) => {
      if (err) {
        log.error(TAG, `Failed to publish event: ${eventName}. Code is ${err.code}, message is ${err.message}`);
      } else {
        log.info(TAG, `Succeeded in publishing event: ${eventName}`);
      }
    });
  }

  /**
   * 获取当前的应用数据，包括：
   * 1. 当前用户手动添加的应用
   * 2. 本次移除掉的应用
   * @returns
   */
  private getCurrentAppData(allAddedApps: string[], removedApps: string[]): commonEventManager.CommonEventPublishData {
    let map: Map<string, string[]> = new Map<string, string[]>();
    map.set('allAddedApp', allAddedApps);
    map.set('removedApp', removedApps);
    let dataString: string = CommonUtils.mapToJonStr(map);
    log.showInfo(TAG, `publish data: ${dataString}`);
    let options: commonEventManager.CommonEventPublishData = {
      code: 1, // 公共事件的初始代码
      data: dataString, // 公共事件的初始数据
    };
    return options;
  }

  /**
   * 获取用户添加的应用
   * @returns
   */
  private getUserAddedApps(): string[] {
    let bundleNameList: string[] = [];
    LaunchLayoutCacheManager.getInstance().getAllApps().forEach(item => {
      if (item.intent?.includes('userAdd')) {
        bundleNameList.push(item.bundleName);
      }
    });
    return bundleNameList;
  }
}