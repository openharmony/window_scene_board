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

import { MultiKeyCode } from '@ohos/systemuicommon';
import { CommonUtils, Log } from '@ohos/basicutils';
import { windowMgr } from '@ohos/windowscene';
import { EvtBus, PluginPosition, PluginSlot, ViewArea } from '@ohos/frameworkwrapper';
import {
  sPrivacySubLayoutController
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/PrivacySubPageLayoutController';
import { WindowPositionChangeEvent } from '@ohos/frameworkwrapper';

const TAG = 'PrivacyAbilityComponent';

interface PrivacySendData {
  showWindow: boolean;
}

/**
 * 远程AbilityComponent组件使用
 *
 * @since 2022-10-22
 */
@Component
export struct PrivacyAbilityComponent {
  @State pluginUri: string = 'load';
  /**
   * AbilityComponent组件包名
   */
  @Prop pluginBundleName: string = '';
  /**
   * AbilityComponent组件ability名
   */
  @Prop pluginAbilityName: string = '';
  @Prop pluginSlot: string = '';
  @Prop @Watch('onShow') isShowing: boolean = false;
  @Prop canDestroy: boolean = true;
  @Prop isIntWithoutShow: boolean = false;
  @Prop showControlOrSubPanel: boolean = false;
  private proxy: UIExtensionProxy | null = null;

  aboutToAppear(): void {
    Log.showInfo(TAG, 'aboutToAppear bundle, pluginBundleName: ' + this.pluginBundleName + ', ability, pluginBundleName: ' + this.pluginAbilityName);
  }

  private isShowingComponent(): boolean {
    if (CommonUtils.isEmpty(this.pluginBundleName)) {
      return false;
    }
    if (CommonUtils.isEmpty(this.pluginAbilityName)) {
      return false;
    }
    if (this.isShowing) {
      Log.showInfo(TAG, 'PrivacyAbilityComponentShow')
      return true;
    }
    if (this.canDestroy) {
      return false;
    }
    return true;
  }

  private sendData(data: Object): void {
    if (this.proxy === null) {
      Log.showError(TAG, `sendData failed, proxy is null.`);
      return;
    }
    try {
      this.proxy.send({
        'privacySubpageData': data,
      });
    } catch (err) {
      Log.showError(TAG, `sendData failed, errCode=${err.code}, msg=${err.message}.`);
    }
  }

  private onShow(): void {
    Log.showInfo(TAG, `onShow: ${this.isShowing}.`);
    if (this.isShowing) {
      this.sendData({
        showWindow: true,
      } as PrivacySendData);
    }
  }

  build() {
    // 这里必须用if来控制，不能用.visibility，否则会预先加载打印机，导致状态栏出现打印机空胶囊
    if ((this.isShowingComponent() || this.isIntWithoutShow) && this.showControlOrSubPanel) {
      Stack({alignContent: Alignment.Top}) {
        UIExtensionComponent({
          bundleName: this.pluginBundleName,
          abilityName: this.pluginAbilityName,
          parameters: {
            'ability.want.params.uiExtensionType': 'sys/commonUI'
          },
          uri: this.pluginUri,
        },
          { dpiFollowStrategy: DpiFollowStrategy.FOLLOW_HOST_DPI }
        )
          .onRelease((code: number) => {
            this.pluginUri = this.pluginUri === 'load' ? 'reLoad' : 'load';
            Log.showError(TAG, 'ability onRelease,code: ' + code + ',  uri, pluginUri: ' + this.pluginUri);
          })
          .onReceive((data) => {
            Log.showInfo(TAG, 'onReceive')
            try {
              let obj: object;
            if (typeof data === 'string') {
                obj = JSON.parse(data);
            } else {
              obj = data;
            }
            let methodObj: string = obj['method'];
            if (methodObj === 'initHeight') {
              let initHeight: number = obj['height'];
              if (initHeight === null || initHeight === 0 || initHeight === undefined || Number.isNaN(initHeight)) {
                return;
              }
              let position = windowMgr.getWindowPosition(this.pluginSlot);
              let area = {
                left: position.left,
                top: position.top,
                width: position.width,
                height: initHeight
              } as ViewArea;
              EvtBus.post(WindowPositionChangeEvent,
                { windowName: this.pluginSlot,
                  position: PluginPosition.POSITION_RIGHT,
                  area});
            }
            } catch (error) {
              Log.showError(TAG, error);
            }
          })
          .onRemoteReady((proxy) => {
            Log.showInfo(TAG, 'onRemoteReady');
            this.proxy = proxy;
            sPrivacySubLayoutController.onRemoteReadyPC(proxy, vp2px(600));
          })
          .onError(err => {
            Log.showError(TAG, 'ability onError');
          })
          .width('100%')
          .height(600)
          .defaultFocus(true)
          .onKeyEvent((keyEvent?: KeyEvent) => {
            if (this.pluginSlot && keyEvent &&
              (keyEvent.keyCode === MultiKeyCode.ESC ||
                keyEvent.keyCode === MultiKeyCode.BACK) &&
              keyEvent.type === KeyType.Up) {
              windowMgr.hideWindowWithAnim(this.pluginSlot);
            }
          })
      }
      .height('100%').alignSelf(ItemAlign.Start)
    }
  }
}