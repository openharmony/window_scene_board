/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
import { WindowConstants } from '@ohos/commonconstants';
import ScreenLockPowerMenu from './ScreenLockPowerMenu';
import { NormalPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import Constants from '../common/Constants';
import { CommonConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { StatusBarAnimConstants } from '@ohos/systemuicommon';
import Curves from '@ohos.curves';
import slPowerPanelModel, { SlPowerPanelListInfo } from './ViewModel/SlPowerPanelViewModel';
import { PowerMenuType } from './PowerViewModel';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'SCBScreenLock-PowerPanel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Component
export struct SCBScreenLockPowerPanel {
  @State globalClickable: boolean = false;
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  private onDialogShow: () => void = () => {};
  private onDialogHide: () => void = () => {};
  @Link dialogOffset: Offset;

  private requestFocus(value: string, reason?: string): void {
    let isSuccess = focusControl.requestFocus(value);
    log.showInfo(`Pwd textbox requestFocus, reson:${reason}, isSuccess = ${isSuccess}`);
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.panelInfo = StatusBarPanelManager.getInstance()
      .createPanelInfo(CommonConstants.INVALID_VALUE) as NormalPanelInfo;
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    StatusBarPanelManager.getInstance().deletePanelInfo(this.panelInfo);
    this.requestFocus(Constants.PC_COMPONENT_SLIDE_SCREEN_LOCK, 'moveFocus2Pwd');
  }

  build() {
    Stack() {
        Column()
          .width(Constants.POWER_PANEL_WIDTH)
          .height(slPowerPanelModel.slPowerPanelHeight)
          .backgroundColor(this.panelInfo?.panelBlurBgColor)
          .borderRadius(Constants.POWER_PANEL_RADIUS)
          .backgroundEffect({ radius: WindowConstants.BLUR_RADIUS })

        Column() {
          if (DeviceHelper.isPcNot2in1Device()) {
            ScreenLockPowerMenu(
              {
                powerType: PowerMenuType.DORMANT,
                textContent: $r('app.string.sleep'),
                clickable: true,
                globalClickable: $globalClickable,
                panelInfo: this.panelInfo,
                dialogOffset: this.dialogOffset,
                onDialogShow: (): void => {
                  this.onDialogShow()
                },
                onDialogCancel: (): void => {
                  this.onDialogHide()
                }
              }
            )
          }
          ScreenLockPowerMenu(
            {
              powerType: PowerMenuType.RESTART,
              textContent: $r('app.string.reboot_device'),
              clickable: true,
              globalClickable: $globalClickable,
              panelInfo: this.panelInfo,
              dialogMsg: $r('app.string.restart_dialog_message'),
              dialogOffset: this.dialogOffset,
              onDialogShow: (): void => {
                this.onDialogShow()
              },
              onDialogCancel: (): void => {
                this.onDialogHide()
              }
            }
          )
          ScreenLockPowerMenu(
            {
              powerType: PowerMenuType.POWER_OFF,
              textContent: $r('app.string.shutdown_device'),
              clickable: true,
              globalClickable: $globalClickable,
              panelInfo: this.panelInfo,
              dialogMsg: $r('app.string.power_dialog_message'),
              dialogOffset: this.dialogOffset,
              onDialogShow: (): void => {
                this.onDialogShow()
              },
              onDialogCancel: (): void => {
                this.onDialogHide()
              }
            }
          )
        }
      }
      .width(Constants.POWER_PANEL_WIDTH)
      .height(slPowerPanelModel.slPowerPanelHeight)
      .borderRadius(Constants.POWER_PANEL_RADIUS)
      .border({
        width: this.panelInfo?.panelBorderWidth,
        color: this.panelInfo?.panelInsideBorderColor,
        radius: Constants.POWER_PANEL_RADIUS
      })
      .outline({
        width: this.panelInfo?.panelBorderWidth,
        color: this.panelInfo?.panelOutsideBorderColor,
        radius: 1 + Constants.POWER_PANEL_RADIUS
      })
      .backgroundColor(this.panelInfo?.panelAvgColor)
      .shadow(this.panelInfo?.panelShadowOptions)
  }
}
