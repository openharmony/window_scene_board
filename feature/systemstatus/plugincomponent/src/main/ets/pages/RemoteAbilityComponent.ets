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

import {
  CommonUtils,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { windowMgr } from '@ohos/windowscene';
import { MultiKeyCode } from '@ohos/systemuicommon';

const TAG = 'RemoteAbilityComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 远程AbilityComponent组件使用
 *
 * @since 2022-10-22
 */
@Component
export struct RemoteAbilityComponent {
  /**
   * AbilityComponent组件包名
   */
  @Prop pluginBundleName: string = '';

  /**
   * AbilityComponent组件ability名
   */
  @Prop pluginAbilityName: string = '';

  @Prop pluginSlot: string = '';

  @Prop isShowing: boolean = false;

  aboutToAppear(): void {
    log.showInfo('aboutToAppear bundle:' + this.pluginBundleName + ', ability: ' + this.pluginAbilityName);
  }

  build() {
    // 这里必须用if来控制，不能用.visibility，否则会预先加载打印机，导致状态栏出现打印机空胶囊
    if (!CommonUtils.isEmpty(this.pluginBundleName) && !CommonUtils.isEmpty(this.pluginAbilityName) && this.isShowing) {
      AbilityComponent({
        want: {
          bundleName: this.pluginBundleName,
          abilityName: this.pluginAbilityName
        }
      })
        .onConnect(() => {
          log.showError('ability onConnect:' + this.pluginBundleName);
        })
        .width('100%')
        .height('100%')
        .defaultFocus(true)
        .onKeyEvent((keyEvent?: KeyEvent) => {
          if (this.pluginSlot && keyEvent &&
            (keyEvent.keyCode === MultiKeyCode.ESC || keyEvent.keyCode === MultiKeyCode.BACK) &&
            keyEvent.type === KeyType.Up) {
            windowMgr.hideWindowWithAnim(this.pluginSlot);
          }
        })
        .key(`${TAG}_${this.pluginBundleName}_${this.pluginAbilityName}`)
    }
  }
}