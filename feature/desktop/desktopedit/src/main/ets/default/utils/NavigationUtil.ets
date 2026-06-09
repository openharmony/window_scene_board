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

import base from '@ohos.base';
import router from '@ohos.router';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NavBarHideAndShowManager } from '@ohos/launchercommon/src/main/ets/TsIndex';

const TAG: string = 'NavigationUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * UIExtension 导航帮助类
 */
export class NavigationUtil {
  public static session: UIExtensionContentSession | undefined;

  /**
   * 导航返回逻辑
   */
  public static doPageBack(): void {
    if (!NavigationUtil.session) {
      log.showInfo('terminateSelf in file:NavigationUtil>doPageBack');
      router.back();
      return;
    }
    log.showInfo('UIExt back');
    try {
      NavigationUtil.session.sendData({'back': true});
    } catch (err) {
      log.showError(`send Msg error: ${err}`);
    }
  }

  /**
   * 返回动效结束
   */
  public static backAnimationDone(): void {
    if (!NavigationUtil.session) {
      log.showInfo('terminateSelf in file:NavigationUtil>doPageBack');
      router.back();
      return;
    }
    log.showInfo('UIExt backAnimate done');
    try {
      NavigationUtil.session.sendData({'backAnimationDone': true});
    } catch (err) {
      log.showError(`send Msg error: ${err}`);
    }
  }

  /**
   * 应用逻辑
   */
  public static doApplyTheme(): void {
    if (!NavigationUtil.session) {
      router.back();
      return;
    }
    log.showInfo('UIExt apply theme');
    try {
      NavigationUtil.session.sendData({'apply': true});
    } catch (err) {
      log.showError(`send Msg error: ${(err as base.BusinessError).code}`);
    }
  }
}