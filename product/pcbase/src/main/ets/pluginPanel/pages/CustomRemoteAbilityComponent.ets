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

import { MultiKeyCode } from '@ohos/systemuicommon';
import { CommonUtils, Log } from '@ohos/basicutils';
import { windowMgr } from '@ohos/windowscene';
import {
  onAsyncReceiverRegister
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/UIExtensionProxyHelper';

const TAG = 'CustomRemoteAbilityComponent';
const FIELD_METHOD = 'method';
const FIELD_HEIGHT = 'height';

/**
 * 远程AbilityComponent组件使用
 *
 * @since 2022-10-22
 */
@Component
export struct CustomRemoteAbilityComponent {
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
  @Prop pluginParams: Record<string, Object> = {};
  @Prop isShowing: boolean = false;
  @Prop canDestroy: boolean = true;
  @Prop isNeedPreShow: boolean = false;
  updateHeight?: (height: number) => void;

  aboutToAppear(): void {
    Log.showInfo(TAG,
      'aboutToAppear bundle, pluginBundleName: ' + this.pluginBundleName +
        ', ability, pluginBundleName: ' + this.pluginAbilityName);
  }

  private isShowingComponent(): boolean {
    if (CommonUtils.isEmpty(this.pluginBundleName)) {
      return false;
    }
    if (CommonUtils.isEmpty(this.pluginAbilityName)) {
      return false;
    }
    if (this.isShowing) {
      return true;
    }
    if (this.canDestroy) {
      return false;
    }
    return true;
  }

  private getParams(): Record<string, Object> {
    const params: Record<string, Object> = {
      'ability.want.params.uiExtensionType': 'sys/commonUI',
    };
    for (const key of Object.keys(this.pluginParams)) {
      params[key] = Reflect.get(this.pluginParams, key);
    }
    return params;
  }

  build() {
    // 这里必须用if来控制，不能用.visibility，否则会预先加载打印机，导致状态栏出现打印机空胶囊
    if (this.isShowingComponent() || this.isNeedPreShow) {
      UIExtensionComponent({
        bundleName: this.pluginBundleName,
        abilityName: this.pluginAbilityName,
        parameters: this.getParams(),
        uri: this.pluginUri,
      },
        { dpiFollowStrategy: DpiFollowStrategy.FOLLOW_HOST_DPI }
      )
        .onRelease((code: number) => {
          this.pluginUri = this.pluginUri === 'load' ? 'reLoad' : 'load';
          Log.showError(TAG, 'ability onRelease,code: ' + code + ',  uri, pluginUri: ' + this.pluginUri);
        })
        .onRemoteReady((proxy) => {
          Log.showError(TAG, 'ability onConnect,pluginBundleName: ' + this.pluginBundleName);
          onAsyncReceiverRegister(proxy, (p: UIExtensionProxy) => {
            p?.send({
              'privacySubpageData': {
                maxWindowHeight: vp2px(930),
              }
            });
          })
        })
        .onError(err => {
          Log.showError(TAG, 'ability onError');
        })
        .onReceive((data) => {
          Log.showInfo(TAG, `onReceive, pluginSlot: ${this.pluginSlot}, data: ${JSON.stringify(data)}`);
          if (data && data[FIELD_METHOD] === 'initHeight') {
            Log.showInfo(TAG, `onReceive, height: ${data[FIELD_HEIGHT]}`);
            let height: number = data[FIELD_HEIGHT] as number;
            if (!height || Number.isNaN(height)) {
              Log.showError(TAG, `height invalid: ${data[FIELD_HEIGHT]}`);
              return;
            }
            this.updateHeight?.(height);
          }
        })
        .width('100%')
        .height('100%')
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
  }
}