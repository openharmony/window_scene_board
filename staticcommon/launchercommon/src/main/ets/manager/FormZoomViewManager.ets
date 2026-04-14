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

import { LogDomain, LogHelper, RectInfo } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CardItemInfo } from '../TsIndex';

const TAG = 'FormZoomViewManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export interface FormZoomViewParam {
  formComponentId: string;
  formInfo: CardItemInfo;
  rectInfo: RectInfo;
  formItemWidth: number;
  formItemHeight: number;
  formBorderRadius: number;
}

export interface FormZoomViewController {
  openView: (param: FormZoomViewParam) => void;
  closeView: () => void;
  showView: () => void;
  hideView: () => void;
  getViewState: () => boolean;
}

/**
 * 缩放组件视图管理类
 */
export class FormZoomViewManager {
  private static mInstance: FormZoomViewManager;
  private mFormZoomViewController: FormZoomViewController | null = null;
  private formInfo: CardItemInfo = new CardItemInfo();

  private constructor() {
  }

  /**
   * 获取单实例
   *
   * @returns 实例
   */
  public static getInstance(): FormZoomViewManager {
    if (FormZoomViewManager.mInstance === undefined) {
      FormZoomViewManager.mInstance = new FormZoomViewManager();
    }
    return FormZoomViewManager.mInstance;
  }

  public setFormInfo(cardItemInfo: CardItemInfo): void {
    this.formInfo = cardItemInfo;
  }

  public getFormInfo(): CardItemInfo {
    return this.formInfo;
  }

  public registerFormZoomViewController(viewController: FormZoomViewController): void {
    this.mFormZoomViewController = viewController;
  }

  public unRegisterFormZoomViewController(): void {
    this.mFormZoomViewController = null;
  }

  public openFormZoomView(param: FormZoomViewParam): void {
    log.showInfo('openFormZoomView');
    this.mFormZoomViewController?.openView(param);
  }

  public closeFormZoomView(): void {
    if (this.getFormZoomState()) {
      log.showInfo('closeFormZoomView');
      this.mFormZoomViewController?.closeView();
    }
  }

  public showFormZoomView(): void {
    this.mFormZoomViewController?.showView();
  }

  public hideFormZoomView(): void {
    this.mFormZoomViewController?.hideView();
  }

  public getFormZoomState(): boolean {
    return Boolean(this.mFormZoomViewController?.getViewState());
  }
}