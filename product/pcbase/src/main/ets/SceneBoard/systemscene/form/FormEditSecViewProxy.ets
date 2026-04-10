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

import { window } from '@kit.ArkUI';
import { Logger, LogDomain } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { FormEditViewManager } from '@ohos/launchercommon';
import {
  FormEditViewController,
  FormEditViewParam
} from '@ohos/launchercommon/src/main/ets/manager/FormEditViewManager';
import { FormEditSecViewLayout } from './FormEditLayout';
import { FormEditWindowManager } from './FormEditWindowManager';

const TAG = 'FormEditSecViewProxy';
const log = Logger.getLogHelper(LogDomain.FORM);

export class FormEditSecViewProxy {
  private static instance: FormEditSecViewProxy | undefined = undefined;
  private isEditViewShow_: boolean = false;
  public formEditViewParam: FormEditViewParam | undefined = undefined;
  public formEditLayout: FormEditSecViewLayout  = new FormEditSecViewLayout();
  private viewStateChangeCallback: Callback<boolean> | undefined = undefined;
  private viewController: FormEditViewController = {
    showView: (param: FormEditViewParam) => this.showView(param),
    closeView: () => this.closeView(),
    hideView: () => log.showInfo(TAG, 'hideView'),
    getViewState: () => this.isEditViewShow_,
    backGestureHandler: () => this.gestureBack()
  }

  private set isEditViewShow(isEditViewShow: boolean) {
    if (isEditViewShow === this.isEditViewShow_) {
      return;
    }
    this.isEditViewShow_ = isEditViewShow;
    this.viewStateChangeCallback?.(this.isEditViewShow_);
  }

  public init(): void {
    FormEditViewManager.getInstance().registerFormEditSecPageController(this.viewController);
  }

  public destroy(): void {
    FormEditViewManager.getInstance().unRegisterFormEditSecPageController();
  }

  public resetViewProxy(): void {
    this.isEditViewShow = false;
    this.formEditViewParam = undefined;
    this.formEditLayout.resetParam();
  }

  public static getInstance(): FormEditSecViewProxy {
    if (FormEditSecViewProxy.instance) {
      return FormEditSecViewProxy.instance;
    }
    FormEditSecViewProxy.instance = new FormEditSecViewProxy();
    return FormEditSecViewProxy.instance;
  }

  private async showView(param: FormEditViewParam): Promise<void> {
    log.showInfo(TAG, 'showView');
    this.formEditViewParam = param;
    const windowProperties = FormEditWindowManager.getInstance().getFormEditWindowProperties();
    await this.formEditLayout.updateFormEditHeight(windowProperties, param.viewHeight);
    FormEditWindowManager.getInstance().openFormEditSubWindow((subWindow: window.Window) => {
      subWindow.resize(vp2px(this.formEditLayout.formEditWidth), vp2px(this.formEditLayout.getFormEditHeight()));
      // 设置二级页面相对一级页面的位置，保证拖拽、跨屏等场景相对父窗位置不变
      subWindow.setRelativePositionToParentWindowEnabled(true, window.WindowAnchor.TOP_START,
        vp2px(this.formEditLayout.marginWindowLeft), vp2px(this.formEditLayout.marginWindowTop));
      this.isEditViewShow = true;
    });
  }

  public registerViewStateChangeListener(callback: Callback<boolean>): void {
    this.viewStateChangeCallback = callback;
  }

  public unregisterViewStateChangeListener(): void {
    this.viewStateChangeCallback = undefined;
  }

  public async closeView(): Promise<void> {
    log.showInfo(TAG, 'closeView');
    await FormEditWindowManager.getInstance().closeFormEditSubWindow();
    this.isEditViewShow = false;
    this.resetViewProxy();
  }

  private gestureBack(): void {
    log.showInfo(TAG, 'backGestureHandler');
    this.closeView();
  }
}