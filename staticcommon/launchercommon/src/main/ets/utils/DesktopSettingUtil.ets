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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { common, Want } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'DesktopSettingUtils';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 桌面设置动态配置设置搜索项
 */
export class DesktopSettingUtils {
  private static connectionId: number = -1;

  // 连接设置服务
  private static connectSettingsService(context: common.Context, connectOptions: common.ConnectOptions): number {
    let want: Want = {
      'bundleName': 'com.ohos.settings',
      'abilityName': 'SettingsExtService'
    };
    try {
      let uiContext: common.UIAbilityContext = context as common.UIAbilityContext;
      DesktopSettingUtils.connectionId = uiContext?.connectServiceExtensionAbility(want, connectOptions);
      log.showWarn(`connectionId : ${DesktopSettingUtils.connectionId}`);
    } catch (error) {
      log.showWarn(`connectSettingsService failed. code:${error?.code}, message:${error?.message}`);
    }
    return DesktopSettingUtils.connectionId;
  }

  /**
   * 动态修改搜索项
   */
  private static updateDesktopSettingToSearch(isAbleSearch: boolean): void {
    let method: string = isAbleSearch ? 'enableSearchItems' : 'disableSearchItems';
    let connectOption: common.ConnectOptions = {
      onConnect(elementName, remote) {
        // 发送消息
        let _option = new rpc.MessageOption();
        let _data = new rpc.MessageSequence();
        let _reply = new rpc.MessageSequence();
        // enableSearchItems: 开启搜索项 disableSearchItems: 关闭搜索项
        let enableObj: CallMessage = new CallMessage(method);
        let enableItems: SearchItems = new SearchItems();
        const SETTINGS_ENABLE_SEARCH_ITEMS = 2;
        // 配置搜索项name，同seachpage.json中的itemName
        enableItems.itemList = ['desktop_setting', 'desktop_slide', 'auto_align'];
        enableObj.extra = enableItems;
        log.showWarn(`send message: ${JSON.stringify(enableObj)}`)
        _data.writeString(JSON.stringify(enableObj));
        remote.sendMessageRequest(SETTINGS_ENABLE_SEARCH_ITEMS, _data, _reply, _option)
          .then(result => {
            log.showWarn(`send request success ${result.errCode} ${result.reply.readInt()}`);
            GlobalContext.getContext().disconnectServiceExtensionAbility(DesktopSettingUtils.connectionId).then(() => {
              log.showInfo('disconnect succeed.');
            }).catch((error: BusinessError) => {
              log.showError(`disconnect failed. Error code:${error?.code}, message:${error?.message}`);
            });
          })
      },
      onDisconnect(elementName) {
        log.showWarn('disconnect');
      },
      onFailed(code) {
      }
    };
    log.showWarn('connecting to settings service');
    DesktopSettingUtils.connectionId =
      DesktopSettingUtils.connectSettingsService(GlobalContext.getContext(), connectOption)
  }

  /**
   * 动态修改桌面设置搜索项
   */
  public static enableDesktopSettingsSearchItems(): void {
    try {
      DesktopSettingUtils.updateDesktopSettingToSearch(true);
    } catch (error) {
      log.showError(`enableDesktopSettingsSearchItems error. code:${error?.code}, message:${error?.message}`);
    }
  }

  public static disableDesktopSettingsSearchItems(): void {
    try {
      DesktopSettingUtils.updateDesktopSettingToSearch(false);
    } catch (error) {
      log.showError(`disableDesktopSettingsSearchItems error code:${error?.code}, message:${error?.message}`);
    }
  }
}

class CallMessage {
  /**
   * 方法名
   */
  public method: string;
  /**
   * 附加参数
   */
  public extra?: object;

  constructor(method: string, extra?: object) {
    this.method = method;
    this.extra = extra;
  }
}

class SearchItems {
  public itemList: Array<string> = [];

  public getItemList(): Array<string> {
    return this.itemList;
  }

  public setItemList(itemList: Array<string>): void {
    this.itemList = itemList;
  }
}