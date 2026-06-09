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

import { LogDomain, Logger } from '@ohos/basicutils';
import { IPageDesktopViewModel } from './IPageDesktopViewModel';

const TAG = 'PageDesktopViewModelProxy';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

export class PageDesktopViewModelProxy {

  private static mPageDesktopVM: IPageDesktopViewModel;

  /**
   * 设置PageDesktopViewModel代理实例
   *
   * @param IPageDesktopViewModel 桌面VM实例
   */
  public static setInstance(pageDesktopVM: IPageDesktopViewModel): void {
    PageDesktopViewModelProxy.mPageDesktopVM = pageDesktopVM;
  }

  /**
   * 根据业务类型获取业务DragHandler
   *
   * @param type 业务类型
   * @returns 业务handler
   */
  public static getInstance(): IPageDesktopViewModel {
    if (!PageDesktopViewModelProxy.mPageDesktopVM) {
      log.showWarn(TAG, 'get the PageDesktopViewModel fail with not set');
    }
    return PageDesktopViewModelProxy.mPageDesktopVM;
  }
}