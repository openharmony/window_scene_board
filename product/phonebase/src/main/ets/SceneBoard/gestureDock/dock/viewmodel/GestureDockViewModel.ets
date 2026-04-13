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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GestureDockViewData } from './viewdata/GestureDockViewData';
import GestureDockViewEventMgr from './viewevent/GestureDockViewEventMgr';
import { GestureDockViewEvent } from './viewevent/GestureDockViewEvent';

const TAG = 'SCBGestureDockViewEvent';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * 按需取用相应组件的Event
 */
export class GestureDockViewModel {
  private static mInstance: GestureDockViewModel | null = null;

  private viewEventMgr?: GestureDockViewEventMgr;

  public static getInstance(): GestureDockViewModel {
    if (!GestureDockViewModel.mInstance) {
      GestureDockViewModel.mInstance = new GestureDockViewModel();
    }
    return GestureDockViewModel.mInstance;
  }

  private constructor() {
  }

  /**
   * 初始化ViewModel
   *
   * @param viewEventMgr
   */
  public initViewModel(viewEventMgr: GestureDockViewEventMgr): void {
    this.viewEventMgr = viewEventMgr;
  }

  /**
   * 获取SCBGestureDock的ViewEvent
   *
   * @returns
   */
  public getViewEvent(): GestureDockViewEvent | undefined {
    return this.viewEventMgr;
  }

  /**
   * 获取SCBGestureDock的ViewData
   *
   * @returns
   */
  public getViewData(): GestureDockViewData | undefined {
    return this.viewEventMgr?.viewDataMgr;
  }

  /**
   * 清空ViewModel
   */
  public clearViewModel(): void {
    this.viewEventMgr = undefined;
  }
}