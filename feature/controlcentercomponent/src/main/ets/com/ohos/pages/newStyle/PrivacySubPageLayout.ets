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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { sEventManager } from '@ohos/frameworkwrapper';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { CC_LAYOUT_CONFIGS, ControlCenterLayoutIndex } from '../../controller/ControlCenterLayoutController';
import { sPrivacySubLayoutController } from '../../controller/PrivacySubPageLayoutController';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ScreenLockStatus } from '@ohos/screenlockcommon/src/main/ets/interface/ScreenOnOffMediator';
import { ScreenLockAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ScreenLockAdapter';

const DEFAULT_WIDTH: number = 312;
const DEFAULT_HEIGHT: number = 398;
const TAG: string = 'Ctrl.PrivacySubPageLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

@Component
export struct PrivacySubPageLayout {
  private windowWidth: number = DEFAULT_WIDTH;
  private windowHeight: number = DEFAULT_HEIGHT;
  @Link contentHeight: number | string;
  @Consume ccLayoutIndex: ControlCenterLayoutIndex;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State isShowExtension: boolean = true;

  private backToMainPage(event?: TouchEvent) {
    if (event?.type === TouchType.Up || event?.type === TouchType.Cancel) {
      sPrivacySubLayoutController.hideWindow();
    }
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    if (ScreenLockAdapter.getLock()) {
      this.isShowExtension = false;
    } else {
      this.isShowExtension = true;
    }
    log.showDebug(`aboutToAppear this.isShowExtension: ${this.isShowExtension}`);
    // UIE加载锁屏状态监听
    sEventManager.subscribe('ControlCenterLockStatus', this.onLockStatusChanged);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    sEventManager.off('ControlCenterLockStatus', this.onLockStatusChanged);
  }

  private onLockStatusChanged = (lockStatus: ScreenLockStatus): void => {
    log.showInfo(`onLockStatusChanged lock status: ${lockStatus}`);
    if (lockStatus === ScreenLockStatus.UNLOCK) {
      this.isShowExtension = true;
    } else {
      this.isShowExtension = false;
    }
    log.showDebug(`onLockStatusChanged this.isShowExtension: ${this.isShowExtension}`);
  }

  build() {
    Stack() {
      this.loadBlankStack()
      Stack() {
        this.loadBlankStack()
        this.loadUIExtension()
      }
      .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelWidth)
      .height(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.subpageVerticalCenter ? '100%' : this.contentHeight)
      .margin(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelMargin)
    }
    .direction(Direction.Ltr)
    .width('100%')
    .height('100%')
    .alignContent(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelAlignment)
  }

  @Builder
  loadBlankStack() {
    Stack() {
    }.width('100%')
    .height('100%')
    .onTouch((event) => {
      this.backToMainPage(event);
    })
  }

  @Builder
  loadUIExtension() {
    Column() {
      if (this.isShowExtension) {
        UIExtensionComponent({
          bundleName: 'com.ohos.security.privacycenter',
          abilityName: 'IndicatorDetailingAbility',
          parameters: { 'ability.want.params.uiExtensionType': 'sys/commonUI', }
        })
          .width('100%')
          .height('100%')
          .onReceive((data) => {
            let obj: object;
            if (typeof data === 'string') {
              obj = JSON.parse(data);
            } else {
              obj = data;
            }
            let methodObj: string = obj['method'];
            if (methodObj == 'closeControlCenter') {
              DropDownPanelManager.hideWindowDirectly();
              return;
            }
          })
          .onRemoteReady((proxy) => {
            sPrivacySubLayoutController.onRemoteReady(proxy);
          })
      }
    }
    .width(this.windowWidth)
    .height(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.subpageHeight)
    .borderRadius(32)
    .backgroundColor(this.colorModeViewData.getSolidColor(
      this.colorModeViewData.subLayoutBgColor, this.colorModeViewData.mainCardOption))
    .backgroundBrightnessInternal(this.colorModeViewData.getBrightnessOption(
      this.colorModeViewData.mainCardTogOption))
    .clip(true)
    .margin(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.subpageMargin)
  }

}
