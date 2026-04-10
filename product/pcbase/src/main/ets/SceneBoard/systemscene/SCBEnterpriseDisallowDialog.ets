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

import { LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  ViewCallback,
  ViewManagerPolicy,
  viewMgrPolicy,
  ViewType,
} from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager, SCBScreenProperty } from '@ohos/windowscene';
import { BaseViewController } from '@ohos/frameworkcommon';

const TAG = '[DesktopWorld]SCBEnterpriseDisallowDialog';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);


@Component
export struct SCBEnterpriseDisallowDialog {
  persistentId: number = 0;
  screenProp: SCBScreenProperty | null = null;
  private desktopSwitchCallback: ViewCallback = {
    onShow: (): void => {
      log.showInfo('SCBMultiDesktopSwitcher show');
    }
  };
  @State viewController: BaseViewController = new BaseViewController(ViewType.ENTERPRISE_DISALLOW_DIALOG);
  @State isSwitching: boolean = false;
  @StorageLink('isShowEnterpriseAlertDialog') @Watch('updateAlertDialogStatus')
  isShowEnterpriseAlertDialog: boolean = false;

  private updateAlertDialogStatus() {
    log.showInfo('SCBEnterpriseDisallowDialog updateAlertDialogStatus');
    if (this.isShowEnterpriseAlertDialog) {
      ViewManagerPolicy.showView(ViewType.ENTERPRISE_DISALLOW_DIALOG);
      this.updateSwitching(true);
    }
    this.isShowEnterpriseAlertDialog = false;
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear, start ` + this.persistentId + ' ' + this.screenProp);
    viewMgrPolicy.registerViewController(ViewType.ENTERPRISE_DISALLOW_DIALOG, this.viewController);
    viewMgrPolicy.registerViewCallback(ViewType.ENTERPRISE_DISALLOW_DIALOG, this.desktopSwitchCallback);
    this.viewController.updateId(this.persistentId);
    this.registerTransparentDetection();
  }

  private registerTransparentDetection(): void {
    const session = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    session?.registerContextTransparentCallback(() => {
      log.showError('window is transparency!!');
    })
  }

  aboutToDisappear() {
    viewMgrPolicy.unregisterViewController(ViewType.ENTERPRISE_DISALLOW_DIALOG);
    viewMgrPolicy.unRegisterViewCallback(ViewType.ENTERPRISE_DISALLOW_DIALOG, this.desktopSwitchCallback);
  }

  updateSwitching(isSwitching: boolean): void {
    this.isSwitching = isSwitching;
  }

  build() {
    if (this.isSwitching) {
      Column() {
        Column() {
          Text($r('app.string.enterprise_right_warning'))
            .fontFamily('HarmonyHeiTi')
            .fontWeight(FontWeight.Regular)
            .fontSize(16)
            .lineHeight(19)
            .margin({ top: 24, bottom: 16 })
          Button($r('app.string.enterprise_confirm'))
            .onClick(() => {
              ViewManagerPolicy.hideView(ViewType.ENTERPRISE_DISALLOW_DIALOG);
              this.updateSwitching(false);
            })
            .width(250)
            .height(40)
            .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
            .fontFamily('HarmonyHeiT')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
        }
        .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
        .width(394)
        .height(125)
        .borderRadius(16)
        .align(Alignment.Center)
      }
      .width('100%')
      .height('100%')
      .alignItems( HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }

  }
}