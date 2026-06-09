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

import { LogDomain, LogHelper, CommonUtils } from '@ohos/basicutils';
import { PluginClickInfo, DeviceHelper } from '@ohos/frameworkwrapper';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { CommonData } from '@ohos/controlcentercommon/Index';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';

const TAG: string = 'SubPageLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const COMPONENT_ID_ICON: string = TAG + '_AbilityComponent_';
const DEFAULT_WIDTH: number = 312;
const DEFAULT_HEIGHT: number = 398;

/**
 * 远程AbilityComponent组件使用
 *
 * @since 2023-03-13
 */
@Component
export struct SubPageLayout {
  /**
   * AbilityComponent组件包名
   */
  pluginBundleName: string = '';
  /**
   * AbilityComponent组件ability名
   */
  pluginAbilityName: string = '';
  /**
   * UIExtension的uiExtensionType
   */
  uiExtensionType: string = 'sys/commonUI';
  private isPad: boolean = DeviceHelper.isPad();
  @State windowWidth: number = DEFAULT_WIDTH;
  @State windowHeight: number = DEFAULT_HEIGHT;
  clickToggleSlot: string = '';
  @StorageLink('DarkModeModel_DarkModeStatus') darkModeData: CommonData = new CommonData();
  @StorageLink('isLandscape') isLandscape: boolean = false;
  private isSameStyleToCC: boolean = false;

  aboutToAppear(): void {
    this.clickToggleSlot = sToggleSubWindowController.getCurrentSubPanelSlot();
    let subPageClickInfo: PluginClickInfo = sToggleSubWindowController.getClickInfo(this.clickToggleSlot) as
      PluginClickInfo;
    this.pluginBundleName = subPageClickInfo?.bundleName;
    this.pluginAbilityName = subPageClickInfo?.abilityName;
    if (subPageClickInfo?.uiExtensionType) {
      this.uiExtensionType = subPageClickInfo?.uiExtensionType;
      this.isSameStyleToCC = true;
    }
    this.windowHeight = subPageClickInfo?.windowHeight ?? DEFAULT_HEIGHT;
    log.showInfo('aboutToAppear clickToggleSlot:' + this.clickToggleSlot);
    log.showInfo(
      'aboutToAppear bundle: ' + this.pluginBundleName + ', ability: ' + this.pluginAbilityName +
      ', uiExtensionType: ' + this.uiExtensionType + ', windowHeight:' + this.windowHeight);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear clickToggleSlot:' + this.clickToggleSlot);
  }

  build() {
    Stack() {
      Stack() {
      }.width('100%')
      .height('100%')
      .onTouch((event) => {
        if (event?.type === TouchType.Up || event?.type === TouchType.Cancel) {
          sToggleSubWindowController.hideWindow();
        }
      })

      Stack() {
        if (!CommonUtils.isEmpty(this.pluginBundleName) && !CommonUtils.isEmpty(this.pluginAbilityName)) {
          UIExtensionComponent({
            bundleName: this.pluginBundleName,
            abilityName: this.pluginAbilityName,
            parameters: {
              'ability.want.params.uiExtensionType': this.uiExtensionType,
            }
          })
            .width('100%')
            .height('100%')
            .id(COMPONENT_ID_ICON + this.clickToggleSlot);
        }
      }
      .borderRadius(32)
      .width(this.windowWidth)
      .height(this.windowHeight)
      .height(this.isLandscape ? undefined : this.windowHeight)
      .margin(this.isLandscape ? { bottom: 24 } : undefined)
      .saturate(this.isSameStyleToCC ?
        undefined : DropDownPanelManager.getDropDownCardSaturation(this.darkModeData?.status))
      .backgroundColor(this.isSameStyleToCC ? undefined : $r('app.color.blur_style_bg'))
      .clip(true)
      .geometryTransition(this.clickToggleSlot)
    }
    .width('100%')
    .height('100%')
    .alignContent(this.isPad ? Alignment.End : Alignment.Center)
    .transition({
      type: TransitionType.All,
      opacity: 0
    })
  }
}