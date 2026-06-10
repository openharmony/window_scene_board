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

import GestureDockBarViewEventMgr from './viewevent/GestureDockBarViewEventMgr';
import { GestureDockBarViewData } from './viewdata/GestureDockBarViewData';
import { GestureDockBarViewEvent } from './viewevent/GestureDockBarViewEvent';

/**
 * 按需取用相应组件的Event
 */
export class GestureDockBarViewModel {
  private static mInstance: GestureDockBarViewModel | null = null;
  private viewEventMgr?: GestureDockBarViewEventMgr;

  public static getInstance(): GestureDockBarViewModel {
    if (!GestureDockBarViewModel.mInstance) {
      GestureDockBarViewModel.mInstance = new GestureDockBarViewModel();
    }
    return GestureDockBarViewModel.mInstance;
  }

  private constructor() {
  }

  /**
   * 初始化ViewModel
   *
   * @param viewEventMgr
   */
  public initViewModel(viewEventMgr: GestureDockBarViewEventMgr) {
    this.viewEventMgr = viewEventMgr;
  }

  /**
   * 获取DockBar的ViewEvent
   *
   * @returns
   */
  public getViewEvent(): GestureDockBarViewEvent | undefined {
    return this.viewEventMgr;
  }

  /**
   * 获取DockBar的ViewData
   *
   * @returns
   */
  public getViewData(): GestureDockBarViewData | undefined {
     return this.viewEventMgr?.viewDataMgr;
  }

  /**
   * 清空ViewModel
   */
  public clearViewModel(): void {
    this.viewEventMgr = undefined;
  }
}