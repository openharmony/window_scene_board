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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { AccountChangeListener } from '../listener/AccountChangeListener';
import { AppGalleryListener } from '../listener/AppGalleryListener';
import { BMSListener } from '../listener/BMSListener';
import { AppStatusNameMapping } from '@ohos/launchercommon/src/main/ets/appinstall/AppStatusNameMapping';

const TAG = 'appInstall_IAppInstallRegister';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 注册AppInstall
 */
export class AppInstallRegister {
  /**
   * 注册AppInstall
   * @param label
   */
  public static register(label: string): boolean {
    log.showWarn('register %{public}s', label);
    try {
      AppGalleryListener.getInstance().init();
      BMSListener.getInstance().init();
      AccountChangeListener.getInstance().init();
      AppStatusNameMapping.getInstance().init();
      return true;
    } catch (error) {
      log.showError(`register error. code ${error?.code}`);
    }
    return false;
  }

  /**
   * 反注册AppInstall
   */
  public static unRegister(label: string): boolean {
    log.showWarn('unRegister %{public}s', label);
    try {
      AppGalleryListener.getInstance().destroy();
      BMSListener.getInstance().destroy();
      return true;
    } catch (error) {
      log.showError(`register error. code ${error?.code}`);
    }
    return false;
  }
}