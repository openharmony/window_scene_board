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
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { DialogDisappearController, DialogDisappearListener } from '@ohos/pcbase/src/main/ets/SystemDialog/ExtendedScreenDialog/controller/DialogDisappearController';
import { ExtendedScreenDialogView } from '@ohos/pcbase/src/main/ets/SystemDialog/ExtendedScreenDialog/pages/ExtendedScreenDialogView';

const TAG = 'ExtendedScreenDialogPage';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const settingKey :string = 'settings.ExtendedScreenDialog.enable';
const delayTime: number = 60000;
let storage = LocalStorage.getShared();
if (storage === undefined) {
  log.showError(`local storage is undefined!`);
}

@Entry
@Component
export struct ExtendedScreenDialogPage {
  @State private isDialogShowed: boolean = true;
  @State isChecked: boolean = false;
  @StorageLink('isExtendedDialogNeedClose') @Watch('closeDialog') isNeedClose: boolean = false;
  private session: UIExtensionContentSession | undefined = storage?.get('session') as UIExtensionContentSession;
  private context: Context = getContext(this);
  private controller: DialogDisappearController = DialogDisappearController.getInstance();
  private intervalId: number = -1;

  private dialogControllerConfirm: CustomDialogController = new CustomDialogController({
    builder: ExtendedScreenDialogView({
      onCancel: () => { this.closeDialog(this.isChecked) },
      isChecked: $isChecked
    }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: true,
    onWillDismiss:(dismissDialogAction: DismissDialogAction)=> {
      log.showInfo(`onWillDismiss, reason: ${JSON.stringify(dismissDialogAction.reason)}`);
      this.closeDialog();
    }
  })

  aboutToAppear(): void {
    log.showInfo(`${TAG} aboutToAppear`);
    this.controller.registerExtendedScreenDialogStatusListener(this.dialogDisappearListener);
    this.dialogControllerConfirm.open();
    this.initAutoShutdownDialog();
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    clearInterval(this.intervalId);
    this.controller.unregisterExtendedScreenDialogStatusListener(this.dialogDisappearListener);
  }

  private dialogDisappearListener: DialogDisappearListener = {
    onExtendedScreenDialogStatusChange: () => {
      let res: boolean = sSettingsUtil.getSystemValue(settingKey, '0', this.context) === '0';
      log.showInfo(`listened extended screen dialog status change - ${res}`);
      if (res) {
        this.closeDialog();
      }
    }
  }

  private initAutoShutdownDialog(): void {
    this.intervalId = setInterval(() => {
      this.closeDialog();
    }, delayTime);
  }

  private closeDialog(isChecked: boolean = false): void {
    if (isChecked) {
      let res: boolean = sSettingsUtil.setSystemValue(settingKey, '1', this.context);
      log.showInfo(`never show dialog res: ${res} - ${this.isChecked} - ${isChecked}`);
    }
    this.dialogControllerConfirm.close();
    this.isDialogShowed = false;
    this.closeSystemDialog();
  }

  private closeSystemDialog(): void {
    log.showInfo('closeSystemDialog begin');
    try {
      this.session?.terminateSelf();
    } catch (e) {
      log.showError('Close SystemDialog fail');
    }
  }

  build() {
    Column() {
    }
    .visibility(this.isDialogShowed ? Visibility.None : Visibility.Visible)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}