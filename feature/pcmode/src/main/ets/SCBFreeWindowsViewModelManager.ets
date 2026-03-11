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

import { SCBScreenProperty } from '@ohos/windowscene';
import { ViewModelType } from './constants/BaseConstants';
import { IFreeWindowsViewModel } from './presenter/IFreeWindowsViewModel';
import { SCBPcFreeWindowsViewModel } from './presenter/SCBPcFreeWindowsViewModel';
import { SCBScenePanelProxy } from './presenter/SCBScenePanelProxy';

/**
 * 窗口管理类，对外提供代理的管理
 */
export class SCBFreeWindowsViewModelManager {
  private static INSTANCE: SCBFreeWindowsViewModelManager;
  private presenterMap: Map<number, IFreeWindowsViewModel> = new Map();

  constructor() {
  }

  /**
   * 单例对象
   *
   * @returns 单例对象
   */
  public static getInstance(): SCBFreeWindowsViewModelManager {
    if (!SCBFreeWindowsViewModelManager.INSTANCE) {
      SCBFreeWindowsViewModelManager.INSTANCE = new SCBFreeWindowsViewModelManager();
    }
    return SCBFreeWindowsViewModelManager.INSTANCE;
  }

  /**
   * 获取或者创建对应ViewModel
   *
   * @param uiContext 上下文
   * @param screenProperty 屏幕参数
   * @param presenterType 类型
   * @returns
   */
  public getOrCreatePresenter(uiContext: UIContext, screenProperty: SCBScreenProperty, panelProxy: SCBScenePanelProxy,
    presenterType: ViewModelType): IFreeWindowsViewModel {
    const screenId = screenProperty.screenId;
    let presenter = this.presenterMap.get(screenId);
    if (presenter === undefined) {
      presenter = this.createPresenter(uiContext, screenProperty, panelProxy, presenterType);
      this.presenterMap.set(screenId, presenter);
    }
    return presenter;
  }

  /**
   * 创建对应ViewModel
   *
   * @param uiContext
   * @param screenProperty
   * @param presenterType
   * @returns
   */
  private createPresenter(uiContext: UIContext, screenProperty: SCBScreenProperty, panelProxy: SCBScenePanelProxy,
    presenterType: ViewModelType): IFreeWindowsViewModel {
    switch (presenterType) {
      case ViewModelType.VIEW_MODEL_PC:
        return new SCBPcFreeWindowsViewModel(uiContext, screenProperty, panelProxy);
      default:
        return new SCBPcFreeWindowsViewModel(uiContext, screenProperty, panelProxy);
    }
  }

  /**
   * 获取对应ViewModel
   *
   * @param screenId 屏幕ID
   * @returnsViewModel
   */
  public getPresenter(screenId: number): IFreeWindowsViewModel | null {
    if (this.presenterMap.has(screenId)) {
      return this.presenterMap.get(screenId) as IFreeWindowsViewModel;
    }
    return null;
  }

  /**
   * 移除ViewModel
   *
   * @param screenId 屏幕ID
   */
  public removePresenter(screenId: number): void {
    if (this.presenterMap.has(screenId)) {
      this.presenterMap.delete(screenId);
    }
  }
}