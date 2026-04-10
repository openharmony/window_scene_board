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

import { Logger, LogDomain } from '@ohos/basicutils';
import { AppItemInfo, CardItemInfo, FormEditViewManager, FormModel } from '@ohos/launchercommon';
import {
  FormEditViewController,
  FormEditViewParam
} from '@ohos/launchercommon/src/main/ets/manager/FormEditViewManager';
import { FormEditViewLayout } from './FormEditLayout';
import { FormEditWindowManager } from './FormEditWindowManager';
import { common } from '@kit.AbilityKit';
import { FormEditSecViewProxy } from './FormEditSecViewProxy';

const TAG = 'FormEditViewProxy';
const log = Logger.getLogHelper(LogDomain.FORM);

export class FormEditViewProxy {
  private static instance: FormEditViewProxy | undefined = undefined;
  private uiContext: UIContext | undefined = undefined;
  private viewParam: FormEditViewParam | undefined = undefined;
  private updateViewCallback: Callback<void> = () => log.showInfo(TAG, 'default updateViewCallback');
  public isEditViewShow: boolean = false;
  public formEditViewLayout: FormEditViewLayout = new FormEditViewLayout();

  private viewController: FormEditViewController = {
    showView: (param: FormEditViewParam): void => this.showView(param),
    closeView: () => this.closeView(),
    hideView: () => log.showInfo(TAG, 'hideView'),
    getViewState: () => this.isEditViewShow,
    backGestureHandler: () => this.gestureBack()
  }

  public init(uiContext: UIContext): void {
    FormEditViewManager.getInstance().registerFormEditViewController(this.viewController);
    this.uiContext = uiContext;
  }

  public getUIContext(): UIContext | undefined {
    return this.uiContext;
  }

  public destroy(): void {
    FormEditViewManager.getInstance().unRegisterFormEditViewController();
  }

  public getViewParam(): FormEditViewParam | undefined {
    return this.viewParam;
  }

  public resetViewProxy(): void {
    this.isEditViewShow = false;
    this.formEditViewLayout.resetParam();
    this.viewParam = undefined;
  }

  public static getInstance(): FormEditViewProxy {
    if (FormEditViewProxy.instance) {
      return FormEditViewProxy.instance;
    }
    FormEditViewProxy.instance = new FormEditViewProxy();
    return FormEditViewProxy.instance;
  }

  private showView(param: FormEditViewParam): void {
    log.showInfo(TAG, `showView, isViewShow:${this.isEditViewShow}, bundleName:${param.bundleName}, viewHeight:${param.viewHeight}`);
    this.formEditViewLayout.updateFormEditHeight(param.viewHeight);
    this.viewParam = param;
    if (this.isEditViewShow) {
      this.refreshView(() => {
        // 把窗口拉到前台
        FormEditWindowManager.getInstance().openFormEditWindow(
          this.uiContext?.getHostContext() as common.UIAbilityContext, this.formEditViewLayout.getFormEditRect());
      });
      return;
    }
    FormEditWindowManager.getInstance().openFormEditWindow(this.uiContext?.getHostContext() as common.UIAbilityContext,
      this.formEditViewLayout.getFormEditRect());
    this.isEditViewShow = true;
  }

  private async refreshView(finishCallback: Callback<void>): Promise<void> {
    if (FormEditViewManager.getInstance().isFormEditSecPageShowing()) {
      await FormEditSecViewProxy.getInstance().closeView();
    }
    this.updateViewCallback();
    finishCallback();
  }

  public registerViewChangeListener(callback: Callback<void>): void {
    this.updateViewCallback = callback;
  }

  public unregisterViewChangeListener(): void {
    this.updateViewCallback = () => log.showInfo(TAG, 'default updateViewCallback');
  }

  public closeView(reason?: string): void {
    log.showInfo(TAG, `closeView, because ${reason}`);
    FormEditWindowManager.getInstance().closeFormEditWindow();
    FormEditViewManager.getInstance().closeFormEditSecPageView();
    this.isEditViewShow = false;
    this.resetViewProxy();
  }

  private gestureBack(): void {
    log.showInfo(TAG, 'backGestureHandler');
    this.closeView();
  }
}