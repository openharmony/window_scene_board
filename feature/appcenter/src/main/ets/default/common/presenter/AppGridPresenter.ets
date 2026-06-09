/**
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

import { CommonConstants, ShortcutInfo } from '@ohos/launchercommon';
import { AppListPresenter } from './AppListPresenter';

/**
 * AppGridPresenter
 */
export class AppGridPresenter extends AppListPresenter {
  private static instances: AppGridPresenter;

  private constructor() {
    super();
    this.registerEventListener();
  }

  /**
   * get instance
   */
  static getInstance(): AppGridPresenter {
    if (AppGridPresenter.instances == null) {
      AppGridPresenter.instances = new AppGridPresenter();
    }
    return AppGridPresenter.instances;
  }

  /**
   * Register to listen to events
   */
  registerAppListChange(screenId: number = 0) {
    if (this.mScreenIds.indexOf(screenId) === CommonConstants.INVALID_VALUE) {
      this.mScreenIds.push(screenId);
    }
    this.registerAppListChangeCallback();
  }

  /**
   * Unregister listener events
   */
  unregisterAppListChange(screenId: number = 0) {
    const index = this.mScreenIds.indexOf(screenId);
    if (index !== CommonConstants.INVALID_VALUE) {
      this.mScreenIds.splice(index, 1);
    }
    if (this.mScreenIds.length === 0) {
      this.unregisterAppListChangeCallback();
    }
  }

  registerEventListener() {
    this.onAppListViewCreate();
  }

  unregisterEventListener() {
    this.onAppListViewDestroy();
  }

  /**
   * Get shortcut information by bundleName
   */
  getShortcutInfo(bundleName: string): ShortcutInfo[] | undefined {
    return this.mAppModel.getShortcutInfo(bundleName);
  }
}