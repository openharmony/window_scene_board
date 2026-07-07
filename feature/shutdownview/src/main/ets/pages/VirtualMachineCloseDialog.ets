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

import { appManager, bundleResourceManager } from '@kit.AbilityKit';
import bundleResource from '@ohos.bundle.bundleResourceManager';
import statusBar from '@ohos.pcService.statusBar';
import osAccount from '@ohos.account.osAccount';
import { ResUtils } from '@ohos/windowscene';
import { LogDomain, LogHelper, CheckEmptyUtils, CapabilityUtil } from '@ohos/basicutils';
import { viewMgrPolicy, ViewType, settingsDataManager } from '@ohos/frameworkwrapper';
import { KeyCodeConstants } from '@ohos/commonconstants';
import { ShutdownViewConstant } from './ShutdownViewConstants';
import { RunningAppListState } from './RunningAppListState';
import { SystemShutdownStyle } from './SystemShutdownStyle';
import { rpcShutdownPolicy } from '../policy/RpcShutdownPolicy';

const TAG = 'VirtualMachineCloseDialog';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

@CustomDialog
export struct VirtualMachineCloseDialog {
  public dialogController?: CustomDialogController;
  private virtualMachineIcon: string | Resource = '';
  private virtualMachineAppName: string = '';
  @State warningText: Resource | undefined = undefined;
  @Link runningVirtualMachine: string;
  @Link virtualMachineDlgHeight: number; // 需要重新计算高度
  @Link isReboot: boolean;

  private async judgeWarningText(): Promise<void> {
    let currentAccountId: string = await this.getCurrentAccountId();
    let virtualMachineAccountId: string =
      settingsDataManager.getValue(null, ShutdownViewConstant.virtualMachineCurrentUser, '');
    if (currentAccountId != '' && virtualMachineAccountId != '' && virtualMachineAccountId !== currentAccountId) {
      this.warningText = this.isReboot ? $r('app.string.reboot_warning_when_kiddo_update_in_other_user') :
        $r('app.string.shutdown_warning_when_kiddo_update_in_other_user');
      return;
    }
    this.warningText = this.isReboot ? $r('app.string.reboot_warning_when_kiddo_update') :
    $r('app.string.shutdown_warning_when_kiddo_update');
  }

  private async virtualMachineTerminate(): Promise<void> {
    try {
      settingsDataManager.setValue(null, ShutdownViewConstant.virtualMachineTerminateKey, 'true');
      let pidList: number[] = [];
      const processInfoList: appManager.ProcessInformation[] =
        await appManager.getRunningProcessInfoByBundleName(this.runningVirtualMachine);
      if (processInfoList.length === 0) {
        log.showInfo('processInfoList length is 0');
        return;
      }
      processInfoList.forEach(item => {
        if (!item.bundleNames || item.bundleNames.length === 0) {
          log.showInfo('item.bundleNames error');
        } else if (item.bundleNames[0] === this.runningVirtualMachine && CheckEmptyUtils.isEmpty(item.appCloneIndex) &&
          pidList.indexOf(item.pid) === -1) {
          pidList.push(item.pid);
        } else {
          log.showInfo('item error');
        }
      });
      if (pidList.length === 0) {
        log.showInfo('pidList length is 0');
        return;
      }
      log.showInfo(`exit ${this.runningVirtualMachine} app pid list size : ${pidList.length}`);
      CapabilityUtil.isStatusBarAvailable() && statusBar.exitProcesses(pidList);
    } catch (e) {
      log.showError(`virtualMachineTerminate error, code: ${e?.code}, message: ${e?.message}`);
    }
  }

  initDlgHeight() {
    this.virtualMachineDlgHeight = SystemShutdownStyle.virtualMachineCloseDialogHeight;
    log.showInfo(`init virtual machine dlgHeight: ${this.virtualMachineDlgHeight}`);
  }

  private async getCurrentAccountId(): Promise<string> {
    let osAccountManager: osAccount.AccountManager = osAccount.getAccountManager();
    if (!osAccountManager) {
      log.showInfo('osAccountManager is null');
      return '';
    }
    try {
      let currentAccountId: number = await osAccountManager.getForegroundOsAccountLocalId();
      return currentAccountId.toString();
    } catch (e) {
      log.showError(`getForegroundOsAccountLocalId failed, code: ${e?.code}, message: ${e?.message}`);
      return '';
    }
  }

  @Builder
  VirtualMachineItem() {
    Column() {
      Image(this.virtualMachineIcon)
        .width(SystemShutdownStyle.virtualMachineIconSize)
        .height(SystemShutdownStyle.virtualMachineIconSize)
        .interpolation(ImageInterpolation.Medium)
        .borderRadius(SystemShutdownStyle.virtualMachineIconRadius)
        .margin({ top: SystemShutdownStyle.virtualMachineIconTop })
        .outline({
          width: SystemShutdownStyle.appOutlineWidth,
          color: SystemShutdownStyle.appOutlineColor,
          radius: {
            topLeft: SystemShutdownStyle.virtualMachineIconRadius,
            topRight: SystemShutdownStyle.virtualMachineIconRadius,
            bottomLeft: SystemShutdownStyle.virtualMachineIconRadius,
            bottomRight: SystemShutdownStyle.virtualMachineIconRadius
          }
        })
      Text(this.virtualMachineAppName)
        .width(SystemShutdownStyle.virtualMachineNameWidth)
        .lineHeight(SystemShutdownStyle.virtualMachineNameLineHeight)
        .fontSize(SystemShutdownStyle.mediumFontSize)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(ShutdownViewConstant.confirmDlgTitleMaxLines)
        .margin({ top: SystemShutdownStyle.virtualMachineIconBottom })
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.ohos_fa_text_primary'))
        .textAlign(TextAlign.Center)
    }
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  ButtonBuilder() {
    Row({ space: ResUtils.getNumber($r('app.float.screenLock_shutdown_dialog_button_space')) }) {
      Button($r('app.string.got_it'), { type: ButtonType.Normal })
        .layoutWeight(1)
        .fontSize($r('app.float.screenLock_shutdown_dialog_font_size'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.shutdown_dialog_negative_font_color'))
        .height($r('app.float.screenLock_shutdown_dialog_button_height'))
        .borderRadius($r('sys.float.corner_radius_level4'))
        .backgroundColor($r('app.color.shutdown_dialog_negative_button_background'))
        .tabIndex(1)
        .onClick(() => {
          log.showInfo('click confirm');
          this.dialogController?.close();
          settingsDataManager.setValue(null, ShutdownViewConstant.virtualMachineTerminateKey, 'false');
          viewMgrPolicy.hideView(ViewType.SHUTDOWN_VIEW);
          if (rpcShutdownPolicy.getRpcView()) {
            try {
              rpcShutdownPolicy.rpcShutDownView('onClickCancel');
            } catch (e) {
              log.showError(`cancel rpcShutDownView err, code: ${e?.code}, message: ${e?.message}`);
            }
          }
        })
    }
    .padding({
      left: $r('app.float.screenLock_shutdown_dialog_button_padding'),
      right: $r('app.float.screenLock_shutdown_dialog_button_padding'),
      bottom: SystemShutdownStyle.virtualMachineButtonBottom
    })
  }

  async aboutToAppear() {
    log.showInfo('aboutToAppear');
    const defaultState: RunningAppListState = new RunningAppListState();
    let resourceInfo: bundleResourceManager.BundleResourceInfo =
      bundleResourceManager.getBundleResourceInfo(this.runningVirtualMachine);
    this.virtualMachineIcon = resourceInfo ? resourceInfo.icon : defaultState.icon;
    this.virtualMachineAppName = resourceInfo ? resourceInfo.label : defaultState.appName;
    await this.judgeWarningText();
    this.initDlgHeight();
    await this.virtualMachineTerminate();
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  build() {
    Column() {
      this.VirtualMachineItem();
      Text(this.warningText)
        .draggable(false)
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontSize($r('app.float.screenLock_shutdown_dialog_font_size'))
        .fontWeight(FontWeight.Regular)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .lineHeight($r('app.float.screenLock_shutdown_dialog_line_height'))
        .padding($r('app.float.screenLock_shutdown_dialog_padding'))
        .padding({
          left: $r('app.float.screenLock_shutdown_dialog_padding'),
          right: $r('app.float.screenLock_shutdown_dialog_padding'),
          top: SystemShutdownStyle.virtualMachineWarningTop,
          bottom: SystemShutdownStyle.virtualMachineWarningBottom
        })
      this.ButtonBuilder();
    }
    .constraintSize({
      maxHeight: SystemShutdownStyle.confirmDialogMaxHeight
    })
    .borderRadius(SystemShutdownStyle.confirmDialogBorderRadius)
    .height(this.virtualMachineDlgHeight)
    .constraintSize({
      minHeight: this.virtualMachineDlgHeight,
      maxHeight: SystemShutdownStyle.confirmDialogMaxHeight
    })
    .width(SystemShutdownStyle.confirmDialogWidth)
    .shadow(ShadowStyle.OUTER_DEFAULT_MD)
    .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK)
    .onKeyEvent((event?: KeyEvent) => {
      if (event?.keyCode === KeyCodeConstants.KEYCODE_ESCAPE && event?.type === KeyType.Up) {
        log.showInfo('close shutdown dialog due to esc');
        this.dialogController?.close();
        settingsDataManager.setValue(null, ShutdownViewConstant.virtualMachineTerminateKey, 'false');
        viewMgrPolicy.hideView(ViewType.SHUTDOWN_VIEW);
        if (rpcShutdownPolicy.getRpcView()) {
          try {
            rpcShutdownPolicy.rpcShutDownView('onClickCancel');
          } catch (e) {
            log.showError(`cancel rpcShutDownView err, code: ${e?.code}, message: ${e?.message}`);
          }
        }
      }
    })
    .focusable(true)
  }
}