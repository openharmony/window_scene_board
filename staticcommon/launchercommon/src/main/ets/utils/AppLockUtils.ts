/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import AppLockConstants from '../constants/AppLockConstants';
import { AppLockManager, AppLockStatusEnum } from '../manager/AppLockManager';
import { AppItemInfo, CommonConstants, MenuInfo } from '../TsIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';

const TAG = 'AppLockUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 用于处理应用锁menuList的utils
 */
export default class AppLockUtils {
  private static mAppLockUtils: AppLockUtils;

  private constructor() {
  }

  /**
   * 获取单例对象
   * @returns AppLockUtils
   */
  public static getInstance(): AppLockUtils {
    if (!AppLockUtils.mAppLockUtils) {
      AppLockUtils.mAppLockUtils = new AppLockUtils();
    }
    return AppLockUtils.mAppLockUtils;
  }

  /**
   * 获取应用对应的应用锁信息菜单
   * @param appInfo 应用信息
   * @returns MenuInfo | undefined
   */
  public buildAppLockMenu(appInfo: AppItemInfo): MenuInfo | undefined {
    const appLockMenu: MenuInfo = new MenuInfo();
    appLockMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    appLockMenu.menuImgSrc = '/common/pics/app_lock.svg';
    let appLockStatus: AppLockStatusEnum =
      AppLockManager.getInstance().getAppLockStatus(appInfo.bundleName, appInfo.appIndex ?? 0);
    log.showInfo('appLockStatus: %{public}s', appLockStatus.toString());
    let action: string = '';
    switch (appLockStatus) {
      case AppLockStatusEnum.LOCK:
        appLockMenu.menuText = $r('app.string.remove_app_lock');
        action = AppLockConstants.ACTION_UNLOCK;
        appInfo.isAppLocked = true;
        break;
      case AppLockStatusEnum.UNLOCK:
        appLockMenu.menuText = $r('app.string.add_app_lock');
        action = AppLockConstants.ACTION_LOCK;
        appInfo.isAppLocked = false;
        break;
      default:
        log.showInfo('status is not support, status: %{public}s', appLockStatus.toString());
        return undefined;
    }

    appLockMenu.onMenuClick = (): void => {
      let want: Want = {
        bundleName: AppLockConstants.APP_LOCK_BUNDLE_NAME,
        moduleName: AppLockConstants.APP_LOCK_MODULE_NAME,
        abilityName: AppLockConstants.APP_LOCK_ABILITY_NAME,
        parameters: {
          'bundleName': appInfo.bundleName,
          'appIndex': appInfo.appIndex ?? 0,
          'action': action,
        }
      };
      GlobalContext.getContext().startAbility(want).then(() => {
        log.showInfo('startAbility success');
      }).catch((err: BusinessError) => {
        log.showError('startAbility failed, code: %{public}d, message: %{public}s', err?.code, err?.message);
      });
    };
    return appLockMenu;
  }
}