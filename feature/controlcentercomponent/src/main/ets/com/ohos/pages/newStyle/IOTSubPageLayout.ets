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
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { sIOTSubPageLayoutController } from '../../controller/IOTSubPageLayoutController';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { CC_LAYOUT_CONFIGS, ControlCenterLayoutIndex } from '../../controller/ControlCenterLayoutController';

const TAG: string = 'IOTSubLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const IOT_CONTAINER_WIDTH: number = 360;

/**
 * IOT卡片详情&编辑
 *
 * @since 2023-11-08
 */
@Component
export struct IOTSubPageLayout {
  @Link contentHeight: number | string;
  @Link isIotServiceAlive: boolean;
  @Consume ccLayoutIndex: ControlCenterLayoutIndex;
  private statusBarHeight = ResUtils.getNumber($r('app.float.status_bar_phone_height'));

  aboutToAppear(): void {
  }

  aboutToDisappear() {
  }

  build() {
    Stack() {
      Stack() {
      }.width('100%')
      .height('100%')
      .onTouch(sIOTSubPageLayoutController.onBlankAreaTouch)

      Stack() {
        // 顶部margin区域也要支持点击
        Stack() {
        }.width('100%')
        .height('100%')
        .onTouch(sIOTSubPageLayoutController.onBlankAreaTouch)

        this.buildDetailLayout();
      }
      .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelWidth)
      .height(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.subpageVerticalCenter ? '100%' : this.contentHeight)
      .margin(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelMargin)
      .alignContent(Alignment.Center)
    }
    .direction(Direction.Ltr)
    .width('100%')
    .height('100%')
    .alignContent(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelAlignment)
    .transition({
      type: TransitionType.All,
      opacity: 0
    })
  }

  @Builder
  buildDetailLayout() {
    UIExtensionComponent({
      bundleName: 'com.ohos.ailifesvc',
      abilityName: 'IotDeviceDetailAbility',
      parameters: { 'ability.want.params.uiExtensionType': 'sys/commonUI' }
    })
      .width(IOT_CONTAINER_WIDTH)
      .height(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.subpageVerticalCenter ? '100%' :
        this.contentHeight as number - this.statusBarHeight - CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.headerHeight)
      .margin(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.subpageMargin)
      .onReceive(sIOTSubPageLayoutController.onRemoteReceive)
      .onRemoteReady(sIOTSubPageLayoutController.onRemoteReady)
      .onRelease((data: number) => {
        log.showInfo(`IotDeviceDetailAbility released, code: ${data}`);
        this.isIotServiceAlive = false;
        this.backToMainPage();
      })
      .accessibilityUseSamePage(AccessibilitySamePageMode.FULL_SILENT)
  }

  private backToMainPage() {
    sIOTSubPageLayoutController.hideWindow();
  }
}