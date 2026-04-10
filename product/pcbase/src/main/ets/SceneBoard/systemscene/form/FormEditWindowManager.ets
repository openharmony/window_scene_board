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

import { LogDomain, Logger } from '@ohos/basicutils';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { WindowRect } from './FormEditLayout';

const TAG = 'FormEditWindowManager';
const log = Logger.getLogHelper(LogDomain.FORM);

const FORM_EDIT_ABILITY_BUNDLE_NAME = 'com.ohos.sceneboard';
const FORM_EDIT_ABILITY_NAME = 'FormEditAbility';
// 主屏幕ID，Hopper悬停态时为B面屏幕ID
const MAIN_SCREEN_ID: number = 0;

export class FormEditWindowManager {
  private static instance: FormEditWindowManager | undefined = undefined;
  private windowStage: window.WindowStage | undefined = undefined;
  private uiAbilityContext: common.UIAbilityContext | undefined = undefined;

  public static getInstance(): FormEditWindowManager {
    if (FormEditWindowManager.instance) {
      return FormEditWindowManager.instance;
    }
    FormEditWindowManager.instance = new FormEditWindowManager();
    return FormEditWindowManager.instance;
  }

  public setWindowInfo(windowStage: window.WindowStage, context: common.UIAbilityContext): void {
    this.windowStage = windowStage;
    this.uiAbilityContext = context;
  }

  public getFormEditWindow(): window.Window | undefined {
    try {
      return this.windowStage?.getMainWindowSync();
    } catch (err) {
      log.showWarn(TAG, `getWindow error, errCode:${err?.code}, errMsg:${err?.message}`);
    }
    return undefined;
  }

  public getFormEditWindowProperties(): window.WindowProperties | undefined {
    try {
      return this.getFormEditWindow()?.getWindowProperties();
    } catch (err) {
      log.showWarn(TAG, `getFormEditWindowRect fail, errCode:${err?.code}, errMsg:${err?.message}`);
    }
    return undefined;
  }

  public registerFormEditWindowEventListener(callback: Callback<window.WindowEventType>): void {
    try {
      const formEditWindow: window.Window | undefined = this.getFormEditWindow();
      if (!formEditWindow) {
        log.showWarn(TAG, 'registerFormEditWindowEventListener, formEditWindow is null');
        return;
      }
      formEditWindow.on('windowEvent', callback);
    } catch (err) {
      log.showWarn(TAG, `registerFormEditWindowEventListener error, errCode:${err?.code}, errMsg:${err?.message}`);
    }
  }

  public unregisterFormEditWindowEventListener(callback: Callback<window.WindowEventType>): void {
    try {
      const formEditWindow: window.Window | undefined = this.getFormEditWindow();
      if (!formEditWindow) {
        log.showWarn(TAG, 'unregisterFormEditWindowEventListener, formEditWindow is null');
        return;
      }
      formEditWindow.off('windowEvent', callback);
    } catch (err) {
      log.showWarn(TAG, `unregisterFormEditWindowEventListener error, errCode:${err?.code}, errMsg:${err?.message}`);
    }
  }

  public openFormEditWindow(uiAbilityContext: common.UIAbilityContext | undefined, formEditRect: WindowRect): void {
    if (!uiAbilityContext) {
      log.showWarn(TAG, 'open window fail, uiAbilityContext is null');
      return;
    }
    this.launchFormEditAbility(uiAbilityContext, formEditRect);
  }

  public closeFormEditWindow(): void {
    this.closeFormEditAbility();
    this.closeFormEditSubWindow();
    this.clearWindowInfo();
  }

  private launchFormEditAbility(uiAbilityContext: common.UIAbilityContext, formEditRect: WindowRect): void {
    if (!uiAbilityContext) {
      log.showError(TAG, 'abilityUIContext is undefined');
      return;
    }
    uiAbilityContext.startAbility({
      bundleName: FORM_EDIT_ABILITY_BUNDLE_NAME,
      abilityName: FORM_EDIT_ABILITY_NAME,
    }, {
      displayId: MAIN_SCREEN_ID,
      windowTop: formEditRect.top,
      windowLeft: formEditRect.left,
      windowWidth: formEditRect.width,
      windowHeight: formEditRect.height
    }).then(() => {
      log.showInfo(TAG, 'startAbility success.');
    }).catch((error: BusinessError) => {
      log.showError(TAG, `startAbility failed. errCode:${error?.code}, errMsg:${error?.message}`);
    });
  }

  private closeFormEditAbility(): void {
    if (!this.uiAbilityContext) {
      log.showWarn(TAG, 'formEditUIAbilityContext is undefined');
      return;
    }
    this.uiAbilityContext.terminateSelf().catch((err: BusinessError) => {
      log.showError(TAG, `closeFormEditAbility failed, errCode:${err.code}, errMsg:${err.message}`);
    });
  }

  public clearWindowInfo(): void {
    this.windowStage = undefined;
    this.uiAbilityContext = undefined;
  }

  public async registerFormEditSecWindowEventListener(callback: Callback<window.WindowEventType>): Promise<void> {
    try {
      const formEditSecWindow: window.Window | undefined = await this.getFormEditSubWindow();
      if (!formEditSecWindow) {
        log.showWarn(TAG, 'registerFormEditSecWindowEventListener, formEditWindow is null');
        return;
      }
      formEditSecWindow.on('windowEvent', callback);
    } catch (err) {
      log.showWarn(TAG, `registerFormEditSecWindowEventListener error, errCode:${err?.code}, errMsg:${err?.message}`);
    }
  }

  public async unregisterFormEditSecWindowEventListener(callback: Callback<window.WindowEventType>): Promise<void> {
    try {
      const formEditSecWindow: window.Window | undefined = await this.getFormEditSubWindow();
      if (!formEditSecWindow) {
        log.showWarn(TAG, 'unregisterFormEditSecWindowEventListener, formEditWindow is null');
        return;
      }
      formEditSecWindow.off('windowEvent', callback);
    } catch (err) {
      log.showWarn(TAG, `unregisterFormEditSecWindowEventListener error, errCode:${err?.code}, errMsg:${err?.message}`);
    }
  }

  public async openFormEditSubWindow(successCallback?: Callback<window.Window>): Promise<void> {
    try {
      const window: window.Window | undefined = await this.createSubWindow();
      if (!window) {
        log.showWarn(TAG, 'openFormEditSubWindow fail, window is null');
        return;
      }
      successCallback?.(window);
      window.setSubWindowModal(true);
      await window.loadContent('pages/FormEditSecPage', new LocalStorage());
      window.showWindow();
    } catch (error) {
      log.showError(TAG, `openFormEditSubWindow error, errCode:${error?.code}, errMsg:${error?.message}`);
    }
  }

  public async closeFormEditSubWindow(): Promise<void> {
    await this.destroySubWindow();
  }

  private async getFormEditSubWindow(): Promise<window.Window | undefined> {
    try {
      const subWindow: window.Window[] | undefined = await this.windowStage?.getSubWindow();
      log.showInfo(TAG, `getFormEditSubWindow, window length:${subWindow?.length}`);
      if (subWindow && subWindow.length > 0) {
        return subWindow[0];
      }
    } catch (err) {
      log.showError(TAG, `getFormEditSubWindow error, errCode:${err?.code}, errMsg:${err?.message}`);
    }
    return undefined;
  }

  public async createSubWindow(): Promise<window.Window | undefined> {
    if (!this.windowStage) {
      return new Promise((resolve) => resolve(undefined));
    }
    const subwindow = await this.getFormEditSubWindow();
    if (subwindow) {
      return subwindow;
    }
    const options: window.SubWindowOptions = {
      title: '',
      decorEnabled: false,
      isModal: true,
      modalityType: window.ModalityType.WINDOW_MODALITY
    };
    try {
      return this.windowStage?.createSubWindowWithOptions('secEditView', options);
    } catch (err) {
      log.showWarn(TAG, `createSubWindowWithOptions err, errCode:${err?.code}, errMsg:${err?.message}`);
    }
    return undefined;
  }

  private async destroySubWindow(): Promise<void> {
    try {
      const subWindows = await this.windowStage?.getSubWindow();
      if (!subWindows || subWindows.length <= 0) {
        log.showWarn(TAG, 'formEditWindow is undefined');
        return;
      }
      for (const window of subWindows) {
        await window.destroyWindow().catch((err: BusinessError) => {
          log.showError(TAG, `destroy form edit window error, errCode:${err?.code}, errMsg:${err?.message}`);
        })
      }
    } catch (err) {
      log.showError(TAG, `destroyWindow error, errCode:${err?.code}, errMsg:${err?.message}`);
    }
  }
}