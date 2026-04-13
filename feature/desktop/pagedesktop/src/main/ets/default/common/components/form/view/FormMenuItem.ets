/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { desktopUtil } from '@ohos/componenthelper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { AppMenu, FormMenu } from '@ohos/launchercommon/Index'
import { MenuInfo, StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';

const TAG = 'FormMenuItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export default struct FormMenuItem {
  private mMenuInfo: MenuInfo[] = [];
  private mIsMenuClicked: boolean = false;

  private onAppearEventHandle?: () => void;
  private onDisappearEventHandle?: (isClick: boolean) => void;

  build() {
    if (DeviceHelper.isPC()) {
      AppMenu({
        menuInfoList: this.mMenuInfo,
        menuWidth: StyleConstants.MENU_WIDTH_COLUMNS_PC,
        isBusinessStyle: true
      })
        .onAppear(() => {
          log.showWarn('MenuBuilder onAppear');
          this.onAppearEventHandle?.()
        })
    } else {
      FormMenu({
        menuInfoList: this.mMenuInfo,
        closeMenu: () => { this.mIsMenuClicked = true },
      })
        .width(launcherStatusUtil.getShowOutLauncherStatus() ? desktopUtil.getSmallFoldFormMenuWidthColumns() :
          StyleConstants.CONTEXT_FORM_MENU_WIDTH)
        .onAppear(() => {
          log.showWarn(`MenuBuilder onAppear`);
          this.mIsMenuClicked = false;
          this.onAppearEventHandle?.()
        })
        .onDisAppear(() => {
          log.showWarn(`MenuBuilder onDisAppear`);
          const isClicked: boolean = this.mIsMenuClicked;
          this.mIsMenuClicked = false;
          this.onDisappearEventHandle?.(isClicked);
        })
    }
  }
}