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

import { bundleManager, Want } from '@kit.AbilityKit';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlobalContext, ViewController, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { CardItemInfo } from '../TsIndex';
import { CommonConstants } from '../constants/CommonConstants';

const TAG = 'FormEditViewManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class FormEditViewParam {
  // 打开卡片服务界面的应用包名
  bundleName?: string;
  // 打开卡片管理界面的卡片信息
  formInfo?: CardItemInfo;
  // 设定卡片编辑高度
  viewHeight?: number;
  // 设置是否支持一镜到底动效
  isSupportCreateAnimate: boolean = false;
  // 二级页面名
  secPageAbilityName?: string;
}

export interface FormEditViewController {
  showView: (param: FormEditViewParam) => void;
  hideView: (height?: number) => void;
  closeView: () => void;
  getViewState: () => boolean;
  backGestureHandler: () => void;
  recoveryDefaultHeight?: () => void;
}

const DEFAULT_Z_INDEX: number = 5;

/**
 * 界面管理类：用于跳转界面.
 */
export class FormEditViewManager {
  private static mInstance: FormEditViewManager;
  private mFormEditViewController: FormEditViewController | null = null;
  private mFormEditSecPageController: FormEditViewController | null = null;
  private editingFormInfo: CardItemInfo = new CardItemInfo();
  // 标识卡片编辑页是否是半模态编辑页
  public isSheetEditView: boolean = true;

  private constructor() {
  }

  /**
   * 获取单实例
   *
   * @returns 实例
   */
  public static getInstance(): FormEditViewManager {
    if (FormEditViewManager.mInstance === undefined) {
      FormEditViewManager.mInstance = new FormEditViewManager();
    }
    return FormEditViewManager.mInstance;
  }

  public formEditHomeGestureHandler(): void {
    // home手势关闭所有页面
    this.mFormEditViewController?.closeView();
    this.mFormEditSecPageController?.closeView();
    this.setEditingFormInfo(new CardItemInfo());
  }

  public setEditingFormInfo(cardItemInfo: CardItemInfo): void {
    this.editingFormInfo = cardItemInfo;
  }

  public getEditingFormInfo(): CardItemInfo {
    return this.editingFormInfo;
  }

  /**
   * 卡片编辑一级页面注册
   *
   * @param viewController
   */
  public registerFormEditViewController(viewController: FormEditViewController): void {
    this.mFormEditViewController = viewController;
  }

  public unRegisterFormEditViewController(): void {
    this.mFormEditViewController = null;
  }

  public formEditBackGestureHandler(): void {
    if (this.isFormEditSecPageShowing()) {
      this.mFormEditSecPageController?.backGestureHandler();
      if (this.isFormEditViewShowing()) {
        this.openFormEditView();
      }
      return;
    }

    if (this.isFormEditViewShowing()) {
      this.mFormEditViewController?.backGestureHandler();
    }
  }

  public openFormEditView(param?: FormEditViewParam): void {
    log.showInfo('openFormEditView');
    let viewParam: FormEditViewParam = param ?? new FormEditViewParam();
    if (CheckEmptyUtils.isEmpty(param)) {
      viewParam.bundleName = this.editingFormInfo.bundleName;
      viewParam.formInfo = this.editingFormInfo;
    }
    viewMgrPolicy.getViewController(ViewType.FORM_CENTER)?.setZIndex(DEFAULT_Z_INDEX);
    this.mFormEditViewController?.showView(viewParam);
  }

  public hideFormEditView(height?: number): void {
    if (this.isFormEditViewShowing()) {
      this.mFormEditViewController?.hideView(height);
    }
  }

  public closeFormEditView(): void {
    log.showInfo('closeFormEditView');
    if (this.isFormEditSecPageShowing()) {
      this.mFormEditSecPageController?.closeView();
    }

    this.mFormEditViewController?.closeView();
  }

  public isFormEditViewShowing(): boolean {
    return this.mFormEditViewController?.getViewState() ?? false;
  }

  /**
   * 卡片编辑二级页面注册
   *
   * @param viewController
   */
  public registerFormEditSecPageController(viewController: FormEditViewController): void {
    this.mFormEditSecPageController = viewController;
  }

  public unRegisterFormEditSecPageController(): void {
    this.mFormEditSecPageController = null;
  }

  public openFormEditSecPageView(param?: FormEditViewParam): void {
    log.showInfo('openFormEditSecPageView');
    let viewParam: FormEditViewParam = param ?? new FormEditViewParam();

    if (!CheckEmptyUtils.checkStrIsEmpty(this.editingFormInfo.bundleName) &&
      this.editingFormInfo.bundleName !== viewParam.bundleName) {
      log.showError('open second page fail. bundleName is exception');
      return;
    }
    //进入二级编辑页面，打断一级编辑页面的落位动效
    GlobalContext.getContext()?.eventHub.emit('interruptFormEffect');
    this.mFormEditSecPageController?.showView(viewParam);
    // 卡片编辑页为半模态窗口时，只能显示一个半模态，互斥显示，所以拉起二级页面时需要关闭一级页面
    if (this.isSheetEditView && this.isFormEditViewShowing()) {
      this.hideFormEditView();
    }
  }

  public closeFormEditSecPageView(onlyCloseFormEditSecPage?: boolean): void {
    log.showInfo('closeFormEditSecPageView');
    this.mFormEditSecPageController?.closeView();
    if (this.isSheetEditView) {
      this.openFormEditView();
    }
    GlobalContext.getContext()?.eventHub.emit('enterFormEditDone');
  }

  public isFormEditSecPageShowing(): boolean {
    return this.mFormEditSecPageController?.getViewState() ?? false;
  }

  public isFormEditExtensionAbility(bundleName: string, abilityName: string): boolean {
    try {
      const extensionAbilityType: bundleManager.ExtensionAbilityType = bundleManager.ExtensionAbilityType.UNSPECIFIED;
      const extensionFlags: bundleManager.ExtensionAbilityFlag =
        bundleManager.ExtensionAbilityFlag.GET_EXTENSION_ABILITY_INFO_DEFAULT;
      const want: Want = {
        bundleName: bundleName,
        abilityName: abilityName
      };
      const extensionAbilityTypeName = bundleManager.queryExtensionAbilityInfoSync(want, extensionAbilityType,
        extensionFlags)[0]?.extensionAbilityTypeName;
      log.showWarn(TAG, `isFormEditExtensionAbility. extensionAbilityTypeName: ${extensionAbilityTypeName}`);
      return extensionAbilityTypeName === CommonConstants.FORM_EDIT_UI_EXTENSION_TYPE;
    } catch (err) {
      log.showError(TAG, `getExtensionAbilityTypeName error, code: ${err?.code}, message: ${err?.message}`);
      return false;
    }
  }
}