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

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import window from '@ohos.window';
import { BusinessError } from '@kit.BasicServicesKit';
import { LogDomain, Logger } from '@ohos/basicutils';
import { FormEditViewProxy } from '@ohos/pcbase/src/main/ets/SceneBoard/systemscene/form/FormEditViewProxy';
import { FormEditWindowManager } from '@ohos/pcbase/src/main/ets/SceneBoard/systemscene/form/FormEditWindowManager';

const TAG: string = 'FormEditAbility';
const log: Logger = Logger.getLogHelper(LogDomain.FORM);

export default class FormEditAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    log.showInfo(TAG, 'onCreate');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    log.showInfo(TAG, `onWindowStageCreate`);
    FormEditWindowManager.getInstance().setWindowInfo(windowStage, this.context);
    try {
      const mainWindow: window.Window = windowStage.getMainWindowSync();
      windowStage.loadContent('pages/FormEditPage', new LocalStorage(), (err: BusinessError) => {
        if (err?.code) {
          log.showError(TAG, `Failed to load the content. errCode:${err?.code}, errMsg:${err?.message}`);
          return;
        }
        this.initWindowProperty(mainWindow);
        log.showInfo(TAG, 'Succeeded in loading the content.');
      });
    } catch (err) {
      log.showWarn(TAG, `errCode:${err?.code}, errMsg:${err?.message}`);
    }
  }

  private initWindowProperty(mainWindow: window.Window): void {
    try {
      mainWindow.setResizeByDragEnabled(false);
      mainWindow.setWindowDecorVisible(false);
      mainWindow.setWindowTitleButtonVisible(false, false);
      const formEditLayout = FormEditViewProxy.getInstance().formEditViewLayout;
      mainWindow.setWindowDecorHeight(formEditLayout.titleHeight);
      mainWindow.setDecorButtonStyle({
        buttonBackgroundSize: formEditLayout.closeButtonHeight,
        closeButtonRightMargin: formEditLayout.closeButtonMarginRight
      });
    } catch (err) {
      log.showWarn(TAG, `initWindowProperty error, errCode:${err?.code}, errMsg:${err?.message}`);
    }
  }

  onForeground(): void {
    log.showInfo(TAG, 'onForeground');
  }

  onBackground(): void {
    log.showInfo(TAG, 'onBackground');
  }

  onDestroy(): void | Promise<void> {
    log.showInfo(TAG, 'onDestroy');
    FormEditViewProxy.getInstance().closeView('onDestroy');
    FormEditWindowManager.getInstance().clearWindowInfo();
  }
}